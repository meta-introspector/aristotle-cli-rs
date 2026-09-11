import RequestProject.Gvcs.Sim.Dynamic
import RequestProject.Gvcs.Controls

/-!
# The external interface: wiring the circuits to the controls of the game

The circuits of `Sim/Static.lean`, `Sim/Electric.lean` and `Sim/Dynamic.lean`
live in Lean; the game that drives them runs somewhere else — in a browser, in
Roblox, in a joystick handler.  Something has to carry the driver's intention
in and the state of the machine out.  This file is that something: a small
binary protocol, defined once, with the properties an interface has to have
proved rather than tested.

A **command frame** is thirteen bytes:

```
'L' 'T' 0x01 | throttle hi lo | steer hi lo | lift hi lo | tilt hi lo | flags | checksum
```

each axis being a signed value in thousandths, `-1000 … 1000`, carried as an
unsigned 16-bit number offset by 1000, and `flags` carrying the ignition and
the lights.  A **telemetry frame** is the same idea in the other direction.

Proved here:

* `Command.sanitize_valid` and `Command.sanitize_eq_self` — whatever the game
  sends, sanitising it puts every axis inside its range, and sanitising a
  legal command changes nothing (so the interface cannot be made to demand
  more of the machine than it can do);
* `decode_encode` — a valid command survives the round trip through the wire
  exactly; `decode_encode_sanitize` — an arbitrary one survives it up to
  sanitising;
* `encode_length`, `decode_length_eq` — frames are 13 bytes and nothing else
  decodes;
* `decode_checksum_mismatch` — a frame whose checksum does not match is
  rejected, so a corrupted byte cannot be taken for a command;
* `Telemetry.decode_encode` — the same for the state going back to the game;
* the bridge to the machine itself: `Command.forward`, `Command.turn` and
  `forward_mem_Icc`, `turn_mem_Icc`, which land in exactly the interval the
  skid-steer mixer of `Controls.lean` expects, `Command.coils` counting the
  valve coils a command energises, and `coilDraw_le_peak`, which says no
  command the interface can deliver can overload the electrical system.
-/

namespace LifeTrac
namespace Interface

open Electric

/-! ## Commands -/

/-- What the driver (or the autopilot) asks of the machine, in thousandths of
full scale. -/
structure Command where
  /-- Forward demand, `-1000 … 1000`. -/
  throttle : ℤ
  /-- Right-turn demand, `-1000 … 1000`. -/
  steer : ℤ
  /-- Loader lift demand, `-1000 … 1000`. -/
  lift : ℤ
  /-- Bucket tilt demand, `-1000 … 1000`. -/
  tilt : ℤ
  /-- Ignition on? -/
  ignition : Bool
  /-- Lights on? -/
  lights : Bool
  deriving DecidableEq, Repr

/-- The neutral command: everything centred, everything off. -/
def Command.neutral : Command := ⟨0, 0, 0, 0, false, false⟩

/-- An axis value is in range when it is a demand of at most full scale. -/
def InRange (x : ℤ) : Prop := -1000 ≤ x ∧ x ≤ 1000

instance (x : ℤ) : Decidable (InRange x) := inferInstanceAs (Decidable (_ ∧ _))

/-- A command is valid when every axis is in range. -/
def Command.Valid (c : Command) : Prop :=
  InRange c.throttle ∧ InRange c.steer ∧ InRange c.lift ∧ InRange c.tilt

instance (c : Command) : Decidable c.Valid :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _ ∧ _))

/-- Clamp one axis into range. -/
def clampAxis (x : ℤ) : ℤ := max (-1000) (min 1000 x)

theorem clampAxis_inRange (x : ℤ) : InRange (clampAxis x) := by
  unfold InRange clampAxis
  omega

theorem clampAxis_eq_self {x : ℤ} (h : InRange x) : clampAxis x = x := by
  obtain ⟨h1, h2⟩ := h
  unfold clampAxis
  omega

/-- Sanitising a command: clamp every axis. -/
def Command.sanitize (c : Command) : Command :=
  { c with throttle := clampAxis c.throttle, steer := clampAxis c.steer,
           lift := clampAxis c.lift, tilt := clampAxis c.tilt }

theorem Command.sanitize_valid (c : Command) : c.sanitize.Valid :=
  ⟨clampAxis_inRange _, clampAxis_inRange _, clampAxis_inRange _, clampAxis_inRange _⟩

theorem Command.sanitize_eq_self {c : Command} (h : c.Valid) : c.sanitize = c := by
  obtain ⟨h1, h2, h3, h4⟩ := h
  simp [Command.sanitize, clampAxis_eq_self h1, clampAxis_eq_self h2, clampAxis_eq_self h3,
    clampAxis_eq_self h4]

theorem Command.sanitize_idem (c : Command) : c.sanitize.sanitize = c.sanitize :=
  Command.sanitize_eq_self c.sanitize_valid

/-! ## Bytes on the wire -/

/-- The three-byte header of every frame: `'L' 'T'` and the protocol version. -/
def header : List UInt8 := [0x4C, 0x54, 0x01]

/-- High byte of an axis: the value offset by 1000 into `0 … 2000`, big
endian. -/
def encAxisHi (x : ℤ) : UInt8 := ((clampAxis x + 1000).toNat / 256).toUInt8

/-- Low byte of an axis. -/
def encAxisLo (x : ℤ) : UInt8 := ((clampAxis x + 1000).toNat % 256).toUInt8

/-- An axis, as two bytes. -/
def encAxis (x : ℤ) : List UInt8 := [encAxisHi x, encAxisLo x]

/-- …and back. -/
def decAxis (hi lo : UInt8) : ℤ := (hi.toNat * 256 + lo.toNat : ℤ) - 1000

theorem decAxis_encAxis {x : ℤ} (h : InRange x) :
    decAxis (encAxisHi x) (encAxisLo x) = x := by
  obtain ⟨h1, h2⟩ := h
  have hc : clampAxis x = x := clampAxis_eq_self ⟨h1, h2⟩
  simp only [encAxisHi, encAxisLo, hc, decAxis]
  set n := (x + 1000).toNat with hn
  have hn2 : (n : ℤ) = x + 1000 := Int.toNat_of_nonneg (by omega)
  have hlt : n < 2001 := by omega
  have hhi : (n / 256) < 256 := by omega
  have hlo : (n % 256) < 256 := Nat.mod_lt _ (by norm_num)
  rw [UInt8.toNat_ofNat_of_lt' hhi, UInt8.toNat_ofNat_of_lt' hlo]
  have := Nat.div_add_mod n 256
  omega

/-- The flags byte: bit 0 the ignition, bit 1 the lights. -/
def encFlags (ign lights : Bool) : UInt8 :=
  (if ign then 1 else 0) + (if lights then 2 else 0)

/-- Ignition bit of a flags byte. -/
def decIgnition (b : UInt8) : Bool := b.toNat % 2 == 1

/-- Lights bit of a flags byte. -/
def decLights (b : UInt8) : Bool := b.toNat / 2 % 2 == 1

@[simp] theorem decIgnition_encFlags (a b : Bool) : decIgnition (encFlags a b) = a := by
  cases a <;> cases b <;> decide

@[simp] theorem decLights_encFlags (a b : Bool) : decLights (encFlags a b) = b := by
  cases a <;> cases b <;> decide

/-- The checksum of a payload: the bytes added up, modulo 256. -/
def checksum (bs : List UInt8) : UInt8 :=
  (bs.foldl (fun (a : ℕ) (b : UInt8) => (a + b.toNat) % 256) 0).toUInt8

/-- The nine payload bytes of a command frame. -/
def payload (c : Command) : List UInt8 :=
  encAxis c.throttle ++ encAxis c.steer ++ encAxis c.lift ++ encAxis c.tilt ++
    [encFlags c.ignition c.lights]

/-- A command frame. -/
def encode (c : Command) : List UInt8 := header ++ payload c ++ [checksum (payload c)]

/-- Reading a command frame: the header, the length and the checksum must all
be right, or nothing is returned. -/
def decode : List UInt8 → Option Command
  | [h1, h2, h3, t1, t2, s1, s2, l1, l2, b1, b2, f, ck] =>
      if h1 = 0x4C ∧ h2 = 0x54 ∧ h3 = 0x01 ∧
          ck = checksum [t1, t2, s1, s2, l1, l2, b1, b2, f] then
        some { throttle := decAxis t1 t2, steer := decAxis s1 s2, lift := decAxis l1 l2,
               tilt := decAxis b1 b2, ignition := decIgnition f, lights := decLights f }
      else none
  | _ => none

/-- Every frame is thirteen bytes. -/
theorem encode_length (c : Command) : (encode c).length = 13 := by
  simp [encode, header, payload, encAxis]

/-- Nothing but a thirteen-byte frame decodes. -/
theorem decode_length_eq {bs : List UInt8} {c : Command} (h : decode bs = some c) :
    bs.length = 13 := by
  unfold decode at h
  split at h
  · simp
  · exact absurd h (by simp)

/-- **The round trip.**  A valid command comes back off the wire unchanged. -/
theorem decode_encode {c : Command} (h : c.Valid) : decode (encode c) = some c := by
  obtain ⟨h1, h2, h3, h4⟩ := h
  have e1 := decAxis_encAxis h1
  have e2 := decAxis_encAxis h2
  have e3 := decAxis_encAxis h3
  have e4 := decAxis_encAxis h4
  simp only [encode, header, payload, encAxis, List.cons_append,
    List.nil_append, decode]
  rw [if_pos (by refine ⟨?_, ?_, ?_, ?_⟩ <;> trivial)]
  simp only [Option.some.injEq]
  cases c
  simp_all

/-- Whatever the game sends, the machine receives the sanitised version of
it. -/
theorem decode_encode_sanitize (c : Command) :
    decode (encode c.sanitize) = some c.sanitize :=
  decode_encode c.sanitize_valid

/-- A frame whose checksum does not match is refused. -/
theorem decode_checksum_mismatch {t1 t2 s1 s2 l1 l2 b1 b2 f ck : UInt8}
    (h : ck ≠ checksum [t1, t2, s1, s2, l1, l2, b1, b2, f]) :
    decode [0x4C, 0x54, 0x01, t1, t2, s1, s2, l1, l2, b1, b2, f, ck] = none := by
  simp only [decode]
  rw [if_neg]
  rintro ⟨-, -, -, hck⟩
  exact h hck

/-- A frame with the wrong header is refused. -/
theorem decode_bad_header {h1 : UInt8} (hne : h1 ≠ 0x4C) (rest : List UInt8)
    (hlen : rest.length = 12) : decode (h1 :: rest) = none := by
  match rest, hlen with
  | [a, b, c, d, e, f, g, i, j, k, l, m], _ =>
      simp only [decode]
      rw [if_neg]
      rintro ⟨hh, -, -, -⟩
      exact hne hh

/-! ## Telemetry: the machine answering back -/

/-- What the machine reports each tick: all quantities as whole units, offset
so that they travel as unsigned 16-bit numbers. -/
structure Telemetry where
  /-- Battery voltage, in millivolts (`0 … 65535`). -/
  batt_mV : ℤ
  /-- Supply pressure, in kilopascals. -/
  press_kPa : ℤ
  /-- Engine speed, in rpm. -/
  rpm : ℤ
  /-- Ground speed, in millimetres per second, offset by 1000 like an axis. -/
  speed_mmps : ℤ
  deriving DecidableEq, Repr

/-- An unsigned field is in range when it fits in sixteen bits. -/
def InWord (x : ℤ) : Prop := 0 ≤ x ∧ x ≤ 65535

/-- A telemetry record is valid when its unsigned fields fit and its signed
speed is an axis-sized quantity. -/
def Telemetry.Valid (s : Telemetry) : Prop :=
  InWord s.batt_mV ∧ InWord s.press_kPa ∧ InWord s.rpm ∧ InRange s.speed_mmps

/-- High byte of an unsigned 16-bit field, big endian. -/
def encWordHi (x : ℤ) : UInt8 := (x.toNat / 256 % 256).toUInt8

/-- Low byte of an unsigned 16-bit field. -/
def encWordLo (x : ℤ) : UInt8 := (x.toNat % 256).toUInt8

/-- An unsigned 16-bit field, big endian. -/
def encWord (x : ℤ) : List UInt8 := [encWordHi x, encWordLo x]

/-- …and back. -/
def decWord (hi lo : UInt8) : ℤ := (hi.toNat * 256 + lo.toNat : ℤ)

theorem decWord_encWord {x : ℤ} (h : InWord x) :
    decWord (encWordHi x) (encWordLo x) = x := by
  obtain ⟨h1, h2⟩ := h
  simp only [encWordHi, encWordLo, decWord]
  set n := x.toNat with hn
  have hn2 : (n : ℤ) = x := Int.toNat_of_nonneg h1
  have hlt : n < 65536 := by omega
  have hhi : (n / 256 % 256) < 256 := Nat.mod_lt _ (by norm_num)
  have hlo : (n % 256) < 256 := Nat.mod_lt _ (by norm_num)
  rw [UInt8.toNat_ofNat_of_lt' hhi, UInt8.toNat_ofNat_of_lt' hlo]
  have hdm := Nat.div_add_mod n 256
  have hsmall : n / 256 % 256 = n / 256 := Nat.mod_eq_of_lt (by omega)
  rw [hsmall]
  omega

/-- The payload of a telemetry frame. -/
def telemetryPayload (s : Telemetry) : List UInt8 :=
  encWord s.batt_mV ++ encWord s.press_kPa ++ encWord s.rpm ++ encAxis s.speed_mmps

/-- A telemetry frame: the same header with a different version byte, so a
command and a report cannot be confused. -/
def Telemetry.encode (s : Telemetry) : List UInt8 :=
  [0x4C, 0x54, 0x02] ++ telemetryPayload s ++ [checksum (telemetryPayload s)]

/-- Reading a telemetry frame. -/
def Telemetry.decode : List UInt8 → Option Telemetry
  | [h1, h2, h3, v1, v2, p1, p2, r1, r2, s1, s2, ck] =>
      if h1 = 0x4C ∧ h2 = 0x54 ∧ h3 = 0x02 ∧
          ck = checksum [v1, v2, p1, p2, r1, r2, s1, s2] then
        some { batt_mV := decWord v1 v2, press_kPa := decWord p1 p2, rpm := decWord r1 r2,
               speed_mmps := decAxis s1 s2 }
      else none
  | _ => none

/-- **The round trip, the other way.** -/
theorem Telemetry.decode_encode {s : Telemetry} (h : s.Valid) :
    Telemetry.decode s.encode = some s := by
  obtain ⟨h1, h2, h3, h4⟩ := h
  have e1 := decWord_encWord h1
  have e2 := decWord_encWord h2
  have e3 := decWord_encWord h3
  have e4 := decAxis_encAxis h4
  simp only [Telemetry.encode, telemetryPayload, encWord, encAxis,
    List.cons_append, List.nil_append, Telemetry.decode]
  rw [if_pos (by refine ⟨?_, ?_, ?_, ?_⟩ <;> trivial)]
  simp only [Option.some.injEq]
  cases s
  simp_all

/-! ## What a command means to the machine -/

/-- The forward demand as a fraction of full scale, the form the skid-steer
mixer of `Controls.lean` takes. -/
noncomputable def Command.forward (c : Command) : ℝ := (c.throttle : ℝ) / 1000

/-- The turn demand as a fraction of full scale. -/
noncomputable def Command.turn (c : Command) : ℝ := (c.steer : ℝ) / 1000

theorem Command.forward_mem_Icc {c : Command} (h : c.Valid) : c.forward ∈ Set.Icc (-1 : ℝ) 1 := by
  obtain ⟨⟨h1, h2⟩, -⟩ := h
  have h1' : ((-1000 : ℤ) : ℝ) ≤ (c.throttle : ℝ) := by exact_mod_cast h1
  have h2' : (c.throttle : ℝ) ≤ ((1000 : ℤ) : ℝ) := by exact_mod_cast h2
  push_cast at h1' h2'
  constructor <;> rw [Command.forward] <;> [linarith; linarith]

theorem Command.turn_mem_Icc {c : Command} (h : c.Valid) : c.turn ∈ Set.Icc (-1 : ℝ) 1 := by
  obtain ⟨-, ⟨h1, h2⟩, -⟩ := h
  have h1' : ((-1000 : ℤ) : ℝ) ≤ (c.steer : ℝ) := by exact_mod_cast h1
  have h2' : (c.steer : ℝ) ≤ ((1000 : ℤ) : ℝ) := by exact_mod_cast h2
  push_cast at h1' h2'
  constructor <;> rw [Command.turn] <;> [linarith; linarith]

/-- A command off the wire drives the mixer of `Controls.lean` without ever
asking a wheel for more than it can give. -/
theorem mix_within_envelope {vmax : ℝ} (hv : 0 ≤ vmax) (c : Command) :
    |Chassis.mixL vmax c.forward c.turn| ≤ vmax ∧
      |Chassis.mixR vmax c.forward c.turn| ≤ vmax :=
  ⟨Chassis.abs_mixL_le hv _ _, Chassis.abs_mixR_le hv _ _⟩

/-- How many valve coils a command energises: one for each hydraulic service it
asks to move. -/
def Command.coils (c : Command) : ℕ :=
  (if c.throttle ≠ 0 then 1 else 0) + (if c.steer ≠ 0 then 1 else 0) +
    (if c.lift ≠ 0 then 1 else 0) + (if c.tilt ≠ 0 then 1 else 0)

theorem Command.coils_le_four (c : Command) : c.coils ≤ 4 := by
  unfold Command.coils
  split <;> split <;> split <;> split <;> norm_num

/-- **No command can overload the electrics.**  Whatever the interface
delivers, the current it calls up is within the worst case the system is sized
for. -/
theorem coilDraw_le_peak (c : Command) :
    lifeTracElectrics.draw 12 c.coils ≤ lifeTracElectrics.peakDraw 12 :=
  lifeTracElectrics.draw_le_peak (by norm_num) (by simpa [lifeTracElectrics] using c.coils_le_four)

/-! ## A worked frame -/

/-- Half throttle, a touch of right steer, loader coming up, ignition and
lights on. -/
def sampleCommand : Command := ⟨500, 250, 1000, -250, true, true⟩

theorem sampleCommand_valid : sampleCommand.Valid := by decide

theorem sampleCommand_roundtrip : decode (encode sampleCommand) = some sampleCommand :=
  decode_encode sampleCommand_valid

end Interface
end LifeTrac
