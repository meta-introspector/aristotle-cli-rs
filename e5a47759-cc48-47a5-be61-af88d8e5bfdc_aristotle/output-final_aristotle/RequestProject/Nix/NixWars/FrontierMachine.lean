import RequestProject.Nix.NixWars.OracleMachine
import RequestProject.Nix.NixWars.Frontier

/-!
# The Frontier Run, compiled

The fourteenth door goes through the pipeline unchanged: its rules are compiled
into the expression language of `Machine.lean`, and `frontierStepIR_correct`
proves the compiled table computes exactly `frontierStep`. The same compiler
then turns it into WebAssembly with no new code.

The 3-torus is built out of comparisons rather than a modulo — a hop forward is
`c + d` or `c + d - 16`, a hop back is `c - d` or `c + 16 - d` — so nothing in
the table multiplies two unknowns and the static overflow bound is untouched.
-/

namespace NixWars

/-- The commands of the flight, as the page names them. -/
inductive FrontierTag
  | turnTo
  | thrust
  | brake
  | fly
  | dock
  deriving DecidableEq, Repr, Inhabited

/-- A tag plus its numeric argument is a command; for `turnTo` the argument is
the axis direction to point along. -/
def FrontierTag.cmd : FrontierTag → Nat → FrontierCmd
  | .turnTo, h => .turnTo h
  | .thrust, _ => .thrust
  | .brake, _ => .brake
  | .fly, _ => .fly
  | .dock, _ => .dock

/-- The state vector is `[x, y, z, hdg, speed, fuel, docked, turn]`. -/
def frontierFieldNames : List String :=
  ["x", "y", "z", "hdg", "speed", "fuel", "docked", "turn"]

/-! ## The compiled flight -/

/-- One coordinate, moved forward round the torus, compiled. -/
def frontierUpIR (c : Expr) : Expr :=
  .cond (.le (.add c (.fld 4)) (.lit 15)) (.add c (.fld 4))
    (.sub (.add c (.fld 4)) (.lit 16))

/-- One coordinate, moved back round the torus, compiled. -/
def frontierDownIR (c : Expr) : Expr :=
  .cond (.le (.fld 4) c) (.sub c (.fld 4)) (.sub (.add c (.lit 16)) (.fld 4))

/-- The new value of the coordinate at field `i`, whose axis is `axis`. -/
def frontierAxisIR (axis i : Nat) : Expr :=
  .cond (eqIR (.fld 3) (.lit (2 * axis))) (frontierUpIR (.fld i))
    (.cond (eqIR (.fld 3) (.lit (2 * axis + 1))) (frontierDownIR (.fld i)) (.fld i))

/-- The ship is free to move: not docked, and with fuel for the throttle. -/
def frontierFlyOkIR : Expr := andIR (eqIR (.fld 6) (.lit 0)) (.le (.fld 4) (.fld 5))

/-- The ship is standing on the station's cell. -/
def frontierAtStationIR : Expr :=
  andIR (eqIR (.fld 0) (.lit 6)) (andIR (eqIR (.fld 1) (.lit 4)) (eqIR (.fld 2) (.lit 2)))

/-- The compiled transition table of the Frontier Run. -/
def frontierStepIR : FrontierTag → List Expr
  | .turnTo =>
      [ .fld 0, .fld 1, .fld 2, .cond (.le .arg (.lit 5)) .arg (.fld 3),
        .fld 4, .fld 5, .fld 6, .add (.fld 7) (.lit 1) ]
  | .thrust =>
      [ .fld 0, .fld 1, .fld 2, .fld 3,
        .cond (andIR (eqIR (.fld 6) (.lit 0)) (ltIR (.fld 4) (.lit 3)))
          (.add (.fld 4) (.lit 1)) (.fld 4),
        .fld 5, .fld 6, .add (.fld 7) (.lit 1) ]
  | .brake =>
      [ .fld 0, .fld 1, .fld 2, .fld 3, .sub (.fld 4) (.lit 1), .fld 5, .fld 6,
        .add (.fld 7) (.lit 1) ]
  | .fly =>
      [ .cond frontierFlyOkIR (frontierAxisIR 0 0) (.fld 0),
        .cond frontierFlyOkIR (frontierAxisIR 1 1) (.fld 1),
        .cond frontierFlyOkIR (frontierAxisIR 2 2) (.fld 2),
        .fld 3, .fld 4,
        .cond frontierFlyOkIR (.sub (.fld 5) (.fld 4)) (.fld 5),
        .fld 6, .add (.fld 7) (.lit 1) ]
  | .dock =>
      let undock : Expr := eqIR (.fld 6) (.lit 1)
      [ .fld 0, .fld 1, .fld 2, .fld 3,
        .cond undock (.fld 4) (.cond frontierAtStationIR (.lit 0) (.fld 4)),
        .cond undock (.fld 5) (.cond frontierAtStationIR (.lit 71) (.fld 5)),
        .cond undock (.lit 0) (.cond frontierAtStationIR (.lit 1) (.fld 6)),
        .add (.fld 7) (.lit 1) ]

/-- **The compiled table is the Frontier Run.** -/
theorem frontierStepIR_correct (tag : FrontierTag) (s : Frontier) (v : Nat) :
    runIR (frontierStepIR tag) (frontierSerialize s) v
      = frontierSerialize (frontierStep s (tag.cmd v)) := by
  cases tag with
  | turnTo =>
      by_cases hv : v ≤ 5 <;>
        simp [runIR, frontierStepIR, Expr.eval, frontierSerialize, frontierStep,
          FrontierTag.cmd, hv]
  | thrust =>
      by_cases hd : s.docked = 0 <;> by_cases hs : s.speed < 3 <;>
        simp [runIR, frontierStepIR, Expr.eval, eval_andIR, eval_eqIR, eval_ltIR,
          frontierSerialize, frontierStep, FrontierTag.cmd, hd, hs]
  | brake =>
      simp [runIR, frontierStepIR, Expr.eval, frontierSerialize, frontierStep,
        FrontierTag.cmd]
  | fly =>
      by_cases hok : s.docked = 0 ∧ s.speed ≤ s.fuel
      · obtain ⟨hd, hf⟩ := hok
        simp [runIR, frontierStepIR, Expr.eval, eval_andIR, eval_eqIR, frontierFlyOkIR,
          frontierAxisIR, frontierUpIR, frontierDownIR, frontierSerialize, frontierStep,
          frontierAxis, frontierUp, frontierDown, FrontierTag.cmd, hd, hf]
      · simp [runIR, frontierStepIR, Expr.eval, eval_andIR, eval_eqIR, frontierFlyOkIR,
          frontierSerialize, frontierStep, FrontierTag.cmd, hok]
  | dock =>
      by_cases hu : s.docked = 1
      · simp [runIR, frontierStepIR, Expr.eval, eval_eqIR, frontierSerialize, frontierStep,
          FrontierTag.cmd, hu]
      · by_cases hst : s.x = 6 ∧ s.y = 4 ∧ s.z = 2
        · obtain ⟨h1, h2, h3⟩ := hst
          simp [runIR, frontierStepIR, Expr.eval, eval_andIR, eval_eqIR, frontierAtStationIR,
            frontierSerialize, frontierStep, FrontierTag.cmd, hu, h1, h2, h3, frontierTank]
        · simp [runIR, frontierStepIR, Expr.eval, eval_andIR, eval_eqIR, frontierAtStationIR,
            frontierSerialize, frontierStep, FrontierTag.cmd, hu, hst]

/-- The commands with the names the page uses. -/
def frontierTagsWithNames : List (String × FrontierTag) :=
  [("turn", .turnTo), ("thrust", .thrust), ("brake", .brake), ("fly", .fly),
   ("dock", .dock)]

end NixWars
