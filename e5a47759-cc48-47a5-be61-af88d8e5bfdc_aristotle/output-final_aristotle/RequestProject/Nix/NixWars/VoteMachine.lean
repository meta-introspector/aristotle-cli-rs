import RequestProject.Nix.NixWars.OracleMachine
import RequestProject.Nix.NixWars.Vote

/-!
# The Assembly, compiled

The twelfth door goes through the pipeline unchanged: its rules are compiled
into the expression language of `Machine.lean`, and `ballotStepIR_correct`
proves the compiled table computes exactly `ballotStep`. The same compiler then
turns it into WebAssembly with no new code.

The floor needs nothing the earlier doors did not: one strict comparison for
"there are still nodes that have not voted" and one for the quorum.
-/

namespace NixWars

/-- The commands of the assembly door, as the page names them. -/
inductive VoteTag
  | aye
  | nay
  | tally
  | next
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; the floor takes no numeric argument. -/
def VoteTag.cmd : VoteTag → VoteCmd
  | .aye => .aye
  | .nay => .nay
  | .tally => .tally
  | .next => .next

/-- The state vector is `[ayes, nays, round, passed]`. -/
def voteFieldNames : List String := ["ayes", "nays", "round", "passed"]

/-! ## The compiled floor -/

/-- Some node has not voted yet. -/
def hasVoterIR : Expr := ltIR (.add (.fld 0) (.fld 1)) (.lit 23)

/-- The ayes have a quorum. -/
def hasQuorumIR : Expr := .le (.lit 12) (.fld 0)

/-- The compiled transition table of the assembly door. -/
def ballotStepIR : VoteTag → List Expr
  | .aye => [ .cond hasVoterIR (.add (.fld 0) (.lit 1)) (.fld 0), .fld 1, .fld 2, .fld 3 ]
  | .nay => [ .fld 0, .cond hasVoterIR (.add (.fld 1) (.lit 1)) (.fld 1), .fld 2, .fld 3 ]
  | .tally => [ .fld 0, .fld 1, .fld 2, .cond hasQuorumIR (.lit 1) (.fld 3) ]
  | .next => [ .lit 0, .lit 0, .add (.fld 2) (.lit 1), .lit 0 ]

/-- **The compiled table is the Assembly.** -/
theorem ballotStepIR_correct (tag : VoteTag) (s : Ballot) (v : Nat) :
    runIR (ballotStepIR tag) (ballotSerialize s) v
      = ballotSerialize (ballotStep s tag.cmd) := by
  cases tag with
  | aye =>
      by_cases h : s.ayes + s.nays < paxosNodes
      · simp only [paxosNodes] at h
        simp [runIR, ballotStepIR, hasVoterIR, eval_ltIR, Expr.eval, ballotSerialize,
          ballotStep, VoteTag.cmd, paxosNodes, h]
      · simp only [paxosNodes, Nat.not_lt] at h
        simp [runIR, ballotStepIR, hasVoterIR, eval_ltIR, Expr.eval, ballotSerialize,
          ballotStep, VoteTag.cmd, paxosNodes, Nat.not_lt.mpr h]
  | nay =>
      by_cases h : s.ayes + s.nays < paxosNodes
      · simp only [paxosNodes] at h
        simp [runIR, ballotStepIR, hasVoterIR, eval_ltIR, Expr.eval, ballotSerialize,
          ballotStep, VoteTag.cmd, paxosNodes, h]
      · simp only [paxosNodes, Nat.not_lt] at h
        simp [runIR, ballotStepIR, hasVoterIR, eval_ltIR, Expr.eval, ballotSerialize,
          ballotStep, VoteTag.cmd, paxosNodes, Nat.not_lt.mpr h]
  | tally =>
      by_cases h : paxosQuorum ≤ s.ayes
      · simp only [paxosQuorum] at h
        simp [runIR, ballotStepIR, hasQuorumIR, Expr.eval, ballotSerialize, ballotStep,
          VoteTag.cmd, paxosQuorum, h]
      · simp only [paxosQuorum, Nat.not_le] at h
        simp [runIR, ballotStepIR, hasQuorumIR, Expr.eval, ballotSerialize, ballotStep,
          VoteTag.cmd, paxosQuorum, Nat.not_le.mpr h]
  | next =>
      simp [runIR, ballotStepIR, Expr.eval, ballotSerialize, ballotStep, VoteTag.cmd]

/-- The commands with the names the page uses. -/
def voteTagsWithNames : List (String × VoteTag) :=
  [("aye", .aye), ("nay", .nay), ("tally", .tally), ("next", .next)]

end NixWars
