import RequestProject.Solfunmeme.Sync.Lattice

/-!
# Axiom audit for the replication model

Every result in `RequestProject/Sync/Lattice.lean`, printed with the axioms it
rests on.  As elsewhere in this project the intent is that nothing here needs
`native_decide`: these are ordinary proofs about finite sets, so at worst they
use `propext`, `Classical.choice` and `Quot.sound`.
-/

namespace Solfunmeme.Sync

-- merge is a semilattice join
#print axioms merge_comm
#print axioms merge_assoc
#print axioms merge_idem
#print axioms merge_self_right
#print axioms subset_merge_left
#print axioms merge_mono
#print axioms card_le_card_merge

-- a run depends only on what was delivered
#print axioms run_eq_merge_delivered
#print axioms run_append
#print axioms delivered_append
#print axioms subset_run
#print axioms run_mono_state

-- order, duplication and transport are irrelevant
#print axioms run_pair_comm
#print axioms run_perm_invariant
#print axioms run_append_self
#print axioms run_cons_dup
#print axioms run_retag
#print axioms transports_interchangeable
#print axioms online_offline_commute

-- convergence
#print axioms final_subset_total
#print axioms convergence
#print axioms converged_pairwise
#print axioms one_bundle_suffices

-- the head
#print axioms head_congr
#print axioms heads_agree
#print axioms headKey_mono
#print axioms headKey_run
#print axioms headKey_empty
#print axioms headKey_mem

end Solfunmeme.Sync
