import RequestProject.Nix.NixWars.MarketMachine
import RequestProject.Nix.NixWars.Wumpus

/-!
# Hunt the Wumpus, compiled

The fifth door goes through the same pipeline as the others:
`huntStepIR_correct` proves the compiled table computes exactly `huntStep`, and
the same WebAssembly compiler then turns it into module code.

The wumpus's creep is a rotation of the 71-shard ring, which the machine builds
out of two comparisons rather than a modulo — so, as with the other doors,
nothing in the table multiplies two unknowns and the static overflow bound
stays comfortable.
-/

namespace NixWars

/-- The commands of the hunt, as the page names them. -/
inductive HuntTag
  | move
  | shoot
  | sense
  deriving DecidableEq, Repr, Inhabited

/-- A tag plus the shard named by the player is a command. -/
def HuntTag.cmd : HuntTag → Nat → HuntCmd
  | .move, r => .move r
  | .shoot, r => .shoot r
  | .sense, _ => .sense

/-- The state vector is `[room, wumpus, arrows, alive, turn]`. -/
def huntFieldNames : List String := ["room", "wumpus", "arrows", "alive", "turn"]

/-- The wumpus's creep, compiled. -/
def creepIR : Expr :=
  .cond (.le (.lit 71) (.fld 1)) (.fld 1)
    (.cond (eqIR (.fld 1) (.lit 70)) (.lit 0) (.add (.fld 1) (.lit 1)))

theorem eval_creepIR (st : List Nat) (v : Nat) :
    creepIR.eval st v = wumpusCreep (st.getD 1 0) := by
  simp only [creepIR, Expr.eval, eval_eqIR, wumpusCreep, wumpusSlain]
  split_ifs <;> simp_all

/-- The compiled transition table of Hunt the Wumpus. -/
def huntStepIR : HuntTag → List Expr
  | .move =>
      let alive : Expr := .fld 3
      let room : Expr := .cond (.le .arg (.lit 70)) .arg (.fld 0)
      [ .cond alive room (.fld 0),
        .cond alive creepIR (.fld 1),
        .fld 2,
        .cond alive (.sub (.lit 1) (eqIR room creepIR)) (.fld 3),
        .cond alive (.add (.fld 4) (.lit 1)) (.fld 4) ]
  | .shoot =>
      let act : Expr := .cond (.fld 3) (.le (.lit 1) (.fld 2)) (.lit 0)
      let hit : Expr := eqIR .arg (.fld 1)
      [ .fld 0,
        .cond act (.cond hit (.lit 71) creepIR) (.fld 1),
        .cond act (.sub (.fld 2) (.lit 1)) (.fld 2),
        .fld 3,
        .cond act (.add (.fld 4) (.lit 1)) (.fld 4) ]
  | .sense => [.fld 0, .fld 1, .fld 2, .fld 3, .fld 4]

/-- **The compiled table is Hunt the Wumpus.** -/
theorem huntStepIR_correct (tag : HuntTag) (s : Hunt) (v : Nat) :
    runIR (huntStepIR tag) (huntSerialize s) v = huntSerialize (huntStep s (tag.cmd v)) := by
  cases s with
  | mk room wumpus arrows alive turn =>
    cases tag with
    | move =>
        cases alive
        · simp [runIR, huntStepIR, Expr.eval, huntSerialize, huntStep, HuntTag.cmd]
        · by_cases he : (if v ≤ 70 then v else room) = wumpusCreep wumpus <;>
            simp [runIR, huntStepIR, Expr.eval, eval_creepIR, eval_eqIR, huntSerialize,
              huntStep, HuntTag.cmd, he]
    | shoot =>
        cases alive
        · simp [runIR, huntStepIR, Expr.eval, huntSerialize, huntStep, HuntTag.cmd]
        · by_cases ha : arrows = 0
          · simp [runIR, huntStepIR, Expr.eval, huntSerialize, huntStep, HuntTag.cmd, ha]
          · by_cases hv : v = wumpus <;>
              simp [runIR, huntStepIR, Expr.eval, eval_creepIR, eval_eqIR, huntSerialize,
                huntStep, HuntTag.cmd, ha, hv, wumpusSlain, Nat.one_le_iff_ne_zero]
    | sense =>
        cases alive <;>
          simp [runIR, huntStepIR, Expr.eval, huntSerialize, huntStep, HuntTag.cmd]

/-- The commands with the names the page uses. -/
def huntTagsWithNames : List (String × HuntTag) :=
  [("move", .move), ("shoot", .shoot), ("sense", .sense)]

end NixWars
