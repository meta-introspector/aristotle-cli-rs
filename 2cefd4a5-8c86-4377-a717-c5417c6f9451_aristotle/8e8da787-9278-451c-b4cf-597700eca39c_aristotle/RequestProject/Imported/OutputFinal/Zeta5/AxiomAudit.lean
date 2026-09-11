/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Companion effort: arithmetic holonomy certificate for `ζ_5(3)`.
-/
import RequestProject.Imported.OutputFinal.Zeta5.Certificate
import RequestProject.Imported.OutputFinal.Zeta5.PublishedTemplate
import RequestProject.Imported.OutputFinal.Zeta5.HauptmodulBC
import RequestProject.Imported.OutputFinal.Zeta5.EtaQuotient
import RequestProject.Imported.OutputFinal.Zeta5.BostCharlesEnergy
import RequestProject.Imported.OutputFinal.Zeta5.EnergyBounds
import RequestProject.Imported.OutputFinal.Zeta5.DividedDifference

/-!
# Axiom audit for the `ζ_5(3)` certificate

Every headline result of the companion effort is listed here with
`#print axioms`.  Each one must report only the three standard axioms
`propext`, `Classical.choice`, `Quot.sound` (or a subset).  In particular no
`sorryAx` and no extra axiom of our own occurs.
-/

namespace Zeta5

-- Task 1: template admissibility
#print axioms Zeta5.tmplNum_eq
#print axioms Zeta5.tmplL1_eq
#print axioms Zeta5.tmplL1_lt_one
#print axioms Zeta5.norm_psi_le
#print axioms Zeta5.psi_neg_one
#print axioms Zeta5.psi_norm_isGreatest
#print axioms Zeta5.template_log_max_neg
#print axioms Zeta5.template_log_max_lt

-- Certified logarithms
#print axioms Zeta5.log_five_gt
#print axioms Zeta5.log_five_lt
#print axioms Zeta5.log_twentyfive_gt
#print axioms Zeta5.log_twentyfive_lt

-- Task 2: Bost–Charles integral
#print axioms Zeta5.polyEval_ne_zero_of_dominant
#print axioms Zeta5.circleAverage_log_norm_polyEval
#print axioms Zeta5.BC_eq_log_25
#print axioms Zeta5.BC_gt
#print axioms Zeta5.BC_lt

-- Task 3: denominator type
#print axioms Zeta5.bseq_den
#print axioms Zeta5.ordProj_lcmUpTo_le
#print axioms Zeta5.tendsto_five_part
#print axioms Zeta5.tendsto_log_lcm_trunc
#print axioms Zeta5.denomType_bseq

-- Task 4: 5-adic radius
#print axioms Zeta5.padicNorm_bseq
#print axioms Zeta5.padicNorm_bseq_mul
#print axioms Zeta5.overconv_radius_bseq

-- The assembled certificate (four ingredients)
#print axioms Zeta5.zeta5_certificate

-- The demoted comparison (kept for the record; not a criterion)
#print axioms Zeta5.BC_lt_budgetInput
#print axioms Zeta5.archCostGuess_lt_budgetInput
#print axioms Zeta5.archCostGuess_budgetInput_margin

-- The published 41-coefficient template: certified admissibility bound
#print axioms Zeta5.Published.tail_abs_sum
#print axioms Zeta5.Published.head_quadratic_le
#print axioms Zeta5.Published.re_logPsi_le
#print axioms Zeta5.Published.norm_psi_le
#print axioms Zeta5.Published.norm_psi_lt_one
#print axioms Zeta5.Published.log_norm_psi_le
#print axioms Zeta5.Published.circleAverage_log_norm_psi
#print axioms Zeta5.Published.circleAverage_log_norm_psi_approx
#print axioms Zeta5.Published.naive_l1_bound_fails

-- Task 5: the Hauptmodul of `X₀(5)` as a convergent eta product
#print axioms Zeta5.Hauptmodul.abs_log_norm_one_sub_le
#print axioms Zeta5.Hauptmodul.abs_etaFactorLog_le
#print axioms Zeta5.Hauptmodul.summable_etaFactorLog
#print axioms Zeta5.Hauptmodul.summable_clog_one_sub_pow
#print axioms Zeta5.Hauptmodul.hasProd_etaFactor
#print axioms Zeta5.Hauptmodul.log_norm_hauptmodul

-- Task 5: the composition `φ = t ∘ ψ` is well defined
#print axioms Zeta5.Hauptmodul.differentiable_psi
#print axioms Zeta5.Hauptmodul.psi_zero
#print axioms Zeta5.Hauptmodul.exp_bound_le_psiRadius
#print axioms Zeta5.Hauptmodul.norm_psi_le_psiRadius
#print axioms Zeta5.Hauptmodul.norm_psiPub_le
#print axioms Zeta5.Hauptmodul.log_norm_phi

-- Task 5: the Bost–Charles integral of the composition, exactly
#print axioms Zeta5.Hauptmodul.circleAverage_log_norm_one_sub_psi_pow
#print axioms Zeta5.Hauptmodul.circleAverage_etaFactorLog
#print axioms Zeta5.Hauptmodul.continuous_tsum_etaFactorLog
#print axioms Zeta5.Hauptmodul.intervalIntegral_tsum_etaFactorLog
#print axioms Zeta5.Hauptmodul.circleAverage_tsum_etaFactorLog
#print axioms Zeta5.Hauptmodul.circleAverage_logPhi
#print axioms Zeta5.Hauptmodul.BC_phi_eq
#print axioms Zeta5.Hauptmodul.circleAverage_logPhiPub
#print axioms Zeta5.Hauptmodul.circleAverage_logPhi_inv
#print axioms Zeta5.Hauptmodul.BC_phi_inv_eq

-- Task 5: `t = (η(τ)/η(5τ))^6`
#print axioms Zeta5.Hauptmodul.etaProd_eq_exp
#print axioms Zeta5.Hauptmodul.etaProd_ne_zero
#print axioms Zeta5.Hauptmodul.hauptmodul_eq_etaProd
#print axioms Zeta5.Hauptmodul.norm_nome_lt_one
#print axioms Zeta5.Hauptmodul.nome_five
#print axioms Zeta5.Hauptmodul.dedekindEta_ne_zero
#print axioms Zeta5.Hauptmodul.etaQuotient_eq_hauptmodul

-- Task 6: the paper's functionals `BC`, `cost`, `budget` (`Zeta5/BostCharlesEnergy.lean`)
#print axioms Zeta5.Hauptmodul.paperCost_eq
#print axioms Zeta5.Hauptmodul.paperCost_eq_add_jensenMean
#print axioms Zeta5.Hauptmodul.four_c_zero_enclosure
#print axioms Zeta5.Hauptmodul.paperBudget_eq
#print axioms Zeta5.Hauptmodul.paperBudget_gt
#print axioms Zeta5.Hauptmodul.paperBudget_lt
#print axioms Zeta5.Hauptmodul.abs_paperBudget_sub_quoted_lt
#print axioms Zeta5.Hauptmodul.phi_eq_etaQuotient
#print axioms Zeta5.Hauptmodul.inv_phi_eq_etaQuotient_inv
#print axioms Zeta5.Hauptmodul.jensenMean_phi_inv_eq_neg
#print axioms Zeta5.Hauptmodul.log_norm_inv_sub_inv
#print axioms Zeta5.Hauptmodul.pairwiseEnergy_inv
#print axioms Zeta5.Hauptmodul.hauptmodul_ne_zero
#print axioms Zeta5.Hauptmodul.phi_ne_zero_circle
#print axioms Zeta5.Hauptmodul.circleAverage_log_norm_phi
#print axioms Zeta5.Hauptmodul.pairwiseEnergy_phi_inv
#print axioms Zeta5.Hauptmodul.paperCostInv_eq
#print axioms Zeta5.Hauptmodul.integral_log_norm_circleMap_sub_eq_zero
#print axioms Zeta5.Hauptmodul.pairwiseEnergy_id
#print axioms Zeta5.Hauptmodul.pairwiseEnergy_le_of_le
#print axioms Zeta5.Hauptmodul.paperCost_lt_paperBudget_of_energy_bound
#print axioms Zeta5.Hauptmodul.paperCostInv_lt_paperBudget_of_energy_bound

-- Task 7: how lossy a supremum bound is (`Zeta5/EnergyBounds.lean`)
#print axioms Zeta5.Hauptmodul.pairwiseEnergy_le_of_le_of_nonneg
#print axioms Zeta5.Hauptmodul.pairwiseEnergy_eq_of_factor
#print axioms Zeta5.Hauptmodul.tsum_etaBound
#print axioms Zeta5.Hauptmodul.log_norm_hauptmodul_inv_le
#print axioms Zeta5.Hauptmodul.log_norm_phi_inv_le_crude
#print axioms Zeta5.Hauptmodul.pairwiseEnergy_phi_inv_le_crude

-- Task 8: the regular integrand `g` (`Zeta5/DividedDifference.lean`)
#print axioms Zeta5.Hauptmodul.norm_sub_le_of_deriv_le
#print axioms Zeta5.Hauptmodul.norm_pow_sub_pow_le
#print axioms Zeta5.Hauptmodul.norm_clog_one_sub_sub_le
#print axioms Zeta5.Hauptmodul.norm_cexp_sub_cexp_le
#print axioms Zeta5.Hauptmodul.norm_etaFactorCLog_sub_le
#print axioms Zeta5.Hauptmodul.summable_etaLipBound
#print axioms Zeta5.Hauptmodul.tsum_etaLipBound
#print axioms Zeta5.Hauptmodul.norm_tsum_etaFactorCLog_sub_le
#print axioms Zeta5.Hauptmodul.hauptmodulInv_eq_inv_hauptmodul
#print axioms Zeta5.Hauptmodul.abs_re_tsum_etaFactorCLog_le
#print axioms Zeta5.Hauptmodul.norm_hauptmodulInv_le
#print axioms Zeta5.Hauptmodul.norm_hauptmodulInv_sub_le
#print axioms Zeta5.Hauptmodul.hasDerivAt_logPsi
#print axioms Zeta5.Hauptmodul.norm_logPsi_le
#print axioms Zeta5.Hauptmodul.norm_deriv_logPsi_le
#print axioms Zeta5.Hauptmodul.norm_psi_sub_le
#print axioms Zeta5.Hauptmodul.Fmap_eq_phi_inv
#print axioms Zeta5.Hauptmodul.norm_Fmap_le
#print axioms Zeta5.Hauptmodul.norm_Fmap_sub_le
#print axioms Zeta5.Hauptmodul.dividedDiff_mul
#print axioms Zeta5.Hauptmodul.gPhiInv_mul
#print axioms Zeta5.Hauptmodul.gPhiInv_symm
#print axioms Zeta5.Hauptmodul.norm_gPhiInv_le
#print axioms Zeta5.Hauptmodul.continuousOn_Fmap
#print axioms Zeta5.Hauptmodul.continuousOn_gPhiInv_offDiag
#print axioms Zeta5.Hauptmodul.norm_gPhiInv_sub_le
#print axioms Zeta5.Hauptmodul.norm_circleMap_sub_circleMap
#print axioms Zeta5.Hauptmodul.norm_circleMap_sub_circleMap_ge
#print axioms Zeta5.Hauptmodul.gPhiInv_factorisation
#print axioms Zeta5.Hauptmodul.norm_gPhiInv_circleMap_le
#print axioms Zeta5.Hauptmodul.norm_gPhiInv_circleMap_sub_le

end Zeta5
