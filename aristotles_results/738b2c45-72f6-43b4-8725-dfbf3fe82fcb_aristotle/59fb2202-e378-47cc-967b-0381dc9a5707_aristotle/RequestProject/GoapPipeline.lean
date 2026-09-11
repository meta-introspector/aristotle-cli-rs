/-
# GOAP Pipeline — core model

A Goal-Oriented Action Planning (GOAP) pipeline modelled over a finite,
26-atom boolean world state.

* The world state is a `BitVec 26`: each of the 26 bits is one *atom*
  (a boolean world property).
  - bits `0 .. 12`  : the 13 input *resources* are available;
  - bits `13 .. 25` : the 13 pipeline *stages* have completed.
* A `Step` is a GOAP action with a precondition mask (`pre`), a delete
  mask (`del`) and an add mask (`add`).
* There are exactly **13 steps**, forming a linear pipeline: `stage i`
  requires resource `i` and (for `i > 0`) the completion of `stage (i-1)`,
  and it sets the completion bit of `stage i`.

All concrete facts are discharged with `native_decide`; structural facts
(`run_append`) are proved generically.
-/

namespace Goap

/-- Number of atoms (world properties). -/
def atomCount : Nat := 26

/-- The world state: one boolean per atom. -/
abbrev State := BitVec 26

/-- A GOAP action: preconditions, deletions and additions as bit masks. -/
structure Step where
  pre : BitVec 26
  del : BitVec 26
  add : BitVec 26
  deriving Repr, DecidableEq

/-- A step is enabled when all its precondition atoms hold. -/
def Step.enabled (s : Step) (st : State) : Bool := (st &&& s.pre) == s.pre

/-- The raw effect of a step: clear the `del` atoms, then set the `add` atoms. -/
def Step.apply (s : Step) (st : State) : State := (st &&& (~~~ s.del)) ||| s.add

/-- Applying a step: it fires only when enabled, otherwise it is the identity. -/
def Step.step (s : Step) (st : State) : State := if s.enabled st then s.apply st else st

/-- Build the `i`-th pipeline step (`0 ≤ i < 13`). -/
def mkStep (i : Nat) : Step :=
  let resBit    : Nat := 2 ^ i                       -- resource i (bit i)
  let prevStage : Nat := if i = 0 then 0 else 2 ^ (12 + i)  -- stage (i-1) done
  let doneBit   : Nat := 2 ^ (13 + i)                -- stage i done (bit 13+i)
  { pre := BitVec.ofNat 26 (resBit ||| prevStage)
    del := 0
    add := BitVec.ofNat 26 doneBit }

/-- The 13 pipeline steps. -/
def steps : List Step := (List.range 13).map mkStep

/-- Run a plan: fold the (guarded) step application from left to right. -/
def run (plan : List Step) (st : State) : State :=
  plan.foldl (fun s a => a.step s) st

/-- Initial state: all 13 resources available, no stage done yet. -/
def initState : State := BitVec.ofNat 26 (2 ^ 13 - 1)

/-- Goal state: all 26 atoms hold (resources available and every stage done). -/
def goalState : State := BitVec.ofNat 26 (2 ^ 26 - 1)

/-! ## Counting facts -/

theorem atomCount_eq : atomCount = 26 := rfl

theorem steps_count : steps.length = 13 := by native_decide

/-! ## The pipeline achieves its goal -/

/-- Running the full 13-step pipeline from the initial state reaches the goal. -/
theorem pipeline_reaches_goal : run steps initState = goalState := by native_decide

/-! ## Structural law of `run` (used by split / merge / unification) -/

/-- Running a concatenation of plans is running the second after the first. -/
theorem run_append (p q : List Step) (st : State) :
    run (p ++ q) st = run q (run p st) := by
  simp [run, List.foldl_append]

end Goap
