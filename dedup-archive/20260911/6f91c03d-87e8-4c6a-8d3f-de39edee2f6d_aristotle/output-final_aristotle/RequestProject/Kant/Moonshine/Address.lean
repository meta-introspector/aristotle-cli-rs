/-
# The 64-bit address: `magic ‖ class ‖ type ‖ digest prefix`

The legacy block asserted an address *and* a shard triple, and the two
disagreed.  Here the address is a single canonical word

```
[63..48] magic 0xDA51 | [47..30] class (18 bits) | [29..26] type (4) | [25..0] digest prefix
```

with `2^17 < 196883 ≤ 2^18`, so eighteen bits are exactly enough to carry a
placement class and no more.

Proved:

* `parse (render a) = some a` and `render a' = w` whenever `parse w = some a'`
  (`parse_render`, `render_parse`) — parser and renderer are mutually
  inverse, so the fields are the address and the address is the fields;
* the hexadecimal form used in the markup round-trips
  (`hexValue_renderHex`, `renderHex_injective`);
* **the layout does not determine content** (`address_does_not_determine_content`):
  any assignment of 64-bit words to payloads collides, so the 26-bit digest
  prefix is a display aid, never an identity;
* the legacy word `0xda51141032ac46ca` is *inconsistent with its own
  markup*: the triple derived from it is `(25, 12, 5)`, not the asserted
  `(68, 16, 35)` (`legacy_shard_disagrees_with_address`), and its byte
  reading is `(20, 16, 50)` (`legacy_bytes`) — the middle coordinate agrees
  and the outer two do not.  This is the concrete reason a derived field
  must never also be asserted.
-/
import Mathlib
import RequestProject.Kant.Bytes
import RequestProject.Kant.Moonshine.Crt

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

open Kant.Bytes

/-! ## Field widths -/

/-- The 16-bit magic prefix, as in `Kant.Dasl`. -/
def addrMagic : ℕ := 0xDA51

/-- Eighteen bits carry a placement class, and seventeen would not. -/
theorem class_width : 2 ^ 17 < 196883 ∧ 196883 ≤ 2 ^ 18 := by decide

/-- A parsed address: four fields, each within its width. -/
structure Address where
  /-- The placement class (18 bits, and below `196883`). -/
  cls : ℕ
  /-- The object type nibble. -/
  typ : ℕ
  /-- The low bits of the content digest, carried for display only. -/
  digestPrefix : ℕ
  cls_lt : cls < 196883
  typ_lt : typ < 16
  digestPrefix_lt : digestPrefix < 2 ^ 26
deriving DecidableEq

/-- Assemble the 64-bit word. -/
def Address.render (a : Address) : ℕ :=
  addrMagic * 2 ^ 48 + a.cls * 2 ^ 30 + a.typ * 2 ^ 26 + a.digestPrefix

/-- Read the fields of a word, rejecting anything that is not a well-formed
address. -/
def parseAddress (w : ℕ) : Option Address :=
  if h : w / 2 ^ 48 = addrMagic ∧ (w / 2 ^ 30) % 2 ^ 18 < 196883 then
    some { cls := (w / 2 ^ 30) % 2 ^ 18
           typ := (w / 2 ^ 26) % 16
           digestPrefix := w % 2 ^ 26
           cls_lt := h.2
           typ_lt := Nat.mod_lt _ (by norm_num)
           digestPrefix_lt := Nat.mod_lt _ (by positivity) }
  else none

theorem Address.render_lt (a : Address) : a.render < 2 ^ 64 := by
  have h1 := a.cls_lt; have h2 := a.typ_lt; have h3 := a.digestPrefix_lt
  simp only [render, addrMagic]
  norm_num at h1 h2 h3 ⊢
  omega

@[simp] theorem Address.render_magic (a : Address) : a.render / 2 ^ 48 = addrMagic := by
  have h1 := a.cls_lt; have h2 := a.typ_lt; have h3 := a.digestPrefix_lt
  simp only [render, addrMagic]
  norm_num at h1 h2 h3 ⊢
  omega

@[simp] theorem Address.render_cls (a : Address) : (a.render / 2 ^ 30) % 2 ^ 18 = a.cls := by
  have h1 := a.cls_lt; have h2 := a.typ_lt; have h3 := a.digestPrefix_lt
  simp only [render, addrMagic]
  norm_num at h1 h2 h3 ⊢
  omega

@[simp] theorem Address.render_typ (a : Address) : (a.render / 2 ^ 26) % 16 = a.typ := by
  have h1 := a.cls_lt; have h2 := a.typ_lt; have h3 := a.digestPrefix_lt
  simp only [render, addrMagic]
  norm_num at h1 h2 h3 ⊢
  omega

@[simp] theorem Address.render_digestPrefix (a : Address) : a.render % 2 ^ 26 = a.digestPrefix := by
  have h1 := a.cls_lt; have h2 := a.typ_lt; have h3 := a.digestPrefix_lt
  simp only [render, addrMagic]
  norm_num at h1 h2 h3 ⊢
  omega

/-- **Renderer then parser is the identity.** -/
@[simp] theorem parse_render (a : Address) : parseAddress a.render = some a := by
  have hc : (a.render / 2 ^ 30) % 2 ^ 18 < 196883 := by rw [a.render_cls]; exact a.cls_lt
  simp only [parseAddress, a.render_magic, hc, and_self, dif_pos, Option.some.injEq]
  cases a
  simp only [Address.mk.injEq]
  exact ⟨Address.render_cls _, Address.render_typ _, Address.render_digestPrefix _⟩

/-- **Parser then renderer is the identity** on words it accepts. -/
theorem render_parse {w : ℕ} {a : Address} (h : parseAddress w = some a) :
    a.render = w := by
  simp only [parseAddress] at h
  split at h
  · rename_i hcond
    obtain ⟨hm, _⟩ := hcond
    have := Option.some.inj h
    subst this
    simp only [Address.render, ← hm]
    norm_num
    omega
  · exact absurd h (by simp)

/-- Distinct fields give distinct words. -/
theorem Address.render_injective : Function.Injective Address.render := by
  intro a b h
  have ha := parse_render a
  have hb := parse_render b
  rw [h, hb] at ha
  exact (Option.some.inj ha).symm

/-! ## The hexadecimal form used in the markup -/

/-- `k` hexadecimal digits of `v`, most significant first. -/
def hexDigits : ℕ → ℕ → List Char
  | 0, _ => []
  | k + 1, v => hexDigits k (v / 16) ++ [hexDigit (v % 16)]

theorem hexDigits_length (k v : ℕ) : (hexDigits k v).length = k := by
  induction k generalizing v with
  | zero => rfl
  | succ k ih => simp [hexDigits, ih]

/-- Value of a big-endian hexadecimal string. -/
def hexValue : List Char → Option ℕ
  | [] => some 0
  | c :: cs => match hexVal c, hexValue cs with
    | some d, some v => some (d * 16 ^ cs.length + v)
    | _, _ => none

theorem hexValue_append (a b : List Char) {va vb : ℕ}
    (ha : hexValue a = some va) (hb : hexValue b = some vb) :
    hexValue (a ++ b) = some (va * 16 ^ b.length + vb) := by
  induction a generalizing va with
  | nil =>
      simp only [hexValue, Option.some.injEq] at ha
      subst ha
      simpa using hb
  | cons c cs ih =>
      simp only [hexValue] at ha
      rcases hd : hexVal c with _ | d
      · rw [hd] at ha; simp at ha
      · rcases hv : hexValue cs with _ | v
        · rw [hd, hv] at ha; simp at ha
        · rw [hd, hv] at ha
          simp only [Option.some.injEq] at ha
          subst ha
          have hrec := ih hv
          simp only [List.cons_append, hexValue, hd, hrec, List.length_append,
            Option.some.injEq]
          rw [pow_add]
          ring

/-- **Round trip.** Reading back `k` rendered digits gives the value modulo
`16^k`. -/
theorem hexValue_hexDigits (k v : ℕ) : hexValue (hexDigits k v) = some (v % 16 ^ k) := by
  induction k generalizing v with
  | zero => simp [hexDigits, hexValue, Nat.mod_one]
  | succ k ih =>
      have hlast : hexValue [hexDigit (v % 16)] = some (v % 16) := by
        simp only [hexValue, hexVal_hexDigit (Nat.mod_lt _ (by norm_num : (0:ℕ) < 16))]
        simp
      rw [hexDigits, hexValue_append _ _ (ih (v / 16)) hlast]
      simp only [List.length_singleton, pow_one, Option.some.injEq]
      rw [pow_succ', Nat.mod_mul]
      ring

/-- The `dasl:addr` attribute text: `0x` and sixteen digits. -/
def Address.renderHex (a : Address) : List Char := '0' :: 'x' :: hexDigits 16 a.render

/-- Parse an address from its attribute text. -/
def parseAddressHex (s : List Char) : Option Address :=
  match s with
  | '0' :: 'x' :: ds =>
      if ds.length = 16 then
        match hexValue ds with
        | some w => parseAddress w
        | none => none
      else none
  | _ => none

theorem Address.render_mod (a : Address) : a.render % 16 ^ 16 = a.render :=
  Nat.mod_eq_of_lt (by simpa [show (16:ℕ) ^ 16 = 2 ^ 64 by norm_num] using a.render_lt)

/-- **The attribute text round-trips**: what the markup shows is exactly the
address, and reading it back gives the same four fields. -/
theorem parseAddressHex_renderHex (a : Address) : parseAddressHex a.renderHex = some a := by
  simp only [Address.renderHex, parseAddressHex, hexDigits_length,
    hexValue_hexDigits, a.render_mod, parse_render, if_true]

theorem Address.renderHex_injective : Function.Injective Address.renderHex := by
  intro a b h
  have := congrArg parseAddressHex h
  rw [parseAddressHex_renderHex, parseAddressHex_renderHex] at this
  exact Option.some.inj this

/-! ## The address of a payload -/

/-- The address of a payload of a given type: the class is derived from the
digest, and the prefix is the low bits of that digest. -/
def addressOf (typ : ℕ) (data : Blob) : Address :=
  { cls := (placementOf data).val
    typ := typ % 16
    digestPrefix := natOfBytes (digest data) % 2 ^ 26
    cls_lt := ZMod.val_lt _
    typ_lt := Nat.mod_lt _ (by norm_num)
    digestPrefix_lt := Nat.mod_lt _ (by positivity) }

theorem addressOf_cls (typ : ℕ) (data : Blob) :
    (addressOf typ data).cls = (placementOf data).val := rfl

/-- **The address does not determine content.**  Sixty-four bits, infinitely
many payloads: every addressing scheme collides.  Identity stays with the
full-width digest. -/
theorem address_does_not_determine_content (f : Blob → Address) :
    ∃ a b : Blob, a ≠ b ∧ f a = f b := by
  have : Infinite { l : Blob // True } :=
    Infinite.of_injective (fun n : ℕ => ⟨List.replicate n 0, trivial⟩)
      (fun m n h => blob_infinite (congrArg Subtype.val h))
  obtain ⟨x, y, hne, heq⟩ :=
    Finite.exists_ne_map_eq_of_infinite
      (fun l : { l : Blob // True } => (⟨(f l.1).render, (f l.1).render_lt⟩ : Fin (2 ^ 64)))
  refine ⟨x.1, y.1, fun h => hne (Subtype.ext h), ?_⟩
  exact Address.render_injective (congrArg Fin.val heq)

/-! ## The legacy word, and why it contradicted its own markup -/

/-- The address printed in the old block. -/
def legacyWord : ℕ := 0xda51141032ac46ca

/-- The triple the old block asserted in `erdfa:shard`. -/
def legacyAssertedShard : ℕ × ℕ × ℕ := (68, 16, 35)

/-- Bytes three, four and five of the legacy word: the reading that made the
middle coordinate look right. -/
theorem legacy_bytes :
    ((legacyWord / 2 ^ 40) % 256, (legacyWord / 2 ^ 32) % 256, (legacyWord / 2 ^ 24) % 256)
      = (20, 16, 50) := by decide

/-- Under the canonical layout the legacy word does parse, with class
`20544`, type `12` and prefix `44844746`. -/
theorem legacy_parses :
    (parseAddress legacyWord).map (fun a => (a.cls, a.typ, a.digestPrefix))
      = some (20544, 12, 44844746) := by decide

/-- **The asserted triple is not the derived triple.**  The class carried by
the legacy word has coordinates `(25, 12, 5)`; the block asserted
`(68, 16, 35)`.  One of the two fields had to be derived, and neither was. -/
theorem legacy_shard_disagrees_with_address :
    ((20544 : ℕ) % 71, (20544 : ℕ) % 59, (20544 : ℕ) % 47) ≠ legacyAssertedShard := by
  decide

/-- The derived coordinates of the legacy class, for the record. -/
theorem legacy_derived_shard :
    ((20544 : ℕ) % 71, (20544 : ℕ) % 59, (20544 : ℕ) % 47) = (25, 12, 5) := by decide

end Kant.Moonshine
