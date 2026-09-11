/-
# Representation Ring Structure and the rowSum Homomorphism

## Overview

The "rowSum" functional — the total p-adic valuation mass of an irrep's
dimension, summed over the 15 supersingular primes — is not just an ad hoc
cost function. It is a **monoid homomorphism** from the multiplicative monoid
of positive integers to `(ℕ, +)`.

Since `dim(ρ ⊗ σ) = dim(ρ) · dim(σ)`, the rowSum is additive under
tensor product: `rowSum(ρ ⊗ σ) = rowSum(ρ) + rowSum(σ)`.

Similarly, the prime support (the set of supersingular primes dividing the
dimension) satisfies `support(ρ ⊗ σ) = support(ρ) ∪ support(σ)`.

These two facts — **cost additivity** and **support union** under tensor
product — are what make the TSP optimality problem well-structured.

## What this file formalizes

1. **Valuation additivity** (`totalVal_mul`): For any finite set of primes S,
   `Σ_{p ∈ S} v_p(ab) = Σ_{p ∈ S} v_p(a) + Σ_{p ∈ S} v_p(b)`.
   This is the general number-theoretic fact underlying rowSum additivity.

2. **Support union** (`primeFactors_mul`): The set of prime factors of `a · b`
   is the union of those of `a` and `b` (restated from Mathlib).

3. **Tensor product predictions**: If irreps 2 and 32 were tensored:
   - rowSum of product = 6 + 16 = 22 (full coverage at minimum cost)
   - support of product = full set (all 15 supersingular primes)

4. **The rowSum gap**: The gap between 7 and 8 in nonzero rowSums is
   formalized as an exhaustive fact about the data, with the structural
   consequence for the `four_plus_ge_22` bound made explicit.

5. **Fiber analysis**: The 4-element fiber over full support (irreps
   {116, 149, 164, 187} with rowSums {23, 26, 24, 28}) is the largest
   fiber in the support quotient. The cheapest element (irrep 116, cost 23)
   is exactly the cheapest single-irrep cover.

## On irrep 32 (χ₃₃ in ATLAS notation)

Irrep 32 (0-indexed from OEIS A001379) has:
- Dimension: 31,569,817,307,122,699,605 ≈ 3.16 × 10¹⁹
- Factorization: 3² · 5 · 7 · 11 · 13² · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
- rowSum: 16
- Support: 14 of 15 supersingular primes (all except 2)

In the ATLAS of finite groups, this corresponds to χ₃₃ (1-indexed). Its
dimension places it among the moderate-sized Monster irreps. The remarkable
property — covering 14 of 15 supersingular primes while missing only 2 —
makes it uniquely complementary to irrep 2 (which covers {2, 31, 41, 59, 71}).
Their pairing as the unique optimal cover is a consequence of irrep 32's
near-universal prime coverage combined with its relatively low rowSum of 16.

The factorization 3² · 5 · 7 · 11 · 13² · 17 · 19 · 23 · 29 · 31 · 41 · 47 · 59 · 71
is notable: every supersingular prime except 2 appears, and only 3 and 13
appear with multiplicity > 1. The total exponent count of 16 is remarkably
low for a number with 14 distinct prime factors.
-/

import Mathlib
import RequestProject.MonsterTSP
import RequestProject.MonsterSheaf

namespace MonsterRepRing

open MonsterSheaf

/-! ## General Number Theory: Valuation Additivity

The total p-adic valuation mass (sum of v_p over a set of primes) is
completely additive: it converts multiplication to addition.

This is the number-theoretic foundation for the representation ring
interpretation of rowSum. -/

/-- The total factorization mass over any set of primes is additive under
    multiplication. This is the general principle behind rowSum additivity:
    `rowSum(ρ ⊗ σ) = rowSum(ρ) + rowSum(σ)` when `dim(ρ ⊗ σ) = dim(ρ) · dim(σ)`. -/
theorem totalVal_mul (S : Finset ℕ) (a b : ℕ) (ha : a ≠ 0) (hb : b ≠ 0) :
    S.sum (a * b).factorization = S.sum a.factorization + S.sum b.factorization := by
  rw [Nat.factorization_mul ha hb]
  simp [Finsupp.coe_add, Pi.add_apply, Finset.sum_add_distrib]

/-- The prime factors of a product are the union of the prime factors of
    the multiplicands. This is the support union property:
    `support(ρ ⊗ σ) = support(ρ) ∪ support(σ)`. -/
theorem primeFactors_mul (a b : ℕ) (ha : a ≠ 0) (hb : b ≠ 0) :
    (a * b).primeFactors = a.primeFactors ∪ b.primeFactors :=
  Nat.primeFactors_mul ha hb

/-- The factorization of a product at any specific prime is the sum of
    the individual factorizations. -/
theorem factorization_mul_apply (a b : ℕ) (p : ℕ) (ha : a ≠ 0) (hb : b ≠ 0) :
    (a * b).factorization p = a.factorization p + b.factorization p := by
  simp [Nat.factorization_mul ha hb, Finsupp.coe_add]

/-! ## The rowSum Gap

Among the 194 Monster irreps, nonzero rowSums cluster: there are values
at 3, 6, 7, 7 (the four cheapest nonzero), then a gap, with the next
cheapest at 9. This gap is what makes the `four_plus_ge_22` bound clean. -/

/-- The rowSum gap: every nonzero rowSum is either ≤ 7 or ≥ 9.
    (In fact, the only values ≤ 7 are 3, 6, 7, 7.) -/
theorem rowSum_gap_refined : ∀ i : Fin 194,
    irrepRowSum i = 0 ∨ irrepRowSum i = 3 ∨ irrepRowSum i = 6 ∨
    irrepRowSum i = 7 ∨ irrepRowSum i ≥ 9 := by
  native_decide

/-- No irrep has rowSum equal to 1, 2, 4, 5, or 8. -/
theorem rowSum_forbidden_values : ∀ i : Fin 194,
    irrepRowSum i ≠ 1 ∧ irrepRowSum i ≠ 2 ∧
    irrepRowSum i ≠ 4 ∧ irrepRowSum i ≠ 5 ∧
    irrepRowSum i ≠ 8 := by
  native_decide

/-- The four cheapest nonzero irreps are exactly {1, 2, 3, 5} with
    rowSums {3, 6, 7, 7}. The gap above 7 (no value 8) is crucial
    for the proof that 4+ irreps cost ≥ 22. -/
theorem cheapest_nonzero_enum :
    irrepRowSum ⟨1, by omega⟩ = 3 ∧
    irrepRowSum ⟨2, by omega⟩ = 6 ∧
    irrepRowSum ⟨3, by omega⟩ = 7 ∧
    irrepRowSum ⟨5, by omega⟩ = 7 ∧
    (∀ i : Fin 194, irrepRowSum i > 0 → irrepRowSum i < 9 →
      i = ⟨1, by omega⟩ ∨ i = ⟨2, by omega⟩ ∨
      i = ⟨3, by omega⟩ ∨ i = ⟨5, by omega⟩) := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide, ?_⟩
  native_decide

/-! ## Tensor Product Predictions

If we tensor irreps 2 and 32 (multiply their dimensions), the resulting
representation would have:
- rowSum = 6 + 16 = 22 (by valuation additivity)
- support = all 15 supersingular primes (by support union)

This tensor product is NOT one of the 194 irreducible representations
(it decomposes into a sum of irreps), but its dimension properties follow
from general principles. -/

/-- The tensor product of irreps 2 and 32 would have rowSum 22
    (by additivity of the total valuation functional). -/
theorem tensor_2_32_rowSum :
    irrepRowSum ⟨2, by omega⟩ + irrepRowSum ⟨32, by omega⟩ = 22 :=
  (achievable_22).1

/-- The tensor product of irreps 2 and 32 would cover all 15 primes
    (by support union). -/
theorem tensor_2_32_full_support :
    primeSupport ⟨2, by omega⟩ ∪ primeSupport ⟨32, by omega⟩ = Finset.univ :=
  pair_2_32_support_union

/-- Irrep 32's near-universal coverage: it covers 14 of 15 primes.
    The single missing prime (index 0 = prime 2) is the smallest
    supersingular prime. -/
theorem irrep32_coverage :
    (primeSupport ⟨32, by omega⟩).card = 14 ∧
    (Finset.univ \ primeSupport ⟨32, by omega⟩).card = 1 := by
  constructor <;> native_decide

/-- Irrep 2's sparse but strategic coverage: exactly 5 primes,
    including the crucial prime 2 that irrep 32 misses. -/
theorem irrep2_coverage :
    (primeSupport ⟨2, by omega⟩).card = 5 ∧
    -- Irrep 2 covers the prime that irrep 32 misses
    (⟨0, by omega⟩ : Fin 15) ∈ primeSupport ⟨2, by omega⟩ ∧
    (⟨0, by omega⟩ : Fin 15) ∉ primeSupport ⟨32, by omega⟩ := by
  refine ⟨by native_decide, by native_decide, by native_decide⟩

/-! ## Fiber Structure over Full Support

The 4-element fiber over `Finset.univ` — irreps {116, 149, 164, 187} —
represents four distinct "sections" over the maximal point in the support
poset. They all factor through every supersingular prime but with different
exponent distributions.

In the sheaf language: the stalk at the generic point has 4 distinct elements.
The cheapest (irrep 116, rowSum 23) is exactly the unique cheapest single-irrep
cover. The others are "heavier" sections at the same location. -/

/-- The four full-support irreps and their rowSums, ordered by cost. -/
theorem full_fiber_ordered :
    irrepRowSum ⟨116, by omega⟩ = 23 ∧  -- cheapest single cover
    irrepRowSum ⟨164, by omega⟩ = 24 ∧  -- second cheapest
    irrepRowSum ⟨149, by omega⟩ = 26 ∧  -- third
    irrepRowSum ⟨187, by omega⟩ = 28    -- most expensive
    := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide⟩

/-- Irrep 116 is the unique cheapest single-irrep full cover.
    It beats the pair {2, 32} in single-irrep cost (23 vs impossible-in-one)
    but loses to the pair in total cost (23 > 22). -/
theorem irrep116_cheapest_single :
    ∀ i : Fin 194, irrepBitmask i = fullBitmask →
    irrepRowSum i ≥ irrepRowSum ⟨116, by omega⟩ := by
  native_decide

/-- The full-support fiber has strictly distinct rowSums —
    all four sections are genuinely different in cost. -/
theorem full_fiber_all_distinct_costs :
    irrepRowSum ⟨116, by omega⟩ ≠ irrepRowSum ⟨149, by omega⟩ ∧
    irrepRowSum ⟨116, by omega⟩ ≠ irrepRowSum ⟨164, by omega⟩ ∧
    irrepRowSum ⟨116, by omega⟩ ≠ irrepRowSum ⟨187, by omega⟩ ∧
    irrepRowSum ⟨149, by omega⟩ ≠ irrepRowSum ⟨164, by omega⟩ ∧
    irrepRowSum ⟨149, by omega⟩ ≠ irrepRowSum ⟨187, by omega⟩ ∧
    irrepRowSum ⟨164, by omega⟩ ≠ irrepRowSum ⟨187, by omega⟩ := by
  refine ⟨by native_decide, by native_decide, by native_decide,
          by native_decide, by native_decide, by native_decide⟩

/-! ## Bitmask Properties of Irrep 32

Irrep 32 has bitmask 32766 = 0b111111111111110, which is `fullBitmask - 1`.
This means every bit is set except the least significant (prime 2 at index 0). -/

/-- Irrep 32's bitmask is exactly fullBitmask with bit 0 cleared. -/
theorem irrep32_bitmask :
    irrepBitmask ⟨32, by omega⟩ = fullBitmask - 1 := by native_decide

/-- Irrep 32 is the unique irrep with support of size 14 and rowSum 16. -/
theorem irrep32_unique :
    ∀ i : Fin 194,
    (primeSupport i).card = 14 → irrepRowSum i = 16 →
    i = ⟨32, by omega⟩ := by
  native_decide

/-- The number of irreps with support size ≥ 14 (covering 14 or 15 of 15 primes). -/
theorem near_full_support_count :
    (Finset.univ.filter (fun i : Fin 194 => (primeSupport i).card ≥ 14)).card = 14 := by
  native_decide

/-- Among irreps with support ≥ 14, irrep 32 has the smallest rowSum. -/
theorem irrep32_cheapest_near_full :
    ∀ i : Fin 194, (primeSupport i).card ≥ 14 →
    irrepRowSum i ≥ irrepRowSum ⟨32, by omega⟩ := by
  native_decide

/-! ## The Complementary Pair Structure

The unique optimal pair {2, 32} has a striking complementary structure:
- Irrep 2's support ∩ irrep 32's support = 4 primes (the "overlap")
- Irrep 2 contributes 1 unique prime (prime 2)
- Irrep 32 contributes 10 unique primes
- Together: 1 + 4 + 10 = 15 primes

The overlap is not empty — this is NOT a partition into disjoint supports.
Rather, the 4 shared primes contribute their valuations from both irreps
(which would add under tensor product). -/

/-- The overlap primes: exactly {31, 41, 59, 71} (indices {10, 11, 13, 14}). -/
theorem overlap_is_large_primes :
    primeSupport ⟨2, by omega⟩ ∩ primeSupport ⟨32, by omega⟩ =
    {⟨10, by omega⟩, ⟨11, by omega⟩, ⟨13, by omega⟩, ⟨14, by omega⟩} := by
  native_decide

/-- Irrep 2's unique contribution: only prime 2 (index 0). -/
theorem irrep2_unique_prime :
    primeSupport ⟨2, by omega⟩ \ primeSupport ⟨32, by omega⟩ =
    {⟨0, by omega⟩} := by
  native_decide

/-- The complementarity ratio: irrep 32 contributes 10 unique primes
    vs irrep 2's 1 unique prime, with 4 shared. -/
theorem complementarity_ratio :
    (primeSupport ⟨2, by omega⟩ \ primeSupport ⟨32, by omega⟩).card = 1 ∧
    (primeSupport ⟨32, by omega⟩ \ primeSupport ⟨2, by omega⟩).card = 10 ∧
    (primeSupport ⟨2, by omega⟩ ∩ primeSupport ⟨32, by omega⟩).card = 4 := by
  refine ⟨by native_decide, by native_decide, by native_decide⟩

/-! ## Distribution of rowSums

The distribution of rowSums reveals the structure of the optimization
landscape. The rowSum histogram shows clustering around certain values. -/

/-- The rowSum distribution: count of irreps at each rowSum value. -/
theorem rowSum_at_zero : (Finset.univ.filter (fun i : Fin 194 => irrepRowSum i = 0)).card = 1 := by
  native_decide

theorem rowSum_at_three : (Finset.univ.filter (fun i : Fin 194 => irrepRowSum i = 3)).card = 1 := by
  native_decide

theorem rowSum_at_six : (Finset.univ.filter (fun i : Fin 194 => irrepRowSum i = 6)).card = 1 := by
  native_decide

theorem rowSum_at_seven : (Finset.univ.filter (fun i : Fin 194 => irrepRowSum i = 7)).card = 2 := by
  native_decide

/-- The minimum nonzero rowSum (3) is achieved uniquely by irrep 1,
    whose dimension is 196883 = 47 · 59 · 71.
    This is the famous McKay dimension — the smallest nontrivial
    Monster irrep, whose connection to the j-invariant coefficient
    j(τ) = q⁻¹ + 196884q + … (with 196884 = 196883 + 1) launched
    Monstrous Moonshine. -/
theorem mckay_irrep :
    irrepRowSum ⟨1, by omega⟩ = 3 ∧
    (∀ i : Fin 194, irrepRowSum i > 0 → irrepRowSum i ≥ 3) := by
  exact ⟨by native_decide, min_nonzero_rowSum_ge_3⟩

/-! ## The Tensor Product ρ₂ ⊗ ρ₃₂: Full Support at Minimum Cost

The central object connecting the optimal pair to the representation ring:
the tensor product of irreps 2 and 32. By `totalVal_mul` and `primeFactors_mul`,
this (reducible) representation has:
- **rowSum 22** (= 6 + 16, additive under ⊗)
- **Full support** (= all 15 supersingular primes, union under ⊗)

It is the unique cheapest element of Rep(M) with full prime support that
factors as a tensor product of two irreducibles. -/

/-- The tensor product of irreps 2 and 32 has full support and minimum cost.
    This is the representation-ring incarnation of the TSP optimality:
    the optimal pair {2, 32} certifies an element of Rep(M) with full
    support and rowSum 22. -/
theorem tensor_2_32_full_support_min_cost :
    -- Full support (union of supports = Fin 15)
    primeSupport ⟨2, by omega⟩ ∪ primeSupport ⟨32, by omega⟩ = Finset.univ ∧
    -- Minimum pair cost
    irrepRowSum ⟨2, by omega⟩ + irrepRowSum ⟨32, by omega⟩ = 22 ∧
    -- No cheaper pair achieves full support
    (∀ i j : Fin 194, primeSupport i ∪ primeSupport j = Finset.univ →
      irrepRowSum i + irrepRowSum j ≥ 22) ∧
    -- Unique optimal pair (up to order)
    (∀ i j : Fin 194, primeSupport i ∪ primeSupport j = Finset.univ →
      irrepRowSum i + irrepRowSum j = 22 →
      ({i, j} : Finset (Fin 194)) = {⟨2, by omega⟩, ⟨32, by omega⟩}) := by
  refine ⟨pair_2_32_support_union, (achievable_22).1, cover_pair_cost_lower_bound, ?_⟩
  intro i j hcov hcost
  have hbm := (bitmask_iff_support_union i j).mpr hcov
  have := unique_optimal_pair i j hbm hcost
  rcases this with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> simp [Finset.pair_comm]

/-! ## Open Question: Irreducible Decomposition of ρ₂ ⊗ ρ₃₂

The tensor product ρ₂ ⊗ ρ₃₂ is a (reducible) Monster representation of
dimension dim(ρ₂) · dim(ρ₃₂). It decomposes as a direct sum of irreducibles:

    ρ₂ ⊗ ρ₃₂ = ⊕ᵢ nᵢ · ρᵢ

where the multiplicities nᵢ are determined by the character inner products:

    nᵢ = ⟨χ₂ · χ₃₂, χᵢ⟩ = (1/|M|) Σ_{g ∈ M} χ₂(g) · χ₃₂(g) · χᵢ(g)⁻¹

**The key question**: Does irrep 116 (the cheapest single-irrep full cover,
rowSum 23) appear in this decomposition? I.e., is n₁₁₆ > 0?

If yes, the optimal pair cover {2, 32} "contains" the optimal single cover
via the representation ring — the tensor product of the pair produces
(among other things) the cheapest individual full-cover irrep.

More generally: do any of {116, 149, 164, 187} (the 4 full-support irreps)
appear? If so, there is a functorial connection between pair and single
covers mediated by the tensor product.

Resolving this requires the full Monster character table (not just dimensions),
which is available in the ATLAS but not yet formalized in Lean/Mathlib.

-- TODO: Given the full character table, formalize:
-- theorem irrep116_in_tensor_decomp :
--     ⟨χ₂ · χ₃₂, χ₁₁₆⟩ > 0 := by ...
--
-- This would establish that the optimal pair "generates" the optimal
-- singleton via the ring structure of Rep(M).
-/

end MonsterRepRing
