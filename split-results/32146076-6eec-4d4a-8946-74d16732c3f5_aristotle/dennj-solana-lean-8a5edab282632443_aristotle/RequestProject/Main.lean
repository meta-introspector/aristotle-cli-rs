import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Colosseum vault — formalized safety theorems

This file formalizes the mathematically meaningful core of the `Colosseum/Colosseum.lean`
demo program from the `dennj-solana-lean` repository (a Solana "proof-carrying" vault).

The original program depends on a custom `Std.Solana` module (Borsh encoding, the Solana
program entry point, FFI), which is not available outside that Lean-compiler fork. Here we
reproduce the parts that carry actual mathematical content — the vault state, its safety
invariant, the `deposit`/`withdraw`/`step` state transitions, and the safety theorems
stating that these transitions preserve the invariant — using only `UInt64`/`Nat` facts
available in Mathlib.

The safety invariant is: *the vault never owes more than it took in*, i.e.
`balance + totalOut = totalIn` (computed in `Nat` to side-step `UInt64` wraparound).
-/

namespace Colosseum

/-- Vault state held in the program account: live balance, lifetime in, lifetime out. -/
structure Vault where
  balance  : UInt64
  totalIn  : UInt64
  totalOut : UInt64
  deriving DecidableEq

/-- Safety invariant: the vault never owes more than it took in.
    Computed in `Nat` to side-step UInt64 wraparound at the proof level. -/
def Vault.ok (v : Vault) : Bool :=
  v.balance.toNat + v.totalOut.toNat == v.totalIn.toNat

/-- Deposit `amount`: balance and totalIn both grow. -/
def Vault.deposit (v : Vault) (amount : UInt64) : Vault :=
  { v with
    balance := v.balance + amount
    totalIn := v.totalIn + amount }

/-- Withdraw `amount`: balance shrinks, totalOut grows.
    Deleting the `balance := v.balance - amount` line is the canonical
    balance-leak bug — the `withdraw` proof below stops checking. -/
def Vault.withdraw (v : Vault) (amount : UInt64) : Vault :=
  { v with
    balance  := v.balance - amount
    totalOut := v.totalOut + amount }

/-- **Safety theorem (deposit).** For any vault `v` satisfying the
    invariant, depositing `amount` preserves the invariant — provided
    neither `balance + amount` nor `totalIn + amount` overflows
    `UInt64`. -/
theorem deposit_preserves_ok
    (v : Vault) (amount : UInt64)
    (h_ok : v.ok = true)
    (h_bal : v.balance.toNat + amount.toNat < UInt64.size)
    (h_in  : v.totalIn.toNat  + amount.toNat < UInt64.size) :
    (v.deposit amount).ok = true := by
  simp only [Vault.ok, Vault.deposit, UInt64.toNat_add, beq_iff_eq] at *
  rw [Nat.mod_eq_of_lt h_bal, Nat.mod_eq_of_lt h_in]
  omega

/-- **Safety theorem (withdraw).** For any vault `v` satisfying the
    invariant, withdrawing `amount` preserves the invariant — provided
    `amount ≤ balance` (no underflow) and `totalOut + amount` does not
    overflow `UInt64`. Removing the `balance := v.balance - amount`
    line in `Vault.withdraw` makes this theorem unprovable. -/
theorem withdraw_preserves_ok
    (v : Vault) (amount : UInt64)
    (h_ok  : v.ok = true)
    (h_pre : amount ≤ v.balance)
    (h_out : v.totalOut.toNat + amount.toNat < UInt64.size) :
    (v.withdraw amount).ok = true := by
  have h_pre_nat : amount.toNat ≤ v.balance.toNat := UInt64.le_iff_toNat_le.mp h_pre
  simp only [Vault.ok, Vault.withdraw, UInt64.toNat_add, beq_iff_eq] at *
  rw [UInt64.toNat_sub_of_le _ _ h_pre, Nat.mod_eq_of_lt h_out]
  omega

-- ── Instruction dispatch ────────────────────────────────────────────────────

def opDeposit  : UInt8 := 0
def opWithdraw : UInt8 := 1

/-- Apply an op to the vault. Returns `none` for unknown op or insufficient balance. -/
def step (v : Vault) (op : UInt8) (amount : UInt64) : Option Vault :=
  if op == opDeposit then
    some (v.deposit amount)
  else if op == opWithdraw then
    if amount ≤ v.balance then some (v.withdraw amount) else none
  else
    none

/-- **Safety theorem (dispatch).** Whenever `step` produces a new vault `v'` from
    a vault `v` satisfying the invariant, `v'` also satisfies the invariant —
    provided the relevant `UInt64` operation does not overflow. This combines the
    `deposit` and `withdraw` cases and shows that the program's entry-point
    dispatcher cannot produce an unsafe state. -/
theorem step_preserves_ok
    (v v' : Vault) (op : UInt8) (amount : UInt64)
    (h_ok : v.ok = true)
    (h_bal : v.balance.toNat + amount.toNat < UInt64.size)
    (h_in  : v.totalIn.toNat  + amount.toNat < UInt64.size)
    (h_out : v.totalOut.toNat + amount.toNat < UInt64.size)
    (h_step : step v op amount = some v') :
    v'.ok = true := by
  unfold step at h_step
  split at h_step
  · -- deposit branch
    rw [← Option.some_inj.mp h_step]
    exact deposit_preserves_ok v amount h_ok h_bal h_in
  · split at h_step
    · -- withdraw branch
      split at h_step
      · rw [← Option.some_inj.mp h_step]
        rename_i hle
        exact withdraw_preserves_ok v amount h_ok hle h_out
      · exact absurd h_step (by simp)
    · -- unknown op
      exact absurd h_step (by simp)

end Colosseum
