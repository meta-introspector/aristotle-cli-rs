/-
# Fuzz-Grant — exhaustive completeness

The `FuzzGrantProofs` file establishes the grant/implementation properties over
a 438-vector fuzz bank.  Here we strengthen the guarantees to **exhaustive**
(complete) checks over an entire smaller state space (`BitVec 12`, i.e. all
4096 states).  Fuzzing samples; these theorems cover every state.
-/
import RequestProject.FuzzGrantProofs

namespace Goap

/-- **Complete grant monotonicity.** Over *all* `BitVec 12` states and all 12
atoms, granting an atom preserves every previously-held atom. -/
theorem grant_complete :
    (∀ st : BitVec 12, ∀ b : Fin 12,
      st &&& (st ||| BitVec.ofNat 12 (2 ^ b.val)) = st) := by
  native_decide

/-- **Complete grant idempotence.** Granting the same atom twice equals
granting it once, over the entire `BitVec 12` state space. -/
theorem grant_idem_complete :
    (∀ st : BitVec 12, ∀ b : Fin 12,
      (st ||| BitVec.ofNat 12 (2 ^ b.val)) ||| BitVec.ofNat 12 (2 ^ b.val)
        = st ||| BitVec.ofNat 12 (2 ^ b.val)) := by
  native_decide

/-- Width-12 saturation reference predicate (all 12 atoms hold). -/
def refW (st : BitVec 12) : Bool := st == BitVec.ofNat 12 (2 ^ 12 - 1)

/-- Width-12 implementation `k`: scan bits `0 .. k-1` then `k .. 11`. -/
def implAtW (k : Nat) : BitVec 12 → Bool :=
  fun st => (List.range k).all (fun i => st.getLsbD i)
            && (List.range (12 - k)).all (fun i => st.getLsbD (k + i))

/-- **Complete implementation agreement.** Each of the 13 split-implementations
agrees with the reference predicate on *every* `BitVec 12` state. -/
theorem implW_complete :
    (∀ st : BitVec 12,
      (List.range 13).all (fun k => implAtW k st == refW st)) = true := by
  native_decide

end Goap
