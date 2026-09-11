/-
# The catalogue element: five layers, none of them asserted twice

This is the record that replaces the legacy `<div>`.  Its discipline is that
**only two things are stored** — the content identity and the choices a
publisher actually makes — and everything else is a *function* of them:

```
identity (full-width digest)   ── stored
type, encoding, eigenspace, Bott degree, irrep index   ── stored (typed)
placement class, coordinates, 64-bit address           ── derived
shadow evidence (≤ 3 anchors)                          ── stored, separate
replication witnesses and threshold                    ── stored, separate
```

so the failure that produced `shard = 68,16,35` beside an address saying
something else cannot recur: there is no second place to write the triple.

Proved:

* every derived field is a function of the stored ones, and they agree —
  `address_cls_eq_placement`, `coords_eq_of_address`;
* the typed metadata round-trips against its attribute text
  (`parseEncoding_encodingName` and friends), so the markup cannot drift
  from the model;
* the Bott field is a value of one clock, not two: the real Clifford clock
  mod 8, in which `Cl₂ = ℍ` — which is what the legacy `"2 (H)"` was
  reaching for (`cliffordOf_two`, `bott_attr_roundTrip`);
* `WellFormed` is decidable, bounds the frame at three *distinct* anchors
  that are not the target, and requires a replication threshold that its
  witness list can actually meet;
* the two counts are independent: a frame of three landmarks with a
  threshold of two, and a frame of none with a threshold of three, are both
  well formed (`counts_are_independent`).  No single constant configures
  both.
-/
import Mathlib
import RequestProject.Kant.Sheaf
import RequestProject.Kant.Moonshine.Address
import RequestProject.Kant.Moonshine.Shadow

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

open Kant.Bytes Kant.Sheaf

/-! ## Typed metadata, with total decoders -/

/-- The real Clifford clock: `Cl₀ … Cl₇`, which is the clock on which the
legacy `"2 (H)"` makes sense — `Cl₂ = ℍ`.  Complex Bott periodicity is mod 2
and is a different field; this one is mod 8. -/
inductive Clifford
  | R | C | H | HplusH | H2 | C4 | R8 | R8plusR8
deriving DecidableEq, Repr, Fintype

/-- The Clifford algebra at a real Bott degree. -/
def cliffordOf : Fin 8 → Clifford
  | 0 => .R
  | 1 => .C
  | 2 => .H
  | 3 => .HplusH
  | 4 => .H2
  | 5 => .C4
  | 6 => .R8
  | 7 => .R8plusR8

/-- `Cl₂ = ℍ`: the reading the legacy attribute wanted. -/
theorem cliffordOf_two : cliffordOf 2 = .H := rfl

/-- The clock is faithful: eight degrees, eight algebras. -/
theorem cliffordOf_injective : Function.Injective cliffordOf := by decide

/-- Attribute text of an algebra. -/
def cliffordName : Clifford → List Char
  | .R => "R".toList
  | .C => "C".toList
  | .H => "H".toList
  | .HplusH => "H+H".toList
  | .H2 => "H(2)".toList
  | .C4 => "C(4)".toList
  | .R8 => "R(8)".toList
  | .R8plusR8 => "R(8)+R(8)".toList

/-- The eight Bott degrees. -/
def allBott : List (Fin 8) := [0, 1, 2, 3, 4, 5, 6, 7]

/-- The `dasl:bott` attribute: the degree and, in brackets, its algebra —
both derived from one value of `Fin 8`. -/
def bottAttr (d : Fin 8) : List Char :=
  [Char.ofNat (48 + d.val)] ++ " (".toList ++ cliffordName (cliffordOf d) ++ ")".toList

/-- Read the attribute back. -/
def parseBottAttr (s : List Char) : Option (Fin 8) :=
  allBott.find? (fun d => bottAttr d = s)

/-- **The Bott attribute round-trips.**  In particular `bottAttr 2 = "2 (H)"`. -/
theorem bott_attr_roundTrip (d : Fin 8) : parseBottAttr (bottAttr d) = some d := by
  fin_cases d <;> decide

theorem bottAttr_two : bottAttr 2 = "2 (H)".toList := by decide

/-- The four eigenspaces. -/
def allEigenSpaces : List EigenSpace := [.earth, .spoke, .hub, .clock]

/-- Attribute text of an eigenspace. -/
def eigenName : EigenSpace → List Char
  | .earth => "Earth".toList
  | .spoke => "Spoke".toList
  | .hub => "Hub".toList
  | .clock => "Clock".toList

def parseEigenSpace (s : List Char) : Option EigenSpace :=
  allEigenSpaces.find? (fun e => eigenName e = s)

theorem parseEigenSpace_name (e : EigenSpace) : parseEigenSpace (eigenName e) = some e := by
  cases e <;> decide

/-- The ten encodings of `Kant.Sheaf`. -/
def allEncodings : List Encoding :=
  [.raw, .base64, .morse, .split, .qr, .dtmf, .numbers, .stego, .ipfs, .dasl]

/-- The encoding names are those of `Kant.Sheaf`; here they are given a total
decoder that fails on unknown text instead of silently defaulting to `raw`. -/
def parseEncodingStrict (s : List Char) : Option Encoding :=
  allEncodings.find? (fun e => e.name = s)

theorem parseEncodingStrict_name (e : Encoding) : parseEncodingStrict e.name = some e := by
  cases e <;> decide

/-- Unknown attribute text is rejected rather than read as `raw`. -/
theorem parseEncodingStrict_unknown : parseEncodingStrict "sheaf".toList = none := by decide

/-! ## The record -/

/-- A catalogue element.  Stored data only: identity, the publisher's typed
choices, the evidence and the attestations.  Coordinates and addresses are
**not** fields — they are the functions below. -/
structure CatalogElement where
  /-- The full-width content digest: the only identity in the record. -/
  identity : Blob
  /-- The object type nibble. -/
  typ : Fin 16
  /-- The presentation the object is currently in. -/
  encoding : Encoding
  /-- The routing eigenspace. -/
  eigen : EigenSpace
  /-- The real Bott degree. -/
  bott : Fin 8
  /-- An optional representation index, when the object carries one. -/
  irrep : Option IrrepIndex
  /-- Shadow evidence: landmarks named by their identities, with measured
  distances in units of `10⁻ᵐᵉᵃˢᵘʳᵉScale`. -/
  anchors : List (Blob × ℕ)
  /-- The declared measurement scale of those distances. -/
  measureScale : ℕ
  /-- Replication attestations: who claims to hold these bytes. -/
  witnesses : List Blob
  /-- How many distinct attestations this publisher's policy wants. -/
  witnessThreshold : ℕ
deriving DecidableEq, Repr

namespace CatalogElement

variable (e : CatalogElement)

/-- Derived: the placement class. -/
def placement : PlacementClass := (natOfBytes e.identity : ℕ)

/-- Derived: the three placement coordinates. -/
def coords : PlacementCoordinates := coordsOf e.placement

/-- Derived: the canonical 64-bit address. -/
def address : Address :=
  { cls := e.placement.val
    typ := e.typ.val
    digestPrefix := natOfBytes e.identity % 2 ^ 26
    cls_lt := ZMod.val_lt _
    typ_lt := e.typ.isLt
    digestPrefix_lt := Nat.mod_lt _ (by positivity) }

/-- **The address carries the placement class, and nothing restates it.** -/
theorem address_cls_eq_placement : (e.address.cls : ZMod 196883) = e.placement := by
  simp [address, ZMod.natCast_val, ZMod.cast_id]

/-- **The coordinates are the address's class, read through the CRT.**  There
is no independent shard field to disagree with. -/
theorem coords_eq_of_address : e.coords = coordsOf ((e.address.cls : ℕ) : ZMod 196883) := by
  rw [address_cls_eq_placement]
  rfl

/-- The evidence, as a shadow frame over content identities. -/
def frame (tol : ℕ) : Option (ShadowFrame Blob) :=
  let obs : List (Blob × ℚ) :=
    e.anchors.map (fun p => (p.1, (p.2 : ℚ) / (10 : ℚ) ^ e.measureScale))
  if h : obs.length ≤ shadowAnchorBound ∧ (obs.map Prod.fst).Nodup ∧
      e.identity ∉ obs.map Prod.fst then
    some { target := e.identity
           observations := obs
           tolerance := (tol : ℚ) / (10 : ℚ) ^ e.measureScale
           tolerance_nonneg := by positivity
           anchor_bound := h.1
           anchors_nodup := h.2.1
           target_not_anchor := h.2.2 }
  else none

/-- A well-formed element: at most three distinct landmarks, none of them the
element itself, and a replication threshold its witness list can meet. -/
def WellFormed : Prop :=
  e.anchors.length ≤ shadowAnchorBound ∧
  (e.anchors.map Prod.fst).Nodup ∧
  e.identity ∉ e.anchors.map Prod.fst ∧
  e.witnesses.Nodup ∧
  0 < e.witnessThreshold ∧
  e.witnessThreshold ≤ e.witnesses.length

instance : Decidable e.WellFormed := by unfold WellFormed; infer_instance

/-- A well-formed element always yields a frame. -/
theorem frame_isSome (h : e.WellFormed) (tol : ℕ) : (e.frame tol).isSome := by
  obtain ⟨h1, h2, h3, -⟩ := h
  simp only [frame, List.length_map, List.map_map]
  rw [dif_pos]
  · rfl
  · refine ⟨h1, ?_, ?_⟩
    · simpa [List.map_map, Function.comp] using h2
    · simpa [List.map_map, Function.comp] using h3

/-- The element derived from a payload: identity from the content, everything
else a declared choice. -/
def ofContent (data : Blob) (typ : Fin 16) (enc : Encoding) (eig : EigenSpace)
    (b : Fin 8) : CatalogElement :=
  { identity := digest data
    typ := typ
    encoding := enc
    eigen := eig
    bott := b
    irrep := none
    anchors := []
    measureScale := 0
    witnesses := []
    witnessThreshold := 0 }

/-- The derived placement of such an element is the placement of the payload. -/
theorem ofContent_placement (data : Blob) (typ : Fin 16) (enc : Encoding) (eig : EigenSpace)
    (b : Fin 8) : (ofContent data typ enc eig b).placement = placementOf data := rfl

end CatalogElement

/-- **The three counts are independent.**  A frame of three landmarks with a
replication threshold of two, and a frame with no landmarks and a threshold
of three, are both well formed: no single constant configures the coordinate
arity, the anchor bound and the trust threshold. -/
theorem counts_are_independent :
    ∃ a b : CatalogElement,
      a.WellFormed ∧ a.anchors.length = 3 ∧ a.witnessThreshold = 2 ∧
      b.WellFormed ∧ b.anchors.length = 0 ∧ b.witnessThreshold = 3 := by
  refine ⟨{ identity := [0]
            typ := 1
            encoding := .raw
            eigen := .spoke
            bott := 2
            irrep := none
            anchors := [([1], 5), ([2], 7), ([3], 9)]
            measureScale := 3
            witnesses := [[10], [11]]
            witnessThreshold := 2 },
          { identity := [0]
            typ := 1
            encoding := .raw
            eigen := .spoke
            bott := 2
            irrep := none
            anchors := []
            measureScale := 3
            witnesses := [[10], [11], [12]]
            witnessThreshold := 3 }, ?_, rfl, rfl, ?_, rfl, rfl⟩
  · exact ⟨by decide, by decide, by decide, by decide, by decide, by decide⟩
  · exact ⟨by decide, by decide, by decide, by decide, by decide, by decide⟩

end Kant.Moonshine
