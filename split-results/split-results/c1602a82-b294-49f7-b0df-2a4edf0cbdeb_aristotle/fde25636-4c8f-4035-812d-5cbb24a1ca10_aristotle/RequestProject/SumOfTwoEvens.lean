/-
# The Proof Linker: "Sum of Two Evens is Even"

The ZOS Proof Linker architecture carries formal proofs as low-level data.
The canonical example is the proof that the sum of two even numbers is even.

This file provides multiple formulations and proofs of this fundamental fact,
demonstrating the Lean4 "Proof Carrier" concept from the ZOS specification.
-/
import Mathlib

/-!
## Core Theorem: Sum of Two Evens
-/

/-- The sum of two even natural numbers is even. -/
theorem sum_of_two_evens (a b : ℕ) (ha : Even a) (hb : Even b) : Even (a + b) := by
  exact ha.add hb

/-- The sum of two even integers is even. -/
theorem sum_of_two_evens_int (a b : ℤ) (ha : Even a) (hb : Even b) : Even (a + b) := by
  exact ha.add hb

/-- Constructive version: given witnesses, produce a witness for the sum. -/
theorem sum_of_two_evens_explicit (a b : ℕ) (k₁ k₂ : ℕ)
    (ha : a = 2 * k₁) (hb : b = 2 * k₂) :
    a + b = 2 * (k₁ + k₂) := by
  omega

/-!
## The Proof Linker Concept

A `ProofLinker` bundles a high-level summary (the meme) with a low-level
carrier (the formal proof term). This is the core data structure of the
ZOS verification architecture.
-/

/-- A ProofLinker pairs a human-readable summary with a machine-verified proof. -/
structure ProofLinker (P : Prop) where
  /-- High-level human-readable description -/
  summary : String
  /-- The formal proof term -/
  proof : P

/-- The canonical ProofLinker for "sum of two evens is even". -/
def balanceMeme : ProofLinker (∀ a b : ℕ, Even a → Even b → Even (a + b)) :=
  { summary := "Balance: the sum of two even numbers is even"
    proof := fun _ _ ha hb => ha.add hb }
