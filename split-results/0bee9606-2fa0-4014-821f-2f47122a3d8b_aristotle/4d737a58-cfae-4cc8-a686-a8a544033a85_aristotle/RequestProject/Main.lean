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
# Convergence of a polymer / cluster expansion at weak coupling

This file formalizes the convergence estimate for a polymer (cluster) expansion,
of the kind used in constructive quantum field theory and lattice gauge theory
(e.g. four–dimensional Yang–Mills).

The mathematical inputs are:

* **Single polymer bound** (step 1): a connected polymer `γ` of size `n` has weight
  `|K(γ)| ≤ exp (- c_K n / g²)`.  Here this is folded into the grouped weight
  `W n` (the total weight of all polymers of size `n` containing the origin), via the
  hypothesis `W n ≤ N n * exp (- c_K n / g²)`.

* **Lattice animal bound** (step 2): the number `N n` of connected animals of size `n`
  containing a fixed site is bounded by `(8 e)ⁿ` (the `d = 4` Cayley/tree estimate).

The derivation (steps 3–5) tunes `a = c_K / (4 g²)` and assumes a sufficiently weak
coupling `g² < g₀²/2` with `g₀² = c_K / (2 log (16 e))`, i.e.
`g² < c_K / (4 log (16 e))`.  Under these hypotheses the weighted polymer sum
`∑_{γ ∋ 0} |K(γ)| e^{2a|γ|}` (here `∑' n, W n e^{2 a n}`) is bounded by `1/2`.

Throughout we write `gsq` for the coupling `g²`.
-/

namespace PolymerExpansion

open Real

/-
**Steps 4–5: the geometric ratio is small at weak coupling.**

With the tuning `a = c_K / (4 g²)` and weak coupling `g² < c_K / (4 log (16 e))`,
the ratio of the geometric series,
`r = 8 e · exp (- c_K / g²) · exp (2 a)`, is at most `1/4`.
-/
lemma ratio_bound (cK gsq a : ℝ) (hcK : 0 < cK) (hgsq : 0 < gsq)
    (ha : a = cK / (4 * gsq))
    (hsmall : gsq < cK / (4 * Real.log (16 * Real.exp 1))) :
    8 * Real.exp 1 * Real.exp (-cK / gsq) * Real.exp (2 * a) ≤ 1 / 4 := by
  -- Substitute $a$ from hypothesis away.
  rw [ha] at *; ring_nf at *;
  norm_num [ ← Real.exp_add ] at *;
  rw [ ← Real.log_le_log_iff ( by positivity ) ( by positivity ), Real.log_mul ( by positivity ) ( by positivity ), Real.log_exp ];
  rw [ show ( 8 : ℝ ) = 2 ^ 3 by norm_num, Real.log_pow, show ( 1 / 4 : ℝ ) = 2 ^ ( -2 : ℝ ) by norm_num, Real.log_rpow ] <;> ring_nf;
  · rw [ Real.log_mul ( by positivity ) ( by positivity ), Real.log_exp ] at hsmall;
    rw [ show ( 16 : ℝ ) = 2 ^ 4 by norm_num, Real.log_pow ] at hsmall ; ring_nf at * ; nlinarith [ inv_pos.mpr hgsq, mul_inv_cancel₀ hgsq.ne', Real.log_pos one_lt_two, mul_inv_cancel₀ ( by positivity : ( 1 + Real.log 2 * 4 ) ≠ 0 ) ];
  · norm_num

/-
**Geometric tail bound.**  If `0 ≤ r ≤ 1/4`, then `∑_{n ≥ 1} rⁿ = r/(1-r) ≤ 1/2`
(in fact `≤ 1/3`).
-/
lemma geom_tail_le (r : ℝ) (hr0 : 0 ≤ r) (hr : r ≤ 1 / 4) :
    ∑' (n : ℕ), r ^ (n + 1) ≤ 1 / 2 := by
  ring_nf;
  rw [ tsum_mul_left, tsum_geometric_of_lt_one ] <;> norm_num <;> try linarith;
  nlinarith [ mul_inv_cancel₀ ( by linarith : ( 1 - r ) ≠ 0 ) ]

/-
**Main estimate: convergence of the polymer expansion at weak coupling.**

Let `W n` be the total weight of all polymers of size `n` containing the origin, and
`N n` the number of lattice animals of size `n` containing the origin.  Assume

* the single–polymer/grouped weight bound `W n ≤ N n · exp (- c_K n / g²)`;
* the lattice–animal bound `N n ≤ (8 e)ⁿ`;
* the tuning `a = c_K / (4 g²)`;
* weak coupling `g² < c_K / (4 log (16 e))` (i.e. `g² < g₀²/2`).

Then the weighted sum over all polymers containing the origin satisfies
`∑' n, W n · exp (2 a n) ≤ 1/2`.
-/
theorem polymer_sum_bound
    (cK gsq a : ℝ) (hcK : 0 < cK) (hgsq : 0 < gsq)
    (ha : a = cK / (4 * gsq))
    (hsmall : gsq < cK / (4 * Real.log (16 * Real.exp 1)))
    (N W : ℕ → ℝ)
    (hN : ∀ n, N n ≤ (8 * Real.exp 1) ^ n)
    (hWnonneg : ∀ n, 0 ≤ W n)
    (hW0 : W 0 = 0)
    (hWbound : ∀ n, W n ≤ N n * Real.exp (-cK * n / gsq)) :
    ∑' (n : ℕ), W n * Real.exp (2 * a * n) ≤ 1 / 2 := by
  -- Let $r := 8 * \exp 1 * \exp (-cK / gsq) * \exp (2 * a)$. By ratio_bound, $r \leq 1/4$.
  set r : ℝ := 8 * Real.exp 1 * Real.exp (-cK / gsq) * Real.exp (2 * a)
  have hr : r ≤ 1 / 4 := by
    convert ratio_bound cK gsq a hcK hgsq ha hsmall using 1;
  -- By the claim, $W n * \exp (2 * a * n) \leq r^n$ for all $n$.
  have h_bound : ∀ n, W n * Real.exp (2 * a * n) ≤ r ^ n := by
    intro n
    have h_step : W n * Real.exp (2 * a * n) ≤ (8 * Real.exp 1) ^ n * Real.exp (-cK * n / gsq) * Real.exp (2 * a * n) := by
      exact mul_le_mul_of_nonneg_right ( le_trans ( hWbound n ) ( mul_le_mul_of_nonneg_right ( hN n ) ( Real.exp_nonneg _ ) ) ) ( Real.exp_nonneg _ );
    have hpow : (8 * Real.exp 1 * Real.exp (-cK / gsq) * Real.exp (2 * a)) ^ n
        = (8 * Real.exp 1) ^ n * Real.exp (-cK * n / gsq) * Real.exp (2 * a * n) := by
      rw [mul_pow, mul_pow, ← Real.exp_nat_mul, ← Real.exp_nat_mul,
          show (n : ℝ) * (-cK / gsq) = -cK * n / gsq by ring,
          show (n : ℝ) * (2 * a) = 2 * a * n by ring]
    exact h_step.trans_eq hpow.symm
  -- Since $W 0 = 0$, we have $\sum' n, W n * \exp (2 * a * n) = \sum' n, W (n + 1) * \exp (2 * a * (n + 1))$.
  have h_sum_shift : ∑' n, W n * Real.exp (2 * a * n) = ∑' n, W (n + 1) * Real.exp (2 * a * (n + 1)) := by
    rw [ Summable.tsum_eq_zero_add ];
    · norm_num [ hW0 ];
    · exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( hWnonneg n ) ( Real.exp_nonneg _ ) ) h_bound ( summable_geometric_of_lt_one ( by positivity ) ( by linarith ) );
  -- By the claim, $\sum' n, W (n + 1) * \exp (2 * a * (n + 1)) \leq \sum' n, r^{n + 1}$.
  have h_sum_le : ∑' n, W (n + 1) * Real.exp (2 * a * (n + 1)) ≤ ∑' n, r ^ (n + 1) := by
    refine' Summable.tsum_le_tsum _ _ _;
    · exact fun n => mod_cast h_bound _;
    · exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( hWnonneg _ ) ( Real.exp_nonneg _ ) ) ( fun n => mod_cast h_bound _ ) ( summable_nat_add_iff 1 |>.2 <| summable_geometric_of_lt_one ( by positivity ) <| by linarith );
    · exact Summable.comp_injective ( summable_geometric_of_lt_one ( by positivity ) ( by linarith ) ) ( Nat.succ_injective );
  exact h_sum_shift.symm ▸ h_sum_le.trans ( geom_tail_le r ( by positivity ) hr )

end PolymerExpansion