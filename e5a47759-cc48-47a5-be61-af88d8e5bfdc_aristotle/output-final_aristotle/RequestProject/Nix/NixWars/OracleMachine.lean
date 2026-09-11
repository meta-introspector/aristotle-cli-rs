import RequestProject.Nix.NixWars.HyperspaceMachine
import RequestProject.Nix.NixWars.Oracle

/-!
# The Provenance Oracle, compiled

The eleventh door goes through the pipeline unchanged: its rules are compiled
into the expression language of `Machine.lean`, and `oracleStepIR_correct`
proves the compiled table computes exactly `oracleStep`. The same compiler then
turns it into WebAssembly with no new code.

The only new shape is a conjunction — a `lift` needs three witnesses *and* room
above it — and a conjunction of two comparisons is one `cond`, so the static
overflow bound is untouched: the guards are still zero or one.
-/

namespace NixWars

/-- The commands of the oracle door, as the page names them. -/
inductive OracleTag
  | witness
  | lift
  | mint
  | audit
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; the oracle takes no numeric argument. -/
def OracleTag.cmd : OracleTag → OracleCmd
  | .witness => .witness
  | .lift => .lift
  | .mint => .mint
  | .audit => .audit

/-- The state vector is `[layer, evidence, seeds, bounty]`. -/
def oracleFieldNames : List String := ["layer", "evidence", "seeds", "bounty"]

/-! ## The compiled desk -/

/-- Conjunction of two guards, each zero or one. -/
def andIR (a b : Expr) : Expr := .cond a b (.lit 0)

theorem eval_andIR (st : List Nat) (v : Nat) (a b : Expr) :
    (andIR a b).eval st v = if a.eval st v ≠ 0 then b.eval st v else 0 := rfl

/-- `a < b`, as an expression. -/
def ltIR (a b : Expr) : Expr := .le (.add a (.lit 1)) b

theorem eval_ltIR (st : List Nat) (v : Nat) (a b : Expr) :
    (ltIR a b).eval st v = if a.eval st v < b.eval st v then 1 else 0 := by
  simp only [ltIR, Expr.eval]
  exact if_congr Nat.lt_iff_add_one_le.symm rfl rfl

/-- Three witnesses are in hand. -/
def hasEvidenceIR : Expr := .le (.lit 3) (.fld 1)

/-- There is a layer left to climb. -/
def canLiftIR : Expr := andIR hasEvidenceIR (ltIR (.fld 0) (.lit 3))

/-- The chain reaches the seed layer and is witnessed. -/
def canMintIR : Expr := andIR hasEvidenceIR (eqIR (.fld 0) (.lit 3))

/-- The compiled transition table of the oracle door. -/
def oracleStepIR : OracleTag → List Expr
  | .witness => [.fld 0, .add (.fld 1) (.lit 1), .fld 2, .fld 3]
  | .lift =>
      [ .cond canLiftIR (.add (.fld 0) (.lit 1)) (.fld 0),
        .cond canLiftIR (.sub (.fld 1) (.lit 3)) (.fld 1),
        .fld 2, .fld 3 ]
  | .mint =>
      [ .cond canMintIR (.lit 0) (.fld 0),
        .cond canMintIR (.sub (.fld 1) (.lit 3)) (.fld 1),
        .cond canMintIR (.add (.fld 2) (.lit 1)) (.fld 2),
        .cond canMintIR (.add (.fld 3) (.lit 59)) (.fld 3) ]
  | .audit => [.fld 0, .fld 1, .fld 2, .fld 3]

/-- **The compiled table is the Provenance Oracle.** -/
theorem oracleStepIR_correct (tag : OracleTag) (s : Provenance) (v : Nat) :
    runIR (oracleStepIR tag) (oracleSerialize s) v
      = oracleSerialize (oracleStep s tag.cmd) := by
  cases tag with
  | witness => simp [runIR, oracleStepIR, Expr.eval, oracleSerialize, oracleStep, OracleTag.cmd]
  | lift =>
      by_cases h : witnessesPerLayer ≤ s.evidence ∧ s.layer < seedLayer
      · obtain ⟨h1, h2⟩ := h
        simp only [witnessesPerLayer] at h1
        simp only [seedLayer] at h2
        simp [runIR, oracleStepIR, canLiftIR, andIR, hasEvidenceIR, eval_ltIR, Expr.eval,
          oracleSerialize, oracleStep, OracleTag.cmd, witnessesPerLayer, seedLayer, h1, h2]
      · have hstep : oracleStep s OracleTag.lift.cmd = s := by
          simp only [OracleTag.cmd, oracleStep, if_neg h]
        rw [hstep]
        simp only [witnessesPerLayer, seedLayer, not_and_or, Nat.not_le, Nat.not_lt] at h
        rcases h with h | h <;>
          simp [runIR, oracleStepIR, canLiftIR, andIR, hasEvidenceIR, eval_ltIR, Expr.eval,
            oracleSerialize, h, Nat.not_le.mpr, Nat.not_lt.mpr]
  | mint =>
      by_cases h : witnessesPerLayer ≤ s.evidence ∧ s.layer = seedLayer
      · obtain ⟨h1, h2⟩ := h
        simp only [witnessesPerLayer] at h1
        simp only [seedLayer] at h2
        simp [runIR, oracleStepIR, canMintIR, andIR, hasEvidenceIR, eqIR, Expr.eval,
          oracleSerialize, oracleStep, OracleTag.cmd, witnessesPerLayer, seedLayer, seedBounty,
          h1, h2]
      · have hstep : oracleStep s OracleTag.mint.cmd = s := by
          simp only [OracleTag.cmd, oracleStep, if_neg h]
        rw [hstep]
        simp only [witnessesPerLayer, seedLayer, not_and_or, Nat.not_le] at h
        rcases h with h | h
        · simp [runIR, oracleStepIR, canMintIR, andIR, hasEvidenceIR, eqIR, Expr.eval,
            oracleSerialize, h, Nat.not_le.mpr]
        · simp only [runIR, oracleStepIR, canMintIR, andIR, hasEvidenceIR, eqIR, Expr.eval,
            oracleSerialize, List.map, List.getD_cons_zero, List.getD_cons_succ]
          simp only [List.cons.injEq, and_true]
          split_ifs <;> omega
  | audit => simp [runIR, oracleStepIR, Expr.eval, oracleSerialize, oracleStep, OracleTag.cmd]

/-- The commands with the names the page uses. -/
def oracleTagsWithNames : List (String × OracleTag) :=
  [("witness", .witness), ("lift", .lift), ("mint", .mint), ("audit", .audit)]

end NixWars
