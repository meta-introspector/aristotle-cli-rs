import RequestProject.Nix.NixWars.TycoonMachine
import RequestProject.Nix.NixWars.Meme

/-!
# The Meme Breeding Pool, compiled

The ninth door goes through the pipeline unchanged: its rules are compiled into
the expression language of `Machine.lean`, and `memeStepIR_correct` proves the
compiled table computes exactly `memeStep`. The same compiler then turns it into
WebAssembly with no new code.

Crossover is an average, so the table divides — the compiler has had floor
division since the fuel arithmetic of NixWars — and the ten per cent a mutation
shaves off the challenger's cycle count is one more division. Nothing multiplies
two unknowns, so the static overflow bound is unaffected.
-/

namespace NixWars

/-- The commands of the breeding door, as the page names them. -/
inductive MemeTag
  | breed
  | mutate
  | select
  deriving DecidableEq, Repr, Inhabited

/-- A tag is a command; the pool takes no numeric argument. -/
def MemeTag.cmd : MemeTag → MemeCmd
  | .breed => .breed
  | .mutate => .mutate
  | .select => .select

/-- The state vector is `[champfit, champcyc, chalfit, chalcyc, gen]`. -/
def memeFieldNames : List String := ["champfit", "champcyc", "chalfit", "chalcyc", "gen"]

/-! ## The compiled pool -/

/-- The child's fitness: the average of the parents' plus one. -/
def childFitnessIR : Expr := .add (.div (.add (.fld 0) (.fld 2)) (.lit 2)) (.lit 1)

/-- The child's cycles: the average of the parents'. -/
def childCyclesIR : Expr := .div (.add (.fld 1) (.fld 3)) (.lit 2)

theorem eval_childFitnessIR (st : List Nat) (v : Nat) :
    childFitnessIR.eval st v = childFitness (st.getD 0 0) (st.getD 2 0) := rfl

theorem eval_childCyclesIR (st : List Nat) (v : Nat) :
    childCyclesIR.eval st v = childCycles (st.getD 1 0) (st.getD 3 0) := rfl

/-- The compiled transition table of the breeding door. -/
def memeStepIR : MemeTag → List Expr
  | .breed =>
      let takes : Expr := .le (.fld 0) childFitnessIR
      [ .cond takes childFitnessIR (.fld 0),
        .cond takes childCyclesIR (.fld 1),
        .cond takes (.fld 0) childFitnessIR,
        .cond takes (.fld 1) childCyclesIR,
        .add (.fld 4) (.lit 1) ]
  | .mutate =>
      [ .fld 0, .fld 1,
        .add (.fld 2) (.lit 1),
        .sub (.fld 3) (.div (.fld 3) (.lit 10)),
        .fld 4 ]
  | .select =>
      let swaps : Expr := .le (.fld 0) (.fld 2)
      [ .cond swaps (.fld 2) (.fld 0),
        .cond swaps (.fld 3) (.fld 1),
        .cond swaps (.fld 0) (.fld 2),
        .cond swaps (.fld 1) (.fld 3),
        .fld 4 ]

/-- **The compiled table is the Meme Breeding Pool.** -/
theorem memeStepIR_correct (tag : MemeTag) (s : MemePool) (v : Nat) :
    runIR (memeStepIR tag) (memeSerialize s) v
      = memeSerialize (memeStep s tag.cmd) := by
  cases tag with
  | breed =>
      simp only [runIR, memeStepIR, List.map, Expr.eval, eval_childFitnessIR, eval_childCyclesIR,
        memeSerialize, List.getD_cons_zero, List.getD_cons_succ, memeStep, MemeTag.cmd]
      split_ifs with h <;> simp_all
  | mutate =>
      simp [runIR, memeStepIR, Expr.eval, memeSerialize, memeStep, MemeTag.cmd]
  | select =>
      by_cases h : s.champFit ≤ s.chalFit
      · simp [runIR, memeStepIR, Expr.eval, memeSerialize, memeStep, MemeTag.cmd, h]
      · simp [runIR, memeStepIR, Expr.eval, memeSerialize, memeStep, MemeTag.cmd, h]

/-- The commands with the names the page uses. -/
def memeTagsWithNames : List (String × MemeTag) :=
  [("breed", .breed), ("mutate", .mutate), ("select", .select)]

end NixWars
