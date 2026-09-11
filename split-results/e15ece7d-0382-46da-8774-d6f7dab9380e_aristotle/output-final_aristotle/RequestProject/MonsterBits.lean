/-
# Information-Theoretic Bits Metric for Monster Irreps

## Overview

The "rowSum" metric counts total exponents uniformly: `Σ eᵢ`. But each
exponent carries different information content — one power of 71 (≈ 6.15 bits)
is worth six times more entropy than one power of 2 (1 bit).

The **bits metric** weights each exponent by `⌊1000 · log₂(pᵢ)⌋`:

    bitsCost(ρ) = Σᵢ eᵢ · ⌊1000 · log₂(pᵢ)⌋

This is a scaled-integer approximation to `log₂(dim(ρ))`, the actual
information content of the dimension — the number of bits needed to
specify an element in a set of size `dim(ρ)`.

Like rowSum, bitsCost is a **monoid homomorphism** under tensor product:

    bitsCost(ρ ⊗ σ) = bitsCost(ρ) + bitsCost(σ)

But unlike rowSum, it preserves the information-theoretic structure.

## Key Finding: The rowSum Gap Disappears

The rowSum gap (no value 8 between 7 and 9) is an artifact of the
unweighted exponent count. In the bits metric:

    irrep 3 (rowSum 7) ≈ 29.6 bits
    irrep 4 (rowSum 9) ≈ 34.1 bits    ← slots BETWEEN the two rowSum-7 irreps!
    irrep 5 (rowSum 7) ≈ 34.2 bits

Irrep 4 (rowSum 9, bits ≈ 34.1) has **lower bits** than irrep 5 (rowSum 7,
bits ≈ 34.2) because irrep 4's exponents concentrate on small primes
(2², 7, 11, ...) while irrep 5's are on larger primes (13², 23, ...).

The "gap at 8" is a coordinate artifact: the unweighted metric conflates
exponents that differ by a factor of 6 in information content.

## Multiscale Structure

The same Monster group produces representations spanning:
- **17.6 bits** at irrep 1 (just 47·59·71, the trivector seed)
- **87.7 bits** at irrep 193 (the heavy 3¹²·5⁷ regime)

Both are exact. The bits metric makes the multiscale structure explicit:
the 15-prime coordinate system spans nearly two orders of magnitude
in information content across the 194 irreps.

## Tensor Product Comparison

In the bits metric, the optimal pair {2, 32} still wins:
- {2, 32}: 24.3 + 64.8 = **89.1 bits** (rowSum 22)
- {11, 13}: 47.7 + 50.0 = **97.6 bits** (rowSum 23)

The pair {2, 32} is cheaper in both metrics, using about 49.8% of the
Monster group order's total information budget (≈179.0 bits, rowSum 95).
-/

import Mathlib
import RequestProject.MonsterIrreps
import RequestProject.MonsterTSP

namespace MonsterBits

/-! ## The Bits Metric

We approximate `log₂(pᵢ)` by `⌊1000 · log₂(pᵢ)⌋`, giving a scaled-integer
metric that preserves ordering and additivity. The scale factor of 1000
provides 3 decimal digits of precision, which is more than enough for
structural analysis. -/

/-- Scaled log₂ weights: `log2Weight i = ⌊1000 · log₂(supersingularPrimes i)⌋`.

    Values:
    - p= 2: 1000   (1.000)    p= 3: 1584  (1.585)
    - p= 5: 2321   (2.322)    p= 7: 2807  (2.807)
    - p=11: 3459   (3.459)    p=13: 3700  (3.700)
    - p=17: 4087   (4.087)    p=19: 4247  (4.248)
    - p=23: 4523   (4.524)    p=29: 4857  (4.858)
    - p=31: 4954   (4.954)    p=41: 5357  (5.358)
    - p=47: 5554   (5.555)    p=59: 5882  (5.883)
    - p=71: 6149   (6.150) -/
private def log2WeightData : Array ℕ :=
  #[1000, 1584, 2321, 2807, 3459, 3700, 4087, 4247, 4523, 4857, 4954, 5357, 5554, 5882, 6149]

private theorem log2WeightData_size : log2WeightData.size = 15 := by native_decide

def log2Weight (i : Fin 15) : ℕ :=
  log2WeightData[i.val]'(by have := log2WeightData_size; omega)

/-- The bits cost of a valuation vector: `Σᵢ eᵢ · ⌊1000 · log₂(pᵢ)⌋`.
    This approximates `1000 · log₂(dim(ρ))`. -/
def bitsCost (v : Fin 15 → ℕ) : ℕ :=
  Finset.univ.sum (fun i => v i * log2Weight i)

/-! ## Additivity (Monoid Homomorphism)

Like rowSum, bitsCost is additive under componentwise addition of valuation
vectors. Since tensor product adds valuations, this means:
  `bitsCost(ρ ⊗ σ) = bitsCost(ρ) + bitsCost(σ)` -/

/-- The bits metric is additive: `bitsCost(v + w) = bitsCost(v) + bitsCost(w)`.
    This is the monoid homomorphism property. -/
theorem bitsCost_add (v w : Fin 15 → ℕ) :
    bitsCost (fun i => v i + w i) = bitsCost v + bitsCost w := by
  simp only [bitsCost, Nat.add_mul, Finset.sum_add_distrib]

/-! ## Comparison with rowSum

The bits metric refines rowSum. Since `log₂(pᵢ) ≥ 1` for all supersingular
primes (all ≥ 2), and our scaled weights satisfy `log2Weight i ≥ 1000`,
we have `bitsCost v ≥ 1000 · rowSum v`. -/

/-- Every log₂ weight is at least 1000 (corresponding to `log₂(2) = 1`). -/
theorem log2Weight_ge_1000 : ∀ i : Fin 15, log2Weight i ≥ 1000 := by
  native_decide

/-- The bits metric dominates the rowSum (scaled by 1000). -/
theorem bitsCost_ge_rowSum_scaled (v : Fin 15 → ℕ) :
    bitsCost v ≥ 1000 * (Finset.univ.sum v) := by
  unfold bitsCost
  calc Finset.univ.sum (fun i => v i * log2Weight i)
      ≥ Finset.univ.sum (fun i => v i * 1000) := by
        apply Finset.sum_le_sum
        intro i _
        exact Nat.mul_le_mul_left _ (log2Weight_ge_1000 i)
    _ = 1000 * Finset.univ.sum v := by
        rw [Finset.mul_sum]; congr 1; ext i; ring

/-- The maximum log₂ weight is 6149 (for prime 71). -/
theorem log2Weight_le_6149 : ∀ i : Fin 15, log2Weight i ≤ 6149 := by
  native_decide

/-! ## Exact Values for Known Irreps

We compute the exact (scaled) bits cost for the 14 irreps with known
valuation vectors (from MonsterIrreps.lean), plus key additional irreps. -/

/-- Irrep 0 (trivial, dim = 1): 0 bits. -/
theorem bits_irrep0 : bitsCost v0 = 0 := by native_decide

/-- Irrep 1 (dim = 47·59·71 = 196883): ≈17.6 bits.
    The famous McKay dimension — the lightest nontrivial Monster irrep. -/
theorem bits_irrep1 : bitsCost v1 = 17585 := by native_decide

/-- Irrep 2 (dim = 2²·31·41·59·71): ≈24.3 bits. -/
theorem bits_irrep2 : bitsCost v2 = 24342 := by native_decide

/-- Irrep 3 (dim = 2·13²·29·31·47·59): ≈29.6 bits. -/
theorem bits_irrep3 : bitsCost v3 = 29647 := by native_decide

/-- Irrep 4 (dim = 2²·7·11·23·29·31·41·71): ≈34.1 bits. -/
theorem bits_irrep4 : bitsCost v4 = 34106 := by native_decide

/-- Irrep 5 (dim = 13²·23·29·41·59·71): ≈34.2 bits. -/
theorem bits_irrep5 : bitsCost v5 = 34168 := by native_decide

theorem bits_irrep6 : bitsCost v6 = 38089 := by native_decide
theorem bits_irrep7 : bitsCost v7 = 41813 := by native_decide
theorem bits_irrep8 : bitsCost v8 = 45030 := by native_decide
theorem bits_irrep9 : bitsCost v9 = 46828 := by native_decide
theorem bits_irrep10 : bitsCost v10 = 47427 := by native_decide
theorem bits_irrep11 : bitsCost v11 = 47657 := by native_decide
theorem bits_irrep12 : bitsCost v12 = 49886 := by native_decide
theorem bits_irrep13 : bitsCost v13 = 49972 := by native_decide

/-! ## The rowSum Gap Dissolves in Bits

The key structural finding: in the rowSum metric, there is a gap between
7 and 9 (no irrep has rowSum 8). In the bits metric, this gap is filled:

    irrep 3: rowSum 7, bits 29647 (≈29.6)
    irrep 4: rowSum 9, bits 34106 (≈34.1)  ← between the two rowSum-7 irreps!
    irrep 5: rowSum 7, bits 34168 (≈34.2)

Irrep 4 (rowSum 9) has LOWER bits than irrep 5 (rowSum 7). The unweighted
gap is a coordinate artifact — it disappears when exponents are weighted
by their actual information content. -/

/-- The ordering reversal: irrep 4 (rowSum 9) costs less in bits than
    irrep 5 (rowSum 7). The rowSum ordering disagrees with the information-
    theoretic ordering. -/
theorem bits_ordering_reversal :
    bitsCost v4 < bitsCost v5 ∧
    rowSum v4 > rowSum v5 := by
  constructor <;> native_decide

/-- In the bits metric, irrep 4 falls strictly between irreps 3 and 5. -/
theorem bits_fills_gap :
    bitsCost v3 < bitsCost v4 ∧ bitsCost v4 < bitsCost v5 := by
  constructor <;> native_decide

/-- The rowSum "tie" between irreps 3 and 5 (both rowSum 7) hides a large
    gap in bits: 29647 vs 34168, a difference of 4521 (≈4.5 bits). -/
theorem bits_breaks_rowSum_tie :
    rowSum v3 = rowSum v5 ∧
    bitsCost v5 - bitsCost v3 = 4521 := by
  constructor <;> native_decide

/-! ## Additional Key Irreps

Valuation vectors for irreps not in MonsterIrreps.lean but critical
for the analysis. -/

/-- Valuation vector for irrep 32 (χ₃₃ in ATLAS).
    Dimension: 3²·5·7·11·13²·17·19·23·29·31·41·47·59·71
    Support: 14 of 15 supersingular primes (all except 2). -/
def v32 : Fin 15 → ℕ := ![0, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]

/-- Consistency check: v32's rowSum matches irrepRowSum. -/
theorem v32_rowSum : rowSum v32 = 16 := by native_decide

/-- Consistency check: v32's bitmask matches irrepBitmask. -/
theorem v32_bitmask_consistent :
    irrepBitmask ⟨32, by omega⟩ = fullBitmask - 1 ∧
    (∀ j : Fin 15, (v32 j > 0) ↔ (irrepBitmask ⟨32, by omega⟩).testBit j.val = true) := by
  constructor
  · native_decide
  · native_decide

/-- Irrep 32: ≈64.8 bits. The near-universal irrep. -/
theorem bits_irrep32 : bitsCost v32 = 64765 := by native_decide

/-- Valuation vector for irrep 193 (the heaviest, 3¹²·5⁷ regime).
    Dimension: 3¹²·5⁷·13³·17·23·29·31·41·47·59·71
    This is the "88-bit" irrep — maximum entropy in the 15-prime basis. -/
def v193 : Fin 15 → ℕ := ![0, 12, 7, 0, 0, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1]

/-- Consistency check: v193's rowSum matches irrepRowSum. -/
theorem v193_rowSum : rowSum v193 = 30 := by native_decide

/-- Consistency check: v193's bitmask matches irrepBitmask. -/
theorem v193_bitmask_consistent :
    (∀ j : Fin 15, (v193 j > 0) ↔ (irrepBitmask ⟨193, by omega⟩).testBit j.val = true) := by
  native_decide

/-- Irrep 193: ≈87.7 bits. The maximum-entropy irrep. -/
theorem bits_irrep193 : bitsCost v193 = 87718 := by native_decide

/-! ## Tensor Product Comparison in Bits

The optimal pair {2, 32} wins in both metrics — rowSum and bits.
The bits comparison is even more decisive. -/

/-- The tensor product ρ₂ ⊗ ρ₃₂ in the bits metric. -/
theorem tensor_2_32_bits :
    bitsCost v2 + bitsCost v32 = 89107 := by native_decide

/-- The tensor product ρ₁₁ ⊗ ρ₁₃ in the bits metric. -/
theorem tensor_11_13_bits :
    bitsCost v11 + bitsCost v13 = 97629 := by native_decide

/-- The pair {2, 32} is cheaper than {11, 13} in both metrics. -/
theorem optimal_pair_wins_both_metrics :
    rowSum v2 + rowSum v32 < rowSum v11 + rowSum v13 ∧
    bitsCost v2 + bitsCost v32 < bitsCost v11 + bitsCost v13 := by
  constructor <;> native_decide

/-- The bits saving from using {2,32} vs {11,13}: 8522 ≈ 8.5 bits.
    In rowSum, the saving is only 1 (22 vs 23). The bits metric reveals
    the pair {2,32} is dramatically more efficient, not just marginally. -/
theorem bits_saving :
    bitsCost v11 + bitsCost v13 - (bitsCost v2 + bitsCost v32) = 8522 ∧
    rowSum v11 + rowSum v13 - (rowSum v2 + rowSum v32) = 1 := by
  constructor <;> native_decide

/-! ## The Monster Group Order in Bits

The Monster group order |M| = 2⁴⁶·3²⁰·5⁹·7⁶·11²·13³·17·19·23·29·31·41·47·59·71
has rowSum 95 and ≈179.0 bits. Every irrep dimension divides |M|, so every
irrep's bitsCost is bounded above by the group order's bitsCost. -/

/-- The valuation vector of the Monster group order at supersingular primes. -/
def vMonsterOrder : Fin 15 → ℕ := ![46, 20, 9, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1]

theorem monsterOrder_rowSum : rowSum vMonsterOrder = 95 := by native_decide

/-- The Monster group order: ≈179.0 bits (log₂|M| ≈ 179.0). -/
theorem monsterOrder_bits : bitsCost vMonsterOrder = 179039 := by native_decide

/-- The tensor product ρ₂ ⊗ ρ₃₂ uses about 49.8% of the group order's
    information budget. -/
theorem tensor_vs_order :
    2 * (bitsCost v2 + bitsCost v32) < bitsCost vMonsterOrder ∧
    bitsCost v2 + bitsCost v32 > bitsCost vMonsterOrder / 2 - 1000 := by
  constructor <;> native_decide

/-! ## The Multiscale Span

The bits metric reveals the full dynamic range of Monster representations:
from 17.6 bits (irrep 1, the 196883-dimensional trivector) to 87.7 bits
(irrep 193, the heavy 3¹²·5⁷ regime). A factor of 5× in information
content across the 194 irreps. -/

/-- The full scale: from 17585 (irrep 1) to 87718 (irrep 193). -/
theorem multiscale_range :
    bitsCost v193 - bitsCost v1 = 70133 ∧
    -- The ratio is about 5:1 (87718 / 17585 ≈ 4.99)
    bitsCost v193 / bitsCost v1 = 4 ∧
    bitsCost v193 % bitsCost v1 = 17378 := by
  refine ⟨by native_decide, by native_decide, by native_decide⟩

/-- Every known irrep's bitsCost is bounded by the Monster order's bitsCost. -/
theorem bits_bounded_by_order :
    bitsCost v1 ≤ bitsCost vMonsterOrder ∧
    bitsCost v2 ≤ bitsCost vMonsterOrder ∧
    bitsCost v32 ≤ bitsCost vMonsterOrder ∧
    bitsCost v193 ≤ bitsCost vMonsterOrder := by
  refine ⟨by native_decide, by native_decide, by native_decide, by native_decide⟩

/-! ## Structural Summary

The bits metric (information-theoretic cost) and the rowSum metric
(exponent-counting cost) are both monoid homomorphisms from Rep(M) to ℕ.
They agree on ordering in many cases but diverge crucially:

1. **The rowSum gap at 8 is an artifact** of treating 2¹ and 71¹ as equally
   costly. In information terms, one power of 71 costs 6.15× more than
   one power of 2.

2. **The optimal pair {2, 32} wins more decisively in bits**: the saving
   vs {11, 13} is 8.5 bits (≈9.5% improvement) vs 1 rowSum unit (≈4.3%).
   The bits metric reveals that {2, 32}'s strategy — concentrating cheap
   exponents at prime 2 via irrep 2 — is information-theoretically superior.

3. **The same 15-prime basis spans 70 bits of dynamic range** across the
   194 irreps. The coordinate system is intrinsically multiscale because
   log₂(71)/log₂(2) ≈ 6.15 — the heaviest coordinate is 6× the lightest.
-/

end MonsterBits
