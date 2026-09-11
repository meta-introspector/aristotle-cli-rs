import RequestProject.Nix.NixWars.Session

/-!
# A tiny machine the browser can run

The single-page app must step the game, but we do not want the game's rules to
be re-implemented (and re-bugged) in JavaScript. So the rules are compiled,
inside Lean, into a first-order expression language `Expr` over the serialized
state vector, and `stepIR_correct` proves that running the compiled expressions
computes exactly what `shipStep` computes.

The page then ships two things: a table of `Expr`s emitted by Lean, and a
twelve-line evaluator for `Expr`. All the game logic lives in the table.

Semantics to note: `Expr.sub` is truncated subtraction (as on `Nat`) and
`Expr.div` is floor division, matching the game's fuel arithmetic.
-/

namespace NixWars

/-- Expressions over the serialized state vector. -/
inductive Expr
  | lit (n : Nat)
  | fld (i : Nat)
  | arg
  | add (a b : Expr)
  | mul (a b : Expr)
  | sub (a b : Expr)
  | div (a b : Expr)
  | le (a b : Expr)
  | cond (c a b : Expr)
  deriving Repr, Inhabited, DecidableEq

namespace Expr

/-- Evaluate an expression in a state vector, with `arg` bound to the numeric
argument of the command. -/
def eval (st : List Nat) (v : Nat) : Expr → Nat
  | lit n => n
  | fld i => st.getD i 0
  | arg => v
  | add a b => a.eval st v + b.eval st v
  | mul a b => a.eval st v * b.eval st v
  | sub a b => a.eval st v - b.eval st v
  | div a b => a.eval st v / b.eval st v
  | le a b => if a.eval st v ≤ b.eval st v then 1 else 0
  | cond c a b => if c.eval st v ≠ 0 then a.eval st v else b.eval st v

end Expr

/-- Apply a compiled step: every field of the new state is an expression in the
old one. -/
def runIR (prog : List Expr) (st : List Nat) (v : Nat) : List Nat :=
  prog.map (fun e => e.eval st v)

/-- The command names the page can send. -/
inductive Tag
  | warp
  | scan
  | status
  | jnav
  | unlock
  | quit
  deriving DecidableEq, Repr, Inhabited

/-- A tag plus a numeric argument is a game command. -/
def Tag.cmd : Tag → Nat → ShipCmd
  | .warp, d => .warp d
  | .scan, _ => .scan
  | .status, _ => .status
  | .jnav, _ => .jnav
  | .unlock, _ => .unlock
  | .quit, _ => .quit

/-- The state vector is `[dist, fuel, credits, turn, unlocked]`. -/
def fieldNames : List String := ["dist", "fuel", "credits", "turn", "unlocked"]

/-- The identity program. -/
def idIR : List Expr := [.fld 0, .fld 1, .fld 2, .fld 3, .fld 4]

/-- Compiled `WARP`, for an arbitrary expression giving the distance. -/
def warpIR (d : Expr) : List Expr :=
  let cost : Expr := .div d (.lit 100)
  let ok : Expr := .le cost (.fld 1)
  [ .cond ok (.sub (.fld 0) d) (.fld 0),
    .cond ok (.sub (.fld 1) cost) (.fld 1),
    .fld 2,
    .cond ok (.add (.fld 3) (.lit 1)) (.fld 3),
    .fld 4 ]

/-- Run a program only when `c` is nonzero; otherwise keep the state. -/
def guardIR (c : Expr) (prog : List Expr) : List Expr :=
  List.zipWith (fun e i => Expr.cond c e (Expr.fld i)) prog [0, 1, 2, 3, 4]

/-- The compiled transition table of NixWars: one program per command. -/
def stepIR : Tag → List Expr
  | .warp => warpIR .arg
  | .scan => idIR
  | .status => idIR
  | .jnav => guardIR (.fld 4) (warpIR (.div (.fld 0) (.lit 10)))
  | .unlock => [.fld 0, .fld 1, .fld 2, .fld 3, .lit 1]
  | .quit => idIR

/-- **The compiled machine is the game.** Evaluating the emitted expressions on
the serialized state computes exactly the serialized successor state, so the
browser page and the Lean model cannot disagree. -/
theorem stepIR_correct (tag : Tag) (s : Ship) (v : Nat) :
    runIR (stepIR tag) (shipSerialize s) v = shipSerialize (shipStep s (tag.cmd v)) := by
  cases s with
  | mk dist fuel credits turn unlocked =>
    cases tag with
    | warp =>
      by_cases h : v / 100 ≤ fuel <;>
        cases unlocked <;>
          simp [runIR, stepIR, warpIR, Expr.eval, shipSerialize, shipStep, warpShip,
            warpCost, Tag.cmd, h]
    | scan => cases unlocked <;> simp [runIR, stepIR, idIR, Expr.eval, shipSerialize,
        shipStep, Tag.cmd]
    | status => cases unlocked <;> simp [runIR, stepIR, idIR, Expr.eval, shipSerialize,
        shipStep, Tag.cmd]
    | jnav =>
      by_cases h : dist / 10 / 100 ≤ fuel <;>
        cases unlocked <;>
          simp [runIR, stepIR, guardIR, warpIR, Expr.eval, shipSerialize, shipStep,
            warpShip, warpCost, Tag.cmd, h]
    | unlock => cases unlocked <;> simp [runIR, stepIR, Expr.eval, shipSerialize,
        shipStep, Tag.cmd]
    | quit => cases unlocked <;> simp [runIR, stepIR, idIR, Expr.eval, shipSerialize,
        shipStep, Tag.cmd]

end NixWars
