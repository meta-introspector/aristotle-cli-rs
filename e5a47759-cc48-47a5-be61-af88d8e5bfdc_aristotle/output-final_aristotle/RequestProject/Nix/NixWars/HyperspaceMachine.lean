import RequestProject.Nix.NixWars.MemeMachine
import RequestProject.Nix.NixWars.Hyperspace

/-!
# 8D Hyperspace, compiled

The tenth door goes through the pipeline unchanged: its rules are compiled into
the expression language of `Machine.lean`, and `hyperStepIR_correct` proves the
compiled table computes exactly `hyperStep`. The same compiler then turns it
into WebAssembly with no new code.

This is the first door whose numeric argument selects *which* field to change:
`fwd d` and `back d` carry the axis in the command argument, so every one of
the eight output expressions is a comparison of the argument against its own
index. Nothing multiplies two unknowns, so the static overflow bound is
unaffected.
-/

namespace NixWars

/-- The commands of the hyperspace door, as the page names them. -/
inductive HyperTag
  | fwd
  | back
  | home
  | fix
  deriving DecidableEq, Repr, Inhabited

/-- A tag and its numeric argument are a command; for `fwd` and `back` the
argument is the axis to move along. -/
def HyperTag.cmd : HyperTag → Nat → HyperCmd
  | .fwd, v => .fwd v
  | .back, v => .back v
  | .home, _ => .home
  | .fix, _ => .fix

/-- The state vector is one coordinate per axis of the Monster manifold. -/
def hyperFieldNames : List String :=
  ["conductor", "weight", "level", "traits", "primes", "gitdepth", "muses", "complexity"]

/-! ## The compiled navigator -/

/-- One step forward along axis `i`, compiled. -/
def bumpUpIR (i : Nat) : Expr :=
  .cond (.le (.add (.fld i) (.lit 1)) (.lit 7)) (.add (.fld i) (.lit 1)) (.lit 0)

/-- One step back along axis `i`, compiled. -/
def bumpDownIR (i : Nat) : Expr :=
  .cond (.le (.fld i) (.lit 0)) (.lit 7) (.sub (.fld i) (.lit 1))

/-- Axis `i` moves only when the command argument names it. -/
def axisIR (i : Nat) (moved : Expr) : Expr := .cond (eqIR .arg (.lit i)) moved (.fld i)

/-- The compiled transition table of the hyperspace door. -/
def hyperStepIR : HyperTag → List Expr
  | .fwd =>
      [axisIR 0 (bumpUpIR 0), axisIR 1 (bumpUpIR 1), axisIR 2 (bumpUpIR 2),
       axisIR 3 (bumpUpIR 3), axisIR 4 (bumpUpIR 4), axisIR 5 (bumpUpIR 5),
       axisIR 6 (bumpUpIR 6), axisIR 7 (bumpUpIR 7)]
  | .back =>
      [axisIR 0 (bumpDownIR 0), axisIR 1 (bumpDownIR 1), axisIR 2 (bumpDownIR 2),
       axisIR 3 (bumpDownIR 3), axisIR 4 (bumpDownIR 4), axisIR 5 (bumpDownIR 5),
       axisIR 6 (bumpDownIR 6), axisIR 7 (bumpDownIR 7)]
  | .home =>
      [.lit 0, .lit 0, .lit 0, .lit 0, .lit 0, .lit 0, .lit 0, .lit 0]
  | .fix =>
      [.fld 0, .fld 1, .fld 2, .fld 3, .fld 4, .fld 5, .fld 6, .fld 7]

/-- **The compiled table is 8D Hyperspace.** -/
theorem hyperStepIR_correct (tag : HyperTag) (s : Position) (v : Nat) :
    runIR (hyperStepIR tag) (hyperSerialize s) v
      = hyperSerialize (hyperStep s (tag.cmd v)) := by
  cases tag with
  | fwd =>
      rcases Nat.lt_or_ge v 8 with hv | hv
      · interval_cases v <;>
          simp [runIR, hyperStepIR, axisIR, bumpUpIR, eqIR, Expr.eval, hyperSerialize,
            hyperStep, HyperTag.cmd, setCoord, coord, bumpUp, span]
      · have h0 : ¬ (v = 0) := by omega
        have h1 : ¬ (v = 1) := by omega
        have h2 : ¬ (v = 2) := by omega
        have h3 : ¬ (v = 3) := by omega
        have h4 : ¬ (v = 4) := by omega
        have h5 : ¬ (v = 5) := by omega
        have h6 : ¬ (v = 6) := by omega
        have h7 : ¬ (v = 7) := by omega
        simp [runIR, hyperStepIR, axisIR, bumpUpIR, eqIR, Expr.eval, hyperSerialize,
          hyperStep, HyperTag.cmd, setCoord, h0, h1, h2, h3, h4, h5, h6, h7]
        omega
  | back =>
      rcases Nat.lt_or_ge v 8 with hv | hv
      · interval_cases v <;>
          simp [runIR, hyperStepIR, axisIR, bumpDownIR, eqIR, Expr.eval, hyperSerialize,
            hyperStep, HyperTag.cmd, setCoord, coord, bumpDown, span]
      · have h0 : ¬ (v = 0) := by omega
        have h1 : ¬ (v = 1) := by omega
        have h2 : ¬ (v = 2) := by omega
        have h3 : ¬ (v = 3) := by omega
        have h4 : ¬ (v = 4) := by omega
        have h5 : ¬ (v = 5) := by omega
        have h6 : ¬ (v = 6) := by omega
        have h7 : ¬ (v = 7) := by omega
        simp [runIR, hyperStepIR, axisIR, bumpDownIR, eqIR, Expr.eval, hyperSerialize,
          hyperStep, HyperTag.cmd, setCoord, h0, h1, h2, h3, h4, h5, h6, h7]
        omega
  | home =>
      simp [runIR, hyperStepIR, Expr.eval, hyperSerialize, hyperStep, HyperTag.cmd, origin]
  | fix =>
      simp [runIR, hyperStepIR, Expr.eval, hyperSerialize, hyperStep, HyperTag.cmd]

/-- The commands with the names the page uses. -/
def hyperTagsWithNames : List (String × HyperTag) :=
  [("fwd", .fwd), ("back", .back), ("home", .home), ("fix", .fix)]

end NixWars
