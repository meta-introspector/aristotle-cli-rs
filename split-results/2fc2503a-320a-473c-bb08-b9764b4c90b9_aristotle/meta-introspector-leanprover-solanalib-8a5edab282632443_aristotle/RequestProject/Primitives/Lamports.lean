/-
Copyright (c) 2026 Solana Foundation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Solanalib Contributors
-/
import RequestProject.Init

/-!
# Lamports

The native unit of value on Solana. Two parallel names, used for different
reasoning layers:

* `Lamports`           — the strict on-chain u64 representation. Use this in
                         `Account` fields, instruction payloads, and any
                         signature that describes real on-chain state.
                         Operations on `Lamports` are u64-modular: a `credit`
                         that pushes past `2^64 - 1` wraps. To prevent that,
                         operations declare overflow / underflow preconditions.
* `LamportsUnchecked`  — an unbounded `Nat`. Use this for algebraic /
                         conservation reasoning where the u64 bound is
                         irrelevant. `omega` and all of Mathlib's `Nat` simp
                         set work on `LamportsUnchecked` without ceremony.

The bridge is `UInt64.toNat : Lamports → LamportsUnchecked`. Theorems about
on-chain behaviour are typically stated against `Lamports` and reduced — via
`.toNat` — to `LamportsUnchecked` for the arithmetic step.

## Main definitions

* `Lamports` — `UInt64`, the strict on-chain representation.
* `LamportsUnchecked` — `Nat`, the unbounded algebraic representation.
* `Solanalib.Lamports.perSol` — the number of lamports in one SOL.
-/

namespace Solanalib.Lamports

/-- The number of lamports in one SOL. -/
def perSol : UInt64 := 1_000_000_000

end Solanalib.Lamports

/-- A lamport count, with the strict on-chain u64 representation.

`Lamports` arithmetic is u64-modular (wraps at `2^64`); operations that could
overflow or underflow carry an explicit precondition. For abstract reasoning
that doesn't care about the bound, use `LamportsUnchecked` instead. -/
notation "Lamports" => UInt64

/-- An unbounded lamport count for abstract reasoning.

A plain `Nat`, so `omega` and Mathlib's `Nat` simp lemmas work without any
unfolding ceremony. Use this in conservation theorems and other algebraic
results where the u64 bound is a separate concern handled at the encoding
layer. Bridge to `Lamports` via `UInt64.toNat` / `UInt64.ofNat`. -/
notation "LamportsUnchecked" => Nat
