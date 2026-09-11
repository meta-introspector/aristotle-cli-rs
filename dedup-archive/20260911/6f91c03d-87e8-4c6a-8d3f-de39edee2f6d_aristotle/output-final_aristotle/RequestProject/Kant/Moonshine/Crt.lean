/-
# Placement coordinates: a declared modulus system and its CRT gluing

The old markup carried two fields that claimed the same thing —

```
<meta property="erdfa:shard"     content="68,16,35" />
<meta property="sheaf:orbifold"  content="(68 mod 71, 16 mod 59, 35 mod 47)" />
```

— beside an address that disagreed with both.  The repair is to stop
asserting a triple and start *deriving* it: one class `n` in `ZMod (p·q·r)`
for a **declared** modulus system, with the triple its image under the
three residue projections.

What is proved here:

* `Moduli.toTriple` — the three residue projections assembled into one ring
  homomorphism — is a bijection (`Moduli.toTriple_bijective`), so the class
  and the triple are the same information;
* both round trips (`Moduli.ofTriple_toTriple`, `Moduli.toTriple_ofTriple`);
* the *gluing* statements that make the word "section" earned: two classes
  agreeing on all three restrictions are equal (`Moduli.eq_of_restrictions`)
  and every locally given triple glues to exactly one class
  (`Moduli.exists_unique_glue`);
* `monsterModuli`, the instance `(71, 59, 47)` with modulus `196883 = 47·59·71`;
* and the honest negative: **no** function from content to classes is
  injective (`class_does_not_determine_content`), so a triple is a placement
  coordinate and never an identity.

Nothing here mentions the Monster group's representation theory; `196883`
enters only as the product of three pairwise coprime numbers.  The
representation-theoretic reading lives in `Kant.Moonshine.Degrees`.
-/
import Mathlib
import RequestProject.Kant.Bytes

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Moonshine

open Kant.Bytes

/-! ## A declared modulus system -/

/-- A *declared* modulus system: three pairwise coprime moduli.  Coordinates
exist only where such a declaration exists — a degree with no declared system
has no CRT triple, and the schema must not pretend otherwise. -/
structure Moduli where
  p : ℕ
  q : ℕ
  r : ℕ
  hp : 0 < p
  hq : 0 < q
  hr : 0 < r
  hpq : Nat.Coprime p q
  hpr : Nat.Coprime p r
  hqr : Nat.Coprime q r

namespace Moduli

variable (M : Moduli)

/-- The composite modulus `p · q · r`. -/
def modulus : ℕ := M.p * M.q * M.r

theorem modulus_pos : 0 < M.modulus := by
  have := M.hp; have := M.hq; have := M.hr
  simpa [modulus] using Nat.mul_pos (Nat.mul_pos M.hp M.hq) M.hr

theorem p_dvd : M.p ∣ M.modulus := ⟨M.q * M.r, by simp [modulus, Nat.mul_assoc]⟩
theorem q_dvd : M.q ∣ M.modulus := ⟨M.p * M.r, by simp [modulus]; ring⟩
theorem r_dvd : M.r ∣ M.modulus := ⟨M.p * M.q, by simp [modulus]; ring⟩

instance : NeZero M.modulus := ⟨Nat.ne_of_gt M.modulus_pos⟩


/-- The three residue projections, assembled.  This is the only definition of
"the triple"; the markup renders it and never asserts it independently. -/
def toTriple : ZMod M.modulus →+* ZMod M.p × ZMod M.q × ZMod M.r :=
  (ZMod.castHom M.p_dvd _).prod
    ((ZMod.castHom M.q_dvd _).prod (ZMod.castHom M.r_dvd _))

/-- Reassociation of a product of rings, for assembling the CRT equivalence. -/
private def prodAssocRingEquiv (A B C : Type) [Semiring A] [Semiring B] [Semiring C] :
    (A × B) × C ≃+* A × B × C :=
  { Equiv.prodAssoc A B C with
    map_mul' := fun _ _ => rfl
    map_add' := fun _ _ => rfl }

/-- **Chinese Remainder.** The class ring is the product of the three residue
rings. -/
def crtEquiv : ZMod M.modulus ≃+* ZMod M.p × ZMod M.q × ZMod M.r :=
  (ZMod.chineseRemainder (M.hpr.mul_left M.hqr)).trans
    (((ZMod.chineseRemainder M.hpq).prodCongr (RingEquiv.refl (ZMod M.r))).trans
      (prodAssocRingEquiv (ZMod M.p) (ZMod M.q) (ZMod M.r)))

/-- The equivalence *is* the triple of residue projections: a ring
homomorphism out of `ZMod n` is unique, so there is no second candidate. -/
theorem crtEquiv_eq_toTriple :
    (M.crtEquiv : ZMod M.modulus →+* ZMod M.p × ZMod M.q × ZMod M.r) = M.toTriple :=
  RingHom.ext_zmod _ _

theorem crtEquiv_apply (n : ZMod M.modulus) : M.crtEquiv n = M.toTriple n := by
  rw [← crtEquiv_eq_toTriple]; rfl

/-- **The triple and the class are the same information.** -/
theorem toTriple_bijective : Function.Bijective M.toTriple := by
  have : Function.Bijective (M.crtEquiv : ZMod M.modulus → ZMod M.p × ZMod M.q × ZMod M.r) :=
    M.crtEquiv.bijective
  simpa [funext fun n => M.crtEquiv_apply n] using this

theorem toTriple_injective : Function.Injective M.toTriple := M.toTriple_bijective.1
theorem toTriple_surjective : Function.Surjective M.toTriple := M.toTriple_bijective.2

/-- Gluing: a locally given triple assembles to a class. -/
def ofTriple (t : ZMod M.p × ZMod M.q × ZMod M.r) : ZMod M.modulus := M.crtEquiv.symm t

@[simp] theorem ofTriple_toTriple (n : ZMod M.modulus) : M.ofTriple (M.toTriple n) = n := by
  rw [ofTriple, ← M.crtEquiv_apply, RingEquiv.symm_apply_apply]

@[simp] theorem toTriple_ofTriple (t : ZMod M.p × ZMod M.q × ZMod M.r) :
    M.toTriple (M.ofTriple t) = t := by
  rw [ofTriple, ← M.crtEquiv_apply, RingEquiv.apply_symm_apply]

/-- **Two sections agreeing on all three restrictions are equal.** -/
theorem eq_of_restrictions {m n : ZMod M.modulus}
    (h₁ : ZMod.castHom M.p_dvd (ZMod M.p) m = ZMod.castHom M.p_dvd (ZMod M.p) n)
    (h₂ : ZMod.castHom M.q_dvd (ZMod M.q) m = ZMod.castHom M.q_dvd (ZMod M.q) n)
    (h₃ : ZMod.castHom M.r_dvd (ZMod M.r) m = ZMod.castHom M.r_dvd (ZMod M.r) n) :
    m = n := by
  refine M.toTriple_injective ?_
  simp only [toTriple, RingHom.prod_apply, Prod.mk.injEq]
  exact ⟨h₁, h₂, h₃⟩

/-- **Gluing axiom.** Every triple of local values glues to exactly one
global class. -/
theorem exists_unique_glue (t : ZMod M.p × ZMod M.q × ZMod M.r) :
    ∃! n : ZMod M.modulus, M.toTriple n = t := by
  refine ⟨M.ofTriple t, M.toTriple_ofTriple t, ?_⟩
  intro y hy
  rw [← hy, M.ofTriple_toTriple]

/-- The class ring has exactly `p · q · r` elements. -/
theorem card_class : Nat.card (ZMod M.modulus) = M.modulus := Nat.card_zmod M.modulus

end Moduli

/-! ## The instance the old markup used: `(71, 59, 47)` -/

/-- The declared modulus system of the legacy `sheaf:orbifold` field. -/
def monsterModuli : Moduli where
  p := 71
  q := 59
  r := 47
  hp := by norm_num
  hq := by norm_num
  hr := by norm_num
  hpq := by decide
  hpr := by decide
  hqr := by decide

@[simp] theorem monsterModuli_modulus : monsterModuli.modulus = 196883 := by
  decide

/-- `47 · 59 · 71 = 196883` — the arithmetic fact the whole coordinate
system rests on, stated for the declared system. -/
theorem monsterModuli_prod : 47 * 59 * 71 = monsterModuli.modulus := by decide

/-- A placement class: an element of `ZMod 196883`. -/
abbrev PlacementClass := ZMod 196883

/-- The three placement coordinates. -/
abbrev PlacementCoordinates := ZMod 71 × ZMod 59 × ZMod 47

/-- The coordinates of a class: derived, never asserted. -/
def coordsOf (n : PlacementClass) : PlacementCoordinates := monsterModuli.toTriple n

/-- The class of a coordinate triple. -/
def classOfCoords (t : PlacementCoordinates) : PlacementClass := monsterModuli.ofTriple t

@[simp] theorem classOfCoords_coordsOf (n : PlacementClass) :
    classOfCoords (coordsOf n) = n := by
  simp [classOfCoords, coordsOf]

@[simp] theorem coordsOf_classOfCoords (t : PlacementCoordinates) :
    coordsOf (classOfCoords t) = t := by
  simp [classOfCoords, coordsOf]

/-- Publishing both the class and the triple is safe: each determines the
other. -/
theorem shard_determines_class {m n : PlacementClass} (h : coordsOf m = coordsOf n) : m = n := by
  have := congrArg classOfCoords h
  simpa using this

/-! ## Deriving a class from content -/

/-- Little-endian numeric value of a byte string. -/
def natOfBytes : Blob → ℕ
  | [] => 0
  | b :: bs => b.toNat + 256 * natOfBytes bs

/-- The placement class of a payload: derived from its digest, and from
nothing else. -/
def placementOf (data : Blob) : PlacementClass := (natOfBytes (digest data) : ℕ)

/-- The placement coordinates of a payload. -/
def coordinatesOf (data : Blob) : PlacementCoordinates := coordsOf (placementOf data)

theorem placementOf_deterministic {a b : Blob} (h : a = b) : placementOf a = placementOf b := by
  rw [h]

/-- Blobs are infinite: `List.replicate n 0` are pairwise distinct. -/
theorem blob_infinite : Function.Injective (fun n : ℕ => (List.replicate n 0 : Blob)) := by
  intro m n h
  have := congrArg List.length h
  simpa using this

/-- **A class cannot determine content.**  Pigeonhole: there are infinitely
many payloads and only `196883` classes, so *every* class assignment — the
one here, or any other — collides.  The triple is where to fetch from, never
what the thing is. -/
theorem class_does_not_determine_content (f : Blob → PlacementClass) :
    ∃ a b : Blob, a ≠ b ∧ f a = f b := by
  have hinf : Infinite { l : Blob // True } := by
    exact Infinite.of_injective (fun n : ℕ => ⟨List.replicate n 0, trivial⟩)
      (fun m n h => blob_infinite (congrArg Subtype.val h))
  obtain ⟨x, y, hne, heq⟩ :=
    Finite.exists_ne_map_eq_of_infinite (fun l : { l : Blob // True } => f l.1)
  exact ⟨x.1, y.1, fun h => hne (Subtype.ext h), heq⟩

/-- The same statement for the shipped derivation. -/
theorem placement_does_not_determine_content :
    ∃ a b : Blob, a ≠ b ∧ placementOf a = placementOf b :=
  class_does_not_determine_content placementOf

/-- …and for the coordinates, since they carry exactly the class. -/
theorem coordinates_do_not_determine_content :
    ∃ a b : Blob, a ≠ b ∧ coordinatesOf a = coordinatesOf b := by
  obtain ⟨a, b, hne, h⟩ := placement_does_not_determine_content
  exact ⟨a, b, hne, by simp [coordinatesOf, h]⟩

end Kant.Moonshine
