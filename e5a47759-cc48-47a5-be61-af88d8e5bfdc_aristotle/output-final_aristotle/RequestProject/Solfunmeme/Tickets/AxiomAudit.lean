/-
Axiom audit for the ticket ontology.
-/
import RequestProject.Solfunmeme.Tickets.Plan

/-!
# Axiom audit

Every result of the ticket formalization, with the axioms it depends on.
Nothing here may use anything beyond `propext`, `Classical.choice` and
`Quot.sound`.
-/

namespace SFM.Tickets

-- the logic
#print axioms SFM.DL.FModel.eval_iff
#print axioms SFM.DL.FModel.consistent_of_checkKB
#print axioms SFM.DL.KB.not_entails_bot_of_consistent

-- the knowledge base
#print axioms corpusModel_checks
#print axioms kb_consistent
#print axioms kb_no_absurd_individual

-- the wish list
#print axioms wish_entailed
#print axioms mem_wishNumbers_entails
#print axioms wishNumbers_length
#print axioms extension_wishListItem

-- its shape
#print axioms wishListItem_sub_open
#print axioms wishListItem_sub_ticket
#print axioms wishListItem_not_closed
#print axioms unclaimed_sub_wishListItem
#print axioms actionable_sub_unclaimed
#print axioms actionable_sub_wishListItem
#print axioms actionable_blocked_disjoint
#print axioms rewarded_sub_wishListItem
#print axioms blocked_waits
#print axioms ticket_has_author

-- examples, non-entailments and counts
#print axioms ticket10_rewarded
#print axioms ticket175_proofWish
#print axioms ticket42_communityWish
#print axioms ticket13_not_wish
#print axioms wish_not_sub_rewarded
#print axioms kb_size
#print axioms count_tickets
#print axioms count_wishes
#print axioms count_actionable
#print axioms count_proofWishes
#print axioms count_communityWishes
#print axioms count_rewarded
#print axioms blocked_wishes
#print axioms proof_wishes
#print axioms wish_topic_counts
#print axioms community_wishes

-- what the comment dump added
#print axioms ready_sub_actionable
#print axioms ready_sub_wishListItem
#print axioms quickWin_sub_ready
#print axioms ready_waiting_disjoint
#print axioms waiting_has_open_prerequisite
#print axioms small_large_disjoint
#print axioms discussed_iff_spoken
#print axioms answered_sub_discussed
#print axioms no_waiting_wishes
#print axioms ready_eq_actionable
#print axioms count_quickWins
#print axioms quick_wins
#print axioms count_epics
#print axioms count_needsSpec
#print axioms count_answered_dormant
#print axioms discussion_counts
#print axioms size_counts
#print axioms endorsed_tickets

-- plans in general
#print axioms Plan.rank_lt_of_depEdge
#print axioms Plan.rank_lt_of_transGen
#print axioms Plan.acyclic
#print axioms Plan.mem_tickets_of_prereq

-- the plan for the wish list
#print axioms plan_length
#print axioms plan_nodup
#print axioms plan_only_wishes
#print axioms plan_covers_wishes
#print axioms plan_schedules_the_wish_list
#print axioms plan_entails_wish
#print axioms plan_covers_actionable
#print axioms plan_prereqs_are_the_links
#print axioms plan_prereqs_earlier
#print axioms plan_prereqs_present
#print axioms plan_prereq_before
#print axioms plan_no_cycle
#print axioms plan_phases_monotone
#print axioms plan_phases_named
#print axioms plan_phase_counts
#print axioms plan_blocked_go_last
#print axioms plan_priority_within_phase
#print axioms plan_quickWins_before_epics

end SFM.Tickets
