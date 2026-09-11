/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Axiom audit of the headline results of the project.

Elaborating this file prints, for each of the theorems, the list of axioms its proof
depends on.  The expected — and observed — output is

  'ConnesConsani.WeilPositivity.fourierSide_nonneg' depends on axioms:
    [propext, Classical.choice, Quot.sound]

and likewise for the others, i.e. only the three standard axioms of Lean/Mathlib
(no `sorryAx`, no `Lean.ofReduceBool`, no project-specific axiom).  The verbatim output is
recorded in `RequestProject/VERIFICATION.md`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ArchimedeanPositivity
import RequestProject.Imported.OutputFinal.RequestProject.NormalizedPositivity
import RequestProject.Imported.OutputFinal.RequestProject.UnnormalizedCounterexample
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityNorm
import RequestProject.Imported.OutputFinal.RequestProject.TraceIdentityObstruction
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTrace
import RequestProject.Imported.OutputFinal.RequestProject.TraceDivergence
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedTraceDensity
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedDensitySymmetry
import RequestProject.Imported.OutputFinal.RequestProject.RenormalizedDensityBound
import RequestProject.Imported.OutputFinal.RequestProject.DiagonalQuadraticGrowth
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalSi
import RequestProject.Imported.OutputFinal.RequestProject.WeilKernelComparison
import RequestProject.Imported.OutputFinal.RequestProject.CutoffLogProfile
import RequestProject.Imported.OutputFinal.RequestProject.EvenConstant

namespace ConnesConsani.WeilPositivity

#print axioms fourierSide_nonneg
#print axioms two_thetaDeriv_add_deltaFourier_nonneg
#print axioms LfunNorm_re_nonneg_convLog_starLog
#print axioms LfunNorm_re_nonneg_contDiff_four
#print axioms LPositivityNorm_holds
#print axioms not_LPositivity

-- Operator-theoretic infrastructure.
#print axioms coeFn_fourierL2_of_integrable
#print axioms hsNormSq_le_of_kernel
#print axioms isHilbertSchmidt_P1hat_comp_P1
#print axioms soninSandwich_isPositive
#print axioms isTraceClass_soninSandwich
#print axioms isTraceClass_thetaOp_soninSandwich
#print axioms thetaOpOf_testConv
#print axioms adjoint_thetaOpOf
#print axioms thetaOpOf_testConv_starTest_isPositive
#print axioms re_traceAlong_thetaOp_convSquare_soninSandwich_nonneg
#print axioms LfunNorm_re_nonneg_of_normalizedTraceIdentity

-- The paper's unitary, the kernel form of the local trace formula, the structure of the
-- trace density, and the refutation of the normalized trace identity.
#print axioms range_weilMap
#print axioms coeFn_weilMap_scaling
#print axioms traceAlong_thetaOpOf_soninSandwich_eq_integral
#print axioms normalizedTraceIdentity_iff_traceDensity
#print axioms traceDensity_eq_hsInner
#print axioms conj_traceDensity
#print axioms continuous_traceDensity
#print axioms not_normalizedTraceIdentity

-- The renormalized-trace programme: cut-off family, exhaustion, divergence of the trace of
-- the cut-off sandwich, and the renormalized trace functional.
#print axioms soninSandwichCut_isPositive
#print axioms soninSandwichCut_eq_adjoint_comp
#print axioms Pcut_comp_Pcut_of_le
#print axioms isHilbertSchmidt_PcutHat_comp_Pcut
#print axioms isTraceClass_thetaOp_soninSandwichCut
#print axioms re_traceAlong_thetaOp_convSquare_soninSandwichCut_nonneg
#print axioms tendsto_soninSandwichCut_apply
#print axioms tendsto_traceAlongRe_soninSandwichCut_atTop
#print axioms logCounterTerm_convSquare
#print axioms re_regularizedCutTrace_convSquare_ge
#print axioms not_fixedScale_renormalizedTraceIdentity
#print axioms cutTrace_eq_integral
#print axioms renormalizedTraceIdentity_iff_density
#print axioms traceDensityCut_eq_hsInner
#print axioms conj_traceDensityCut
#print axioms continuous_traceDensityCut
#print axioms norm_traceDensityCut_le_one
#print axioms traceDensityCut_posSemidef
#print axioms re_traceDensityCut_one_mono
#print axioms hasRenormalizedTrace_iff_tendsto_cutTrace

-- The diagonal density grows quadratically, so the pure-diagonal logarithmic hypothesis
-- `DiagLogUpperBound` is refuted.
#print axioms diagDensity_ge_quadratic
#print axioms diagDensity_le_four_mul_sq
#print axioms not_diagLogUpperBound

-- The off-diagonal limit of the semi-local density (the archimedean Weil kernel), its
-- comparison with the kernel of the explicit formula, and the unconditional finite part of
-- the renormalized cut-off trace.
#print axioms semiLocalDensity_eq_Si
#print axioms tendsto_semiLocalDensity_scaling
#print axioms weilPairing_eq_weilR_add_reflectionPairing
#print axioms tendsto_modelCutTrace_LfunNorm
#print axioms exists_hasCutoffLogProfile_refBump
#print axioms exists_universal_finitePart_unconditional
#print axioms exists_universal_finitePart_LfunNorm

-- The even (Sonin) subspace: the even semi-local density in closed form, the halving of the
-- cut-off trace, and the renormalized asymptotic with logarithmic coefficient `2 f(1)`.
#print axioms evenSemiLocalDensity_eq_Si
#print axioms evenModelCutTrace_eq_half
#print axioms tendsto_reflModelCutTrace
#print axioms exists_universal_even_finitePart
#print axioms exists_universal_even_finitePart_LfunNorm
#print axioms even_finitePart_value
#print axioms even_finitePart_value_LfunNorm

end ConnesConsani.WeilPositivity
