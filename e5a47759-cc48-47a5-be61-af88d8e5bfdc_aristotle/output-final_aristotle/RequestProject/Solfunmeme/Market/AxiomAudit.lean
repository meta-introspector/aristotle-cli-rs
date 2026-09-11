import RequestProject.Solfunmeme.Market.Challenge
import RequestProject.Solfunmeme.Market.Compute
import RequestProject.Solfunmeme.Market.Examples
import RequestProject.Solfunmeme.Market.Fit
import RequestProject.Solfunmeme.Market.Private
import RequestProject.Solfunmeme.Market.Roadmap
import RequestProject.Solfunmeme.Market.Stake
import RequestProject.Solfunmeme.Market.Supply
import RequestProject.Solfunmeme.Market.Twin

/-!
# Axiom audit for the verified-computation market

Every result of the market development, printed with the axioms it rests on.
As elsewhere in this project nothing here uses `native_decide` or an axiom of
our own: at worst these proofs use `propext`, `Classical.choice` and
`Quot.sound`.
-/

namespace RequestProject.Market

-- settlement
#print axioms payout_conserves
#print axioms paid_implies_spec
#print axioms payout_of_no_submission
#print axioms honest_operator_paid
#print axioms bond_forfeited_iff

-- revenue
#print axioms revenue_only_from_verified
#print axioms revenue_zero_of_none_accepted
#print axioms revenue_mono

-- proofs versus votes
#print axioms vote_market_pays_for_wrong_result
#print axioms proof_market_immune_to_collusion

-- challenge window, slashing and audit by sampling
#print axioms optimistic_payout_conserves
#print axioms slashed_iff_challenged
#print axioms optimistic_pays_for_wrong_result
#print axioms silent_watch_always_pays
#print axioms unchallenged_of_spec
#print axioms honest_claim_paid
#print axioms challenged_of_not_spec
#print axioms diligent_paid_implies_spec
#print axioms diligent_court_pays_iff_spec
#print axioms challenge_agrees_with_proof_market
#print axioms watchdog_diligent
#print axioms undetected_iff_disjoint
#print axioms full_audit_detects
#print axioms escaping_samples
#print axioms escaping_samples_card
#print axioms all_samples_card
#print axioms escaping_lt_all
#print axioms mul_choose_pred
#print axioms escape_step
#print axioms escape_geometric_bound
#print axioms escape_ratio_le
#print axioms escaping_samples_geometric

-- tolerances, fit and timing in the twin
#print axioms fits_iff_worst_case
#print axioms clearance_bounds
#print axioms fits_of_tighter_shaft
#print axioms fits_of_wider_hole
#print axioms sum_mem
#print axioms width_sum
#print axioms deadline_met_iff
#print axioms FitMachine.closed_of_fitClosed
#print axioms FitMachine.fitClosed_substitute

-- the senator's wishes, as a scheduled wish list
#print axioms vaicuPlan_correct
#print axioms vaicu_no_cycle
#print axioms vaicu_done_is_downward_closed
#print axioms vaicu_done_before_open
#print axioms vaicu_ready
#print axioms vaicu_ready_nonempty
#print axioms vaicu_blocked
#print axioms vaicu_progress
#print axioms vaicu_every_done_has_evidence
#print axioms vaicu_wishes_are_new

-- private input, untrusted compute, verified result
#print axioms unmask_mask
#print axioms mask_blindEquiv
#print axioms mask_bijective
#print axioms card_mask_fiber
#print axioms Blindable.recover
#print axioms private_verified_result

-- stake, reward and the cost of lying
#print axioms run_of_all_accepted
#print axioms stake_plus_forfeits
#print axioms failures_bounded
#print axioms failure_count_le_stake_div_bond
#print axioms liar_earns_nothing

-- software supply chain
#print axioms deployed_eq_rebuild
#print axioms deployed_unique
#print axioms tampering_invalidates_chain
#print axioms rebuild_of_identity_tools
#print axioms deployed_of_identity_tools
#print axioms deployed_satisfies
#print axioms deployed_satisfies_all
#print axioms artifact_of_digest
#print axioms deployed_of_matching_digest

-- machines, bills of materials and substitution
#print axioms Refines.refl
#print axioms Refines.trans
#print axioms Assembly.unions_mono
#print axioms Assembly.provided_subset_substitute
#print axioms Assembly.required_substitute_subset
#print axioms Assembly.guaranteed_subset_substitute
#print axioms Assembly.closed_substitute
#print axioms Assembly.guarantee_preserved
#print axioms Assembly.closed_substitute_list

end RequestProject.Market
