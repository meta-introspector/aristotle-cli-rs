/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Axiom audit of the `A₅` Artin-conductor development.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinConductor
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinSubgroup
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinDecomposition
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinCharacter
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinMultiplicity
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinSylow
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinOrbits
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinEuler
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinCosets
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinThreeDim

/-!
# Axiom audit — the `A₅` Artin conductors

This file is deliberately isolated: its only imports are the `A5Artin*`
modules, so elaborating it does **not** pull in the Weil-positivity chain.  Each `#print axioms` command below names a declaration
that really occurs in `RequestProject/A5ArtinConductor.lean`; the expected — and
observed — output is either

  '...' depends on axioms: [propext]

for the purely computational statements, or the three standard axioms
`[propext, Classical.choice, Quot.sound]`.
-/

-- The invariant dimensions used in the conductor formula are the character averages.
#print axioms A5Artin.fixedDim_mul_card_eq_charSum

-- Local conductor exponents: conductor–discriminant, and the comparison of ρ₃, ρ₃′, ρ₄, ρ₅.
#print axioms A5Artin.condExp_perm5_eq_r4
#print axioms A5Artin.condExp_perm6_eq_r5
#print axioms A5Artin.condExp_r3b_eq_r3
#print axioms A5Artin.condExp_r3_eq_r4
#print axioms A5Artin.condExp_r4_le_r5
#print axioms A5Artin.condExp_perm12
#print axioms A5Artin.condExp_reg

-- Global conductors: N(ρ₃) = N(ρ₃′) = N(ρ₄) = d_K, the formula for N(ρ₅), and the
-- conductor form of the factorisations of the Dedekind zeta functions.
#print axioms A5Artin.discK_eq_artinConductor_r4
#print axioms A5Artin.artinConductor_r3b_eq_r3
#print axioms A5Artin.artinConductor_r3_eq_r4
#print axioms A5Artin.artinConductor_three_eq_discK
#print axioms A5Artin.artinConductor_r5_eq_discK_mul_excess
#print axioms A5Artin.discK_dvd_artinConductor_r5
#print axioms A5Artin.artinConductor_r5_eq_discK
#print axioms A5Artin.artinConductor_perm6_eq_r5
#print axioms A5Artin.artinConductor_perm12_eq
#print axioms A5Artin.artinConductor_reg_eq

-- The sextic discriminant and the unconditional `C₅`-deficit comparison.
#print axioms A5Artin.discK6_eq_artinConductor_r5
#print axioms A5Artin.discK_eq_artinConductor_r3_mul_deficit
#print axioms A5Artin.artinConductor_r3_dvd_discK
#print axioms A5Artin.deficit_eq_one

-- Verification against the numerical tables of `docs/A5_even_Artin.md`.
#print axioms A5Artin.table_conductors
#print axioms A5Artin.table_integral
#print axioms A5Artin.table_no_C5

-- The `Subgp` table is grounded in genuine subgroups of `Equiv.Perm (Fin 5)`.
#print axioms A5Artin.card_clsFinset
#print axioms A5Artin.mem_clsFinset_iff_isConj
#print axioms A5Artin.Subgp.closure_gens
#print axioms A5Artin.Subgp.toSubgroup_le_alternatingGroup
#print axioms A5Artin.Subgp.card_toSubgroup
#print axioms A5Artin.Subgp.count_eq_card_filter

-- One decomposition datum, three consequences.
#print axioms A5Artin.chi_eq_decompose
#print axioms A5Artin.codim_eq_decompose
#print axioms A5Artin.condExp_eq_decompose
#print axioms A5Artin.artinConductor_eq_decompose
#print axioms A5Artin.euler_eq_decompose

/-!
## The tables closed in this pass

The characters of the permutation representations are fixed-point counts, the
6-point set is the set of the six Sylow 5-subgroups, the invariant dimensions of
the two permutation representations are orbit counts of the genuine subgroups,
the multiplicity list is the character inner product, and the Euler-factor
identity holds over an arbitrary commutative ring.
-/

-- Permutation characters as fixed-point counts, and the derived `χ₄`, `χ₅`.
#print axioms A5Artin.chiPerm5_eq_card_fixed
#print axioms A5Artin.chiReg_eq_card_fixed
#print axioms A5Artin.chi4_eq_sub
#print axioms A5Artin.chi4_eq_card_fixed_sub_one
#print axioms A5Artin.chiPerm6_eq_card_fixed
#print axioms A5Artin.chi5_eq_sub
#print axioms A5Artin.chi5_eq_card_fixed_sub_one

-- The six Sylow 5-subgroups and the conjugation action on them.
#print axioms A5Artin.card_syl5
#print axioms A5Artin.syl5_injective
#print axioms A5Artin.syl5Subgroup_le_alternatingGroup
#print axioms A5Artin.card_syl5Subgroup
#print axioms A5Artin.mem_syl5_of_pow_five
#print axioms A5Artin.act6_spec
#print axioms A5Artin.act6_one
#print axioms A5Artin.act6_mul
#print axioms A5Artin.act6_injective

-- Invariant dimensions as orbit counts of the genuine subgroups.
#print axioms A5Artin.orbit5Set_eq_orbit
#print axioms A5Artin.fixedDim_perm5_eq_numOrbits
#print axioms A5Artin.fixedDim_perm6_eq_numOrbits
#print axioms A5Artin.fixedDim_r4_add_one_eq_numOrbits
#print axioms A5Artin.fixedDim_r5_add_one_eq_numOrbits

-- The multiplicity list from the character inner product.
#print axioms A5Artin.mult_eq_decompose
#print axioms A5Artin.mult_self_irreducible
#print axioms A5Artin.mult_orthogonal

-- The Euler-factor identity over an arbitrary commutative ring.
#print axioms A5Artin.eulerGen_eq_decompose
#print axioms A5Artin.permPoly5_eq_of_eulerGen
#print axioms A5Artin.permPoly6_eq_of_eulerGen
#print axioms A5Artin.permPoly12_eq_of_eulerGen
#print axioms A5Artin.regPoly_eq_of_eulerGen
#print axioms A5Artin.euler_eq_decompose_of_gen

-- The 12 cosets of a Sylow 5-subgroup, and the derived sum χ₃ + χ₃′.
#print axioms A5Artin.card_cosets12
#print axioms A5Artin.coe_lcoset_sylS
#print axioms A5Artin.lcoset_sylS_eq_self_iff
#print axioms A5Artin.lcoset_mem_cosets12
#print axioms A5Artin.lcoset_injective
#print axioms A5Artin.chiPerm12_eq_card_fixed
#print axioms A5Artin.chi3_add_chi3b_eq_sub
#print axioms A5Artin.chi3_add_chi3b_eq_card_fixed_sub
#print axioms A5Artin.fixedDim_perm12_eq_numOrbits

-- The explicit three-dimensional representations over ℤ[φ] ⊂ ℚ(√5).
#print axioms A5Artin.rho3_mul
#print axioms A5Artin.rho3_eq_one
#print axioms A5Artin.det_rho3
#print axioms A5Artin.rep3_injective
#print axioms A5Artin.det_rep3
#print axioms A5Artin.trace_rho3_rep
#print axioms A5Artin.chi3_eq_trace_rep3
#print axioms A5Artin.chi3b_eq_trace_rep3
#print axioms A5Artin.chi3b_eq_trace_rep3b
#print axioms A5Artin.rep3_entries_mem_adjoin
