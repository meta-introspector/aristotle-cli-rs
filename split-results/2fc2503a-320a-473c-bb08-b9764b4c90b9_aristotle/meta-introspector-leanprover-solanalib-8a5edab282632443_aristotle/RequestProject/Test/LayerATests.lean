/-
Copyright (c) 2026 Solana Foundation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Solanalib Contributors
-/
import RequestProject.Account.Basic
import RequestProject.Instruction.Basic

/-!
# Layer A regression tests

`example`-style assertions pinning the public API of Layer A (Pubkey,
expanded Account, Instruction, AccountMeta). Each test passes iff it
type-checks, so any breaking change to a public signature surfaces on
the next CI build.
-/

namespace SolanalibTest.LayerA

open Solanalib

section Pubkey

/-- Pubkey equality is decidable via `deriving DecidableEq`. -/
example : (⟨ByteArray.empty⟩ : Pubkey) = ⟨ByteArray.empty⟩ := rfl

/-- Two pubkeys with different bytes are distinguishable. -/
example : (⟨ByteArray.empty⟩ : Pubkey) ≠ ⟨(ByteArray.mk #[1])⟩ := by
  intro h
  exact ByteArray.empty_ne_push (congrArg Pubkey.bytes h)
where
  /-- Helper: an empty `ByteArray` differs from a singleton. -/
  ByteArray.empty_ne_push : (ByteArray.empty : ByteArray) ≠ (ByteArray.mk #[1]) := by
    decide

end Pubkey

section Account

/-- `credit` preserves the `owner` field. -/
example (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (Account.credit a n h).owner = a.owner := rfl

/-- `credit` preserves the `data` field. -/
example (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (Account.credit a n h).data = a.data := rfl

/-- `credit` preserves the `executable` field. -/
example (a : Account) (n : Lamports)
    (h : a.lamports.toNat + n.toNat < UInt64.size) :
    (Account.credit a n h).executable = a.executable := rfl

/-- `debit` preserves the `owner` field. -/
example (a : Account) (n : Lamports) (h : n ≤ a.lamports) :
    (Account.debit a n h).owner = a.owner := rfl

end Account

section Instruction

/-- An instruction with no accounts has no signers and no writables. -/
example (pid : Pubkey) (d : ByteArray) :
    let ix : Instruction := ⟨pid, [], d⟩
    ix.signers = [] ∧ ix.writables = [] := by
  simp [Instruction.signers, Instruction.writables]

/-- Concrete: `signers` extracts only the meta entries marked `isSigner`. -/
example
    (p1 p2 : Pubkey)
    (d : ByteArray) :
    let m1 : AccountMeta := ⟨p1, true,  false⟩      -- signer, read-only
    let m2 : AccountMeta := ⟨p2, false, true⟩       -- writable, non-signer
    let ix : Instruction := ⟨p1, [m1, m2], d⟩
    ix.signers = [p1] := by
  simp [Instruction.signers]

end Instruction

end SolanalibTest.LayerA
