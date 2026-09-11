/-
Original to this repository (not part of the upstream ZetaZeros development).
-/

import Mathlib.MeasureTheory.Integral.CircleIntegral
import Mathlib.RingTheory.RootsOfUnity.Complex
import Mathlib.Analysis.SpecialFunctions.Complex.Analytic

/-! # Experiment track: toy argument principles

The Riemann–von Mangoldt formula is out of reach of the pinned Mathlib mainly because there is no
argument principle: no theorem saying that a contour integral of a logarithmic derivative counts
zeros. This file formalises the two smallest instances of that statement, so that an experiment
proposing a general version has a fixed target to generalise and a fixed baseline to be compared
against.

* `ncard_setOf_pow_eq_one` — the purely algebraic count: `z ^ n = 1` has exactly `n` solutions.
* `circleIntegral_logDeriv_pow` — the analytic count for `f z = z ^ n`:
  `∮ f'/f = 2πi · n` over any circle about the origin.
* `circleIntegral_logDeriv_prod` — the analytic count for a product of linear factors
  `f z = ∏ i, (z - a i)` with all roots strictly inside the contour:
  `∮ f'/f = 2πi · m`, where `m` is the number of factors, i.e. the number of zeros counted with
  multiplicity.

The last statement is the argument principle for polynomials given in factored form. Extending it
to a function that is merely holomorphic and zero-free on the contour — with the zero count read
off from analytic orders rather than from a chosen factorisation — was the open task; it is now
done, in `RequestProject/Analysis/ArgumentPrinciple.lean`
(`ZetaZeros.Analysis.circleIntegral_logDeriv_eq_zeroCount`), and the file below is kept as the
baseline it was written to be.
-/

open Complex Metric Finset

namespace ZetaZeros.Experiments

/-- The algebraic zero count: `z ^ n = 1` has exactly `n` solutions in `ℂ`. -/
theorem ncard_setOf_pow_eq_one {n : ℕ} (hn : n ≠ 0) : {z : ℂ | z ^ n = 1}.ncard = n := by
  have hprim := Complex.isPrimitiveRoot_exp n hn
  have hset : {z : ℂ | z ^ n = 1} = (Polynomial.nthRootsFinset n (1 : ℂ) : Set ℂ) := by
    ext z
    simp [Polynomial.mem_nthRootsFinset (Nat.pos_of_ne_zero hn)]
  rw [hset, Set.ncard_coe_finset, hprim.card_nthRootsFinset]

/-- **Toy argument principle, monomial case.** For `f z = z ^ n` and any circle about the origin,
`(2πi)⁻¹ ∮ f'/f = n`: the contour integral of the logarithmic derivative counts the zero at the
origin with its multiplicity. -/
theorem circleIntegral_logDeriv_pow (n : ℕ) {R : ℝ} (hR : 0 < R) :
    (∮ z in C((0 : ℂ), R), deriv (fun w : ℂ => w ^ n) z / z ^ n) = 2 * Real.pi * Complex.I * n := by
  have hcong : Set.EqOn (fun z : ℂ => deriv (fun w : ℂ => w ^ n) z / z ^ n)
      (fun z : ℂ => (n : ℂ) • (z - 0)⁻¹) (Metric.sphere (0 : ℂ) R) := by
    intro z hz
    have hnorm : ‖z‖ = R := by simpa using hz
    have hz0 : z ≠ 0 := by
      intro h
      rw [h] at hnorm
      simp only [norm_zero] at hnorm
      linarith
    have hd : deriv (fun w : ℂ => w ^ n) z = n * z ^ (n - 1) := by simp
    simp only [smul_eq_mul, sub_zero, hd]
    cases n with
    | zero => simp
    | succ m =>
      have hz1 : z ^ (m + 1) = z ^ m * z := by ring
      simp only [Nat.add_sub_cancel, hz1]
      field_simp
  rw [circleIntegral.integral_congr hR.le hcong, circleIntegral.integral_smul,
    circleIntegral.integral_sub_inv_of_mem_ball (by simpa using hR)]
  simp only [smul_eq_mul]
  ring

/-- **Toy argument principle, factored polynomial case.** If every root `a i` lies strictly inside
the circle `C(c, R)`, then for `f z = ∏ i, (z - a i)`,

`∮ f'/f = 2πi · m`,

with `m` the number of factors, i.e. the number of zeros of `f` inside the contour counted with
multiplicity. -/
theorem circleIntegral_logDeriv_prod {m : ℕ} {c : ℂ} {R : ℝ} (a : Fin m → ℂ)
    (ha : ∀ i, a i ∈ Metric.ball c R) :
    (∮ z in C(c, R), deriv (fun w : ℂ => ∏ i, (w - a i)) z / ∏ i, (z - a i))
      = 2 * Real.pi * Complex.I * m := by
  rcases Nat.eq_zero_or_pos m with hm | hm
  · subst hm
    simp [circleIntegral]
  have hR : 0 < R := by
    obtain ⟨i⟩ : Nonempty (Fin m) := ⟨⟨0, hm⟩⟩
    exact Metric.pos_of_mem_ball (ha i)
  have hsphere : ∀ z ∈ Metric.sphere c R, ∀ i, z - a i ≠ 0 := by
    intro z hz i hcon
    have hz' : dist z c = R := by simpa [Metric.mem_sphere] using hz
    have : dist (a i) c < R := by simpa [Metric.mem_ball] using ha i
    rw [sub_eq_zero] at hcon
    rw [← hcon] at this
    linarith
  -- the logarithmic derivative of the product is the sum of the logarithmic derivatives
  have hcong : Set.EqOn (fun z : ℂ => deriv (fun w : ℂ => ∏ i, (w - a i)) z / ∏ i, (z - a i))
      (fun z : ℂ => ∑ i, (z - a i)⁻¹) (Metric.sphere c R) := by
    intro z hz
    have hfac := hsphere z hz
    have hfun : (fun w : ℂ => ∏ i, (w - a i)) = ∏ i ∈ Finset.univ, (fun w : ℂ => w - a i) := by
      funext w
      simp [Finset.prod_apply]
    have hderiv : deriv (fun w : ℂ => ∏ i, (w - a i)) z
        = ∑ i, ∏ j ∈ Finset.univ.erase i, (z - a j) := by
      rw [hfun, deriv_finset_prod (u := Finset.univ) (f := fun i (w : ℂ) => w - a i)
        (fun i _ => (differentiable_id.sub_const (a i)).differentiableAt)]
      refine Finset.sum_congr rfl fun i _ => ?_
      simp
    dsimp only
    rw [hderiv, Finset.sum_div]
    refine Finset.sum_congr rfl fun i _ => ?_
    have hsplit : (∏ j, (z - a j)) = (z - a i) * ∏ j ∈ Finset.univ.erase i, (z - a j) :=
      (Finset.mul_prod_erase _ _ (Finset.mem_univ i)).symm
    have hprodne : (∏ j ∈ Finset.univ.erase i, (z - a j)) ≠ 0 :=
      Finset.prod_ne_zero_iff.2 fun j _ => hfac j
    rw [hsplit]
    field_simp
  rw [circleIntegral.integral_congr hR.le hcong]
  rw [circleIntegral.integral_fun_sum]
  · have : ∀ i : Fin m, (∮ z in C(c, R), (z - a i)⁻¹) = 2 * Real.pi * Complex.I := fun i =>
      circleIntegral.integral_sub_inv_of_mem_ball (ha i)
    simp only [this, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
    ring
  · intro i _
    refine (circleIntegrable_sub_inv_iff).2 (Or.inr ?_)
    intro hcon
    have hz' : dist (a i) c = |R| := by simpa [Metric.mem_sphere] using hcon
    have : dist (a i) c < R := by simpa [Metric.mem_ball] using ha i
    rw [abs_of_pos hR] at hz'
    linarith

end ZetaZeros.Experiments
