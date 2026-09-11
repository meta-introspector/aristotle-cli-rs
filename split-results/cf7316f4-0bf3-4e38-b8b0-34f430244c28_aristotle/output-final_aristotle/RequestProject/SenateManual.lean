/-
# Senate Manual Structure — Formal Model

Formalizes the structure and contents of the Senate Manual (S.Doc. 117-1),
as described in the report. The Manual compiles the chief official parliamentary
authorities in a single document.
-/

import Mathlib

/-! ## Components of the Senate Manual

The current edition (117th Congress) contains the following components,
as listed in the report under "The Senate Manual and Authorities It Contains":
-/

/-- The components of the Senate Manual as enumerated in the report. -/
inductive ManualComponent where
  | standingRules              -- "Standing Rules of the Senate"
  | standingOrders             -- "Select Standing Orders not embraced in the Rules"
  | chamberRegulations         -- "United States Senate Chamber and Gallery Regulations"
  | impeachmentRules           -- "Rules for Impeachment Trials"
  | cleavesManual              -- "Cleaves' Manual ... in Regard to Conferences"
  | legislativeProcedures      -- "Select Legislative Procedures Enacted in Law"
  | constitution               -- "Constitution of the United States"
  deriving DecidableEq, Repr, Fintype

open ManualComponent

/-- The Senate Manual contains exactly 7 major components. -/
theorem manual_has_seven_components :
    Fintype.card ManualComponent = 7 := by
  decide

/-! ## Section Numbering

"Individual provisions of each procedural authority are assigned section numbers
that run throughout the Manual in a single sequence and always appear in bold type.
The section numbers assigned to the standing rules correspond to the numbers of
the rules themselves. For example, paragraph 2 of Senate Rule XXII, which sets
forth the cloture rule, is found at section 22.2 of the Manual."
-/

/-- A section reference in the Senate Manual.
    The report notes that sections use a dotted notation (e.g., §22.2). -/
structure ManualSection where
  rule : ℕ       -- Rule number (e.g., 22 for Rule XXII)
  paragraph : ℕ  -- Paragraph within the rule (e.g., 2)
  deriving DecidableEq, Repr

/-- The cloture rule is at Manual §22.2. -/
def clotureSection : ManualSection := ⟨22, 2⟩

/-- Standing orders are compiled in Manual §§60-138. -/
def standingOrderSectionRange : Set ℕ := Set.Icc 60 138

/-- There are 79 sections allocated to standing orders (60 through 138 inclusive). -/
theorem standing_order_sections_count :
    Finset.card (Finset.Icc 60 138) = 79 := by decide

/-! ## Standing Rules

"At the start of the 118th Congress, there were 44 standing rules of the Senate."
-/

/-- The number of standing rules at the start of the 118th Congress. -/
def numStandingRules118th : ℕ := 44

/-- There are exactly 44 standing rules. -/
theorem num_standing_rules : numStandingRules118th = 44 := by rfl

/-! ## Continuing Body Principle

"The Senate does not readopt its standing rules at the beginning of each new Congress
but instead regards its rules as continuing in effect without need for readoption."

"The Senate is a continuing body; only one-third of its membership enters on new
terms of office after every biennial election, so a quorum is continuous.
This principle is embodied in paragraph 2 of Senate Rule V."
-/

/-- The fraction of Senators whose terms begin each Congress. -/
def fractionNewTerms : ℚ := 1 / 3

/-- The fraction of continuing Senators (who do NOT enter on new terms). -/
def fractionContinuing : ℚ := 1 - fractionNewTerms

/-- The continuing fraction is 2/3, ensuring a quorum persists. -/
theorem continuing_fraction_is_two_thirds :
    fractionContinuing = 2 / 3 := by
  simp [fractionContinuing, fractionNewTerms]
  ring

/-- Since 2/3 > 1/2, a quorum of the full Senate continues across Congresses,
    justifying the continuing body principle (Rule V, ¶2). -/
theorem continuing_exceeds_quorum_fraction :
    fractionContinuing > (1 : ℚ) / 2 := by
  simp [fractionContinuing, fractionNewTerms]
  norm_num

/-! ## Key Manual References

The report mentions several specific Manual section references. -/

/-- The motion to adjourn is covered in Manual §§6.4, 9, and 22.1. -/
def adjournmentSections : List ManualSection :=
  [⟨6, 4⟩, ⟨9, 0⟩, ⟨22, 1⟩]

/-- Rule XXXIII authorizes the Rules Committee to make regulations for the Senate wing.
    Manual §33. -/
def ruleXXXIII_section : ManualSection := ⟨33, 0⟩

/-- Rule XXVI, ¶2 requires committees to adopt written rules and publish them in the
    Congressional Record not later than March 1 of the first session. Manual §26.2. -/
def committeeRulesDeadline_section : ManualSection := ⟨26, 2⟩

