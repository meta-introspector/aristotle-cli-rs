/-
  AxiomAudit.lean — what the federal model's results depend on.

  Every theorem of `RequestProject/Federal/` printed below should report only
  the three standard axioms `propext`, `Classical.choice`, `Quot.sound` (many
  report fewer).  Nothing in this directory uses `sorry`, `native_decide`, an
  `axiom` declaration or `@[implemented_by]`: the concrete figures of
  `Facts.lean` and `Supply.lean` are checked by `decide`, so the kernel
  recomputes them from the dataset's own tables.
-/

import RequestProject.Solfunmeme.Federal.Supply

namespace Federal

/-! ### Apportionment -/

#print axioms Federal.senate_equal
#print axioms Federal.senateSeats_total
#print axioms Federal.apportion_total
#print axioms Federal.seats_ge_lower_quota
#print axioms Federal.seats_le_upper_quota
#print axioms Federal.baseTotal_le
#print axioms Federal.extras_le
#print axioms Federal.small_division_overrepresented

/-! ### The Congress -/

#print axioms Federal.enacted_iff
#print axioms Federal.overridden_iff
#print axioms Federal.enacted_needs_both_chambers
#print axioms Federal.overridden_needs_supermajority
#print axioms Federal.veto_sustained_of_not_super
#print axioms Federal.quorum_attainable
#print axioms Federal.enactment_attainable
#print axioms Federal.override_attainable
#print axioms Federal.supermajority_implies_passage
#print axioms Federal.contested_passage_needs_majority_of_seats
#print axioms Federal.one_division_cannot_carry_the_senate
#print axioms Federal.one_division_cannot_enact
#print axioms Federal.house_bloc_bounded

/-! ### The roll call at the senators' desk -/

#print axioms Federal.Roll.rollCall_authentic
#print axioms Federal.Roll.rollCall_senator
#print axioms Federal.Roll.rollCall_nodup
#print axioms Federal.Roll.rollCall_first_vote_wins
#print axioms Federal.Roll.bill_must_be_tabled
#print axioms Federal.Roll.rollCall_le_seats
#print axioms Federal.Roll.chamberTally_cast
#print axioms Federal.Roll.passage_needs_quorum_of_ballots
#print axioms Federal.Roll.passage_needs_quorum_of_senators

/-! ### The union, as the dataset has it -/

#print axioms Federal.Union.states_length
#print axioms Federal.Union.state_names_nodup
#print axioms Federal.Union.states_partition_the_roster
#print axioms Federal.Union.total_stake
#print axioms Federal.Union.every_state_has_two_senators
#print axioms Federal.Union.seated_length
#print axioms Federal.Union.seated_nodup
#print axioms Federal.Union.seated_subset_roster
#print axioms Federal.Union.senate_apportionment
#print axioms Federal.Union.house_apportionment
#print axioms Federal.Union.house_total
#print axioms Federal.Union.house_total_general
#print axioms Federal.Union.no_state_has_a_house_majority
#print axioms Federal.Union.no_state_has_a_senate_majority
#print axioms Federal.Union.smallest_state_overrepresented_in_the_senate
#print axioms Federal.Union.congress_can_legislate
#print axioms Federal.Union.no_state_can_carry_the_senate
#print axioms Federal.Union.senate_passage_needs_fourteen_signatures
#print axioms Federal.Union.senate_passage_needs_fourteen_senators
#print axioms Federal.Union.senate_roll_le_26

/-! ### The union against the mint -/

#print axioms Federal.Union.union_raw_stake
#print axioms Federal.Union.raw_apportionment_agrees
#print axioms Federal.Union.rounding_loses_less_than_a_token_per_senator
#print axioms Federal.Union.union_holds_more_than_half_the_supply
#print axioms Federal.Union.union_within_supply
#print axioms Federal.Union.union_share_bounds

end Federal
