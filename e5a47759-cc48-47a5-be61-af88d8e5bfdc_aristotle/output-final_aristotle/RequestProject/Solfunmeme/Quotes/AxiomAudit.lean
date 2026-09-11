/-
  AxiomAudit.lean — what the holders' data feed depends on.

  Nothing here uses `sorry`, `native_decide`, an `axiom` declaration or
  `@[implemented_by]`; the signature verifier and the key-holding predicate are
  named hypotheses of the theorems that use them, not axioms.
-/

import RequestProject.Solfunmeme.Quotes.Feed

namespace Quotes.AxiomAudit

/-! ### `RequestProject/Quotes/Feed.lean` -/

#print axioms Quotes.admitted_are_eligible
#print axioms Quotes.admitted_authentic
#print axioms Quotes.admitted_on_roster
#print axioms Quotes.admittedWith_sources_sublist
#print axioms Quotes.admitted_sources_sublist
#print axioms Quotes.admitted_sources_nodup
#print axioms Quotes.outsider_submission_ignored
#print axioms Quotes.duplicate_submission_ignored
#print axioms Quotes.stuffing_changes_nothing
#print axioms Quotes.sorted_perm
#print axioms Quotes.sorted_length
#print axioms Quotes.sorted_pairwise
#print axioms Quotes.median_mem
#print axioms Quotes.median_between
#print axioms Quotes.inBand_iff
#print axioms Quotes.countP_band_split
#print axioms Quotes.median_robust
#print axioms Quotes.feedValue_robust

end Quotes.AxiomAudit
