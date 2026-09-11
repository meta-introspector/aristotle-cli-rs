import RequestProject.Nix.NixWars.Machine
import RequestProject.Nix.NixWars.Lord

/-!
# Legend of the Red Shard, compiled

The fourth door goes through the same pipeline as the first three: its rules
are compiled into the expression language of `Machine.lean`, and
`lordStepIR_correct` proves the compiled table computes exactly `lordStep`. It
is then compiled to WebAssembly by the same compiler, with no new code.

The only care needed is with the operating bound: the widest term in the table
is `gold + 2 · level`, and `3 · B` still fits in an `i32`.
-/

namespace NixWars

/-- The commands of the combat door, as the page names them. -/
inductive LordTag
  | attack
  | heal
  | flee
  | rest
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; the door takes no numeric argument. -/
def LordTag.cmd : LordTag → LordCmd
  | .attack => .attack
  | .heal => .heal
  | .flee => .flee
  | .rest => .rest

/-- The state vector is `[hp, gold, level, foe, turn]`. -/
def lordFieldNames : List String := ["hp", "gold", "level", "foe", "turn"]

/-- `min a b`, as an expression. -/
def minIR (a b : Expr) : Expr := .cond (.le a b) a b

theorem eval_minIR (st : List Nat) (v : Nat) (a b : Expr) :
    (minIR a b).eval st v = min (a.eval st v) (b.eval st v) := by
  simp only [minIR, Expr.eval]
  split_ifs with h₁ h₂ <;> omega

/-- The hero is alive: `1 ≤ hp`. -/
def lordAliveIR : Expr := .le (.lit 1) (.fld 0)

/-- The champion is down: `foe ≤ level`. -/
def lordWinIR : Expr := .le (.fld 3) (.fld 2)

/-- Run `prog` only when `c` is nonzero, keeping the five fields otherwise. -/
def lordGuard (c : Expr) (prog : List Expr) : List Expr :=
  List.zipWith (fun e i => Expr.cond c e (Expr.fld i)) prog [0, 1, 2, 3, 4]

/-- The compiled transition table of Legend of the Red Shard. -/
def lordStepIR : LordTag → List Expr
  | .attack =>
      lordGuard lordAliveIR
        [ .cond lordWinIR (.fld 0) (.sub (.fld 0) (.lit 1)),
          .cond lordWinIR (.add (.fld 1) (.mul (.lit 2) (.fld 2))) (.fld 1),
          .cond lordWinIR (.add (.fld 2) (.lit 1)) (.fld 2),
          .cond lordWinIR (.add (.mul (.lit 3) (.add (.fld 2) (.lit 1))) (.lit 2))
            (.sub (.fld 3) (.fld 2)),
          .add (.fld 4) (.lit 1) ]
  | .heal =>
      lordGuard (.cond lordAliveIR (.le (.lit 10) (.fld 1)) (.lit 0))
        [ minIR (.lit 59) (.add (.fld 0) (.lit 7)),
          .sub (.fld 1) (.lit 10),
          .fld 2,
          .fld 3,
          .add (.fld 4) (.lit 1) ]
  | .flee =>
      lordGuard lordAliveIR
        [ .fld 0,
          .fld 1,
          .fld 2,
          .add (.mul (.lit 3) (.fld 2)) (.lit 2),
          .add (.fld 4) (.lit 1) ]
  | .rest =>
      lordGuard lordAliveIR
        [ minIR (.lit 59) (.add (.fld 0) (.lit 1)),
          .fld 1,
          .fld 2,
          .fld 3,
          .add (.fld 4) (.lit 1) ]

/-- **The compiled table is Legend of the Red Shard.** -/
theorem lordStepIR_correct (tag : LordTag) (s : Hero) (v : Nat) :
    runIR (lordStepIR tag) (lordSerialize s) v = lordSerialize (lordStep s tag.cmd) := by
  cases s with
  | mk hp gold level foe turn =>
    cases tag with
    | attack =>
        by_cases h0 : hp = 0
        · subst h0
          simp [runIR, lordStepIR, lordGuard, lordAliveIR, lordWinIR, Expr.eval,
            lordSerialize, lordStep, LordTag.cmd]
        · by_cases hw : foe ≤ level <;>
            simp [runIR, lordStepIR, lordGuard, lordAliveIR, lordWinIR, Expr.eval,
              lordSerialize, lordStep, LordTag.cmd, foeHp, h0, hw,
              Nat.one_le_iff_ne_zero]
    | heal =>
        by_cases h0 : hp = 0
        · subst h0
          simp [runIR, lordStepIR, lordGuard, lordAliveIR, Expr.eval, lordSerialize,
            lordStep, LordTag.cmd]
        · by_cases hg : 10 ≤ gold <;>
            simp [runIR, lordStepIR, lordGuard, lordAliveIR, eval_minIR, Expr.eval,
              lordSerialize, lordStep, LordTag.cmd, lordMaxHp, healGain, healCost, h0, hg,
              Nat.one_le_iff_ne_zero]
    | flee =>
        by_cases h0 : hp = 0
        · subst h0
          simp [runIR, lordStepIR, lordGuard, lordAliveIR, Expr.eval, lordSerialize,
            lordStep, LordTag.cmd]
        · simp [runIR, lordStepIR, lordGuard, lordAliveIR, Expr.eval, lordSerialize,
            lordStep, LordTag.cmd, foeHp, h0, Nat.one_le_iff_ne_zero]
    | rest =>
        by_cases h0 : hp = 0
        · subst h0
          simp [runIR, lordStepIR, lordGuard, lordAliveIR, Expr.eval, lordSerialize,
            lordStep, LordTag.cmd]
        · simp [runIR, lordStepIR, lordGuard, lordAliveIR, eval_minIR, Expr.eval,
            lordSerialize, lordStep, LordTag.cmd, lordMaxHp, h0, Nat.one_le_iff_ne_zero]

/-- The commands with the names the page uses. -/
def lordTagsWithNames : List (String × LordTag) :=
  [("attack", .attack), ("heal", .heal), ("flee", .flee), ("rest", .rest)]

end NixWars
