/-
Copyright (c) 2026 Solana Foundation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Solanalib Contributors
-/
import RequestProject.Account.Basic

/-!
# Lamport transfers

A transfer moves lamports from one account to another. Two preconditions
are carried in the type signature, one per arithmetic edge:

* `h_under : amount ≤ src.lamports` — the source has enough to send.
* `h_over  : dst.lamports.toNat + amount.toNat < UInt64.size` — the
  destination won't overflow `u64` after the credit.

Both bounds together guarantee the underlying `UInt64` add and sub
operations do not wrap, so the conservation theorem holds in the
"natural" arithmetic sense.

## Main definitions

* `TransferResult` — pair of (`source`, `destination`) accounts after a
  transfer.
* `transfer` — the operation, taking both bounds proofs explicitly.

## Main statements

* `transfer_preserves_total` — total lamports (as `Nat`, via `.toNat`)
  across source and destination is invariant under `transfer`.
  Conservation is stated in `LamportsUnchecked` (Nat) world so `omega`
  closes the arithmetic; the bridge from `Lamports` lives in
  `Account.credit_lamports_toNat` and `Account.debit_lamports_toNat`.
-/

namespace Solanalib.Account

/-- The result of a `transfer`: source and destination after lamports move. -/
@[ext]
structure TransferResult where
  /-- The source account, with `amount` lamports debited. -/
  source : Account
  /-- The destination account, with `amount` lamports credited. -/
  destination : Account
  deriving Repr

/-- Move `amount` lamports from `src` to `dst`.

Carries two preconditions in its type:
* `h_under` — `src` has at least `amount` lamports (no underflow on debit).
* `h_over`  — adding `amount` to `dst` does not overflow `u64` (no wrap on credit).

The compiler will reject any call site that hasn't proved both. -/
def transfer (src dst : Account) (amount : Lamports)
    (h_under : amount ≤ src.lamports)
    (h_over  : dst.lamports.toNat + amount.toNat < UInt64.size) : TransferResult :=
  { source := src.debit amount h_under,
    destination := dst.credit amount h_over }

/-- **Lamport conservation.** A transfer neither creates nor destroys
lamports: the `.toNat` sum across `source` and `destination` after the
operation equals the original `.toNat` sum.

The statement uses `.toNat` (i.e. `LamportsUnchecked = Nat`) so the
arithmetic is unbounded — that's what `omega` reasons about. The
`UInt64`-level operations are well-defined by the `h_under` / `h_over`
preconditions; conservation in u64 arithmetic *also* holds, but is a
corollary not stated here. -/
theorem transfer_preserves_total
    (src dst : Account) (amount : Lamports)
    (h_under : amount ≤ src.lamports)
    (h_over  : dst.lamports.toNat + amount.toNat < UInt64.size) :
    (transfer src dst amount h_under h_over).source.lamports.toNat
      + (transfer src dst amount h_under h_over).destination.lamports.toNat
      = src.lamports.toNat + dst.lamports.toNat := by
  have h_under_nat : amount.toNat ≤ src.lamports.toNat :=
    UInt64.le_iff_toNat_le.mp h_under
  simp only [transfer]
  rw [debit_lamports_toNat, credit_lamports_toNat]
  omega

end Solanalib.Account
