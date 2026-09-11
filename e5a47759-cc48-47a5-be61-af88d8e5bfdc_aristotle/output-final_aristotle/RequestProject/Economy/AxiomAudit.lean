/-
# Axiom audit for the economic reconstruction layer

The kernel prints, at build time, exactly which axioms each headline result of
this layer depends on.  The expected answer everywhere is the standard three —
`propext`, `Classical.choice`, `Quot.sound`.  In particular no assumption of
this development is a declared axiom: signature unforgeability, honest
non-equivocation, bounded faults and digest collision-freedom are all
hypotheses of the theorems that use them.
-/
import RequestProject.Economy

namespace RequestProject.Economy

#print axioms Dim.area_mul_yield
#print axioms Interval.mul_mem
#print axioms IQty.harvest_mem
#print axioms Interval.helly_of_pairwise
#print axioms glueAt_glued_iff
#print axioms glueAt_inconsistent_witness
#print axioms glueAt_mono
#print axioms exists_globalSection
#print axioms Period.chain_pairwise_disjoint
#print axioms Period.chain_days_sum
#print axioms RegionRegistry.contains_antisymm
#print axioms IntervalAccount.intervalBalanced_of_exact
#print axioms IntervalAccount.balancedWithin_derived
#print axioms IntervalAccount.derivedTolerance_le_declared_precision
#print axioms Obs.median_mem_range
#print axioms Obs.median_eq_of_weight_majority
#print axioms Obs.mean_influence_unbounded
#print axioms Obs.settle_sound
#print axioms reward_independent_of_value
#print axioms same_bytes_of_same_hash
#print axioms Quorum.card_inter_gt_faultBound
#print axioms naive_threshold_fails
#print axioms certificate_agreement
#print axioms accountability
#print axioms accepts_sound
#print axioms accepts_complete
#print axioms Wheat.baseline_is_accepted
#print axioms Wheat.inflated_reconstruction_is_rejected
#print axioms Wheat.disputed_has_no_global_section
#print axioms Wheat.settled_yield_is_robust
#print axioms Wheat.unlisted_site_fails_provenance
#print axioms Wheat.uncovered_cell_fails_coverage

end RequestProject.Economy
