/-
# Monster Moonshine: Supersingular Prime Valuations of Irrep Dimensions

This file formalizes key combinatorial facts about the p-adic valuations of
Monster group irreducible representation dimensions, restricted to the 15
supersingular primes {2,3,5,7,11,13,17,19,23,29,31,41,47,59,71}.

Each irrep (indexed 0–193 following OEIS A001379) has a "valuation vector"
recording the exponent of each supersingular prime in the factorization of
its dimension.

## Main results

- `irreps_11_13_cover_all_primes`: Irreps 11 and 13 together cover all 15
  supersingular primes (every prime appears with positive exponent in at
  least one of the two).
- `irreps_11_13_sum_eq_23`: Their combined exponent sum is 23.
- `irrep_0_trivial`: Irrep 0 is the trivial representation (all zeros).
- `irrep_1_trivector`: Irrep 1 lights up exactly {47, 59, 71}.
- `trade_1_to_2`: The "trade" from irrep 1 to irrep 2 sells 47, buys 2²,31,41.

## The Hero's Journey / TSP interpretation

Starting from irrep 0 (the trivial representation, all exponents zero),
the "fastest" way to reach a state where all 15 supersingular primes are
"lit" (have positive valuation) is via the product of irreps 11 and 13,
which together cover all 15 primes with minimal total cost 23.

Each irrep along the path 0 → 1 → 2 → … → 11 can be viewed as a
"FRACTRAN germ" — a multiplicative agent that buys and sells primes
as it traverses the Monster's representation graph.
-/

import Mathlib

/-! ## Supersingular primes -/

/-- The 15 supersingular primes, in order. -/
def supersingularPrimes : Fin 15 → ℕ :=
  ![2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71]

/-! ## Valuation vectors for selected Monster irreps

For each irrep index, the valuation vector gives the exponent of each
supersingular prime in the prime factorization of the irrep's dimension.
Prime order: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59, 71. -/

/-- Valuation vector for irrep 0 (trivial representation, dimension 1). -/
def v0 : Fin 15 → ℕ := ![0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

/-- Valuation vector for irrep 1. Lit primes: {47, 59, 71}. -/
def v1 : Fin 15 → ℕ := ![0,0,0,0,0,0,0,0,0,0,0,0,1,1,1]

/-- Valuation vector for irrep 2. Lit primes: {2, 31, 41, 59, 71}. -/
def v2 : Fin 15 → ℕ := ![2,0,0,0,0,0,0,0,0,0,1,1,0,1,1]

/-- Valuation vector for irrep 3. -/
def v3 : Fin 15 → ℕ := ![1,0,0,0,0,2,0,0,0,1,1,0,1,1,0]

/-- Valuation vector for irrep 4. -/
def v4 : Fin 15 → ℕ := ![2,0,0,1,1,0,0,0,1,1,1,1,0,0,1]

/-- Valuation vector for irrep 5. -/
def v5 : Fin 15 → ℕ := ![0,0,0,0,0,2,0,0,1,1,0,1,0,1,1]

/-- Valuation vector for irrep 6. -/
def v6 : Fin 15 → ℕ := ![1,1,0,0,1,0,0,1,0,1,0,1,1,1,1]

/-- Valuation vector for irrep 7. -/
def v7 : Fin 15 → ℕ := ![1,1,0,1,1,2,0,1,1,0,0,1,1,1,0]

/-- Valuation vector for irrep 8. -/
def v8 : Fin 15 → ℕ := ![0,6,0,1,0,2,1,1,0,0,1,0,0,1,1]

/-- Valuation vector for irrep 9. -/
def v9 : Fin 15 → ℕ := ![0,0,2,4,0,0,1,0,0,1,1,1,1,0,1]

/-- Valuation vector for irrep 10. -/
def v10 : Fin 15 → ℕ := ![0,3,0,1,1,0,1,0,1,1,0,1,1,1,1]

/-- Valuation vector for irrep 11: the "Initiate".
    Lit primes: {3, 11, 13, 17, 23, 29, 31, 41, 47, 59}. -/
def v11 : Fin 15 → ℕ := ![0,1,0,0,1,2,1,0,1,1,1,1,1,1,0]

/-- Valuation vector for irrep 12. -/
def v12 : Fin 15 → ℕ := ![0,0,0,4,1,2,0,0,0,1,0,1,1,1,1]

/-- Valuation vector for irrep 13: the "Wanderer".
    Lit primes: {2, 5, 7, 19, 23, 29, 31, 41, 47, 59, 71}. -/
def v13 : Fin 15 → ℕ := ![1,0,2,1,0,0,0,1,1,1,1,1,1,1,1]

/-! ## Row exponent sums -/

/-- Row exponent sum: total of all 15 exponents. -/
def rowSum (v : Fin 15 → ℕ) : ℕ := Finset.univ.sum v

theorem v11_sum : rowSum v11 = 11 := by native_decide
theorem v13_sum : rowSum v13 = 12 := by native_decide

/-! ## Coverage -/

/-- Two valuation vectors together cover all 15 primes if for each prime index,
    at least one vector has positive exponent. -/
def allCovered (v w : Fin 15 → ℕ) : Prop :=
  ∀ i : Fin 15, v i > 0 ∨ w i > 0

instance (v w : Fin 15 → ℕ) [DecidableEq ℕ] : Decidable (allCovered v w) :=
  Fintype.decidableForallFintype

/-- **Main theorem**: Irreps 11 and 13 together cover all 15 supersingular primes.

    This is the core fact enabling the "two-hero" strategy: instead of finding a
    single irrep that touches all primes, we can combine two complementary irreps. -/
theorem irreps_11_13_cover_all_primes : allCovered v11 v13 := by native_decide

/-- The combined exponent sum of irreps 11 and 13 is 23.
    Note: this is NOT the minimum cost for full coverage — irreps 2 and 32
    achieve full coverage with cost 22 (see MonsterTSP.lean for the proof). -/
theorem irreps_11_13_sum_eq_23 : rowSum v11 + rowSum v13 = 23 := by native_decide

/-! ## The Hero's Journey: Prime Trading Log

### Step 0 → 1: The First Spark
From the void (all zeros), three distant primes appear: 47, 59, 71.
These are the "trivector primes" — the outermost, lightest supersingular primes. -/

theorem irrep_0_trivial : ∀ i : Fin 15, v0 i = 0 := by native_decide

theorem irrep_1_trivector_primes :
    v1 12 = 1 ∧ v1 13 = 1 ∧ v1 14 = 1 ∧
    (∀ i : Fin 15, i.val < 12 → v1 i = 0) := by native_decide

/-! ### Step 1 → 2: Sell 47, Buy 2², 31, 41
The first real "trade": give up prime 47 in exchange for mass (2²),
an edge (31), and vision (41). Keep 59 and 71. -/

theorem trade_1_to_2 :
    -- 47 (index 12): sold (1 → 0)
    v1 12 = 1 ∧ v2 12 = 0 ∧
    -- 2 (index 0): bought (0 → 2)
    v1 0 = 0 ∧ v2 0 = 2 ∧
    -- 31 (index 10): bought (0 → 1)
    v1 10 = 0 ∧ v2 10 = 1 ∧
    -- 41 (index 11): bought (0 → 1)
    v1 11 = 0 ∧ v2 11 = 1 ∧
    -- 59 (index 13): kept
    v1 13 = 1 ∧ v2 13 = 1 ∧
    -- 71 (index 14): kept
    v1 14 = 1 ∧ v2 14 = 1 := by native_decide

/-! ### Step 2 → 3: Sell 2², 41, 71. Buy 13², 29, 47.
Trade mass for pattern (13²) and direction (29).
47 returns — the shard was merely lent, not lost. -/

theorem trade_2_to_3 :
    -- 2 (index 0): reduced (2 → 1)
    v2 0 = 2 ∧ v3 0 = 1 ∧
    -- 41 (index 11): sold (1 → 0)
    v2 11 = 1 ∧ v3 11 = 0 ∧
    -- 71 (index 14): sold (1 → 0)
    v2 14 = 1 ∧ v3 14 = 0 ∧
    -- 13 (index 5): bought (0 → 2)
    v2 5 = 0 ∧ v3 5 = 2 ∧
    -- 29 (index 9): bought (0 → 1)
    v2 9 = 0 ∧ v3 9 = 1 ∧
    -- 47 (index 12): bought (0 → 1)
    v2 12 = 0 ∧ v3 12 = 1 := by native_decide

/-! ### The full path from 0 to 11: prime accumulation

By irrep 11, the hero has accumulated a dense cluster of 10 primes:
{3, 11, 13, 17, 23, 29, 31, 41, 47, 59}.

Missing from irrep 11: {2, 5, 7, 19, 71}.
These are exactly the primes that irrep 13 (the Wanderer) carries.

Together, 11 ⊗ 13 covers everything. -/

/-- The primes missing from irrep 11 are exactly covered by irrep 13. -/
theorem complementarity :
    (∀ i : Fin 15, v11 i = 0 → v13 i > 0) ∧
    (∀ i : Fin 15, v13 i = 0 → v11 i > 0) := by native_decide

/-! ## Summary

The Monster's 194 irreducible representations, when viewed through their
supersingular prime valuations, form a 15-dimensional lattice.

The "hero's journey" from the trivial irrep (0) to full prime coverage
has optimal cost **22**, achievable by the pair of irreps {2, 32}
(see MonsterTSP.lean for the complete optimality proof).
The pair {11, 13} achieves cost 23, and irrep 116 alone also costs 23.

Each step 0 → 1 → 2 → … → 11 tells a story of prime trading:
buying and selling supersingular primes as the FRACTRAN germ navigates
the Monster's representation graph. -/
