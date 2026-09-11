import RequestProject.Nix.NixWars.OracleMachine
import RequestProject.Nix.NixWars.Qbert

/-!
# Monster Cubes, compiled

The thirteenth door goes through the pipeline unchanged: its rules are compiled
into the expression language of `Machine.lean`, and `qbertStepIR_correct` proves
the compiled table computes exactly `qbertStep`. The same compiler then turns it
into WebAssembly with no new code.

This is the widest table on the board — thirteen fields, ten of them the paint
on the cubes. Each cube compares the landing square against its own coordinates,
so nothing multiplies two unknowns and the static overflow bound is untouched.
-/

namespace NixWars

/-- The four hops, as the page names them. -/
inductive QbertTag
  | dl
  | dr
  | ul
  | ur
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a hop; Monster Cubes takes no numeric argument. -/
def QbertTag.cmd : QbertTag → QbertCmd
  | .dl => .dl
  | .dr => .dr
  | .ul => .ul
  | .ur => .ur

/-- The state vector is `[row, col, c0 … c9, lives]`. -/
def qbertFieldNames : List String :=
  ["row", "col", "c0", "c1", "c2", "c3", "c4", "c5", "c6", "c7", "c8", "c9", "lives"]

/-! ## The compiled cabinet -/

/-- The landing square is the cube at `(x, y)`. -/
def pairEqIR (a b : Expr) (x y : Nat) : Expr := andIR (eqIR a (.lit x)) (eqIR b (.lit y))

theorem eval_pairEqIR (st : List Nat) (v : Nat) (a b : Expr) (x y : Nat) :
    (pairEqIR a b x y).eval st v =
      if a.eval st v = x ∧ b.eval st v = y then 1 else 0 := by
  simp only [pairEqIR, eval_andIR, eval_eqIR, Expr.eval]
  by_cases h₁ : a.eval st v = x <;> by_cases h₂ : b.eval st v = y <;> simp [h₁, h₂]

/-- Choose `a` when the landing square is the cube at `(x, y)`, else `b`. -/
def condEqIR (tr tc : Expr) (x y : Nat) (a b : Expr) : Expr :=
  .cond (pairEqIR tr tc x y) a b

theorem eval_condEqIR (st : List Nat) (v : Nat) (tr tc : Expr) (x y : Nat) (a b : Expr) :
    (condEqIR tr tc x y a b).eval st v =
      if tr.eval st v = x ∧ tc.eval st v = y then a.eval st v else b.eval st v := by
  simp only [condEqIR, Expr.eval, eval_pairEqIR]
  by_cases h : tr.eval st v = x ∧ tc.eval st v = y <;> simp [h]

/-- One hop, compiled, for an arbitrary legality guard `ok` and landing square
`(tr, tc)`: with no lives left nothing moves; a legal hop lands and paints; an
illegal one costs a life and returns to the apex. -/
def qbertProg (ok tr tc : Expr) : List Expr :=
  let alive : Expr := .le (.lit 1) (.fld 12)
  let cube : Nat → Nat → Nat → Expr := fun j rj cj =>
    .cond alive
      (.cond ok (condEqIR tr tc rj cj (.lit 1) (.fld (2 + j))) (.fld (2 + j)))
      (.fld (2 + j))
  [ .cond alive (.cond ok tr (.lit 0)) (.fld 0),
    .cond alive (.cond ok tc (.lit 0)) (.fld 1),
    cube 0 0 0, cube 1 1 0, cube 2 1 1, cube 3 2 0, cube 4 2 1, cube 5 2 2,
    cube 6 3 0, cube 7 3 1, cube 8 3 2, cube 9 3 3,
    .cond alive (.cond ok (.fld 12) (.sub (.fld 12) (.lit 1))) (.fld 12) ]

/-- The compiled transition table of Monster Cubes. -/
def qbertStepIR : QbertTag → List Expr
  | .dl => qbertProg (ltIR (.fld 0) (.lit 3)) (.add (.fld 0) (.lit 1)) (.fld 1)
  | .dr => qbertProg (ltIR (.fld 0) (.lit 3)) (.add (.fld 0) (.lit 1)) (.add (.fld 1) (.lit 1))
  | .ul => qbertProg (ltIR (.lit 0) (.fld 1)) (.sub (.fld 0) (.lit 1)) (.sub (.fld 1) (.lit 1))
  | .ur => qbertProg (ltIR (.fld 1) (.fld 0)) (.sub (.fld 0) (.lit 1)) (.fld 1)

/-- **The compiled table is Monster Cubes.** -/
theorem qbertStepIR_correct (tag : QbertTag) (s : Qbert) (v : Nat) :
    runIR (qbertStepIR tag) (qbertSerialize s) v
      = qbertSerialize (qbertStep s tag.cmd) := by
  by_cases hl : s.lives = 0
  · cases tag <;>
      simp [runIR, qbertStepIR, qbertProg, Expr.eval, qbertSerialize, qbertStep,
        QbertTag.cmd, hl]
  · cases tag <;>
      [(by_cases hok : s.row < 3); (by_cases hok : s.row < 3); (by_cases hok : 0 < s.col);
       (by_cases hok : s.col < s.row)] <;>
      simp [runIR, qbertStepIR, qbertProg, Expr.eval, eval_ltIR, eval_condEqIR,
        qbertSerialize, qbertStep, QbertTag.cmd, qbertHop, qbertFall,
        qbertPaint, hl, hok, Nat.one_le_iff_ne_zero]

/-- The commands with the names the page uses. -/
def qbertTagsWithNames : List (String × QbertTag) :=
  [("dl", .dl), ("dr", .dr), ("ul", .ul), ("ur", .ur)]

end NixWars
