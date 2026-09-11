import RequestProject.Gvcs.Sim.Interface

/-!
# A generic device interface for player-built machines

`Sim/Interface.lean` proves a protocol of a *fixed shape*: four named axes, two
flags, thirteen bytes, one machine on the other end.  A sandbox where players
build their own machines needs the same guarantees for a shape that is not
known until the player has finished building.  This file provides that, by
parametrising the protocol over a `DeviceSpec` and reproving — not weakening —
every property the fixed-shape file establishes.

## What a device declares

* `AxisSpec` — a named axis with its own `range` and its own `coilsPerUnit`,
  generalising the hard-wired `±1000` and the per-axis coil contribution.
* `DeviceSpec` — a list of axes, a list of named flags, and a *declared* peak
  coil draw.

## What is proved, for an arbitrary `spec`

* `GenericCommand.sanitize_valid`, `sanitize_eq_self`, `sanitize_idem` —
  sanitising clamps each axis into *its own* range and leaves a legal command
  alone.
* `decodeG_encodeG`, `decodeG_encodeG_sanitize` — the wire round trip.  The
  frame is self-describing: it carries its own axis and flag counts, so a
  reader can refuse a frame shaped for a different device before parsing a
  single value.
* `encodeG_length` — the frame length as a function of the spec.
* `decodeG_checksum_mismatch`, `decodeG_wrong_shape`, `decodeG_bad_header` —
  a corrupted, mis-shaped or mislabelled frame is refused.
* `maxCoilDraw_sound` — **the safety gate.**  If a spec's declared peak is at
  least the peak *implied* by its own axis ranges, then no valid command
  against that spec can draw more than the declared peak.  A player's declared
  figure is therefore never taken on faith: `SpecSafe` is a decidable check the
  engine runs at build time, and `maxCoilDraw_sound` is what makes passing it
  mean something.

The device's *behaviour* — what it does with a command — is deliberately not
part of any of this.  A player may write silly or broken behaviour; they may
not write an interface that breaks the range or draw guarantees.
-/

namespace LifeTrac
namespace Device

open Interface

/-! ## The shape a device declares -/

/-- One axis of a player-built device: a name, the interval its demand lives
in, and how much coil current a unit of demand calls up. -/
structure AxisSpec where
  name : String
  range : ℤ × ℤ
  coilsPerUnit : ℤ
deriving DecidableEq, Repr, Inhabited

/-- The interface a device presents to the game. -/
structure DeviceSpec where
  axes : List AxisSpec
  flags : List String
  maxCoilDraw : ℤ
deriving DecidableEq, Repr, Inhabited

/-- An axis is well formed when its interval is non-empty, its coil figure is
not negative, and its span fits in the four bytes the wire gives it. -/
def AxisSpec.Ok (a : AxisSpec) : Prop :=
  a.range.1 ≤ a.range.2 ∧ 0 ≤ a.coilsPerUnit ∧ a.range.2 - a.range.1 < 4294967296

instance (a : AxisSpec) : Decidable a.Ok := inferInstanceAs (Decidable (_ ∧ _ ∧ _))

/-! ## Commands over a spec -/

/-- A command aimed at a particular device: one value an axis, one bit a flag,
with the shape checked by construction. -/
structure GenericCommand (spec : DeviceSpec) where
  axisValues : List ℤ
  flagValues : List Bool
  hLen : axisValues.length = spec.axes.length
  hFlagLen : flagValues.length = spec.flags.length

/-- Every axis value inside the interval its own axis declares. -/
def GenericCommand.Valid {spec : DeviceSpec} (c : GenericCommand spec) : Prop :=
  ∀ (i : ℕ) (h : i < spec.axes.length),
    spec.axes[i].range.1 ≤ c.axisValues[i]'(by rw [c.hLen]; exact h) ∧
      c.axisValues[i]'(by rw [c.hLen]; exact h) ≤ spec.axes[i].range.2

/-- The same condition, walked down the two lists together.  This is the form
the proofs use; `valid_iff_axesInRange` says it is the same condition. -/
def AxesInRange : List AxisSpec → List ℤ → Prop
  | [], [] => True
  | a :: as, x :: xs => (a.range.1 ≤ x ∧ x ≤ a.range.2) ∧ AxesInRange as xs
  | _, _ => False

instance : ∀ (as : List AxisSpec) (xs : List ℤ), Decidable (AxesInRange as xs)
  | [], [] => inferInstanceAs (Decidable True)
  | [], _ :: _ => inferInstanceAs (Decidable False)
  | _ :: _, [] => inferInstanceAs (Decidable False)
  | _ :: as, _ :: xs =>
      have : Decidable (AxesInRange as xs) := instDecidableAxesInRange as xs
      inferInstanceAs (Decidable (_ ∧ _))

theorem axesInRange_iff_index :
    ∀ (as : List AxisSpec) (xs : List ℤ) (hlen : xs.length = as.length),
      AxesInRange as xs ↔ ∀ (i : ℕ) (h : i < as.length),
        as[i].range.1 ≤ xs[i]'(by omega) ∧ xs[i]'(by omega) ≤ as[i].range.2
  | [], [], _ => by
      constructor
      · intro _ i h; simp at h
      · intro _; trivial
  | [], _ :: _, hlen => by simp at hlen
  | _ :: _, [], hlen => by simp at hlen
  | a :: as, x :: xs, hlen => by
      have hlen' : xs.length = as.length := by simpa using hlen
      rw [AxesInRange, axesInRange_iff_index as xs hlen']
      constructor
      · rintro ⟨h0, hrest⟩ i hi
        cases i with
        | zero => simpa using h0
        | succ j =>
            have hj : j < as.length := by simpa using hi
            simpa using hrest j hj
      · intro h
        refine ⟨by simpa using h 0 (by simp), fun j hj => ?_⟩
        simpa using h (j + 1) (by simpa using hj)

theorem valid_iff_axesInRange {spec : DeviceSpec} (c : GenericCommand spec) :
    c.Valid ↔ AxesInRange spec.axes c.axisValues :=
  (axesInRange_iff_index spec.axes c.axisValues c.hLen).symm

instance {spec : DeviceSpec} (c : GenericCommand spec) : Decidable c.Valid :=
  decidable_of_iff _ (valid_iff_axesInRange c).symm

/-! ## Sanitising -/

/-- Clamp a value into an interval. -/
def clampTo (r : ℤ × ℤ) (x : ℤ) : ℤ := max r.1 (min r.2 x)

theorem clampTo_mem {r : ℤ × ℤ} (h : r.1 ≤ r.2) (x : ℤ) : r.1 ≤ clampTo r x ∧ clampTo r x ≤ r.2 := by
  unfold clampTo; omega

theorem clampTo_eq_self {r : ℤ × ℤ} {x : ℤ} (h : r.1 ≤ x ∧ x ≤ r.2) : clampTo r x = x := by
  obtain ⟨h1, h2⟩ := h
  unfold clampTo; omega

/-- Clamp every axis into its own range, padding a short list at the bottom of
each range so the result always has the shape the spec calls for. -/
def sanitizeAxes : List AxisSpec → List ℤ → List ℤ
  | [], _ => []
  | a :: as, [] => a.range.1 :: sanitizeAxes as []
  | a :: as, x :: xs => clampTo a.range x :: sanitizeAxes as xs

theorem length_sanitizeAxes : ∀ (as : List AxisSpec) (xs : List ℤ),
    (sanitizeAxes as xs).length = as.length
  | [], _ => rfl
  | a :: as, [] => by simp [sanitizeAxes, length_sanitizeAxes as []]
  | a :: as, x :: xs => by simp [sanitizeAxes, length_sanitizeAxes as xs]

theorem axesInRange_sanitizeAxes : ∀ (as : List AxisSpec) (xs : List ℤ),
    (∀ a ∈ as, a.Ok) → AxesInRange as (sanitizeAxes as xs)
  | [], _, _ => trivial
  | a :: as, [], h => by
      have ha := (h a (by simp)).1
      exact ⟨⟨le_refl _, ha⟩, axesInRange_sanitizeAxes as [] (fun b hb => h b (by simp [hb]))⟩
  | a :: as, x :: xs, h => by
      have ha := (h a (by simp)).1
      exact ⟨clampTo_mem ha x, axesInRange_sanitizeAxes as xs (fun b hb => h b (by simp [hb]))⟩

theorem sanitizeAxes_eq_self : ∀ (as : List AxisSpec) (xs : List ℤ),
    AxesInRange as xs → sanitizeAxes as xs = xs
  | [], [], _ => rfl
  | [], _ :: _, h => absurd h (by simp [AxesInRange])
  | _ :: _, [], h => absurd h (by simp [AxesInRange])
  | a :: as, x :: xs, h => by
      obtain ⟨h0, hrest⟩ := h
      rw [sanitizeAxes, clampTo_eq_self h0, sanitizeAxes_eq_self as xs hrest]

/-- Sanitising a command. -/
def GenericCommand.sanitize {spec : DeviceSpec} (c : GenericCommand spec) :
    GenericCommand spec :=
  { axisValues := sanitizeAxes spec.axes c.axisValues
    flagValues := c.flagValues
    hLen := length_sanitizeAxes _ _
    hFlagLen := c.hFlagLen }

/-- **Sanitising works, whatever the shape.** -/
theorem GenericCommand.sanitize_valid {spec : DeviceSpec} (hs : ∀ a ∈ spec.axes, a.Ok)
    (c : GenericCommand spec) : c.sanitize.Valid :=
  (valid_iff_axesInRange _).2 (axesInRange_sanitizeAxes _ _ hs)

/-- **And changes nothing it does not have to.** -/
theorem GenericCommand.sanitize_eq_self {spec : DeviceSpec} {c : GenericCommand spec}
    (h : c.Valid) : c.sanitize = c := by
  have := sanitizeAxes_eq_self spec.axes c.axisValues ((valid_iff_axesInRange c).1 h)
  cases c
  simp only [GenericCommand.sanitize, GenericCommand.mk.injEq]
  exact ⟨this, trivial⟩

theorem GenericCommand.sanitize_idem {spec : DeviceSpec} (hs : ∀ a ∈ spec.axes, a.Ok)
    (c : GenericCommand spec) : c.sanitize.sanitize = c.sanitize :=
  GenericCommand.sanitize_eq_self (GenericCommand.sanitize_valid hs c)

/-! ## The safety gate -/

/-- The most current one axis can call up. -/
def axisMaxDraw (a : AxisSpec) : ℤ :=
  a.coilsPerUnit * (max a.range.1.natAbs a.range.2.natAbs : ℕ)

/-- The peak draw a spec's *own* axes imply, whatever it may declare. -/
def DeviceSpec.impliedMaxDraw (spec : DeviceSpec) : ℤ :=
  spec.axes.foldl (fun acc a => acc + axisMaxDraw a) 0

/-- What a command actually calls up. -/
def totalCoilDraw (spec : DeviceSpec) (c : GenericCommand spec) : ℤ :=
  (List.zipWith (fun (a : AxisSpec) (x : ℤ) => a.coilsPerUnit * x) spec.axes c.axisValues).sum

theorem foldl_add_eq_sum_map {α : Type*} (f : α → ℤ) :
    ∀ (l : List α) (init : ℤ), l.foldl (fun acc a => acc + f a) init = init + (l.map f).sum
  | [], init => by simp
  | a :: as, init => by
      rw [List.foldl_cons, foldl_add_eq_sum_map f as (init + f a)]
      simp [List.sum_cons]
      ring

theorem impliedMaxDraw_eq (spec : DeviceSpec) :
    spec.impliedMaxDraw = (spec.axes.map axisMaxDraw).sum := by
  rw [DeviceSpec.impliedMaxDraw, foldl_add_eq_sum_map]
  simp

theorem axisDraw_le {a : AxisSpec} (ha : a.Ok) {x : ℤ} (hx : a.range.1 ≤ x ∧ x ≤ a.range.2) :
    a.coilsPerUnit * x ≤ axisMaxDraw a := by
  obtain ⟨-, hc, -⟩ := ha
  obtain ⟨-, hx2⟩ := hx
  have hb : x ≤ (max a.range.1.natAbs a.range.2.natAbs : ℕ) := by
    have h1 : a.range.2 ≤ (a.range.2.natAbs : ℤ) := Int.le_natAbs
    have h2 : (a.range.2.natAbs : ℤ) ≤ ((max a.range.1.natAbs a.range.2.natAbs : ℕ) : ℤ) := by
      exact_mod_cast Nat.le_max_right _ _
    omega
  exact mul_le_mul_of_nonneg_left hb hc

theorem coilDraw_le_implied :
    ∀ (as : List AxisSpec) (xs : List ℤ), (∀ a ∈ as, a.Ok) → AxesInRange as xs →
      (List.zipWith (fun (a : AxisSpec) (x : ℤ) => a.coilsPerUnit * x) as xs).sum ≤
        (as.map axisMaxDraw).sum
  | [], [], _, _ => by simp
  | [], _ :: _, _, h => absurd h (by simp [AxesInRange])
  | _ :: _, [], _, h => absurd h (by simp [AxesInRange])
  | a :: as, x :: xs, hok, h => by
      obtain ⟨h0, hrest⟩ := h
      have hhead := axisDraw_le (hok a (by simp)) h0
      have htail := coilDraw_le_implied as xs (fun b hb => hok b (by simp [hb])) hrest
      simp only [List.zipWith_cons_cons, List.map_cons, List.sum_cons]
      omega

/-- A spec the engine will accept: every axis well formed, the shape small
enough to travel, and the declared peak at least the peak the axes imply. -/
def SpecSafe (spec : DeviceSpec) : Prop :=
  (∀ a ∈ spec.axes, a.Ok) ∧ spec.axes.length < 256 ∧ spec.flags.length < 256 ∧
    spec.impliedMaxDraw ≤ spec.maxCoilDraw

instance (spec : DeviceSpec) : Decidable (SpecSafe spec) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _))

/-- **The safety property.**  A declared peak that clears the peak its own axes
imply is a peak no valid command can exceed — so a player-supplied spec can be
accepted or rejected once, at build time, and never re-examined at runtime. -/
theorem maxCoilDraw_sound {spec : DeviceSpec} (hax : ∀ a ∈ spec.axes, a.Ok)
    (h : spec.impliedMaxDraw ≤ spec.maxCoilDraw) :
    ∀ c : GenericCommand spec, c.Valid → totalCoilDraw spec c ≤ spec.maxCoilDraw := by
  intro c hc
  have := coilDraw_le_implied spec.axes c.axisValues hax ((valid_iff_axesInRange c).1 hc)
  rw [impliedMaxDraw_eq] at h
  exact le_trans this h

/-- The same, from the single decidable check. -/
theorem maxCoilDraw_sound_of_safe {spec : DeviceSpec} (h : SpecSafe spec) :
    ∀ c : GenericCommand spec, c.Valid → totalCoilDraw spec c ≤ spec.maxCoilDraw :=
  maxCoilDraw_sound h.1 h.2.2.2

/-- **And a sanitised command is safe even if it did not arrive safe.** -/
theorem sanitize_draw_le {spec : DeviceSpec} (h : SpecSafe spec) (c : GenericCommand spec) :
    totalCoilDraw spec c.sanitize ≤ spec.maxCoilDraw :=
  maxCoilDraw_sound_of_safe h _ (GenericCommand.sanitize_valid h.1 c)

/-! ## Bytes on the wire -/

/-- A number as one byte. -/
def byteOf (n : ℕ) : UInt8 := (n % 256).toUInt8

@[simp] theorem toNat_byteOf (n : ℕ) : (byteOf n).toNat = n % 256 :=
  UInt8.toNat_ofNat_of_lt' (Nat.mod_lt _ (by norm_num))

/-- A number as four bytes, big endian. -/
def enc32 (n : ℕ) : List UInt8 :=
  [byteOf (n / 16777216), byteOf (n / 65536), byteOf (n / 256), byteOf n]

/-- …and back. -/
def dec32 (b0 b1 b2 b3 : UInt8) : ℕ :=
  b0.toNat * 16777216 + b1.toNat * 65536 + b2.toNat * 256 + b3.toNat

theorem dec32_enc32 {n : ℕ} (h : n < 4294967296) :
    dec32 (byteOf (n / 16777216)) (byteOf (n / 65536)) (byteOf (n / 256)) (byteOf n) = n := by
  simp only [dec32, toNat_byteOf]
  omega

/-- One axis value, as four bytes: the demand measured from the bottom of its
own range. -/
def encAxisValue (a : AxisSpec) (x : ℤ) : List UInt8 :=
  enc32 (clampTo a.range x - a.range.1).toNat

/-- Every axis of a command, in order. -/
def encodeAxes : List AxisSpec → List ℤ → List UInt8
  | [], _ => []
  | a :: as, [] => encAxisValue a a.range.1 ++ encodeAxes as []
  | a :: as, x :: xs => encAxisValue a x ++ encodeAxes as xs

/-- Reading the axis values back, four bytes at a time. -/
def decodeAxes : List AxisSpec → List UInt8 → Option (List ℤ × List UInt8)
  | [], rest => some ([], rest)
  | a :: as, b0 :: b1 :: b2 :: b3 :: rest =>
      match decodeAxes as rest with
      | some (xs, r) => some ((a.range.1 + (dec32 b0 b1 b2 b3 : ℤ)) :: xs, r)
      | none => none
  | _ :: _, _ => none

theorem decodeAxes_encodeAxes :
    ∀ (as : List AxisSpec) (xs : List ℤ) (rest : List UInt8),
      (∀ a ∈ as, a.Ok) → AxesInRange as xs →
        decodeAxes as (encodeAxes as xs ++ rest) = some (xs, rest)
  | [], [], rest, _, _ => rfl
  | [], _ :: _, _, _, h => absurd h (by simp [AxesInRange])
  | _ :: _, [], _, _, h => absurd h (by simp [AxesInRange])
  | a :: as, x :: xs, rest, hok, h => by
      obtain ⟨h0, hrest⟩ := h
      obtain ⟨hlo, hcoil, hspan⟩ := hok a (by simp)
      have hclamp : clampTo a.range x = x := clampTo_eq_self h0
      have hn : (x - a.range.1).toNat < 4294967296 := by omega
      have hback : ((x - a.range.1).toNat : ℤ) = x - a.range.1 := Int.toNat_of_nonneg (by omega)
      have ih := decodeAxes_encodeAxes as xs rest (fun b hb => hok b (by simp [hb])) hrest
      simp only [encodeAxes, encAxisValue, enc32, hclamp, List.cons_append, List.nil_append,
        decodeAxes, ih]
      rw [dec32_enc32 hn]
      simp only [Option.some.injEq, Prod.mk.injEq, List.cons.injEq]
      and_intros <;> first | omega | rfl | trivial

/-- The flags, one byte each. -/
def encodeFlags : List String → List Bool → List UInt8
  | [], _ => []
  | _ :: fs, [] => (0 : UInt8) :: encodeFlags fs []
  | _ :: fs, b :: bs => (if b then (1 : UInt8) else 0) :: encodeFlags fs bs

/-- …and back. -/
def decodeFlags : List String → List UInt8 → Option (List Bool × List UInt8)
  | [], rest => some ([], rest)
  | _ :: fs, b :: rest =>
      match decodeFlags fs rest with
      | some (bs, r) => some ((b.toNat % 2 == 1) :: bs, r)
      | none => none
  | _ :: _, [] => none

theorem decodeFlags_encodeFlags :
    ∀ (fs : List String) (bs : List Bool) (rest : List UInt8), bs.length = fs.length →
      decodeFlags fs (encodeFlags fs bs ++ rest) = some (bs, rest)
  | [], [], rest, _ => rfl
  | [], _ :: _, _, h => by simp at h
  | _ :: _, [], _, h => by simp at h
  | f :: fs, b :: bs, rest, h => by
      have hlen : bs.length = fs.length := by simpa using h
      have ih := decodeFlags_encodeFlags fs bs rest hlen
      cases b <;> simp only [encodeFlags, List.cons_append, decodeFlags, ih] <;> rfl

/-! ## The frame -/

/-- The header of a generic command frame: `'L' 'T'` and a protocol byte that
is not the one the fixed-shape frame uses. -/
def gHeader : List UInt8 := [0x4C, 0x54, 0x10]

/-- The payload: every axis, then every flag. -/
def payloadG {spec : DeviceSpec} (c : GenericCommand spec) : List UInt8 :=
  encodeAxes spec.axes c.axisValues ++ encodeFlags spec.flags c.flagValues

/-- A frame.  It is self-describing: the axis count and the flag count travel
before the payload, so a reader can refuse a frame shaped for another device
without parsing a single value.  The checksum travels in the head, which lets
the whole frame be read in one pass. -/
def encodeG {spec : DeviceSpec} (c : GenericCommand spec) : List UInt8 :=
  gHeader ++ [byteOf spec.axes.length, byteOf spec.flags.length, checksum (payloadG c)] ++
    payloadG c

/-- Reading a frame against a *known* spec. -/
def decodeG (spec : DeviceSpec) : List UInt8 → Option (GenericCommand spec)
  | h1 :: h2 :: h3 :: na :: nf :: ck :: body =>
      if h1 = 0x4C ∧ h2 = 0x54 ∧ h3 = 0x10 ∧ na = byteOf spec.axes.length ∧
          nf = byteOf spec.flags.length ∧ ck = checksum body then
        match decodeAxes spec.axes body with
        | none => none
        | some (xs, rest) =>
            match decodeFlags spec.flags rest with
            | none => none
            | some (bs, []) =>
                if h : xs.length = spec.axes.length ∧ bs.length = spec.flags.length then
                  some ⟨xs, bs, h.1, h.2⟩
                else none
            | some (_, _ :: _) => none
      else none
  | _ => none

theorem length_encodeAxes : ∀ (as : List AxisSpec) (xs : List ℤ),
    (encodeAxes as xs).length = 4 * as.length
  | [], _ => rfl
  | a :: as, [] => by
      simp [encodeAxes, encAxisValue, enc32, length_encodeAxes as []]; ring
  | a :: as, x :: xs => by
      simp [encodeAxes, encAxisValue, enc32, length_encodeAxes as xs]; ring

theorem length_encodeFlags : ∀ (fs : List String) (bs : List Bool),
    (encodeFlags fs bs).length = fs.length
  | [], _ => rfl
  | f :: fs, [] => by simp [encodeFlags, length_encodeFlags fs []]
  | f :: fs, b :: bs => by simp [encodeFlags, length_encodeFlags fs bs]

/-- **The frame length is a function of the shape.** -/
theorem encodeG_length {spec : DeviceSpec} (c : GenericCommand spec) :
    (encodeG c).length = 6 + 4 * spec.axes.length + spec.flags.length := by
  simp [encodeG, gHeader, payloadG, length_encodeAxes, length_encodeFlags]
  omega

/-- **The round trip.**  A valid command comes back off the wire unchanged. -/
theorem decodeG_encodeG {spec : DeviceSpec} (hax : ∀ a ∈ spec.axes, a.Ok)
    {c : GenericCommand spec} (h : c.Valid) : decodeG spec (encodeG c) = some c := by
  have hax' := (valid_iff_axesInRange c).1 h
  have hA : decodeAxes spec.axes (payloadG c) =
      some (c.axisValues, encodeFlags spec.flags c.flagValues) :=
    decodeAxes_encodeAxes spec.axes c.axisValues _ hax hax'
  have hF : decodeFlags spec.flags (encodeFlags spec.flags c.flagValues) =
      some (c.flagValues, []) := by
    have := decodeFlags_encodeFlags spec.flags c.flagValues [] c.hFlagLen
    simpa using this
  have hbody : encodeG c = 0x4C :: 0x54 :: 0x10 :: byteOf spec.axes.length ::
      byteOf spec.flags.length :: checksum (payloadG c) :: payloadG c := rfl
  rw [hbody, decodeG, if_pos ⟨rfl, rfl, rfl, rfl, rfl, rfl⟩]
  simp only [hA, hF]
  rw [dif_pos ⟨c.hLen, c.hFlagLen⟩]

/-- Whatever the game sends, the device receives the sanitised version. -/
theorem decodeG_encodeG_sanitize {spec : DeviceSpec} (hax : ∀ a ∈ spec.axes, a.Ok)
    (c : GenericCommand spec) : decodeG spec (encodeG c.sanitize) = some c.sanitize :=
  decodeG_encodeG hax (GenericCommand.sanitize_valid hax c)

/-- **A frame whose checksum does not match is refused.** -/
theorem decodeG_checksum_mismatch {spec : DeviceSpec} {na nf ck : UInt8} {body : List UInt8}
    (h : ck ≠ checksum body) :
    decodeG spec (0x4C :: 0x54 :: 0x10 :: na :: nf :: ck :: body) = none := by
  simp only [decodeG]
  rw [if_neg]
  rintro ⟨-, -, -, -, -, hck⟩
  exact h hck

/-- **A frame shaped for another device is refused before it is parsed.** -/
theorem decodeG_wrong_shape {spec : DeviceSpec} {na nf ck : UInt8} {body : List UInt8}
    (h : na ≠ byteOf spec.axes.length) :
    decodeG spec (0x4C :: 0x54 :: 0x10 :: na :: nf :: ck :: body) = none := by
  simp only [decodeG]
  rw [if_neg]
  rintro ⟨-, -, -, hna, -, -⟩
  exact h hna

/-- **A frame with the wrong header is refused** — in particular a fixed-shape
frame from `Sim/Interface.lean`, whose protocol byte is `0x01`. -/
theorem decodeG_bad_header {spec : DeviceSpec} {h1 h2 h3 na nf ck : UInt8}
    {body : List UInt8} (h : h3 ≠ 0x10) :
    decodeG spec (h1 :: h2 :: h3 :: na :: nf :: ck :: body) = none := by
  simp only [decodeG]
  rw [if_neg]
  rintro ⟨-, -, hh, -, -, -⟩
  exact h hh

/-- **Nothing shorter than a head decodes.** -/
theorem decodeG_short {spec : DeviceSpec} {bs : List UInt8} (h : bs.length < 6) :
    decodeG spec bs = none := by
  match bs, h with
  | [], _ => rfl
  | [_], _ => rfl
  | [_, _], _ => rfl
  | [_, _, _], _ => rfl
  | [_, _, _, _], _ => rfl
  | [_, _, _, _, _], _ => rfl

end Device
end LifeTrac
