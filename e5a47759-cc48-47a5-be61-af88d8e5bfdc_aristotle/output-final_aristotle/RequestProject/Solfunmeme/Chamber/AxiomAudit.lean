/-
  AxiomAudit.lean — what the new chamber's results depend on.

  The chamber of `RequestProject/Chamber/` replaces the old senate model.  Its
  roster is read off the badge claims, so the concrete facts (100 seats, the
  rotation classes, the quorum, the stake behind it) are checked by `decide`
  and the kernel recomputes them from the dataset's own tables.  Nothing here
  uses `sorry`, `native_decide`, an `axiom` declaration or `@[implemented_by]`.
-/

import RequestProject.Solfunmeme.Chamber.Model
import RequestProject.Solfunmeme.Chamber.Roster
import RequestProject.Solfunmeme.Chamber.Supersede

namespace Chamber.AxiomAudit

/-! ### `RequestProject/Chamber/Model.lean` -/

#print axioms Chamber.Roll.seated_iff
#print axioms Chamber.cast_length_le
#print axioms Chamber.present_le_size
#print axioms Chamber.tally_total
#print axioms Chamber.ayes_add_nays_le_size
#print axioms Chamber.outsider_ballot_ignored
#print axioms Chamber.duplicate_ballot_ignored
#print axioms Chamber.stuffing_changes_nothing
#print axioms Chamber.cast_unanimous
#print axioms Chamber.present_unanimous
#print axioms Chamber.ayes_unanimous
#print axioms Chamber.nays_unanimous
#print axioms Chamber.quorum_attainable
#print axioms Chamber.unanimous_carries
#print axioms Chamber.two_thirds_implies_simple
#print axioms Chamber.three_quarters_implies_two_thirds
#print axioms Chamber.proxy_never_overrides
#print axioms Chamber.self_proxy_adds_nothing
#print axioms Chamber.silent_agent_adds_nothing
#print axioms Chamber.proxy_present_monotone
#print axioms Chamber.retained_add_turningOver
#print axioms Chamber.rotate_size
#print axioms Chamber.rotate_retains_other_classes
#print axioms Chamber.rotate_continuity

/-! ### `RequestProject/Chamber/Roster.lean` -/

#print axioms Chamber.Seated.chamber_size
#print axioms Chamber.Seated.chamber_holders_nodup
#print axioms Chamber.Seated.chamber_holders_are_senators
#print axioms Chamber.Seated.class_sizes
#print axioms Chamber.Seated.classes_cover
#print axioms Chamber.Seated.rotation_retains_two_thirds
#print axioms Chamber.Seated.chamber_quorum
#print axioms Chamber.Seated.chamber_can_act
#print axioms Chamber.Seated.chamber_stake

/-! ### `RequestProject/Chamber/Supersede.lean` -/

#print axioms Chamber.Seated.old_rule_kills_every_vote
#print axioms Chamber.Seated.new_rule_is_live
#print axioms Chamber.Seated.replacement_is_not_vacuous

end Chamber.AxiomAudit
