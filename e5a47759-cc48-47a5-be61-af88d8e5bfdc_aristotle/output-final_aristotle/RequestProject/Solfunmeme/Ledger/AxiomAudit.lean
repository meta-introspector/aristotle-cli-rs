/-
  AxiomAudit.lean — trusted-base audit of the ledger modules.

  Every statement about the recorded transactions in `Ledger.SampleFacts` and
  `Ledger.Verdicts` is discharged by the kernel: `decide`, or `decide` on the
  chunks of the sample combined by the additivity lemmas of `Ledger.Behaviour`.
  None of them uses `native_decide`, so none of them adds `Lean.ofReduceBool`
  or `Lean.trustCompiler` to its trusted base.  The `#print axioms` commands
  below report that (they emit information messages during elaboration).
-/

import RequestProject.Solfunmeme.Ledger.SampleFacts
import RequestProject.Solfunmeme.Ledger.Verdicts
import RequestProject.Solfunmeme.Ledger.PopulationFacts

namespace Ledger.AxiomAudit

-- The general theory of the model: no data, arbitrary lists of transactions.
#print axioms Ledger.nOk_add_nFail
#print axioms Ledger.burnt_le_fees
#print axioms Ledger.nMoves_eq
#print axioms Ledger.nExits_le_nSells
#print axioms Ledger.verdict_good_iff
#print axioms Ledger.verdict_bad_iff
#print axioms Ledger.verdict_bad_of_neverSettles
#print axioms Ledger.verdict_bad_of_inert
#print axioms Ledger.corroborated_of_sound
#print axioms Ledger.ne_of_discriminates

-- What the index as a whole contains.
#print axioms Ledger.SampleFacts.sample_size
#print axioms Ledger.SampleFacts.sample_failed
#print axioms Ledger.SampleFacts.sample_slippage
#print axioms Ledger.SampleFacts.sample_live
#print axioms Ledger.SampleFacts.sample_fees
#print axioms Ledger.SampleFacts.sample_burnt
#print axioms Ledger.SampleFacts.sample_wf_sound
#print axioms Ledger.SampleFacts.sample_failuresAreInert
#print axioms Ledger.SampleFacts.sample_verdict

-- The verdicts on the individual wallets.
#print axioms Ledger.Verdicts.w_J3Z1AfTD_verdict
#print axioms Ledger.Verdicts.w_7QeRHULB_verdict
#print axioms Ledger.Verdicts.w_4AnrXS8H_verdict
#print axioms Ledger.Verdicts.w_9XvBYSKe_verdict
#print axioms Ledger.Verdicts.w_C9YvTztk_verdict
#print axioms Ledger.Verdicts.w_7dGrdJRY_verdict
#print axioms Ledger.Verdicts.w_HxkTYMtx_verdict
#print axioms Ledger.Verdicts.w_EN4kMnNm_verdict
#print axioms Ledger.Verdicts.w_686oaTQa_verdict
#print axioms Ledger.Verdicts.w_6VzidcFh_verdict
#print axioms Ledger.Verdicts.w_27XHsdyK_verdict
#print axioms Ledger.Verdicts.w_5ssQGkUG_verdict
#print axioms Ledger.Verdicts.w_F4oEKU8a_verdict
#print axioms Ledger.Verdicts.w_G1uSQxpf_verdict
#print axioms Ledger.Verdicts.w_DLp2YLYc_verdict
#print axioms Ledger.Verdicts.w_HCb7hLss_verdict
#print axioms Ledger.Verdicts.w_FTotzvz1_verdict
#print axioms Ledger.Verdicts.w_6DAHh1hH_verdict
#print axioms Ledger.Verdicts.w_x3pJA2jG_verdict
#print axioms Ledger.Verdicts.w_CMbBM2BW_verdict
#print axioms Ledger.Verdicts.w_FwqxwTYu_verdict
#print axioms Ledger.Verdicts.w_21nALQTX_verdict

-- The theories of the wallets, and the fleet evidence.
#print axioms Ledger.Verdicts.w_J3Z1AfTD_theory_sound
#print axioms Ledger.Verdicts.w_J3Z1AfTD_theory_discriminates_7QeRHULB
#print axioms Ledger.Verdicts.w_HxkTYMtx_theory_sound
#print axioms Ledger.Verdicts.w_6VzidcFh_theory_sound
#print axioms Ledger.Verdicts.fleet_fees_wEN4kMnNm
#print axioms Ledger.Verdicts.no_exotic_fee_wJ3Z1AfTD
#print axioms Ledger.Verdicts.coSlots_wDLp2YLYc_wHCb7hLss
#print axioms Ledger.Verdicts.coSlots_wJ3Z1AfTD_w686oaTQa

-- Every fee payer at once.
#print axioms Ledger.verdictS_summaryOf
#print axioms Ledger.countVerdict_total
#print axioms Ledger.PopulationFacts.population_size
#print axioms Ledger.PopulationFacts.population_agrees_with_sample
#print axioms Ledger.PopulationFacts.summaryOf_w_J3Z1AfTD
#print axioms Ledger.PopulationFacts.population_good
#print axioms Ledger.PopulationFacts.population_bad
#print axioms Ledger.PopulationFacts.txs_of_bad
#print axioms Ledger.PopulationFacts.busy_bad
#print axioms Ledger.PopulationFacts.busy_good_is_6VzidcFh
#print axioms Ledger.PopulationFacts.no_good_heavy

end Ledger.AxiomAudit
