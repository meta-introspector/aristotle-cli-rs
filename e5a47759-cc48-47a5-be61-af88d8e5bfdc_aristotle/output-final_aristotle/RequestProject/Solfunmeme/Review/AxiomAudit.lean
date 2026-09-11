/-
  AxiomAudit.lean — trusted-base audit of the upstream modules.

  85 of the 98 upstream theorems are discharged by `native_decide`, which evaluates
  the goal with compiled code and therefore adds `Lean.ofReduceBool` and
  `Lean.trustCompiler` to the result's trusted base.  The `#print axioms` commands
  below report this (they emit information messages during elaboration); the
  matching statements in `Review.KernelChecked` are proved by `decide` and depend
  only on the standard axioms — several on none at all.
-/

import RequestProject.Solfunmeme.Review.KernelChecked
import RequestProject.Solfunmeme.Review.ClaudeClaims

namespace Review.AxiomAudit

-- Upstream: proved by `native_decide`.
#print axioms tier_sorted
#print axioms monster_product
#print axioms minimum_passage
#print axioms senator_vote_valid
#print axioms dao_weight_val

-- Same statements, proved by `decide`.
#print axioms Review.KernelChecked.tier_sorted
#print axioms Review.KernelChecked.monster_product
#print axioms Review.KernelChecked.minimum_passage
#print axioms Review.KernelChecked.senator_vote_valid
#print axioms Review.KernelChecked.dao_weight_val

-- The audit of the dataset's own AI commentary is likewise kernel-checked.
#print axioms Review.ClaudeClaims.claim_1600_overstates_influence
#print axioms Review.ClaudeClaims.rank_one_million_accepted
#print axioms Review.ClaudeClaims.eligibleRanks_length_le_1600
#print axioms Review.ClaudeClaims.total_capital

-- Upstream theorems proved without `native_decide` are already clean.
#print axioms weight_pos
#print axioms filter_subset

end Review.AxiomAudit
