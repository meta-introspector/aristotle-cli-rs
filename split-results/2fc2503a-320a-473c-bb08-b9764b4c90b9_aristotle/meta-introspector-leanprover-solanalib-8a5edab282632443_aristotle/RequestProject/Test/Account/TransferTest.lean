/-
Copyright (c) 2026 Solana Foundation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Solanalib Contributors
-/
import RequestProject.Account.Transfer

/-!
# Regression tests for `Solanalib.Account.Transfer`

Each `example` here passes iff the file type-checks. The tests pin
specific shape-preserving properties of the bounded `Lamports = UInt64`
model: if `credit_lamports`, `debit_lamports`, or the `_toNat` bridge
lemmas regress, CI catches it.

Note the proofs lean on `.toNat` to drop into `LamportsUnchecked` (Nat)
land where `omega` works; this is the canonical pattern for
conservation-style reasoning about UInt64-backed Lamports.
-/

namespace SolanalibTest.Account

open Solanalib Solanalib.Account

/-- `omega` works freely over `LamportsUnchecked` (Nat). -/
example (a b : LamportsUnchecked) (h : a ≤ b) : b - a + a = b := by omega

/-- Bridge from Lamports (UInt64) to LamportsUnchecked (Nat) is well-typed. -/
example (n : Lamports) : n.toNat = n.toNat := rfl

/-- Crediting zero lamports leaves an account unchanged. The trivial
overflow proof comes from `a.lamports.toNat < UInt64.size`. -/
theorem credit_zero (a : Account) (h : a.lamports.toNat + (0 : Lamports).toNat < UInt64.size) :
    Account.credit a 0 h = a := by
  ext <;> simp [Account.credit]

/-- Debiting zero lamports leaves an account unchanged. The underflow
proof is `0 ≤ a.lamports`, which is `bot_le`. -/
theorem debit_zero (a : Account) (h : (0 : Lamports) ≤ a.lamports) :
    Account.debit a 0 h = a := by
  ext <;> simp [Account.debit]

/-- Crediting then immediately debiting the same amount is a no-op (at
the `.toNat` level — UInt64-level equality also holds modulo bounds). -/
theorem credit_debit_cancel_toNat
    (a : Account) (m : Lamports)
    (h_cred : a.lamports.toNat + m.toNat < UInt64.size)
    (h_deb  : m ≤ (Account.credit a m h_cred).lamports) :
    (Account.debit (Account.credit a m h_cred) m h_deb).lamports.toNat
      = a.lamports.toNat := by
  rw [debit_lamports_toNat, credit_lamports_toNat]
  -- Goal: (a.lamports.toNat + m.toNat) - m.toNat = a.lamports.toNat
  omega

/-- After a transfer of `m` lamports, the source has exactly `m` fewer
at the `.toNat` level. -/
theorem transfer_source_loses_m
    (src dst : Account) (m : Lamports)
    (h_under : m ≤ src.lamports)
    (h_over  : dst.lamports.toNat + m.toNat < UInt64.size) :
    src.lamports.toNat - (transfer src dst m h_under h_over).source.lamports.toNat
      = m.toNat := by
  have h_under_nat : m.toNat ≤ src.lamports.toNat :=
    UInt64.le_iff_toNat_le.mp h_under
  simp only [transfer]
  rw [debit_lamports_toNat]
  omega

end SolanalibTest.Account
