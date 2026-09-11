/-
# Fuzz-Grant proofs

A *grant* is a monotone GOAP action that only ever **adds** an atom (its `del`
mask is empty and its precondition is trivial).  The key safety property is
**monotonicity**: granting an atom never removes any atom that already held.

We verify this property by *fuzzing*: over a bank of **438** pseudo-random
world states we check monotonicity for all 26 possible grants.

We also collect **27 implementations** of the "world fully saturated"
predicate (each checking that all 26 atoms hold, but splitting the scan at a
different position `0 .. 26`) and verify — again over the 438 fuzz vectors —
that every implementation agrees with the reference.
-/
import RequestProject.GoapPipeline

namespace Goap

/-- Granting atom `bit`: set that atom, keep everything else (monotone). -/
def grant (bit : Nat) : State → State := fun st => st ||| BitVec.ofNat 26 (2 ^ bit)

/-- The fuzz bank: 438 pseudo-random world states. -/
def fuzzStates : List State :=
  (List.range 438).map (fun n => BitVec.ofNat 26 (n * 2654435761 + 12345))

theorem fuzz_count : fuzzStates.length = 438 := by native_decide

/-- **Grant monotonicity (fuzzed).** For every fuzz state and every one of the
26 atoms, granting that atom preserves all previously-held atoms
(`st &&& grant b st = st`). -/
theorem grant_monotone :
    (fuzzStates.all (fun st =>
      (List.range 26).all (fun b => st &&& grant b st == st))) = true := by
  native_decide

/-- Reference predicate: the world is fully saturated (all 26 atoms hold). -/
def ref (st : State) : Bool := st == BitVec.ofNat 26 (2 ^ 26 - 1)

/-- Implementation `k`: check "all 26 atoms hold" by scanning bits `0 .. k-1`
and then bits `k .. 25` separately. -/
def implAt (k : Nat) : State → Bool :=
  fun st => (List.range k).all (fun i => st.getLsbD i)
            && (List.range (26 - k)).all (fun i => st.getLsbD (k + i))

/-- The 27 implementations (split points `0 .. 26`). -/
def impls : List (State → Bool) := (List.range 27).map implAt

theorem impls_count : impls.length = 27 := by native_decide

/-- **Implementation agreement (fuzzed).** Every one of the 27 implementations
agrees with the reference predicate on all 438 fuzz vectors. -/
theorem impls_agree_on_fuzz :
    (fuzzStates.all (fun st => impls.all (fun f => f st == ref st))) = true := by
  native_decide

end Goap
