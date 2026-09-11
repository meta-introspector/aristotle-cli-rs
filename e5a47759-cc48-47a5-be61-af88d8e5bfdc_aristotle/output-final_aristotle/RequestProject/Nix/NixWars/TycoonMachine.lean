import RequestProject.Nix.NixWars.LordMachine
import RequestProject.Nix.NixWars.TournamentMachine
import RequestProject.Nix.NixWars.Tycoon

/-!
# The Combinator Tycoon, compiled

The eighth door goes through the pipeline unchanged: its rules are compiled
into the expression language of `Machine.lean`, and `tycoonStepIR_correct`
proves the compiled table computes exactly `tycoonStep`. The same compiler then
turns it into WebAssembly with no new code.

The only shape the factory needs that the earlier doors did not is the
compression step `min raw forges`, which is `minIR` — one comparison, already
used by Legend of the Red Shard's healing cap.
-/

namespace NixWars

/-- The commands of the tycoon door, as the page names them. -/
inductive TycoonTag
  | mine
  | forge
  | run
  | dump
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; the factory takes no numeric argument. -/
def TycoonTag.cmd : TycoonTag → TycoonCmd
  | .mine => .mine
  | .forge => .forge
  | .run => .run
  | .dump => .dump

/-- The state vector is `[cash, raw, mines, forges, tick]`. -/
def tycoonFieldNames : List String := ["cash", "raw", "mines", "forges", "tick"]

/-! ## The compiled factory -/

/-- What the foundries compress this second: `min raw forges`. -/
def convertedIR : Expr := minIR (.fld 1) (.fld 3)

theorem eval_convertedIR (st : List Nat) (v : Nat) :
    convertedIR.eval st v = min (st.getD 1 0) (st.getD 3 0) := by
  simp [convertedIR, eval_minIR, Expr.eval]

/-- The compiled transition table of the tycoon door. -/
def tycoonStepIR : TycoonTag → List Expr
  | .mine =>
      let afford : Expr := .le (.lit 7) (.fld 0)
      [ .cond afford (.sub (.fld 0) (.lit 7)) (.fld 0),
        .fld 1,
        .cond afford (.add (.fld 2) (.lit 1)) (.fld 2),
        .fld 3,
        .cond afford (.add (.fld 4) (.lit 1)) (.fld 4) ]
  | .forge =>
      let afford : Expr := .le (.lit 11) (.fld 0)
      [ .cond afford (.sub (.fld 0) (.lit 11)) (.fld 0),
        .fld 1,
        .fld 2,
        .cond afford (.add (.fld 3) (.lit 1)) (.fld 3),
        .cond afford (.add (.fld 4) (.lit 1)) (.fld 4) ]
  | .run =>
      [ .add (.fld 0) (.mul (.lit 2) convertedIR),
        .add (.sub (.fld 1) convertedIR) (.fld 2),
        .fld 2,
        .fld 3,
        .add (.fld 4) (.lit 1) ]
  | .dump =>
      [ .add (.fld 0) (.fld 1), .lit 0, .fld 2, .fld 3, .add (.fld 4) (.lit 1) ]

/-- **The compiled table is the Combinator Tycoon.** -/
theorem tycoonStepIR_correct (tag : TycoonTag) (s : Tycoon) (v : Nat) :
    runIR (tycoonStepIR tag) (tycoonSerialize s) v
      = tycoonSerialize (tycoonStep s tag.cmd) := by
  cases tag with
  | mine =>
      by_cases h : mineCost ≤ s.cash
      · have h' : 7 ≤ s.cash := h
        simp [runIR, tycoonStepIR, Expr.eval, tycoonSerialize, tycoonStep, TycoonTag.cmd,
          mineCost, h']
      · have h' : ¬ (7 ≤ s.cash) := h
        simp [runIR, tycoonStepIR, Expr.eval, tycoonSerialize, tycoonStep, TycoonTag.cmd,
          mineCost, h']
  | forge =>
      by_cases h : forgeCost ≤ s.cash
      · have h' : 11 ≤ s.cash := h
        simp [runIR, tycoonStepIR, Expr.eval, tycoonSerialize, tycoonStep, TycoonTag.cmd,
          forgeCost, h']
      · have h' : ¬ (11 ≤ s.cash) := h
        simp [runIR, tycoonStepIR, Expr.eval, tycoonSerialize, tycoonStep, TycoonTag.cmd,
          forgeCost, h']
  | run =>
      simp [runIR, tycoonStepIR, Expr.eval, eval_convertedIR, tycoonSerialize, tycoonStep,
        TycoonTag.cmd, essencePrice]
  | dump =>
      simp [runIR, tycoonStepIR, Expr.eval, tycoonSerialize, tycoonStep, TycoonTag.cmd]

/-- The commands with the names the page uses. -/
def tycoonTagsWithNames : List (String × TycoonTag) :=
  [("mine", .mine), ("forge", .forge), ("run", .run), ("dump", .dump)]

end NixWars
