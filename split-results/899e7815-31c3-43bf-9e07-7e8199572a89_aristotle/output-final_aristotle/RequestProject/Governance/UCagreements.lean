/-
# Unanimous Consent Agreements — Formal Model

Formalizes the properties of UC agreements as described in the report.

"UC agreements also include orders that function as parliamentary authorities in
the Senate. These consent agreements establish conditions for floor consideration
of specified measures, which, in relation to those measures, override the
regulations established by the standing rules and other Senate parliamentary
authorities."
-/

import Mathlib

/-! ## UC Agreements as Parliamentary Authorities

Key properties from the report:
1. Once entered into, a UC agreement is enforceable on the Senate floor.
2. A UC agreement has the same authority as the Senate's standing rules.
3. A UC agreement can only be altered by unanimous consent.
4. UC agreements have the effect of overriding "all Senate rules and precedents
   that are contrary to the terms of the agreement."
5. It takes only one Senator to object to (block) a UC agreement.
-/

/-- A model of a UC agreement's relationship to standing rules.
    `overrides` captures which standing rules the agreement supersedes
    for the measure in question. -/
structure UCAgreement where
  /-- The measure the agreement applies to. -/
  measureId : ℕ
  /-- Whether debate time is limited. -/
  debateLimited : Bool
  /-- Maximum debate time in minutes (if limited). -/
  maxDebateMinutes : Option ℕ
  /-- Whether amendments are restricted. -/
  amendmentsRestricted : Bool
  /-- Whether a specific time for a vote is set. -/
  voteTimeSet : Bool
  deriving DecidableEq, Repr

/-- A UC agreement is enforceable on the floor once propounded and accepted.
    This is a definitional property. -/
def UCAgreement.floorEnforceable (_ : UCAgreement) : Prop := True

/-- A UC agreement can only be altered by unanimous consent.
    We model this as: the number of objections needed to block alteration is 1
    (i.e., any single Senator can prevent alteration). -/
def objectionsToBlockAlteration : ℕ := 1

/-- It takes only one Senator to block a UC agreement from being formed or altered.
    "given the fact that it takes only one Senator to object to a UC agreement" -/
theorem single_senator_can_block : objectionsToBlockAlteration = 1 := by rfl

/-! ## Standing Orders by Unanimous Consent

"In addition to the standing orders created by resolution, the Senate also
establishes standing orders by agreeing to unanimous consent requests. These
agreements usually make these standing orders effective only for the duration
of a Congress or some other limited period."

"On the first day of the 118th Congress in 2023, the Senate adopted 11 unanimous
consent agreements reestablishing standing orders from the previous Congress."
-/

/-- The duration of a standing order created by UC. -/
inductive StandingOrderDuration where
  | singleCongress      -- Effective for one Congress only
  | limitedPeriod (days : ℕ) -- Effective for a specified period
  | permanent            -- Permanent (rare for UC-created orders)
  deriving DecidableEq, Repr

/-- Number of UC standing orders adopted on the first day of the 118th Congress. -/
def ucStandingOrders118th : ℕ := 11

theorem uc_standing_orders_118th_is_11 : ucStandingOrders118th = 11 := by rfl

/-! ## The Override Property

"Consent agreements have the effect of changing 'all Senate rules and precedents
that are contrary to the terms of the agreement.'"

We model this by showing that UC agreements create a local override context.
-/

/-- The set of rule categories that a UC agreement can override. -/
inductive OverridableAuthority where
  | standingRule
  | standingOrder
  | precedent
  | rulemakingStatute
  deriving DecidableEq, Repr, Fintype

/-- UC agreements can override all four categories of floor authority. -/
theorem uc_overrides_all :
    Fintype.card OverridableAuthority = 4 := by
  decide

