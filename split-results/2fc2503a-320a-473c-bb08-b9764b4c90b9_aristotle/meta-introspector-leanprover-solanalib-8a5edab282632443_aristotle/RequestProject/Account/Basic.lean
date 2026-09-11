/-
Copyright (c) 2026 Solana Foundation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Solanalib Contributors
-/
import RequestProject.Primitives.Lamports
import RequestProject.Primitives.Pubkey

/-!
# Accounts

The Solana account model. An on-chain account carries five fields: its
lamport balance (u64), the program that owns it, an opaque data blob, an
executable flag (true for programs, false for data accounts), and the
rent epoch at which rent next comes due.

`Account.lamports` is a `Lamports` (= `UInt64`), so `credit` and `debit`
carry **explicit no-overflow / no-underflow preconditions** in their type
signatures. The compiler will reject any call site that hasn't proved the
relevant bound — modelling the Solana convention of `checked_add` /
`checked_sub` returning `Err` on overflow, but at the type level.

## Main definitions

* `Solanalib.Account` — the five-field on-chain account record.
* `Solanalib.Account.credit` — credit lamports, requires `lhs + rhs < 2^64`.
* `Solanalib.Account.debit`  — debit lamports, requires `amount ≤ balance`.

## Main statements

Projection `@[simp]` lemmas for every field of every operation, so `simp`
can chain through `.field` accesses uniformly. The `credit_lamports_toNat`
and `debit_lamports_toNat` variants drop the result into `Nat` for
conservation-style reasoning where `omega` does the heavy lifting.
-/

namespace Solanalib

/-- A Solana account: lamport balance, owning program, data blob,
executable flag, and rent epoch. -/
@[ext]
structure Account where
  /-- The number of lamports held by this account (u64 on chain). -/
  lamports : Lamports
  /-- The program that owns this account and is authorised to mutate it. -/
  owner : Pubkey
  /-- The opaque data the account holds. Interpretation is owner-specific. -/
  data : ByteArray
  /-- True if this account is a program (BPF binary), false for data. -/
  executable : Bool
  /-- Slot at which rent next becomes due. -/
  rentEpoch : UInt64
  deriving Repr, DecidableEq

namespace Account

/-- Credit `amount` lamports to an account.

Requires a proof `h` that the resulting balance fits in `u64`, so the
underlying `UInt64` addition can never silently wrap. This mirrors what
production Solana code does with `checked_add`, but lifted to a
compile-time obligation. -/
def credit (a : Account) (amount : Lamports)
    (_h : a.lamports.toNat + amount.toNat < UInt64.size) : Account :=
  { a with lamports := a.lamports + amount }

/-- Debit `amount` lamports from an account.

Requires a proof `h` that the account holds at least `amount` lamports,
so the underlying `UInt64` subtraction can never underflow / wrap. -/
def debit (a : Account) (amount : Lamports) (_h : amount ≤ a.lamports) : Account :=
  { a with lamports := a.lamports - amount }

/-! Projection `@[simp]` lemmas. The `_toNat` variants drop the equation
into `Nat`, which is what `omega` needs for conservation arithmetic. -/

@[simp] theorem credit_lamports (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (credit a n h).lamports = a.lamports + n := rfl
@[simp] theorem credit_owner (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (credit a n h).owner = a.owner := rfl
@[simp] theorem credit_data (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (credit a n h).data = a.data := rfl
@[simp] theorem credit_executable (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (credit a n h).executable = a.executable := rfl
@[simp] theorem credit_rentEpoch (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (credit a n h).rentEpoch = a.rentEpoch := rfl

@[simp] theorem debit_lamports (a : Account) (n : Lamports) (h : n ≤ a.lamports) :
    (debit a n h).lamports = a.lamports - n := rfl
@[simp] theorem debit_owner (a : Account) (n : Lamports) (h : n ≤ a.lamports) :
    (debit a n h).owner = a.owner := rfl
@[simp] theorem debit_data (a : Account) (n : Lamports) (h : n ≤ a.lamports) :
    (debit a n h).data = a.data := rfl
@[simp] theorem debit_executable (a : Account) (n : Lamports) (h : n ≤ a.lamports) :
    (debit a n h).executable = a.executable := rfl
@[simp] theorem debit_rentEpoch (a : Account) (n : Lamports) (h : n ≤ a.lamports) :
    (debit a n h).rentEpoch = a.rentEpoch := rfl

/-! Bridging to `Nat`. Conservation-style theorems use these to translate
`Lamports` (UInt64) operations into `UncheckedLamports` (Nat) where `omega`
can close the arithmetic. -/

theorem credit_lamports_toNat (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (credit a n h).lamports.toNat = a.lamports.toNat + n.toNat := by
  rw [credit_lamports, UInt64.toNat_add, Nat.mod_eq_of_lt h]

theorem debit_lamports_toNat (a : Account) (n : Lamports) (h : n ≤ a.lamports) :
    (debit a n h).lamports.toNat = a.lamports.toNat - n.toNat := by
  rw [debit_lamports, UInt64.toNat_sub_of_le _ _ h]

end Account
end Solanalib
