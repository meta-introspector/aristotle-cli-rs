/-
# Voting Thresholds — Formal Model

Formalizes the various voting thresholds described in the report for different
Senate actions.

Key thresholds from the report:
- Simple majority: adopt rules changes, sustain/overturn appeals
- Three-fifths of Senators duly chosen and sworn (60/100): invoke cloture generally
- Two-thirds present and voting: invoke cloture on rules changes, suspend rules
- Two-thirds of Senators present: conviction in impeachment trials
- Unanimous consent: waive rules, alter UC agreements
-/

import Mathlib

/-! ## Vote Thresholds -/

/-- The types of Senate actions that require specific vote thresholds. -/
inductive SenateAction where
  | adoptRulesChange       -- Adopt an amendment to standing rules
  | invokeClotureGeneral   -- Invoke cloture generally (post-1975 threshold)
  | invokeClotureOnRules   -- Invoke cloture on proposals to amend standing rules
  | suspendRules           -- Suspend rules under Rule V
  | overrulePresidingOfficer -- Overturn a ruling of the presiding officer
  | waiveRule              -- Waive a rule by unanimous consent
  | alterUCagreement       -- Alter an existing UC agreement
  | convictImpeachment     -- Convict in an impeachment trial
  deriving DecidableEq, Repr

open SenateAction

/-- The threshold type for a Senate vote. -/
inductive VoteThreshold where
  | simpleMajority              -- More than half of those voting
  | threeFifthsSworn            -- 3/5 of Senators duly chosen and sworn (60 of 100)
  | twoThirdsPresentAndVoting   -- 2/3 of Senators present and voting
  | unanimousConsent            -- All Senators present must agree (no objection)
  deriving DecidableEq, Repr, Fintype

open VoteThreshold

/-- The required vote threshold for each Senate action.

From the report:
- "the Senate can decide what rules should govern its procedures ... by majority vote"
- "invoking cloture on proposals to amend the Senate's standing rules requires the
   vote of two-thirds of Senators present and voting"
- "the body can also suspend its rules by a two-thirds vote" (Rule V)
- "the Senate can waive its rules by unanimous consent"
- "A majority of the Senate may also vote against sustaining a point of order"
- UC agreements "can only be altered by unanimous consent"
- Art I, §3: "no Person shall be convicted without the Concurrence of two thirds
   of the Members present" -/
def SenateAction.requiredThreshold : SenateAction → VoteThreshold
  | adoptRulesChange       => simpleMajority
  | invokeClotureGeneral   => threeFifthsSworn
  | invokeClotureOnRules   => twoThirdsPresentAndVoting
  | suspendRules           => twoThirdsPresentAndVoting
  | overrulePresidingOfficer => simpleMajority
  | waiveRule              => unanimousConsent
  | alterUCagreement       => unanimousConsent
  | convictImpeachment     => twoThirdsPresentAndVoting

/-- A numeric ordering of threshold strictness (higher = harder to achieve). -/
def VoteThreshold.strictness : VoteThreshold → ℕ
  | simpleMajority            => 1
  | threeFifthsSworn          => 2
  | twoThirdsPresentAndVoting => 3
  | unanimousConsent          => 4

/-- Unanimous consent is the strictest threshold.
    "it takes only one Senator to object to a UC agreement" -/
theorem unanimousConsent_strictest (t : VoteThreshold) :
    t.strictness ≤ unanimousConsent.strictness := by
  cases t <;> simp [VoteThreshold.strictness]

/-- Invoking cloture on rules changes is strictly harder than invoking cloture generally.
    "invoking cloture on proposals to amend the Senate's standing rules requires the vote
    of two-thirds of Senators present and voting" vs. three-fifths generally. -/
theorem cloture_on_rules_harder_than_general :
    invokeClotureGeneral.requiredThreshold.strictness <
    invokeClotureOnRules.requiredThreshold.strictness := by
  simp [SenateAction.requiredThreshold, VoteThreshold.strictness]

/-- Adopting a rules change by majority vote is easier than invoking cloture on that
    very proposal. This captures the procedural difficulty noted in the report:
    "A simple majority of Senators may vote to amend the standing rules ... However,
    both the measure proposing the rules change and the motion to proceed to consider
    it are debatable and subject to a filibuster." -/
theorem adopt_easier_than_cloture_on_rules :
    adoptRulesChange.requiredThreshold.strictness <
    invokeClotureOnRules.requiredThreshold.strictness := by
  simp [SenateAction.requiredThreshold, VoteThreshold.strictness]

/-- Waiving a rule and altering a UC agreement have the same threshold: unanimous consent. -/
theorem waive_and_alter_uc_same_threshold :
    waiveRule.requiredThreshold = alterUCagreement.requiredThreshold := by
  rfl

/-- Overruling the presiding officer requires only a simple majority.
    "the Senate might then decide, usually by majority vote, to uphold or overturn
    the presiding officer's decision." -/
theorem overrule_is_majority :
    overrulePresidingOfficer.requiredThreshold = simpleMajority := by
  rfl

/-! ## Quorum Requirements

Article I, Section 5: "a Majority of each [House] shall constitute a Quorum
to do Business."
-/

/-- The total number of Senate seats. -/
def totalSenateSeats : ℕ := 100

/-- The quorum requirement: a majority of the full Senate.
    Art. I, §5: "a Majority of each [House] shall constitute a Quorum to do Business" -/
def quorumRequired : ℕ := totalSenateSeats / 2 + 1

theorem quorum_is_51 : quorumRequired = 51 := by rfl

/-- The three-fifths cloture threshold (of Senators duly chosen and sworn). -/
def clotureThreshold : ℕ := 3 * totalSenateSeats / 5

theorem cloture_threshold_is_60 : clotureThreshold = 60 := by rfl

/-- The two-thirds threshold (of full Senate). -/
def twoThirdsThreshold : ℕ := 2 * totalSenateSeats / 3 + 1

theorem two_thirds_threshold_is_67 : twoThirdsThreshold = 67 := by rfl

/-- Cloture requires more votes than a simple quorum. -/
theorem cloture_exceeds_quorum : clotureThreshold > quorumRequired := by
  simp [clotureThreshold, quorumRequired, totalSenateSeats]

/-- Two-thirds exceeds the cloture threshold. -/
theorem two_thirds_exceeds_cloture : twoThirdsThreshold > clotureThreshold := by
  simp [twoThirdsThreshold, clotureThreshold, totalSenateSeats]

/-! ## Yea and Nay Vote Requirement

Art. I, §5: a recorded vote must occur "upon the Desire of one fifth of those Present."
-/

/-- The fraction of Senators present needed to demand a recorded vote. -/
def recordedVoteFraction : ℚ := 1 / 5

theorem recorded_vote_fraction_is_one_fifth : recordedVoteFraction = 1 / 5 := by rfl

/-- Given n Senators present, the number needed to demand a recorded vote. -/
def senatorsNeededForRecordedVote (present : ℕ) : ℕ :=
  (present + 4) / 5  -- ceiling of present / 5

/-- With a full quorum of 51, 11 Senators can demand a recorded vote. -/
theorem recorded_vote_at_quorum :
    senatorsNeededForRecordedVote 51 = 11 := by rfl

/-- With full attendance, 20 Senators can demand a recorded vote. -/
theorem recorded_vote_full_attendance :
    senatorsNeededForRecordedVote 100 = 20 := by rfl

