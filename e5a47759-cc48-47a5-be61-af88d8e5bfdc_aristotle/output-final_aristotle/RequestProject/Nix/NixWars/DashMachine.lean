import RequestProject.Nix.NixWars.Machine
import RequestProject.Nix.NixWars.Dash

/-!
# Monster Dash, compiled

The second door goes through the same pipeline as the first: its rules are
compiled into the expression language of `Machine.lean`, and `dashStepIR_correct`
proves the compiled table computes exactly `dashStep`. It is then compiled to
WebAssembly by exactly the same compiler, with no new code — that is the point
of having one machine for the whole board.

Two things Monster Dash needs and NixWars did not: the modulo `t % 3` that
places the obstacle (built from `mul` and `div`, since the machine has no `mod`),
and an equality test (built from two `≤`s).
-/

namespace NixWars

/-- The commands of Monster Dash, as the page names them. -/
inductive DashTag
  | left
  | right
  | tick
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; Monster Dash takes no numeric argument. -/
def DashTag.cmd : DashTag → DashCmd
  | .left => .left
  | .right => .right
  | .tick => .tick

/-- The state vector is `[lane, score, lives, turn]`. -/
def dashFieldNames : List String := ["lane", "score", "lives", "turn"]

/-- `a = b`, as an expression: `a ≤ b` and `b ≤ a`. -/
def eqIR (a b : Expr) : Expr := .cond (.le a b) (.le b a) (.lit 0)

/-- `a % b`, as an expression: `a - b * (a / b)`. -/
def modIR (a b : Expr) : Expr := .sub a (.mul b (.div a b))

/-- Where the obstacle is on the current turn: `turn % 3`. -/
def obstacleIR : Expr := modIR (.fld 3) (.lit 3)

/-- The compiled transition table of Monster Dash. -/
def dashStepIR : DashTag → List Expr
  | .left => [.sub (.fld 0) (.lit 1), .fld 1, .fld 2, .fld 3]
  | .right =>
      let inc : Expr := .add (.fld 0) (.lit 1)
      [.cond (.le inc (.lit 2)) inc (.lit 2), .fld 1, .fld 2, .fld 3]
  | .tick =>
      let alive : Expr := .le (.lit 1) (.fld 2)
      let hit : Expr := eqIR (.fld 0) obstacleIR
      [ .fld 0,
        .cond alive (.cond hit (.fld 1) (.add (.fld 1) (.lit 1))) (.fld 1),
        .cond alive (.cond hit (.sub (.fld 2) (.lit 1)) (.fld 2)) (.fld 2),
        .cond alive (.add (.fld 3) (.lit 1)) (.fld 3) ]

/-- **The compiled table is Monster Dash.** -/
theorem dashStepIR_correct (tag : DashTag) (s : Dash) (v : Nat) :
    runIR (dashStepIR tag) (dashSerialize s) v = dashSerialize (dashStep s tag.cmd) := by
  cases s with
  | mk lane score lives turn =>
    cases tag with
    | left => simp [runIR, dashStepIR, Expr.eval, dashSerialize, dashStep, DashTag.cmd]
    | right =>
        by_cases h : lane + 1 ≤ 2
        · simp [runIR, dashStepIR, Expr.eval, dashSerialize, dashStep, DashTag.cmd, h]
        · simp [runIR, dashStepIR, Expr.eval, dashSerialize, dashStep, DashTag.cmd, h]
          omega
    | tick =>
        simp only [runIR, dashStepIR, eqIR, modIR, obstacleIR, Expr.eval, dashSerialize,
          dashStep, DashTag.cmd, obstacleLane, List.map, List.getD_cons_zero,
          List.getD_cons_succ]
        split_ifs <;> simp_all <;> omega

/-- The commands with the names the page uses. -/
def dashTagsWithNames : List (String × DashTag) :=
  [("left", .left), ("right", .right), ("tick", .tick)]

end NixWars
