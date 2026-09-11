/-
# Committee Rules — Formal Model

Formalizes the committee rules system described in the report.

"Rule XXVI, paragraph 2, of the Senate's standing rules requires that each
standing committee adopt written rules of procedure and publish these rules in
the Congressional Record not later than March 1 of the first session of each Congress."
-/

import Mathlib

/-! ## Committee Rules Requirements

Key properties from the report:
1. Each standing committee must adopt written rules of procedure.
2. Rules must be published in the Congressional Record by March 1.
3. Committee rules cover proxy voting, quorum requirements, report preparation.
4. Subcommittees may have supplemental rules.
5. Committees enforce their own rules (no floor points of order).
6. Committee rules cannot supersede standing rules of the Senate.
-/

/-- Topics that committee rules typically cover, as listed in the report.
    "Committee rules cover important aspects of the committee stage of the legislative
    process, such as the procedures for preparing committee reports, proxy voting,
    and quorum requirements." -/
inductive CommitteeRuleTopic where
  | reportPreparation   -- Procedures for preparing committee reports
  | proxyVoting         -- Rules on proxy voting
  | quorumRequirements  -- Quorum requirements for committee business
  | subcommitteeRules   -- Supplemental rules for subcommittees
  deriving DecidableEq, Repr

/-- Properties of the committee rules system. -/
structure CommitteeRulesSystem where
  /-- Each standing committee must adopt rules. -/
  adoptionRequired : Prop
  /-- Publication deadline: March 1 of the first session. -/
  publicationDeadlineMarch1 : Prop
  /-- Enforcement is internal to the committee. -/
  internalEnforcement : Prop
  /-- Cannot supersede standing rules. -/
  cannotSupersedeStandingRules : Prop
  /-- No floor points of order on committee rules. -/
  noFloorPointsOfOrder : Prop

/-- The actual committee rules system as described in the report. -/
def senateCommitteeRulesSystem : CommitteeRulesSystem where
  adoptionRequired := True
  publicationDeadlineMarch1 := True
  internalEnforcement := True
  cannotSupersedeStandingRules := True
  noFloorPointsOfOrder := True

/-- The exception for committees established on or after February 1:
    "the March 1 deadline does not apply to committees established on or after
    February 1. Such committees must publish their rules of procedure not later
    than 60 days after being established." -/
def lateCommitteeDeadlineDays : ℕ := 60

theorem late_committee_deadline_is_60 : lateCommitteeDeadlineDays = 60 := by rfl

/-! ## Publication Venues for Committee Rules

"Each committee's rules appear in the Congressional Record on the day they are
submitted for publication. Some committees also publish their rules in a committee
print or in the committee's interim or final 'Legislative Calendar' and many post
them on the committee websites." -/

/-- Where committee rules may be published. -/
inductive CommitteeRulesVenue where
  | congressionalRecord   -- Required: published in the Record
  | committeePrint         -- Optional: some committees
  | legislativeCalendar    -- Optional: some committees
  | committeeWebsite       -- Optional: many committees
  | authorityAndRules      -- Compiled by Rules and Administration Committee
  deriving DecidableEq, Repr, Fintype

/-- There are 5 publication venues. -/
theorem num_publication_venues :
    Fintype.card CommitteeRulesVenue = 5 := by
  decide

/-- The Congressional Record is the mandatory venue. -/
def CommitteeRulesVenue.mandatory : CommitteeRulesVenue → Prop
  | .congressionalRecord => True
  | _ => False

instance (v : CommitteeRulesVenue) : Decidable v.mandatory := by
  cases v <;> simp [CommitteeRulesVenue.mandatory] <;> infer_instance

/-- Only the Congressional Record is mandatory for publication. -/
theorem only_record_mandatory :
    ∀ v : CommitteeRulesVenue, v.mandatory ↔ v = .congressionalRecord := by
  intro v; cases v <;> simp [CommitteeRulesVenue.mandatory]

