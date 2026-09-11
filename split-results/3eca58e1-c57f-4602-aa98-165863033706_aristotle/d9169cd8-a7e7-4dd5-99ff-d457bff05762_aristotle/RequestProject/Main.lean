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

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The "42-Logic" Sphenic Composition

The architecture essay (Section 6) makes one concrete, verifiable mathematical claim:
that `42` is a **sphenic number**, i.e. the product of three *distinct* primes,
`2 * 3 * 7 = 42`.

A sphenic number is, by the standard definition, a squarefree natural number that is the
product of exactly three primes (equivalently: squarefree with exactly three distinct prime
factors). We formalize and prove both the explicit factorization and this characterization.
-/

/-- **Explicit sphenic decomposition of 42.** Each of `2, 3, 7` is prime, they are pairwise
distinct, and their product is `42`. -/
theorem fortyTwo_prime_decomposition :
    Nat.Prime 2 ∧ Nat.Prime 3 ∧ Nat.Prime 7 ∧
      (2 ≠ 3 ∧ 2 ≠ 7 ∧ 3 ≠ 7) ∧ 2 * 3 * 7 = 42 := by
  refine ⟨?_, ?_, ?_, ⟨?_, ?_, ?_⟩, ?_⟩ <;> norm_num

/-- The three distinct prime factors of `42` are precisely `{2, 3, 7}`. -/
theorem fortyTwo_primeFactors : (42 : ℕ).primeFactors = {2, 3, 7} := by
  simp [Nat.primeFactors]

/-- `42` is squarefree. -/
theorem fortyTwo_squarefree : Squarefree (42 : ℕ) := by
  have h : (42 : ℕ) = 2 * (3 * 7) := by norm_num
  rw [h, Nat.squarefree_mul_iff]
  refine ⟨by norm_num, Nat.prime_two.squarefree, ?_⟩
  rw [Nat.squarefree_mul_iff]
  exact ⟨by norm_num, (by norm_num : Nat.Prime 3).squarefree,
    (by norm_num : Nat.Prime 7).squarefree⟩

/-- **42 is sphenic.** It is squarefree and has exactly three distinct prime factors. -/
theorem fortyTwo_sphenic :
    Squarefree (42 : ℕ) ∧ (42 : ℕ).primeFactors.card = 3 := by
  refine ⟨fortyTwo_squarefree, ?_⟩
  rw [fortyTwo_primeFactors]
  rfl
