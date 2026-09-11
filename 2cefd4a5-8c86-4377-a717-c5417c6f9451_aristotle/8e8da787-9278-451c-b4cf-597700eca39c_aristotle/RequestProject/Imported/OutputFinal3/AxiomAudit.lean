/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.Field1951
import RequestProject.Imported.OutputFinal3.GalA5
import RequestProject.Imported.OutputFinal3.LiftObstruction
import RequestProject.Imported.OutputFinal3.PSL2F5
import RequestProject.Imported.OutputFinal3.KleinPGL
import RequestProject.Imported.OutputFinal3.VonDyck235
import RequestProject.Imported.OutputFinal3.KleinFinField
import RequestProject.Imported.OutputFinal3.RhoBar1951
import RequestProject.Imported.OutputFinal3.KleinSigns
import RequestProject.Imported.OutputFinal3.HolomorphyInterface

/-!
# Axiom audit for `ArtinA5Even`

Every result of `ArtinA5Even.Field1951`, `ArtinA5Even.Discriminant`, `ArtinA5Even.Discr1951`,
`ArtinA5Even.GroupA5`, `ArtinA5Even.Reduction` and `ArtinA5Even.GalA5` that is worth naming is
printed below together with its axiom dependencies.  All of them should rest only on the
standard Lean axioms `propext`, `Classical.choice`, `Quot.sound`.

This file also records, in machine-checkable form, what is *absent*:

* no `axiom` is declared anywhere in this library;
* no term of `ArtinA5Even.ProjectiveEvenIcosahedral` is constructed;
* no term of `ArtinA5Even.SL2Lift` is constructed — i.e. **no `2.A₅` lift**;
* nothing about `L`-functions, modularity, Maass forms, or Artin's conjecture is
  stated, let alone proved.

What *is* now constructed is a term of `ArtinA5Even.EvenIcosahedral1951`
(`ArtinA5Even.evenIcosahedral1951`): all four of its fields, including `gal_eq_A5`, are
theorems.
-/

namespace ArtinA5Even

/-! ## The polynomial and the field -/

#print axioms poly1951_monic
#print axioms poly1951_natDegree
#print axioms poly1951_degree
#print axioms condPrime_prime
#print axioms disc1951_eq
#print axioms disc1951_isSquare
#print axioms poly1951_map_three
#print axioms monic_quadratic_normal_form
#print axioms quintic_irreducible_criterion
#print axioms not_dvd_of_rem
#print axioms poly1951Mod3_no_root
#print axioms poly1951Mod3_no_quadratic_factor
#print axioms poly1951Mod3_irreducible
#print axioms poly1951_irreducible_int
#print axioms poly1951_irreducible_rat
#print axioms poly1951R_eval
#print axioms poly1951R_monic
#print axioms poly1951R_natDegree
#print axioms exists_root_Ioo
#print axioms poly1951R_five_roots
#print axioms poly1951_totally_real

/-! ## The discriminant -/

#print axioms resultant_step
#print axioms poly1951_derivative
#print axioms poly1951_discr
#print axioms discr_eq_rootDiffProd_sq
#print axioms rootDiffProd_comp_perm
#print axioms discr_map_of_monic_five

/-! ## Group theory and reduction mod `p` -/

#print axioms card_alternatingGroup_five
#print axioms subgroup_eq_top_of_fifteen_dvd
#print axioms alternating_le_of_fifteen_dvd
#print axioms natDegree_dvd_card_gal

/-! ## The Galois group -/

#print axioms five_dvd_card_gal
#print axioms three_dvd_card_gal
#print axioms fifteen_dvd_card_gal
#print axioms even_action_of_discr
#print axioms gal_eq_A5_of_disc
#print axioms gal1951_equiv_alternating
#print axioms evenIcosahedral1951
#print axioms alternating_le_range_permRep1951

/-- All four fields of `EvenIcosahedral1951` are theorems. -/
theorem four_of_four_fields :
    Irreducible (poly1951.map (algebraMap ℤ ℚ)) ∧ IsSquare disc1951 ∧ poly1951R.Splits
      ∧ Nonempty ((poly1951.map (algebraMap ℤ ℚ)).Gal ≃* alternatingGroup (Fin 5)) :=
  ⟨poly1951_irreducible_rat, disc1951_isSquare, poly1951_totally_real,
    gal1951_equiv_alternating⟩

#print axioms four_of_four_fields

/-! ## The embedding problem (`ArtinA5Even.LiftObstruction`)

Only group theory is proved there.  In particular:

* no term of `ArtinA5Even.ProjectiveEvenIcosahedral` and no term of `ArtinA5Even.SL2Lift`
  is constructed, so none of `ExistsProjectiveEvenRep1951`, `ExistsLinearLift1951` is
  proved (nor is any of them assumed or axiomatised);
* `ExistsMaass1951` is stated only relative to the hypothetical `MaassInterface`, and no
  instance of that interface, and no Maass form, is produced;
* nothing about modularity, automorphy, Artin's conjecture, or the analytic continuation of
  an `L`-function of the field of `f₁₉₅₁` is proved. -/

#print axioms mem_center_SL2_iff
#print axioms coe_center_SL2
#print axioms card_center_SL2
#print axioms projSL2C_surjective
#print axioms ker_projSL2C
#print axioms mem_ker_projSL2C_iff
#print axioms card_center_SL2C
#print axioms card_SL2F5
#print axioms card_center_SL2F5
#print axioms card_PSL2F5
#print axioms card_PSL2F5_eq_card_alternating
#print axioms SL2F5_unique_involution
#print axioms neg_one_mem_of_two_dvd_card
#print axioms SL2F5_extension_nonsplit
#print axioms existsProjectiveEvenRep1951_of_existsLinearLift1951
#print axioms entireL_of_existsMaass1951

/-! ## `PSL₂(𝔽₅) ≅ A₅` (`ArtinA5Even.PSL2F5`)

Pure finite group theory: the coset action of `SL₂(𝔽₅)` on the five cosets of an explicit
binary tetrahedral subgroup.  Nothing arithmetic, and the isomorphism is *not* composed with
`gal1951_equiv_alternating`. -/

#print axioms card_binTet
#print axioms index_binTet
#print axioms card_quotient_binTet
#print axioms normalCore_binTet
#print axioms ker_permRepFin5
#print axioms card_range_permRepFin5
#print axioms range_permRepFin5
#print axioms psl2F5_equiv_alternating
#print axioms nonempty_psl2F5_equiv_alternating

/-! ## Klein's icosahedral generators in `PGL₂` (`ArtinA5Even.KleinPGL`)

Again pure algebra: the `(2,3,5)` relations for two explicit matrices over any field with a
primitive fifth root of unity, in particular over `ℚ(ζ₅) = ℚ(√5, ζ₅)`.  These matrices are
**not** the image of any Galois group: no arithmetic representation is constructed. -/

#print axioms Klein.sqrtFive_sq
#print axioms Klein.det_genAMat
#print axioms Klein.det_genBMat
#print axioms Klein.genAMat_pow_five
#print axioms Klein.genBMat_sq
#print axioms Klein.genABMat_pow_three
#print axioms Klein.kleinA_pow_five
#print axioms Klein.kleinB_sq
#print axioms Klein.kleinAB_pow_three
#print axioms Klein.orderOf_kleinA
#print axioms Klein.orderOf_kleinB
#print axioms Klein.orderOf_kleinAB
#print axioms Klein.klein_icosahedral_relations
#print axioms Klein.klein_icosahedral_relations_cyclotomic

/-! ## The von Dyck group `Δ(2,3,5)` (`ArtinA5Even.VonDyck235`)

Pure finite group theory: the relations `a⁵ = b² = (ab)³ = 1` bound `|⟨a, b⟩|` by `60`
(twelve coset representatives, Todd–Coxeter), a five-cycle and a double transposition realise
them inside `A₅`, and the presented group `Δ(2,3,5) = ⟨x, y | x⁵, y², (xy)³⟩` is therefore
isomorphic to `A₅`.  Consequently `a ≠ 1` together with the three relations forces
`⟨a, b⟩ ≅ A₅`, in particular `|⟨a, b⟩| = 60`. -/

#print axioms VonDyck.tbl4a
#print axioms VonDyck.tbl5a
#print axioms VonDyck.tbl6a
#print axioms VonDyck.tbl9a
#print axioms VonDyck.tbl10a
#print axioms VonDyck.tbl11a
#print axioms VonDyck.closure_subset_cosetSet
#print axioms VonDyck.card_closure_le
#print axioms VonDyck.closure_permA_permB
#print axioms VonDyck.card_delta
#print axioms VonDyck.deltaEquivAlternating
#print axioms VonDyck.ker_vonDyckHom_eq_bot
#print axioms VonDyck.closureEquivAlternating
#print axioms VonDyck.card_closure_eq_sixty

/-! ## Klein's generators over `𝔽₁₁` (`ArtinA5Even.KleinFinField`)

`z = 3` is a primitive fifth root of unity in `𝔽₁₁`, so Klein's construction reduces to two
explicit matrices over `𝔽₁₁`; the subgroup of `PGL₂(𝔽₁₁)` they generate has exactly `60`
elements and is isomorphic to `A₅`.  The same conclusion holds over `ℚ(ζ₅)`.  No
`native_decide` is used.  (The Galois group of `f₁₉₅₁` *is* mapped into `PGL₂(ℚ(ζ₅))` below,
in `ArtinA5Even.RhoBar1951`, but only as an abstract embedding.) -/

#print axioms KleinF11.three_pow_five
#print axioms KleinF11.genAMat_three
#print axioms KleinF11.genBMat_three
#print axioms KleinF11.orderOf_a11
#print axioms KleinF11.orderOf_b11
#print axioms KleinF11.orderOf_a11b11
#print axioms KleinF11.closureEquivAlternating
#print axioms KleinF11.card_closure_eq_sixty
#print axioms KleinF11.sixty_le_card_closure
#print axioms Klein.closureEquivAlternating_cyclotomic
#print axioms Klein.card_closure_eq_sixty_cyclotomic

/-! ## The composite `ρ̄ : Gal(f₁₉₅₁) → PGL₂(ℚ(ζ₅))` (`ArtinA5Even.RhoBar1951`)

The two isomorphisms `Gal(f₁₉₅₁) ≃* A₅` and `⟨a, b⟩ ≃* A₅` are composed into an injective
homomorphism into `PGL₂(ℚ(ζ₅))` with image Klein's icosahedral subgroup, of order `60`.

This is an *abstract* embedding.  Evenness at complex conjugation is not proved, the Artin
conductor `1951` is not proved for it, no `SL₂` lift is constructed, and — since
`Aut(A₅) ≅ S₅` — the conjugacy class of the embedding is not pinned down.  Accordingly
`ExistsProjectiveEvenRep1951` is **not** inhabited; the statement actually proved is
`ArtinA5Even.rhoBar1951_abstract`. -/

#print axioms rhoBar1951
#print axioms rhoBar1951_apply
#print axioms rhoBar1951_mul
#print axioms rhoBar1951_one
#print axioms rhoBar1951_injective
#print axioms ker_rhoBar1951
#print axioms range_rhoBar1951
#print axioms card_range_rhoBar1951
#print axioms galEquivRangeRhoBar1951
#print axioms rhoBar1951_embedding_icosahedral
#print axioms rhoBar1951_abstract

/-! ### Conjugacy-class dictionary and the named (unproved) linear lift

The dictionary is at the level of *element orders* only: `ρ̄` is injective, so it preserves
orders, and each of Klein's words `b`, `a * b`, `a`, `a ^ 2` has a Galois preimage of order
`2`, `3`, `5`, `5`.  The two five-cycle classes `5A`, `5B` are **not** separated — the cycle
type of `f₁₉₅₁ mod p` does not distinguish them.

`LinearLiftOfRhoBar1951` is a *name* for the statement that `ρ̄` lifts to `SL₂(ℚ(ζ₅))`.  It is
now **disproved**, in `ArtinA5Even/KleinSigns.lean`
(`ArtinA5Even.not_linearLiftOfRhoBar1951`): every `SL₂`-lift of Klein's involution squares to
`-I`.  This concerns `SL₂` only; nothing is claimed about lifts to `GL₂(ℂ)`, which is Artin's
setting. -/

#print axioms kleinWordA
#print axioms kleinWordB
#print axioms kleinWordA_mem
#print axioms kleinWordB_mem
#print axioms orderOf_kleinWordA
#print axioms orderOf_kleinWordB
#print axioms orderOf_kleinWordAB
#print axioms orderOf_kleinWordA_sq
#print axioms rhoBar1951_orderOf
#print axioms exists_preimage_of_mem_kleinSubgroup
#print axioms rhoBar1951_dictionary_two
#print axioms rhoBar1951_dictionary_three
#print axioms rhoBar1951_dictionary_fiveA
#print axioms rhoBar1951_dictionary_fiveB
#print axioms sl2ToPGL2
#print axioms LinearLiftOfRhoBar1951

/-! ### Klein's signs in `SL₂`, and the absence of an `SL₂`-section

`ArtinA5Even/KleinSigns.lean` rescales Klein's generators to determinant `1`
(`det a = 1`, `det b = 5`, and `√5 = 2(ζ₅ + ζ₅⁴) + 1 ∈ ℚ(ζ₅)`), obtaining `X, Y ∈ SL₂(K)`
with the binary icosahedral signs `X⁵ = I`, `Y² = -I`, `(XY)³ = -I`.  The sign `Y² = -I` is
exactly the obstruction: no homomorphism into `SL₂` projectivises to Klein's involution at an
element of order `2`.  Hence `no_sl2_section_kleinEmb` and `not_linearLiftOfRhoBar1951`.

This is **not** a statement about Artin representations, which are homomorphisms into
`GL₂(ℂ)`; Tate's theorem `H²(G_ℚ, ℂ^×) = 0` is neither used nor encoded. -/

#print axioms KleinSigns.sqrtFive
#print axioms KleinSigns.sqrtFive_sq'
#print axioms KleinSigns.sqrtFive_ne_zero
#print axioms KleinSigns.prod_eq_neg_sqrtFive
#print axioms KleinSigns.genAMat_pow_five_smul
#print axioms KleinSigns.genBMat_sq_smul
#print axioms KleinSigns.genABMat_pow_three_smul
#print axioms KleinSigns.det_genAMat'
#print axioms KleinSigns.det_genBMat'
#print axioms KleinSigns.liftX
#print axioms KleinSigns.liftY
#print axioms KleinSigns.liftX_pow_five
#print axioms KleinSigns.liftY_sq
#print axioms KleinSigns.liftXY_pow_three
#print axioms KleinSigns.klein_sl2_signs
#print axioms KleinSigns.toPGL2_eq_of_smul
#print axioms KleinSigns.exists_smul_of_toPGL2_eq
#print axioms KleinSigns.sl2ToPGL2_liftX
#print axioms KleinSigns.sl2ToPGL2_liftY
#print axioms KleinSigns.no_involution_lift
#print axioms kleinEmb
#print axioms no_sl2_section_kleinEmb
#print axioms not_linearLiftOfRhoBar1951

/-! ### The two-dimensional icosahedral characters (`ArtinA5Even.HolomorphyInterface`)

Finite-group data only: five class labels, class sizes, and the values
`(2, 0, -1, (1+√5)/2, (1-√5)/2)`.  These are the traces of the two-dimensional representation
of the binary icosahedral group `2.A₅ ≅ SL₂(𝔽₅)` — realised here by the explicit `SL₂(K)`
matrices of `KleinSigns` — hence a *projective* character of `A₅`; `pairing_chi2_trivial`
records that the pairing with the trivial character of `A₅` is `-1/10 ≠ 0`, so `χ₂` is not a
character of `A₅` itself.  No Frobenius, no `a_p`, no `L`-function. -/

#print axioms Icosa.sum_classSize
#print axioms Icosa.cycleTypeLabel_c5A_eq_c5B
#print axioms Icosa.chi2_neg
#print axioms Icosa.chi2'_eq_chi2_swap5
#print axioms Icosa.chi2_add_chi2'
#print axioms Icosa.pairing_eq
#print axioms Icosa.pairing_chi2_self
#print axioms Icosa.pairing_chi2_chi2'
#print axioms Icosa.pairing_chi2_trivial
#print axioms Icosa.chi2_not_factors_through_cycleType
#print axioms Icosa.cycleType_fiveCycle_pow
#print axioms Icosa.cycleType_inv_eq
#print axioms Icosa.chi2_c1_eq_trace
#print axioms Icosa.chi2_c2A_eq_trace
#print axioms Icosa.chi2_c3A_eq_trace
#print axioms Icosa.chi2_c5A_eq_trace
#print axioms Icosa.chi2_c5B_eq_trace
#print axioms Icosa.chi2_realised_by_sl2

/-! ### The cancellation warning and the holomorphy interface
(`ArtinA5Even.HolomorphyInterface`)

The logical gap "regular product ⇏ regular factors" is a theorem here, in two forms (in the
rational function field, and for entire functions on `ℂ`), and once more in the shape of the
`1951` factorisation.  No `Prop` stands in for a missing theory: no Hecke or Artin
`L`-function is defined, no reduction "product entire ⇒ factors holomorphic" is asserted, and
the entirety of the two-dimensional even Artin `L`-function of conductor `1951` is not even
stated in Lean, let alone proved. -/

#print axioms Holo.inv_sub_C_not_polynomial
#print axioms Holo.exists_ratFunc_factorisation
#print axioms Holo.not_continuousAt_inv_zero
#print axioms Holo.not_continuousAt_inv_sub
#print axioms Holo.inv_mul_sq
#print axioms Holo.exists_entire_prod
#print axioms Holo.exists_pole_cancelled_by_zero
#print axioms Holo.factorisation_does_not_force_holomorphy

/-! ## Still absent, deliberately

* no Maass form, and `ExistsMaass1951` is neither proved nor inhabited nor assumed;
* no `R = 0` certificate, no Fourier coefficient imported as a theorem, no Selberg data;
* no statement that the `L`-function of any representation attached to `f₁₉₅₁` is entire;
* no Tate vanishing `H²(G_ℚ, ℂ^×) = 0`;
* no linear lift `Gal → SL₂` — indeed there is none, by
  `ArtinA5Even.not_linearLiftOfRhoBar1951` — and `ExistsProjectiveEvenRep1951` is not
  inhabited: the composite `ρ̄` of `ArtinA5Even.RhoBar1951` is abstract, with neither evenness
  nor the conductor `1951` proved;
* no lift to `GL₂(ℂ)` is constructed or excluded: the `SL₂` result above says nothing about
  Artin's setting;
* no Artin or Hecke `L`-function, and no `Prop` naming a missing Mathlib theory: the only
  statements about `L`-shaped objects are the counterexamples showing that a factorisation
  with an entire product does not make the factors holomorphic;
* holomorphy of either factor `L(ρ₃)`, `L(ρ₃′)` on `(0,1)`, and entirety of the
  two-dimensional even Artin `L`-function of conductor `1951`, are **not** proved — the latter
  is not even stated in Lean. -/

end ArtinA5Even
