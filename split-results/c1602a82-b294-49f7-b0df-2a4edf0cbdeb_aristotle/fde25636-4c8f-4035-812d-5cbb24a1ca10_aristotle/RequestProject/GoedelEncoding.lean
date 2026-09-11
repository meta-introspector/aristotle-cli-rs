/-
# Gödel Encoding for the Zero Ontology System

The ZOS uses Gödel encoding to map ontological states to unique natural numbers.
Uniqueness is guaranteed by the Fundamental Theorem of Arithmetic: every natural
number > 1 has a unique prime factorization.

This file formalizes:
  1. A Gödel encoding function mapping finite sequences to ℕ
  2. The "Lifted Table" concept for multi-layered interpretation
  3. The Fundamental Theorem of Arithmetic as the foundation
-/
import Mathlib

open Nat Finset BigOperators

/-!
## Gödel Encoding via Prime Products

A Gödel encoding maps a finite sequence of natural numbers `[e₀, e₁, ..., eₙ₋₁]`
to the product `p₀^e₀ * p₁^e₁ * ... * pₙ₋₁^eₙ₋₁` where `pᵢ` is the `i`-th prime.
-/

/-- The `n`-th prime number (0-indexed). Uses Mathlib's `Nat.nth` on the prime predicate. -/
noncomputable def nthPrime : ℕ → ℕ := Nat.nth Nat.Prime

theorem nthPrime_prime (n : ℕ) : Nat.Prime (nthPrime n) :=
  Nat.nth_mem_of_infinite Nat.infinite_setOf_prime n

/-- Gödel encode a finite list of exponents using prime products. -/
noncomputable def goedelEncode (exponents : List ℕ) : ℕ :=
  (exponents.zipIdx.map fun ⟨e, i⟩ => nthPrime i ^ e).prod

/-- The Gödel encoding of the empty list is 1 (the empty product). -/
theorem goedelEncode_nil : goedelEncode [] = 1 := by
  simp [goedelEncode]

/-!
## The Lifted Table Concept

The "Lifted Table" maps base primes to higher-order "lifted primes,"
enabling multi-layered interpretation of the same numerical substrate.
A prime assignment is simply a function ℕ → ℕ selecting which prime
to use at each position.
-/

/-- A PrimeAssignment selects which prime to use at each index position. -/
structure PrimeAssignment where
  /-- The prime to use at position `i` -/
  prime : ℕ → ℕ
  /-- Each assigned value is actually prime -/
  is_prime : ∀ i, Nat.Prime (prime i)
  /-- The assigned primes are pairwise distinct -/
  injective : Function.Injective prime

/-- Encode using a custom prime assignment (the "Lifted Table" generalization). -/
def liftedEncode (pa : PrimeAssignment) (exponents : List ℕ) : ℕ :=
  (exponents.zipIdx.map fun ⟨e, i⟩ => pa.prime i ^ e).prod

/-- The standard prime assignment uses the natural ordering of primes. -/
noncomputable def standardAssignment : PrimeAssignment where
  prime := nthPrime
  is_prime := nthPrime_prime
  injective := Nat.nth_injective Nat.infinite_setOf_prime

/-!
## Fundamental Theorem of Arithmetic (from Mathlib)

The uniqueness of prime factorization is the foundation of Gödel encoding's
injectivity. Mathlib provides this via the `UniqueFactorizationMonoid` instance on `ℕ`.
-/

/-- ℕ is a unique factorization domain (imported from Mathlib). -/
example : UniqueFactorizationMonoid ℕ := inferInstance

/-- Every nonzero natural number equals the product of its prime factorization.
    This is the mathematical foundation guaranteeing that distinct
    ontological states receive distinct Gödel numbers. -/
theorem unique_factorization_foundation (n : ℕ) (hn : n ≠ 0) :
    (n.factorization.prod fun p e => p ^ e) = n :=
  Nat.factorization_prod_pow_eq_self hn
