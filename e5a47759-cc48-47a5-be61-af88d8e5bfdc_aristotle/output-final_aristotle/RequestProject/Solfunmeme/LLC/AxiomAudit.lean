/-
  AxiomAudit.lean — what the New Jersey company model depends on.

  The entity, the filing calendar, the standing machine, the open-source
  investment criteria and the concrete Introspector LLC simulation.  The
  concrete figures of `Sim.lean` are checked by `decide` (one of them by
  `decide +kernel`, because the well-formedness check runs over strings), so
  the kernel recomputes them.  Nothing here uses `sorry`, `native_decide`, an
  `axiom` declaration or `@[implemented_by]`.
-/

import RequestProject.Solfunmeme.LLC.Sim
import RequestProject.Solfunmeme.LLC.Portfolio

namespace LLC.AxiomAudit

/-! ### `RequestProject/LLC/Date.lean` -/

#print axioms LLC.Date.daysInMonth_le_31
#print axioms LLC.Date.key_inj
#print axioms LLC.Date.le_refl
#print axioms LLC.Date.le_trans
#print axioms LLC.Date.le_total
#print axioms LLC.Date.le_antisymm
#print axioms LLC.Date.daysInMonth_pos
#print axioms LLC.Date.daysInMonth_ge_28
#print axioms LLC.Date.valid_of_day_le_28
#print axioms LLC.Date.lastDay_valid
#print axioms LLC.Date.anniversary_valid
#print axioms LLC.Date.anniversary_zero

/-! ### `RequestProject/LLC/Entity.lean` -/

#print axioms LLC.sumUnits_cons
#print axioms LLC.sumUnits_filter_le
#print axioms LLC.Entity.unitsOf_le_totalUnits
#print axioms LLC.Entity.bps_le_10000
#print axioms LLC.Entity.majority_in_interest_iff
#print axioms LLC.Entity.majority_in_interest_unique
#print axioms LLC.Entity.transfer_of_too_much_is_refused
#print axioms LLC.Entity.transfer_conserves_units
#print axioms LLC.Revenue.revenue_total
#print axioms LLC.Revenue.revenue_monotone
#print axioms LLC.shard_split_is_exact

/-! ### `RequestProject/LLC/Filings.lean` -/

#print axioms LLC.Entity.annual_report_in_anniversary_month
#print axioms LLC.Entity.calendar_dates_valid
#print axioms LLC.Record.run_nil
#print axioms LLC.Record.run_cons
#print axioms LLC.Record.compliant_run_stays_good
#print axioms LLC.Record.one_missed_report_is_delinquent
#print axioms LLC.Record.two_missed_reports_revoke
#print axioms LLC.Record.revoked_needs_reinstatement
#print axioms LLC.Record.reinstatement_needs_back_reports
#print axioms LLC.Record.reinstatement_restores_good_standing
#print axioms LLC.Record.dissolution_needs_clearance
#print axioms LLC.Record.dissolved_is_absorbing
#print axioms LLC.Record.dissolved_run_is_absorbing
#print axioms LLC.Record.fees_are_monotone
#print axioms LLC.Record.fees_only_for_accepted_filings

/-! ### `RequestProject/LLC/Portfolio.lean` -/

#print axioms LLC.Portfolio.disqualified_is_not_eligible
#print axioms LLC.Portfolio.licence_switch_disqualifies
#print axioms LLC.Portfolio.non_free_core_disqualifies
#print axioms LLC.Portfolio.eligible_needs_osi_licence
#print axioms LLC.Portfolio.eligible_needs_non_discrimination
#print axioms LLC.Portfolio.eligible_needs_privacy
#print axioms LLC.Portfolio.eligible_needs_threshold
#print axioms LLC.Portfolio.eligible_iff
#print axioms LLC.Portfolio.fitness_monotone
#print axioms LLC.Portfolio.eligible_monotone_on_scores
#print axioms LLC.Portfolio.proprietary_exception_is_narrow
#print axioms LLC.Portfolio.cloud_exception_is_narrow
#print axioms LLC.Portfolio.eligible_decidable
#print axioms LLC.Portfolio.admit_eligible
#print axioms LLC.Portfolio.admit_subset
#print axioms LLC.Portfolio.admit_excludes_disqualified
#print axioms LLC.Portfolio.criteria_names_match_the_scores

/-! ### `RequestProject/LLC/Sim.lean` -/

#print axioms LLC.Sim.introspector_is_well_formed
#print axioms LLC.Sim.cap_table_totals
#print axioms LLC.Sim.cap_table_contributions
#print axioms LLC.Sim.founder_holds_majority
#print axioms LLC.Sim.founder_holds_6000_bps
#print axioms LLC.Sim.shards_hold_the_rest
#print axioms LLC.Sim.plan_length
#print axioms LLC.Sim.plan_fee_cents
#print axioms LLC.Sim.plan_dates_are_valid
#print axioms LLC.Sim.plan_annual_reports
#print axioms LLC.Sim.plan_public_records
#print axioms LLC.Sim.compliant_plan_ends_in_good_standing
#print axioms LLC.Sim.two_lapses_revoke_the_charter
#print axioms LLC.Sim.back_reports_then_reinstatement
#print axioms LLC.Sim.reinstatement_first_is_refused
#print axioms LLC.Sim.dissolution_needs_clearance_here
#print axioms LLC.Sim.wind_up_dissolves
#print axioms LLC.Sim.quarter_revenue_total
#print axioms LLC.Sim.shard_split_of_the_quarter
#print axioms LLC.Sim.shard_split_is_exact_here

end LLC.AxiomAudit
