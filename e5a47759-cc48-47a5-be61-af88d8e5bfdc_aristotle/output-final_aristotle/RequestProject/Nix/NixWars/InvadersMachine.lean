import RequestProject.Nix.NixWars.QbertMachine
import RequestProject.Nix.NixWars.Invaders

/-!
# Shard Invaders, compiled

The fifteenth door goes through the pipeline unchanged: its rules are compiled
into the expression language of `Machine.lean`, and `invadersStepIR_correct`
proves the compiled table computes exactly `invadersStep`. The same compiler
then turns it into WebAssembly with no new code.

Every field is written as "if the rank has landed, leave it alone; otherwise …",
which is exactly how `invadersStep` is written, so the two line up field by
field.
-/

namespace NixWars

/-- The four controls, as the page names them. -/
inductive InvadersTag
  | left
  | right
  | fire
  | tick
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a control; Shard Invaders takes no numeric argument. -/
def InvadersTag.cmd : InvadersTag → InvadersCmd
  | .left => .left
  | .right => .right
  | .fire => .fire
  | .tick => .tick

/-- The state vector is `[px, ox, dir, dy, a0 … a4, turn]`. -/
def invadersFieldNames : List String :=
  ["px", "ox", "dir", "dy", "a0", "a1", "a2", "a3", "a4", "turn"]

/-! ## The compiled cabinet -/

/-- The rank has landed. -/
def invLandedIR : Expr := eqIR (.fld 3) (.lit 5)

/-- Field `i`, held frozen once the rank has landed. -/
def invGuard (i : Nat) (e : Expr) : Expr := .cond invLandedIR (.fld i) e

/-- Invader `j` is shot down when the gun stands under it. -/
def invKill (j : Nat) : Expr :=
  invGuard (4 + j) (.cond (eqIR (.add (.fld 1) (.lit j)) (.fld 0)) (.lit 0) (.fld (4 + j)))

/-- The rank is sliding right. -/
def invRightIR : Expr := eqIR (.fld 2) (.lit 0)

/-- There is room to slide right. -/
def invRoomRightIR : Expr := ltIR (.fld 1) (.lit 3)

/-- There is room to slide left. -/
def invRoomLeftIR : Expr := ltIR (.lit 0) (.fld 1)

/-- The compiled transition table of Shard Invaders. -/
def invadersStepIR : InvadersTag → List Expr
  | .left =>
      [ invGuard 0 (.sub (.fld 0) (.lit 1)), .fld 1, .fld 2, .fld 3,
        .fld 4, .fld 5, .fld 6, .fld 7, .fld 8,
        invGuard 9 (.add (.fld 9) (.lit 1)) ]
  | .right =>
      [ invGuard 0 (.cond (ltIR (.fld 0) (.lit 7)) (.add (.fld 0) (.lit 1)) (.fld 0)),
        .fld 1, .fld 2, .fld 3, .fld 4, .fld 5, .fld 6, .fld 7, .fld 8,
        invGuard 9 (.add (.fld 9) (.lit 1)) ]
  | .fire =>
      [ .fld 0, .fld 1, .fld 2, .fld 3,
        invKill 0, invKill 1, invKill 2, invKill 3, invKill 4,
        invGuard 9 (.add (.fld 9) (.lit 1)) ]
  | .tick =>
      [ .fld 0,
        invGuard 1 (.cond invRightIR
          (.cond invRoomRightIR (.add (.fld 1) (.lit 1)) (.fld 1))
          (.cond invRoomLeftIR (.sub (.fld 1) (.lit 1)) (.fld 1))),
        invGuard 2 (.cond invRightIR
          (.cond invRoomRightIR (.lit 0) (.lit 1))
          (.cond invRoomLeftIR (.lit 1) (.lit 0))),
        invGuard 3 (.cond invRightIR
          (.cond invRoomRightIR (.fld 3) (.add (.fld 3) (.lit 1)))
          (.cond invRoomLeftIR (.fld 3) (.add (.fld 3) (.lit 1)))),
        .fld 4, .fld 5, .fld 6, .fld 7, .fld 8,
        invGuard 9 (.add (.fld 9) (.lit 1)) ]

/-- **The compiled table is Shard Invaders.** -/
theorem invadersStepIR_correct (tag : InvadersTag) (s : Invaders) (v : Nat) :
    runIR (invadersStepIR tag) (invadersSerialize s) v
      = invadersSerialize (invadersStep s tag.cmd) := by
  by_cases hy : s.dy = 5
  · cases tag <;>
      simp [runIR, invadersStepIR, invGuard, invKill, invLandedIR, Expr.eval, eval_eqIR,
        invadersSerialize, invadersStep, InvadersTag.cmd, hy]
  · cases tag <;>
      simp [runIR, invadersStepIR, invGuard, invKill, invLandedIR, invRightIR,
        invRoomRightIR, invRoomLeftIR, Expr.eval, eval_eqIR, eval_ltIR,
        invadersSerialize, invadersStep, InvadersTag.cmd, invadersFire, invadersTick, hy]
    all_goals split_ifs <;> simp_all

/-- The commands with the names the page uses. -/
def invadersTagsWithNames : List (String × InvadersTag) :=
  [("left", .left), ("right", .right), ("fire", .fire), ("tick", .tick)]

end NixWars
