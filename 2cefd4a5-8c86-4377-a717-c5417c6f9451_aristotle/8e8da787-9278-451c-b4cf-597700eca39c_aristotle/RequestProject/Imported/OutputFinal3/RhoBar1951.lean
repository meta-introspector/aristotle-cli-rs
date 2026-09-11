/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.GalA5
import RequestProject.Imported.OutputFinal3.KleinFinField

/-!
# An embedding `ρ̄ : Gal(f₁₉₅₁) ↪ PGL₂(ℚ(ζ₅))`

This module composes two results that are already proved in this library:

* `ArtinA5Even.gal1951_equiv_alternating` — the Galois group of the splitting field of the
  Doud–Moore quintic `f₁₉₅₁ = X⁵ - X⁴ - 780X³ - 1795X² + 3106X + 344` over `ℚ` is isomorphic
  to `A₅`;
* `ArtinA5Even.Klein.closureEquivAlternating_cyclotomic` — Klein's two explicit elements
  `a = diag(ζ₅², ζ₅³)` and `b` of `PGL₂(ℚ(ζ₅))` generate a subgroup isomorphic to `A₅`.

Composing

  `Gal(f₁₉₅₁)  ≃*  A₅  ≃*  ⟨a, b⟩  ↪  PGL₂(ℚ(ζ₅))`

gives a monoid homomorphism

  `ArtinA5Even.rhoBar1951 : poly1951Q.Gal →* PGL₂(ℚ(ζ₅))`

which is proved to be **injective** (`rhoBar1951_injective`), with **image exactly Klein's
subgroup** (`range_rhoBar1951`) and therefore of **cardinality 60**
(`card_range_rhoBar1951`).

## What this map is, and what it is *not*

This map is an embedding of `Gal(f₁₉₅₁)` into `PGL₂(ℚ(ζ₅))` with image `A₅`.

It is **not** automatically the Doud–Moore even icosahedral Artin representation:

* `Aut(A₅) ≅ S₅`, so an outer twist may change the conjugacy class of the embedding: the
  composite depends on the two chosen isomorphisms, and nothing here pins the choice down
  by arithmetic data (Frobenius classes);
* **evenness** of `ρ̄(c)` at a complex conjugation `c` is *not* proved — indeed the map is
  built here on `Gal` of the splitting field, not on `Gal(ℚ̄/ℚ)`, and no decomposition group
  at the archimedean place is examined;
* the **Artin conductor `1951`** is *not* proved for this composite;
* **no lift** to `SL₂(ℂ)` (or to `SL₂` of any ring) is constructed;
* consequently `ArtinA5Even.ExistsProjectiveEvenRep1951` is **not** inhabited here.  That Prop
  would require evenness *and* the conductor computation, neither of which is available; what
  this file provides is deliberately the weaker, honest statement, the *abstract* homomorphism
  `rhoBar1951 : Gal → PGL₂(ℚ(ζ₅))`.

No Maass form, no Artin holomorphy, no `L`-function claim, no `native_decide`, no `axiom`.

The type `PGL₂(K)` used here is `ArtinA5Even.Klein.PGL2 K = GL₂(K) ⧸ center`, the projective
general linear group of degree `2`; Mathlib has no separate `ProjectiveGeneralLinearGroup`
abbreviation at this version.
-/

namespace ArtinA5Even

open Klein

/-! ## The two isomorphisms -/

/-- A choice of isomorphism `Gal(f₁₉₅₁) ≃* A₅`.  Existence is
`ArtinA5Even.gal1951_equiv_alternating`; the particular isomorphism is chosen by
`Classical.choice` and carries no arithmetic information. -/
noncomputable def galEquivA5 : poly1951Q.Gal ≃* alternatingGroup (Fin 5) :=
  gal1951_equiv_alternating.some

/-- Klein's icosahedral subgroup `⟨a, b⟩ ≤ PGL₂(ℚ(ζ₅))`. -/
noncomputable def kleinSubgroup : Subgroup (PGL2 (CyclotomicField 5 ℚ)) :=
  Subgroup.closure ({kleinA zeta5 zeta5_pow_five,
    kleinB zeta5 zeta5_pow_five zeta5_ne_one} : Set (PGL2 (CyclotomicField 5 ℚ)))

/-- `⟨a, b⟩ ≃* A₅`, from `ArtinA5Even.Klein.closureEquivAlternating_cyclotomic`. -/
noncomputable def kleinEquivA5 : kleinSubgroup ≃* alternatingGroup (Fin 5) :=
  Klein.closureEquivAlternating_cyclotomic

theorem card_kleinSubgroup : Nat.card kleinSubgroup = 60 :=
  Klein.card_closure_eq_sixty_cyclotomic

/-! ## The composite -/

/-- **`ρ̄ : Gal(f₁₉₅₁) → PGL₂(ℚ(ζ₅))`**, the composite

  `Gal(f₁₉₅₁) ≃* A₅ ≃* ⟨a, b⟩ ↪ PGL₂(ℚ(ζ₅))`.

This is an embedding with image Klein's icosahedral subgroup, of order `60`.  It is **not**
claimed to be the Doud–Moore even icosahedral representation: evenness at complex conjugation
and the Artin conductor `1951` are not proved, no `SL₂` lift is constructed, and `Aut(A₅) ≅ S₅`
means the conjugacy class of the embedding is not pinned down by this construction.  See the
module docstring. -/
noncomputable def rhoBar1951 : poly1951Q.Gal →* PGL2 (CyclotomicField 5 ℚ) :=
  kleinSubgroup.subtype.comp
    ((kleinEquivA5.symm.toMonoidHom).comp galEquivA5.toMonoidHom)

/-- Unfolding of `rhoBar1951` on an element. -/
theorem rhoBar1951_apply (g : poly1951Q.Gal) :
    rhoBar1951 g = (kleinEquivA5.symm (galEquivA5 g) : PGL2 (CyclotomicField 5 ℚ)) := rfl

/-- `ρ̄` is a group homomorphism: it is a bundled `MonoidHom`, so multiplicativity is
definitional. -/
theorem rhoBar1951_mul (g h : poly1951Q.Gal) :
    rhoBar1951 (g * h) = rhoBar1951 g * rhoBar1951 h :=
  map_mul _ _ _

theorem rhoBar1951_one : rhoBar1951 1 = 1 := map_one _

/-! ## Injectivity -/

/-- **`ρ̄` is injective.**  Both isomorphisms are bijective and the inclusion of a subgroup is
injective. -/
theorem rhoBar1951_injective : Function.Injective rhoBar1951 := by
  intro g h hgh
  rw [rhoBar1951_apply, rhoBar1951_apply, Subtype.coe_inj] at hgh
  exact galEquivA5.injective (kleinEquivA5.symm.injective hgh)

/-- The kernel of `ρ̄` is trivial. -/
theorem ker_rhoBar1951 : rhoBar1951.ker = ⊥ :=
  (MonoidHom.ker_eq_bot_iff _).mpr rhoBar1951_injective

/-! ## The image -/

/-- **The image of `ρ̄` is exactly Klein's icosahedral subgroup `⟨a, b⟩`.** -/
theorem range_rhoBar1951 : rhoBar1951.range = kleinSubgroup := by
  ext x
  constructor
  · rintro ⟨g, rfl⟩
    exact (kleinEquivA5.symm (galEquivA5 g)).2
  · intro hx
    exact ⟨galEquivA5.symm (kleinEquivA5 ⟨x, hx⟩), by
      rw [rhoBar1951_apply, MulEquiv.apply_symm_apply, MulEquiv.symm_apply_apply]⟩

/-- **`|im ρ̄| = 60`.** -/
theorem card_range_rhoBar1951 : Nat.card rhoBar1951.range = 60 := by
  rw [range_rhoBar1951]; exact card_kleinSubgroup

/-- `Gal(f₁₉₅₁) ≃* im ρ̄`, the embedding as an isomorphism onto its image. -/
noncomputable def galEquivRangeRhoBar1951 : poly1951Q.Gal ≃* rhoBar1951.range :=
  MonoidHom.ofInjective rhoBar1951_injective

/-- **Summary.**  `ρ̄` is an injective homomorphism `Gal(f₁₉₅₁) →* PGL₂(ℚ(ζ₅))` whose image is
Klein's icosahedral subgroup, of order `60`. -/
theorem rhoBar1951_embedding_icosahedral :
    Function.Injective rhoBar1951 ∧ rhoBar1951.range = kleinSubgroup ∧
      Nat.card rhoBar1951.range = 60 :=
  ⟨rhoBar1951_injective, range_rhoBar1951, card_range_rhoBar1951⟩

/-! ## The abstract label, kept separate from the arithmetic Prop

`ArtinA5Even.ExistsProjectiveEvenRep1951` (in `ArtinA5Even/LiftObstruction.lean`) asks for an
*even* projective representation of the absolute Galois group of `ℚ` of Artin conductor `1951`.
Neither evenness nor the conductor is proved here, so that Prop is left uninhabited; the
statement actually available is the following purely abstract one. -/

/-- The honest statement proved in this file: there exists an injective homomorphism from
`Gal(f₁₉₅₁)` to `PGL₂(ℚ(ζ₅))` with image of order `60`.  No evenness, no conductor, no lift. -/
def RhoBar1951Abstract : Prop :=
  ∃ r : poly1951Q.Gal →* PGL2 (CyclotomicField 5 ℚ),
    Function.Injective r ∧ Nat.card r.range = 60

theorem rhoBar1951_abstract : RhoBar1951Abstract :=
  ⟨rhoBar1951, rhoBar1951_injective, card_range_rhoBar1951⟩

/-! ## A conjugacy-class dictionary, at the level of element orders

`A₅` has five conjugacy classes, of element orders `1`, `2` (double transpositions), `3`
(3-cycles) and `5`, `5` (the two classes `5A`, `5B` of five-cycles).  On the Klein side the
four orders are realised by the words

| class of `A₅`            | order | Klein word |
|--------------------------|-------|------------|
| identity                 | `1`   | `1`        |
| double transposition     | `2`   | `b`        |
| 3-cycle                  | `3`   | `a * b`    |
| 5-cycle (`5A`)           | `5`   | `a`        |
| 5-cycle (`5B`)           | `5`   | `a ^ 2`    |

Since `ρ̄` is injective, it preserves element orders exactly (`rhoBar1951_orderOf`), and since
its image is all of `⟨a, b⟩` each of the words above has a preimage of the same order
(`rhoBar1951_dictionary_*`).

**Two caveats, both honest limitations.**

* The split of the order-`5` elements into the two classes `5A` and `5B` is *not* proved here:
  `a` and `a ^ 2` are recorded as the standard representatives, but their non-conjugacy inside
  `⟨a, b⟩` is not established, and neither is the matching of a given class with a given
  Frobenius class of `f₁₉₅₁`.
* Reduction data cannot make that split either: the cycle type of `f₁₉₅₁ mod p` only tells one
  that `Frob_p` is a five-cycle, i.e. it distinguishes the *order*, not the class.  Separating
  `5A` from `5B` needs finer information (the two classes are interchanged by the outer
  automorphism of `A₅` and by `√5 ↦ -√5`), which is exactly the ambiguity `Aut(A₅) ≅ S₅`
  already flagged above. -/

/-- Klein's element `a = diag(ζ₅², ζ₅³)` of `PGL₂(ℚ(ζ₅))`, of order `5`. -/
noncomputable def kleinWordA : PGL2 (CyclotomicField 5 ℚ) := kleinA zeta5 zeta5_pow_five

/-- Klein's element `b` of `PGL₂(ℚ(ζ₅))`, of order `2`. -/
noncomputable def kleinWordB : PGL2 (CyclotomicField 5 ℚ) :=
  kleinB zeta5 zeta5_pow_five zeta5_ne_one

theorem kleinWordA_mem : kleinWordA ∈ kleinSubgroup :=
  Subgroup.subset_closure (by simp [kleinWordA])

theorem kleinWordB_mem : kleinWordB ∈ kleinSubgroup :=
  Subgroup.subset_closure (by simp [kleinWordB])

theorem orderOf_kleinWordA : orderOf kleinWordA = 5 :=
  Klein.orderOf_kleinA zeta5 zeta5_pow_five zeta5_ne_one

theorem orderOf_kleinWordB : orderOf kleinWordB = 2 :=
  Klein.orderOf_kleinB zeta5 zeta5_pow_five zeta5_ne_one

theorem orderOf_kleinWordAB : orderOf (kleinWordA * kleinWordB) = 3 :=
  Klein.orderOf_kleinAB zeta5 zeta5_pow_five zeta5_ne_one

theorem orderOf_kleinWordA_sq : orderOf (kleinWordA ^ 2) = 5 :=
  (Nat.Coprime.orderOf_pow (by rw [orderOf_kleinWordA]; decide)).trans orderOf_kleinWordA

/-- **`ρ̄` preserves element orders**, being injective. -/
theorem rhoBar1951_orderOf (g : poly1951Q.Gal) : orderOf (rhoBar1951 g) = orderOf g :=
  orderOf_injective rhoBar1951 rhoBar1951_injective g

/-- Every element of Klein's subgroup is `ρ̄` of a Galois element of the same order. -/
theorem exists_preimage_of_mem_kleinSubgroup {x : PGL2 (CyclotomicField 5 ℚ)}
    (hx : x ∈ kleinSubgroup) : ∃ g : poly1951Q.Gal, rhoBar1951 g = x ∧ orderOf g = orderOf x := by
  have hx' : x ∈ rhoBar1951.range := by rw [range_rhoBar1951]; exact hx
  obtain ⟨g, rfl⟩ := hx'
  exact ⟨g, rfl, (rhoBar1951_orderOf g).symm⟩

/-- Dictionary entry: an element of order `2` of `Gal(f₁₉₅₁)` (a double transposition in `A₅`)
mapping to Klein's `b`. -/
theorem rhoBar1951_dictionary_two :
    ∃ g : poly1951Q.Gal, rhoBar1951 g = kleinWordB ∧ orderOf g = 2 := by
  obtain ⟨g, hg, hord⟩ := exists_preimage_of_mem_kleinSubgroup kleinWordB_mem
  exact ⟨g, hg, hord.trans orderOf_kleinWordB⟩

/-- Dictionary entry: an element of order `3` of `Gal(f₁₉₅₁)` (a 3-cycle in `A₅`) mapping to
Klein's word `a * b`. -/
theorem rhoBar1951_dictionary_three :
    ∃ g : poly1951Q.Gal, rhoBar1951 g = kleinWordA * kleinWordB ∧ orderOf g = 3 := by
  obtain ⟨g, hg, hord⟩ :=
    exists_preimage_of_mem_kleinSubgroup (mul_mem kleinWordA_mem kleinWordB_mem)
  exact ⟨g, hg, hord.trans orderOf_kleinWordAB⟩

/-- Dictionary entry: an element of order `5` of `Gal(f₁₉₅₁)` (a five-cycle in `A₅`) mapping to
Klein's `a`.  Which of the two classes `5A`, `5B` this is is **not** determined here. -/
theorem rhoBar1951_dictionary_fiveA :
    ∃ g : poly1951Q.Gal, rhoBar1951 g = kleinWordA ∧ orderOf g = 5 := by
  obtain ⟨g, hg, hord⟩ := exists_preimage_of_mem_kleinSubgroup kleinWordA_mem
  exact ⟨g, hg, hord.trans orderOf_kleinWordA⟩

/-- Dictionary entry: an element of order `5` of `Gal(f₁₉₅₁)` mapping to Klein's `a ^ 2`, the
second standard representative of a five-cycle class.  Non-conjugacy to the previous one is
**not** proved. -/
theorem rhoBar1951_dictionary_fiveB :
    ∃ g : poly1951Q.Gal, rhoBar1951 g = kleinWordA ^ 2 ∧ orderOf g = 5 := by
  obtain ⟨g, hg, hord⟩ :=
    exists_preimage_of_mem_kleinSubgroup (pow_mem kleinWordA_mem 2)
  exact ⟨g, hg, hord.trans orderOf_kleinWordA_sq⟩

/-! ## The pullback central extension, named only

The binary icosahedral group `2.A₅ ≅ SL₂(𝔽₅)` is a nonsplit central extension of `A₅` by
`{±1}` (`ArtinA5Even.SL2F5_extension_nonsplit`, in `ArtinA5Even/LiftObstruction.lean`).
Pulling `ρ̄` back along `SL₂ → PGL₂` gives a central extension of `Gal(f₁₉₅₁)` by the scalars;
a *linear lift* of `ρ̄` would be a splitting of that pullback, i.e. a homomorphism
`Gal(f₁₉₅₁) →* SL₂(ℚ(ζ₅))` whose projectivisation is `ρ̄`.

The following `Prop` merely names that object.  It is not used as an assumption anywhere.  In
`ArtinA5Even/KleinSigns.lean` it is **disproved**
(`ArtinA5Even.not_linearLiftOfRhoBar1951`), by an explicit sign computation rather than by a
cohomology argument: rescaled to determinant `1`, Klein's involution `b` becomes a matrix `Y`
with `Y² = -I`, and every `SL₂`-lift of the class of `b` is a scalar multiple of `Y` of
determinant `1`, hence also squares to `-I`.  So no element of order `2` of `Gal(f₁₉₅₁)` has an
involutive `SL₂`-lift.

This is a statement about `SL₂` only.  Artin's setting is a lift to `GL₂(ℂ)`, where the centre
is all of `ℂ^×`; nothing here excludes such a lift, and Tate's theorem
`H²(G_ℚ, ℂ^×) = 0`, which supplies them, is not in Mathlib and is not encoded in this
library. -/

/-- The projection `SL₂(K) → PGL₂(K)`. -/
noncomputable def sl2ToPGL2 (K : Type*) [Field K] :
    Matrix.SpecialLinearGroup (Fin 2) K →* PGL2 K :=
  (Klein.toPGL2 (K := K)).comp (Matrix.SpecialLinearGroup.toGL)

/-- A linear lift of `ρ̄` to `SL₂(ℚ(ζ₅))`, i.e. a homomorphism whose projectivisation is
`rhoBar1951`.  This `Prop` is **false**: see `ArtinA5Even.not_linearLiftOfRhoBar1951` in
`ArtinA5Even/KleinSigns.lean`.  Its falsity concerns `SL₂`, not `GL₂(ℂ)`. -/
def LinearLiftOfRhoBar1951 : Prop :=
  ∃ r : poly1951Q.Gal →* Matrix.SpecialLinearGroup (Fin 2) (CyclotomicField 5 ℚ),
    (sl2ToPGL2 (CyclotomicField 5 ℚ)).comp r = rhoBar1951

end ArtinA5Even
