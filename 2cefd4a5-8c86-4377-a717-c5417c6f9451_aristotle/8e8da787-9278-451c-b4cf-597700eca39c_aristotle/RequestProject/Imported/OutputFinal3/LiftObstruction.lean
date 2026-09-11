/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.Field1951
import RequestProject.Imported.OutputFinal3.GalA5
import RequestProject.Imported.OutputFinal3.GroupA5

/-!
# The `1951` embedding problem: naming the two missing objects

The Galois group of the Doud–Moore quintic

  `f₁₉₅₁ = X^5 - X^4 - 780 X^3 - 1795 X^2 + 3106 X + 344`

is `A₅` — this is *proved*, unconditionally, in `ArtinA5Even.GalA5`
(`ArtinA5Even.gal1951_equiv_alternating`).  Everything beyond that point is open
mathematics, and this file exists to *name* what is missing, not to supply it.

## What is missing

1. A projective representation `Gal(ℚ̄/ℚ) → PGL₂(ℂ)` with image `A₅`, even, of Artin
   conductor `1951`.  Doud and Moore (arXiv:math/0405534) prove that such an object exists;
   their proof is not a Lean construction, and **no term of
   `ArtinA5Even.ProjectiveEvenIcosahedral` is built anywhere in this library**.
2. A lift of that projective representation to `SL₂(ℂ)`.  This is the *embedding problem*
   for the central extension `1 → {±1} → SL₂(ℂ) → PSL₂(ℂ) → 1` along the surjection
   `Gal → A₅ ≅ PSL₂(𝔽₅) ↪ PSL₂(ℂ)`.  **No term of `ArtinA5Even.SL2Lift` is built.**
3. A Maass form of level `1951` whose `L`-function is the Artin `L`-function of the lift.
   Mathlib has no Maass forms; §"Maass layer" below only *names* this layer, relative to
   an explicitly hypothetical interface, and proves nothing about it.

## What *is* proved here

Only group theory, and only facts that never mention the number field:

* `ArtinA5Even.mem_center_SL2_iff` : the centre of `SL₂` over a field is `{±1}`;
* `ArtinA5Even.card_center_SL2C`, `ArtinA5Even.projSL2C_surjective`,
  `ArtinA5Even.ker_projSL2C` : the central extension `1 → {±1} → SL₂(ℂ) → PSL₂(ℂ) → 1`;
* `ArtinA5Even.card_SL2F5 = 120`, `ArtinA5Even.card_PSL2F5 = 60`: `SL₂(𝔽₅)` is a double
  cover of a group of the order of `A₅`;
* `ArtinA5Even.SL2F5_unique_involution` : `-1` is the only element of order `2` of
  `SL₂(𝔽₅)`, whence
* `ArtinA5Even.SL2F5_extension_nonsplit` : the extension
  `1 → {±1} → SL₂(𝔽₅) → PSL₂(𝔽₅) → 1` admits **no** group-theoretic section — it is the
  nonsplit double cover `2.A₅`, the binary icosahedral group.

The isomorphism `PSL₂(𝔽₅) ≅ A₅`, and the uniqueness of the nonsplit central extension of
`A₅` by `{±1}` (equivalently `H²(A₅, {±1}) ≅ C₂`, whose nontrivial class is represented by
`2.A₅`), are standard; they are *not* proved here and are *not* stated as unproved theorems.  Mathlib
contains neither `PSL₂(𝔽₅) ≅ A₅` nor a group-cohomology computation of `H²(A₅, {±1})`, so
the cohomological formulation of the obstruction is replaced throughout by explicit
`Exists` statements about homomorphisms.

## Non-claims

No Maass form, no modularity, no Artin conjecture, no `L`-function analyticity for the
(unconstructed) representation, no `IsAutomorphic`, no eigenvalue search, no matrix in
`SL₂(ℂ)`, no `axiom`.
-/

namespace ArtinA5Even

open Matrix Subgroup

set_option maxRecDepth 100000

/-! ## The centre of `SL₂` over a field -/

/-- The centre of `SL₂(F)`, `F` a field, consists exactly of `1` and `-1`. -/
theorem mem_center_SL2_iff {F : Type*} [Field F] {A : SpecialLinearGroup (Fin 2) F} :
    A ∈ Subgroup.center (SpecialLinearGroup (Fin 2) F) ↔ A = 1 ∨ A = -1 := by
  constructor
  · intro h
    obtain ⟨r, hr, hrA⟩ := Matrix.SpecialLinearGroup.mem_center_iff.mp h
    simp only [Fintype.card_fin] at hr
    rcases sq_eq_one_iff.mp hr with rfl | rfl
    · left; apply Subtype.ext; rw [← hrA]; simp
    · right
      apply Subtype.ext
      rw [← hrA]
      ext i j
      fin_cases i <;> fin_cases j <;> simp [Matrix.scalar]
  · rintro (rfl | rfl)
    · exact Subgroup.one_mem _
    · rw [Subgroup.mem_center_iff]
      intro g
      exact Subtype.ext (by simp)

/-- The centre of `SL₂(F)` as a set, for a field `F`. -/
theorem coe_center_SL2 {F : Type*} [Field F] :
    (Subgroup.center (SpecialLinearGroup (Fin 2) F) :
      Set (SpecialLinearGroup (Fin 2) F)) = {1, -1} := by
  ext A
  simpa using mem_center_SL2_iff (A := A)

/-- If `-1 ≠ 1` in `SL₂(F)` (e.g. `char F ≠ 2`), the centre has exactly two elements. -/
theorem card_center_SL2 {F : Type*} [Field F]
    (h : (-1 : SpecialLinearGroup (Fin 2) F) ≠ 1) :
    Nat.card (Subgroup.center (SpecialLinearGroup (Fin 2) F)) = 2 := by
  have hc : Nat.card (Subgroup.center (SpecialLinearGroup (Fin 2) F)) =
      Set.ncard ({1, -1} : Set (SpecialLinearGroup (Fin 2) F)) := by
    rw [← coe_center_SL2 (F := F)]
    exact Nat.card_coe_set_eq _
  rw [hc, Set.ncard_pair (Ne.symm h)]

/-! ## The central extension `1 → {±1} → SL₂(ℂ) → PSL₂(ℂ) → 1`

`SL2C` and `PGL2C` come from `ArtinA5Even.Field1951`. -/

/-- `PSL₂(ℂ) = SL₂(ℂ) / centre`. -/
abbrev PSL2C := Matrix.ProjectiveSpecialLinearGroup (Fin 2) ℂ

/-- The projection `SL₂(ℂ) → PSL₂(ℂ)`, the right-hand map of the central extension
`1 → {±1} → SL₂(ℂ) → PSL₂(ℂ) → 1`. -/
def projSL2C : SL2C →* PSL2C := QuotientGroup.mk' _

theorem projSL2C_surjective : Function.Surjective projSL2C :=
  QuotientGroup.mk'_surjective _

/-- Exactness in the middle: the kernel of `SL₂(ℂ) → PSL₂(ℂ)` is the centre. -/
theorem ker_projSL2C : projSL2C.ker = Subgroup.center SL2C :=
  QuotientGroup.ker_mk' _

/-- Exactness on the left, made explicit: the kernel of `SL₂(ℂ) → PSL₂(ℂ)` is `{±1}`. -/
theorem mem_ker_projSL2C_iff {A : SL2C} : A ∈ projSL2C.ker ↔ A = 1 ∨ A = -1 := by
  rw [ker_projSL2C]; exact mem_center_SL2_iff

theorem neg_one_ne_one_SL2C : (-1 : SL2C) ≠ 1 := by
  intro h
  have := congrArg (fun A : SL2C => (A : Matrix (Fin 2) (Fin 2) ℂ) 0 0) h
  norm_num at this

/-- The kernel `{±1}` of `SL₂(ℂ) → PSL₂(ℂ)` has order two. -/
theorem card_center_SL2C : Nat.card (Subgroup.center SL2C) = 2 :=
  card_center_SL2 neg_one_ne_one_SL2C

/-- The composite `SL₂(ℂ) → GL₂(ℂ) → PGL₂(ℂ)`.  A projective representation with values in
`PGL₂(ℂ)` "lifts" if it factors through this map. -/
def sl2ToPgl2C : SL2C →* PGL2C :=
  (QuotientGroup.mk' (Subgroup.center GL2C)).comp Matrix.SpecialLinearGroup.toGL

/-! ## The abstract double cover `SL₂(𝔽₅) = 2.A₅`

This is the *binary icosahedral group*: a nonsplit central extension of a group of order
`60` by `{±1}`.  Mathlib has no declaration `BinaryIcosahedral` and no isomorphism
`PSL₂(𝔽₅) ≅ A₅`; the orders are computed here and the nonsplitness is proved, but the
isomorphism with `A₅` is only recorded as a standard citation (see the module docstring).
Nothing here is a Galois representation of the field of `f₁₉₅₁`. -/

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

/-- `SL₂(𝔽₅)`, the binary icosahedral group `2.A₅`. -/
abbrev SL2F5 := Matrix.SpecialLinearGroup (Fin 2) (ZMod 5)

/-- `PSL₂(𝔽₅)`, abstractly isomorphic to `A₅` (not proved here). -/
abbrev PSL2F5 := Matrix.ProjectiveSpecialLinearGroup (Fin 2) (ZMod 5)

instance : DecidableEq SL2F5 := Subtype.instDecidableEq

/-- The projection `SL₂(𝔽₅) → PSL₂(𝔽₅)`. -/
def projF5 : SL2F5 →* PSL2F5 := QuotientGroup.mk' _

theorem projF5_surjective : Function.Surjective projF5 := QuotientGroup.mk'_surjective _

theorem ker_projF5 : projF5.ker = Subgroup.center SL2F5 := QuotientGroup.ker_mk' _

/-- `|SL₂(𝔽₅)| = 120`. -/
theorem card_SL2F5 : Nat.card SL2F5 = 120 := by
  rw [Nat.card_eq_fintype_card]
  decide

theorem neg_one_ne_one_SL2F5 : (-1 : SL2F5) ≠ 1 := by decide

/-- The centre of `SL₂(𝔽₅)` is `{±1}`, of order `2`. -/
theorem card_center_SL2F5 : Nat.card (Subgroup.center SL2F5) = 2 :=
  card_center_SL2 neg_one_ne_one_SL2F5

/-- `|PSL₂(𝔽₅)| = 60`: the same order as `A₅`, of which it is in fact a copy (standard;
not proved here). -/
theorem card_PSL2F5 : Nat.card PSL2F5 = 60 := by
  have h := Subgroup.index_mul_card (Subgroup.center SL2F5)
  rw [card_center_SL2F5, card_SL2F5] at h
  have hq : Nat.card PSL2F5 = (Subgroup.center SL2F5).index := rfl
  omega

theorem card_PSL2F5_eq_card_alternating :
    Nat.card PSL2F5 = Nat.card (alternatingGroup (Fin 5)) := by
  rw [card_PSL2F5, card_alternatingGroup_five]

/-- **`-1` is the only involution of `SL₂(𝔽₅)`.**  Checked by exhaustive evaluation over the
`120` elements of the group. -/
theorem SL2F5_unique_involution (A : SL2F5) (h : A * A = 1) : A = 1 ∨ A = -1 := by
  revert A; decide

/-- Every subgroup of `SL₂(𝔽₅)` of even order contains the central element `-1`.

Cauchy's theorem produces an involution, and `-1` is the only one. -/
theorem neg_one_mem_of_two_dvd_card (H : Subgroup SL2F5) (h : 2 ∣ Nat.card H) :
    (-1 : SL2F5) ∈ H := by
  haveI : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  obtain ⟨x, hx⟩ := exists_prime_orderOf_dvd_card' (G := H) 2 h
  have hxx : (x : SL2F5) * (x : SL2F5) = 1 := by
    have : x * x = 1 := by
      have := pow_orderOf_eq_one x
      rw [hx] at this
      simpa [pow_two] using this
    exact congrArg (fun y : H => (y : SL2F5)) this
  have hxne : (x : SL2F5) ≠ 1 := by
    intro hx1
    have : x = 1 := Subtype.ext hx1
    rw [this, orderOf_one] at hx
    omega
  rcases SL2F5_unique_involution (x : SL2F5) hxx with h1 | h1
  · exact absurd h1 hxne
  · exact h1 ▸ x.2

/-- **The double cover `SL₂(𝔽₅) → PSL₂(𝔽₅)` is nonsplit.**

There is no group homomorphism `s : PSL₂(𝔽₅) → SL₂(𝔽₅)` with `proj ∘ s = id`.  Indeed such
an `s` would be injective, so its image would be a subgroup of order `60`, which by
`neg_one_mem_of_two_dvd_card` contains `-1`; but `-1` is in the kernel of the projection,
so `-1 = s 1 = 1`, a contradiction.

Hence `SL₂(𝔽₅)` is the *nonsplit* double cover `2.A₅` of `A₅` — the binary icosahedral
group. -/
theorem SL2F5_extension_nonsplit :
    ¬ ∃ s : PSL2F5 →* SL2F5, ∀ x, projF5 (s x) = x := by
  rintro ⟨s, hs⟩
  have hinj : Function.Injective s := by
    intro a b hab
    rw [← hs a, ← hs b, hab]
  have hcard : Nat.card s.range = 60 := by
    have h := Nat.card_congr (Equiv.ofInjective s hinj)
    rw [card_PSL2F5] at h
    exact h.symm
  have hmem : (-1 : SL2F5) ∈ s.range :=
    neg_one_mem_of_two_dvd_card s.range (by rw [hcard]; norm_num)
  obtain ⟨x, hx⟩ := hmem
  have h1 : projF5 (s x) = projF5 (-1) := by rw [hx]
  have h2 : projF5 (-1 : SL2F5) = 1 := by
    rw [← MonoidHom.mem_ker, ker_projF5]
    exact mem_center_SL2_iff.mpr (Or.inr rfl)
  have hx1 : x = 1 := by rw [hs x] at h1; rw [h1, h2]
  rw [hx1, map_one] at hx
  exact neg_one_ne_one_SL2F5 hx.symm

/-! ## Layer 1: a projective even icosahedral representation of conductor 1951

`ArtinA5Even.ProjectiveEvenIcosahedral` (in `ArtinA5Even.Field1951`) is the type of such
objects.  Doud–Moore prove in the literature that this type is inhabited.  That is *not* a
Lean construction, and no term is produced here. -/

/-- **Layer 1.**  There exists a projective, even, icosahedral representation attached to
the field of `f₁₉₅₁`.  *Not proved, not assumed, not axiomatised.* -/
def ExistsProjectiveEvenRep1951 : Prop := Nonempty ProjectiveEvenIcosahedral

/-! ## Layer 2: the embedding problem — lifting to `SL₂(ℂ)`

The projective representation is the unconstructed datum, so the honest formulation of
"the lift exists" is parametrised by a projective representation. -/

/-- The lifting property for a given (hypothetical) projective representation of the Galois
group of the splitting field of `f₁₉₅₁`: there is a homomorphism to `SL₂(ℂ)` inducing it.

This is the embedding problem for `1 → {±1} → SL₂(ℂ) → PSL₂(ℂ) → 1`, written as an explicit
`Exists` because Mathlib has no `H²(A₅, {±1})`. -/
def LiftExists (rhobar : poly1951Q.Gal →* PGL2C) : Prop :=
  ∃ rho : poly1951Q.Gal →* SL2C, ∀ σ, sl2ToPgl2C (rho σ) = rhobar σ

/-- **Layer 2.**  There is a projective even icosahedral representation of conductor `1951`
*and* it lifts to `SL₂(ℂ)`.  *Not proved.* -/
def ExistsLinearLift1951 : Prop := ∃ P : ProjectiveEvenIcosahedral, Nonempty (SL2Lift P)

/-- Layer 2 trivially implies layer 1.  (The converse is the embedding problem, and is not
proved here for this representation; abstractly it is Tate's theorem on the vanishing of
`H²(G_ℚ, ℂ^×)`, which is not in Mathlib.) -/
theorem existsProjectiveEvenRep1951_of_existsLinearLift1951 :
    ExistsLinearLift1951 → ExistsProjectiveEvenRep1951 := by
  rintro ⟨P, -⟩
  exact ⟨P⟩

/-! ## Layer 3: the Maass form

Mathlib has no Maass forms, no automorphic representations and no Artin `L`-functions, and
this library declares no `axiom`.  The third layer is therefore stated *relative to an
explicitly hypothetical interface*: a type of "forms" with a level and an `L`-function that
is entire.  Constructing a term of `MaassInterface` is trivial and vacuous (take `Form` to
be `Empty`); it is emphatically **not** a development of the theory of Maass forms, and no
statement below asserts that any particular `L`-function arises from one.  Nothing here is
a modularity or automorphy claim. -/

/-- A hypothetical interface standing in for the analytic theory that Mathlib lacks: a type
of forms, a level, an `L`-function, and the (assumed) fact that these `L`-functions are
entire.  This is *documentation with a type*, not a definition of Maass forms. -/
structure MaassInterface where
  /-- The type of forms provided by the interface. -/
  Form : Type
  /-- The level of a form. -/
  level : Form → ℕ
  /-- The `L`-function of a form. -/
  lfun : Form → ℂ → ℂ
  /-- Assumed analytic input: `L`-functions of forms are entire. -/
  lfun_entire : ∀ f, Differentiable ℂ (lfun f)

/-- `L` is entire. -/
def EntireL (L : ℂ → ℂ) : Prop := Differentiable ℂ L

/-- **Layer 3.**  Relative to an interface `I`, there is a form of level `1951` whose
`L`-function is the given function `L` (intended: the Artin `L`-function of the lift of
layer 2, which is not constructed).  *Not proved for any `L` of interest.* -/
def ExistsMaass1951 (I : MaassInterface) (L : ℂ → ℂ) : Prop :=
  ∃ f : I.Form, I.level f = 1951 ∧ I.lfun f = L

/-- The standard implication "layer 3 ⇒ entirety of the `L`-function", which is purely
definitional once the interface's analytic input is granted.  No analysis is done here, and
this says nothing whatsoever about the `L`-function of the (unconstructed) representation
attached to `f₁₉₅₁`. -/
theorem entireL_of_existsMaass1951 (I : MaassInterface) (L : ℂ → ℂ)
    (h : ExistsMaass1951 I L) : EntireL L := by
  obtain ⟨f, -, rfl⟩ := h
  exact I.lfun_entire f

end ArtinA5Even
