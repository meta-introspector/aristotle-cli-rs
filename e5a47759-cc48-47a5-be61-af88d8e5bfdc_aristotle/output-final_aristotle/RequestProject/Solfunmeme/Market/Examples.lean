/-
# The market, instantiated

The theory in this directory is stated for an arbitrary task, an arbitrary
toolchain and an arbitrary bill of materials.  This file exhibits one of each and
computes with it, so that none of the theorems are vacuous: there really is a
task with a sound and complete verifier, a build chain that attests, and a
machine whose replacement part is safe.

The task chosen is deliberately humble — "produce a nontrivial factorisation" —
because it is a case where checking is genuinely cheaper than computing, which is
the whole premise of a verified compute market.
-/
import Mathlib
import RequestProject.Solfunmeme.Market.Challenge
import RequestProject.Solfunmeme.Market.Compute
import RequestProject.Solfunmeme.Market.Stake
import RequestProject.Solfunmeme.Market.Supply
import RequestProject.Solfunmeme.Market.Twin

namespace RequestProject.Market

/-! ## A task: factorisation, hard to do and easy to check -/

/-- "Split this number into two factors, both bigger than one." -/
def factorTask : Task Nat (Nat × Nat) Unit where
  spec n p := p.1 * p.2 = n ∧ 1 < p.1 ∧ 1 < p.2
  verify n p _ := decide (p.1 * p.2 = n ∧ 1 < p.1 ∧ 1 < p.2)
  verify_sound _ _ _ h := of_decide_eq_true h
  verify_complete _ _ h := ⟨(), decide_eq_true h⟩

/-- A correct submission for `15 = 3 * 5`, escrowing 20 with a bond of 5. -/
def paidJob : Job Nat (Nat × Nat) Unit :=
  ⟨15, ⟨20, 5⟩, some ⟨(3, 5), ()⟩⟩

/-- A submission claiming the trivial factorisation, which the specification
rules out. -/
def rejectedJob : Job Nat (Nat × Nat) Unit :=
  ⟨15, ⟨20, 5⟩, some ⟨(1, 15), ()⟩⟩

example : factorTask.accepts paidJob = true := by decide

example : factorTask.payout paidJob = (25, 0) := by decide

example : factorTask.accepts rejectedJob = false := by decide

/-- The bad claim forfeits the bond: the operator gets nothing and the customer
is made whole. -/
example : factorTask.payout rejectedJob = (0, 25) := by decide

/-- Over a batch, revenue counts exactly the verified job. -/
example : factorTask.revenue [paidJob, rejectedJob] = 25 := by decide

/-- An operator with a stake of 12 and a bond of 5 can lie at most twice before
it can no longer bid, and it ends with 2. -/
example :
    (Schedule.run ⟨5, 20⟩ factorTask ⟨12, 0⟩ [rejectedJob, rejectedJob, rejectedJob])
      = ⟨2, 2⟩ := by decide

/-- Honest work compounds instead: three verified jobs at 20 each. -/
example :
    (Schedule.run ⟨5, 20⟩ factorTask ⟨12, 0⟩ [paidJob, paidJob, paidJob])
      = ⟨72, 0⟩ := by decide

/-! ## A challenge window, with a challenger who actually turns up -/

/-- The same factorisation task, run optimistically: no proof is submitted, and
a refutation is just the assertion that the claim fails the specification, which
the court re-checks for itself. -/
def factorCourt : Court Nat (Nat × Nat) Unit where
  spec n p := p.1 * p.2 = n ∧ 1 < p.1 ∧ 1 < p.2
  refutes n p _ := !decide (p.1 * p.2 = n ∧ 1 < p.1 ∧ 1 < p.2)
  refutes_sound _ _ _ h := by
    simp only [Bool.not_eq_true', decide_eq_false_iff_not] at h
    exact h

/-- A challenger that re-runs the check and speaks up whenever it fails. -/
def watchdog : Challenger Nat (Nat × Nat) Unit :=
  fun n p => if p.1 * p.2 = n ∧ 1 < p.1 ∧ 1 < p.2 then none else some ()

/-- The watchdog is diligent, so `diligent_court_pays_iff_spec` applies to it:
the hypothesis of the headline theorem is satisfiable. -/
theorem watchdog_diligent : factorCourt.Diligent watchdog := by
  intro n p h
  have h' : ¬ (p.1 * p.2 = n ∧ 1 < p.1 ∧ 1 < p.2) := h
  refine ⟨(), by simp [watchdog, h'], ?_⟩
  simp only [factorCourt, Bool.not_eq_true', decide_eq_false_iff_not]
  exact h'

/-- An honest claim, escrowing 20 with a bond of 5. -/
def goodClaim : Claim Nat (Nat × Nat) := ⟨15, ⟨20, 5⟩, some (3, 5)⟩

/-- A false claim of the same job. -/
def badClaim : Claim Nat (Nat × Nat) := ⟨15, ⟨20, 5⟩, some (1, 15)⟩

/-- With the watchdog on duty the honest operator is paid in full … -/
example : factorCourt.payout [watchdog] goodClaim = (25, 0, 0) := by decide

/-- … and the liar is slashed: the customer's 20 is returned and the bond of 5
goes to the challenger. -/
example : factorCourt.payout [watchdog] badClaim = (0, 20, 5) := by decide

/-- With nobody watching, the same false claim collects everything — the
possibility `optimistic_pays_for_wrong_result` exhibits, here in numbers. -/
example : factorCourt.payout [] badClaim = (25, 0, 0) := by decide

/-- An audit of two of five jobs misses a single cheat in `4.choose 2 = 6` of
the `5.choose 2 = 10` ways of choosing it. -/
example :
    ((((Finset.univ : Finset (Fin 5)).powersetCard 2).filter
      (fun s => Disjoint s ({3} : Finset (Fin 5)))).card,
      ((Finset.univ : Finset (Fin 5)).powersetCard 2).card) = (6, 10) := by decide

/-! ## A build chain -/

/-- A toy toolchain over "artifacts" that are lists of bytes: tool 1 appends a
version stamp, tool 2 strips a leading debug byte, anything else is the
identity. -/
def toyToolchain : Toolchain (List Nat) where
  run
    | 1, a => a ++ [7]
    | 2, a => a.tail
    | _, a => a

/-- The attested build of `[0, 1, 2]`: strip the debug byte, then stamp. -/
def toyChain : List (Step (List Nat)) :=
  [⟨2, [0, 1, 2], [1, 2]⟩, ⟨1, [1, 2], [1, 2, 7]⟩]

example : toyToolchain.Valid [0, 1, 2] toyChain := by
  refine ⟨rfl, rfl, ⟨rfl, rfl, trivial⟩⟩

example : deployed [0, 1, 2] toyChain = [1, 2, 7] := by decide

/-- The deployed artifact is the rebuild, as `deployed_eq_rebuild` promises. -/
example : deployed [0, 1, 2] toyChain
    = toyToolchain.rebuild [0, 1, 2] (toyChain.map Step.tool) :=
  deployed_eq_rebuild toyToolchain [0, 1, 2] toyChain ⟨rfl, rfl, ⟨rfl, rfl, trivial⟩⟩

/-- A chain that claims an artifact nobody's tools produce cannot be valid. -/
example : ¬ toyToolchain.Valid [0, 1, 2] [⟨2, [0, 1, 2], [9, 9]⟩] := by
  refine tampering_invalidates_chain toyToolchain [0, 1, 2] [⟨2, [0, 1, 2], [9, 9]⟩] ?_
  decide

/-- Every tool here keeps the artifact's bytes below ten, so the deployed
artifact inherits that certified property. -/
example : ∀ b ∈ deployed [0, 1, 2] toyChain, b < 10 := by decide

/-! ## A machine and a replacement part -/

/-- A pump needing hydraulic pressure and a 12V supply, guaranteeing flow. -/
def pump : Component := ⟨1, {10}, {20, 21}, {30}⟩

/-- The rig that supplies it. -/
def rig : Component := ⟨2, {20, 21}, ∅, {31}⟩

/-- The machine: a pump on a rig, closed because the rig provides what the pump
needs. -/
def machine : Assembly := ⟨[pump, rig]⟩

example : machine.Closed := by decide

/-- A second-source pump: same interface, no 12V requirement, and one extra
certified property. -/
def betterPump : Component := ⟨3, {10, 11}, {20}, {30, 32}⟩

example : Refines betterPump pump := by
  refine ⟨?_, ?_, ?_⟩ <;> decide

/-- Swapping in the replacement part keeps the machine buildable … -/
example : (machine.substitute pump betterPump).Closed :=
  Assembly.closed_substitute machine (by decide) ⟨by decide, by decide, by decide⟩

/-- … and keeps the flow guarantee it was certified for. -/
example : (30 : Nat) ∈ (machine.substitute pump betterPump).guaranteed :=
  Assembly.guarantee_preserved machine ⟨by decide, by decide, by decide⟩ (by decide)

end RequestProject.Market
