/-
# Priority Recognition — Formal Model

Formalizes the recognition priority system described in the report.

Standing Rule XIX provides: "the presiding officer shall recognize the Senator
who shall first address him." However, by precedent, "priority of recognition
shall be accorded to the majority leader and minority leader, the majority
manager and minority manager, in that order." (Riddick's Senate Procedure, p. 1098)
-/

import Mathlib

/-! ## Senator Roles and Recognition Priority -/

/-- The roles relevant to recognition priority on the Senate floor.
    The report describes the priority order:
    1. Majority Leader
    2. Minority Leader
    3. Majority Manager (of the bill under consideration)
    4. Minority Manager
    5. Other Senators (recognized in order of seeking recognition per Rule XIX) -/
inductive SenatorRole where
  | majorityLeader
  | minorityLeader
  | majorityManager
  | minorityManager
  | other (id : ℕ)  -- regular Senators, distinguished by an ID
  deriving DecidableEq, Repr

open SenatorRole

/-- Recognition priority rank (lower number = higher priority).
    Based on Riddick's Senate Procedure p. 1098:
    "priority of recognition shall be accorded to the majority leader and
    minority leader, the majority manager and minority manager, in that order." -/
def SenatorRole.priorityRank : SenatorRole → ℕ
  | majorityLeader  => 1
  | minorityLeader  => 2
  | majorityManager => 3
  | minorityManager => 4
  | other _         => 5

/-- The majority leader has the highest recognition priority (rank 1). -/
theorem majorityLeader_highest_priority :
    majorityLeader.priorityRank = 1 := by
  rfl

/-- The majority leader is recognized before the minority leader.
    "when several Senators seek recognition at the same time, the majority leader
    is recognized first, followed by the minority leader." -/
theorem majorityLeader_before_minorityLeader :
    majorityLeader.priorityRank < minorityLeader.priorityRank := by
  simp [SenatorRole.priorityRank]

/-- The minority leader is recognized before the majority manager. -/
theorem minorityLeader_before_majorityManager :
    minorityLeader.priorityRank < majorityManager.priorityRank := by
  simp [SenatorRole.priorityRank]

/-- The majority manager is recognized before the minority manager. -/
theorem majorityManager_before_minorityManager :
    majorityManager.priorityRank < minorityManager.priorityRank := by
  simp [SenatorRole.priorityRank]

/-- The minority manager is recognized before other Senators. -/
theorem minorityManager_before_other (id : ℕ) :
    minorityManager.priorityRank < (other id).priorityRank := by
  simp [SenatorRole.priorityRank]

/-- The full priority chain: majority leader has strictly higher priority than
    any other role. -/
theorem majorityLeader_before_all (r : SenatorRole) (h : r ≠ majorityLeader) :
    majorityLeader.priorityRank < r.priorityRank := by
  cases r <;> simp_all [SenatorRole.priorityRank]

/-- All "other" Senators have equal priority rank among themselves. -/
theorem other_senators_equal_priority (i j : ℕ) :
    (other i).priorityRank = (other j).priorityRank := by
  rfl

/-! ## Recognition as a Function

We model the recognition decision: given a set of Senators seeking recognition,
the one with the lowest priority rank is recognized first. -/

/-- Given a nonempty list of Senators seeking recognition, return the one
    with the highest priority (lowest rank). Ties among `other` Senators
    are broken by list order (modeling "first to address the chair"). -/
def recognizeFirst : List SenatorRole → Option SenatorRole
  | [] => none
  | [r] => some r
  | r :: rs =>
    match recognizeFirst rs with
    | none => some r
    | some r' => if r.priorityRank ≤ r'.priorityRank then some r else some r'

/-
If the majority leader is seeking recognition, they are always recognized.
    This formalizes the key precedent from the report.
-/
theorem majorityLeader_always_recognized (rs : List SenatorRole)
    (h : majorityLeader ∈ rs) (hne : rs ≠ []) :
    ∃ r, recognizeFirst rs = some r ∧ r.priorityRank ≤ majorityLeader.priorityRank := by
  induction rs <;> simp_all +decide;
  rename_i k l ih;
  by_cases hl : l = [];
  · aesop;
  · rcases h with ( rfl | h ) <;> simp_all +decide [ recognizeFirst ];
    · cases h : recognizeFirst l <;> simp_all +decide [majorityLeader_highest_priority];
      split_ifs <;> simp_all +decide;
    · obtain ⟨ r, hr₁, hr₂ ⟩ := ih; use if k.priorityRank ≤ r.priorityRank then k else r; split_ifs <;> simp_all +decide ;
      exact le_trans ‹_› hr₂