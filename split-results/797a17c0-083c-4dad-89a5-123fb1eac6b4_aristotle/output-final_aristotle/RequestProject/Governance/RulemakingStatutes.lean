/-
# Rulemaking Statutes — Formal Model

Formalizes the three categories of rulemaking statutes described in the report,
and their relationship to the Senate's constitutional rulemaking authority.

"Given that these procedures are created through an exercise of each chamber's
constitutional rulemaking authority, they have the same standing as Senate and
House rules."
-/

import Mathlib

/-! ## Categories of Rulemaking Statutes

"In the Senate, statutory rulemaking provisions are principally of three kinds:
(1) those derived from Legislative Reorganization Acts,
(2) those establishing expedited procedures for consideration of specific
    classes of measures, and
(3) those derived from the Congressional Budget Act and related statutes
    governing the budget process."
-/

/-- The three principal categories of rulemaking statutes. -/
inductive RulemakingCategory where
  | legislativeReorganization  -- Legislative Reorganization Acts (1946, 1970)
  | expeditedProcedures        -- "Fast track" provisions
  | budgetProcess              -- Congressional Budget Act and related statutes
  deriving DecidableEq, Repr, Fintype

/-- There are exactly 3 principal categories. -/
theorem three_rulemaking_categories :
    Fintype.card RulemakingCategory = 3 := by
  decide

/-! ## Key Budget Process Statutes -/

/-- The year of the Congressional Budget and Impoundment Control Act. -/
def budgetActYear : ℕ := 1974

/-- The Legislative Reorganization Act years. -/
def lraYears : List ℕ := [1946, 1970]

/-- Both LRA years are in the 20th century. -/
theorem lra_years_20th_century : ∀ y ∈ lraYears, 1900 ≤ y ∧ y < 2000 := by
  intro y hy
  simp [lraYears] at hy
  rcases hy with rfl | rfl <;> omega

/-! ## Exercise of Rulemaking Power Clause

"A statute or concurrent resolution that contains 'rulemaking provisions' ...
often incorporates a section titled 'Exercise of Rulemaking Power.' This section
asserts the rulemaking authority of each chamber and declares that the pertinent
provisions 'shall be considered as part of the rules of each House' and are subject
to being changed 'in the same manner ... as in the case of any other rule of
such House.'"
-/

/-- A rulemaking statute's procedural status. -/
structure RulemakingStatute where
  /-- The statute is "considered as part of the rules." -/
  partOfRules : Prop
  /-- The statute can be changed by simple resolution (same as any other rule). -/
  changeableByResolution : Prop
  /-- The statute has the same standing as standing rules. -/
  sameStandingAsRules : Prop

/-- Rulemaking statutes with the "Exercise of Rulemaking Power" clause satisfy
    all three properties. -/
def withRulemakingClause : RulemakingStatute where
  partOfRules := True
  changeableByResolution := True
  sameStandingAsRules := True

/-! ## Budget Resolutions as Procedural Sources

"A budget resolution may include language providing for supplementary procedural
regulations which govern subsequent action on spending bills or other budget-related
measures."
-/

/-- The scope of procedural provisions in budget resolutions. -/
inductive BudgetResolutionScope where
  | definedTimePeriod    -- Applicable only for a specified time
  | permanent            -- Permanent until altered by further action
  deriving DecidableEq, Repr

/-- PAYGO procedures were first established in 1993.
    "beginning in 1993, Congress has adopted several budget resolutions that have
    established or modified 'pay-as-you-go' (PAYGO) procedures" -/
def paygoFirstYear : ℕ := 1993

theorem paygo_first_year_is_1993 : paygoFirstYear = 1993 := by rfl

/-! ## Congressional Review Act

"A well-known example includes the Congressional Review Act, which provides for
special procedures Congress can use to overturn a rule issued by a federal agency." -/

/-- The CRA is an example of expedited procedures. -/
def craIsExpedited : RulemakingCategory := .expeditedProcedures

