/-
# Split / Merge / Unification

Structural correctness of decomposing a GOAP plan.  These are *generic*
theorems (no `native_decide`): splitting a plan at any point and merging the
two halves back reproduces the original run, and any two split points give
the same result ("unification").
-/
import RequestProject.GoapPipeline

namespace Goap

/-- **Merge**: running `p` then `q` equals running the merged plan `p ++ q`. -/
theorem merge (p q : List Step) (st : State) :
    run q (run p st) = run (p ++ q) st :=
  (run_append p q st).symm

/-- **Split**: any plan can be split at position `k` and the halves run in
sequence without changing the result. -/
theorem split (plan : List Step) (k : Nat) (st : State) :
    run plan st = run (plan.drop k) (run (plan.take k) st) := by
  rw [← run_append, List.take_append_drop]

/-- **Unification**: splitting a plan at two different points `k` and `m`
yields the very same final state — the decomposition is unambiguous. -/
theorem split_unify (plan : List Step) (k m : Nat) (st : State) :
    run (plan.drop k) (run (plan.take k) st)
      = run (plan.drop m) (run (plan.take m) st) := by
  rw [← split, ← split]

/-- Three-way associativity: split/merge is compatible with re-associating
the concatenation of three sub-plans. -/
theorem run_append3 (p q r : List Step) (st : State) :
    run ((p ++ q) ++ r) st = run r (run q (run p st)) := by
  rw [run_append, run_append]

/-- Concrete corollary: the 13-step pipeline can be split at stage `k` and the
prefix/suffix run separately, still reaching the goal from the initial state. -/
theorem pipeline_split_reaches_goal (k : Nat) :
    run (steps.drop k) (run (steps.take k) initState) = goalState := by
  rw [← split]; exact pipeline_reaches_goal

end Goap
