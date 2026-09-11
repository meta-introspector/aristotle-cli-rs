/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Zeta5 companion effort: the divided difference of `F = (1/t) ∘ ψ`.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.Zeta5.EnergyBounds

/-!
# The regular integrand `g` after splitting the diagonal singularity

`Zeta5/EnergyBounds.lean` proves (`pairwiseEnergy_eq_of_factor`) that for any
factorisation of the boundary values

`F(z) − F(w) = (z − w) · g(z, w)`

the Bost–Charles pairwise energy is `BC(F) = (1/4π²) ∬ log‖g‖`: the diagonal
`log‖z − w‖` carries no mass.  This module supplies the factor `g` for the live
normalisation `F = (1/t) ∘ ψ` and proves the elementary properties of it that do
not require any quadrature.

## Contents

* `hauptmodulInv q = q · exp(−Σₙ etaFactorCLog q n)`, an everywhere-defined
  formula for `1/t(q)` (`hauptmodulInv_eq_inv_hauptmodul`), regular at `q = 0`;
* `Fmap a = hauptmodulInv ∘ ψ`, which agrees with `(φ a)⁻¹` off the origin
  (`Fmap_eq_phi_inv`);
* `dividedDiff f z w = (f z − f w)/(z − w)` and
  `gPhiInv a = dividedDiff (Fmap a)`, the factor `g`, together with the
  factorisation identity `dividedDiff_mul` in the form required by
  `pairwiseEnergy_eq_of_factor`;
* a **global Lipschitz bound** for `F` on the closed unit disc
  (`norm_Fmap_sub_le`), obtained from an explicit modulus of continuity for the
  eta-quotient exponent; consequently
* `g` is **bounded on the whole closed bidisc off the diagonal**, by the same
  constant (`norm_gPhiInv_le`), and is continuous there
  (`continuousOn_gPhiInv_offDiag`); and
* an explicit **Lipschitz estimate for `g` off a diagonal strip**
  (`norm_gPhiInv_sub_le`): if `‖z − w‖ ≥ d` and `‖z' − w‖ ≥ d` then
  `‖g(z,w) − g(z',w)‖ ≤ exp 5200 · (1/d + 2/d²) · ‖z − z'‖`;
* the translation of "off a diagonal strip" into angles
  (`norm_circleMap_sub_circleMap_ge`): for `δ ≤ |θ − ψ| ≤ 2π − δ` one has
  `‖e^{iθ} − e^{iψ}‖ ≥ 2 sin(δ/2)`.

## The size of the constants

Everything is proved with the *crude* certified majorant of
`Zeta5/EnergyBounds.lean`, `log‖F‖ ≤ 5177` on the closed unit disc, which comes
from bounding every eta factor by its value at a positive real nome.  The
resulting Lipschitz constant, `exp 5200`, is therefore astronomically larger
than the true `max‖g‖ ≈ 1.5·10³` (uncertified quadrature, `scripts/zeta5/bc_sup.py`).
This is deliberate: the point of this module is the *structure* — `g` is
Lipschitz on the closed bidisc away from the diagonal, with a constant that is
explicit and finite — not the size of the constant.  Sharpening it is a separate
(quantitative) task, and nothing here is used to claim any `cost < budget`
inequality, nor anything about `ζ_5(3) ∉ ℚ`.
-/

noncomputable section

namespace Zeta5.Hauptmodul

open Complex Real

/-! ## 1. Mean-value tools on convex subsets of `ℂ` -/

/-- Mean-value bound: a holomorphic function with derivative bounded by `C` on a
convex set is `C`-Lipschitz there. -/
theorem norm_sub_le_of_deriv_le {s : Set ℂ} (hs : Convex ℝ s) {f f' : ℂ → ℂ}
    (hf : ∀ z ∈ s, HasDerivAt f (f' z) z) {C : ℝ} (hC : ∀ z ∈ s, ‖f' z‖ ≤ C)
    {z w : ℂ} (hz : z ∈ s) (hw : w ∈ s) : ‖f z - f w‖ ≤ C * ‖z - w‖ := by
  refine Convex.norm_image_sub_le_of_norm_hasFDerivWithin_le
    (f' := fun x => ContinuousLinearMap.smulRight (1 : ℂ →L[ℂ] ℂ) (f' x))
    (fun x hx => ((hf x hx).hasFDerivAt).hasFDerivWithinAt) (fun x hx => ?_) hs hw hz
  simpa using hC x hx

theorem mem_closedBall_of_norm_le {ρ : ℝ} {x : ℂ} (hx : ‖x‖ ≤ ρ) :
    x ∈ Metric.closedBall (0 : ℂ) ρ := by
  simpa [Metric.mem_closedBall] using hx

/-- `‖qᵐ − q'ᵐ‖ ≤ m ρ^{m−1} ‖q − q'‖` on the closed disc of radius `ρ`. -/
theorem norm_pow_sub_pow_le {ρ : ℝ} {q q' : ℂ} (hq : ‖q‖ ≤ ρ) (hq' : ‖q'‖ ≤ ρ) (m : ℕ) :
    ‖q ^ m - q' ^ m‖ ≤ m * ρ ^ (m - 1) * ‖q - q'‖ := by
  refine norm_sub_le_of_deriv_le (convex_closedBall (0 : ℂ) ρ)
    (f := fun x => x ^ m) (f' := fun x => m * x ^ (m - 1)) (fun x _ => ?_) (fun x hx => ?_)
    (mem_closedBall_of_norm_le hq) (mem_closedBall_of_norm_le hq')
  · simpa using (hasDerivAt_pow m x)
  · have hx : ‖x‖ ≤ ρ := by simpa [Metric.mem_closedBall] using hx
    rw [norm_mul, norm_pow]
    gcongr
    simp

/-- The principal branch of `log(1 − ·)` is `1/(1 − ρ)`-Lipschitz on the closed
disc of radius `ρ < 1`. -/
theorem norm_clog_one_sub_sub_le {ρ : ℝ} (hρ1 : ρ < 1) {u v : ℂ} (hu : ‖u‖ ≤ ρ) (hv : ‖v‖ ≤ ρ) :
    ‖Complex.log (1 - u) - Complex.log (1 - v)‖ ≤ ‖u - v‖ / (1 - ρ) := by
  have hpos : (0 : ℝ) < 1 - ρ := by linarith
  have key : ∀ x : ℂ, ‖x‖ ≤ ρ → (1 - x) ∈ Complex.slitPlane := by
    intro x hx
    refine Or.inl ?_
    have h := abs_le.1 ((Complex.abs_re_le_norm x).trans hx)
    simp only [Complex.sub_re, Complex.one_re]
    linarith [h.2]
  have main := norm_sub_le_of_deriv_le (convex_closedBall (0 : ℂ) ρ)
    (f := fun x => Complex.log (1 - x)) (f' := fun x => -(1 - x)⁻¹)
    (fun x hx => ?_) (C := 1 / (1 - ρ)) (fun x hx => ?_)
    (mem_closedBall_of_norm_le hu) (mem_closedBall_of_norm_le hv)
  · simp only at main
    calc ‖Complex.log (1 - u) - Complex.log (1 - v)‖ ≤ 1 / (1 - ρ) * ‖u - v‖ := main
      _ = ‖u - v‖ / (1 - ρ) := by ring
  · have hx : ‖x‖ ≤ ρ := by simpa [Metric.mem_closedBall] using hx
    have h1 : HasDerivAt (fun x : ℂ => 1 - x) (-1) x := by
      simpa using (hasDerivAt_id x).const_sub 1
    have := (Complex.hasDerivAt_log (key x hx)).comp x h1
    simpa [mul_comm] using this
  · have hx : ‖x‖ ≤ ρ := by simpa [Metric.mem_closedBall] using hx
    have hre : (1 - ρ) ≤ ‖1 - x‖ := by
      have h := norm_sub_norm_le (1 : ℂ) x
      simp only [norm_one] at h; linarith
    rw [norm_neg, norm_inv, one_div]
    exact inv_anti₀ hpos hre

/-- `exp` is `e^M`-Lipschitz on the half-plane `Re ≤ M`. -/
theorem norm_cexp_sub_cexp_le {M : ℝ} {a b : ℂ} (ha : a.re ≤ M) (hb : b.re ≤ M) :
    ‖Complex.exp a - Complex.exp b‖ ≤ Real.exp M * ‖a - b‖ := by
  refine norm_sub_le_of_deriv_le (s := {z : ℂ | z.re ≤ M}) (convex_halfSpace_re_le M)
    (f := Complex.exp) (f' := Complex.exp) (fun x _ => Complex.hasDerivAt_exp x)
    (fun x hx => ?_) ha hb
  rw [Complex.norm_exp]
  exact Real.exp_le_exp.2 hx

/-! ## 2. A modulus of continuity for the eta-quotient exponent -/

/-- The uniform Lipschitz majorant for the terms of `etaFactorCLog` on
`‖q‖ ≤ ρ`. -/
def etaLipBound (ρ : ℝ) (n : ℕ) : ℝ := 36 * (n + 1) * ρ ^ n / (1 - ρ)

theorem norm_etaFactorCLog_sub_le {ρ : ℝ} (hρ1 : ρ < 1) {q q' : ℂ}
    (hq : ‖q‖ ≤ ρ) (hq' : ‖q'‖ ≤ ρ) (n : ℕ) :
    ‖etaFactorCLog q n - etaFactorCLog q' n‖ ≤ etaLipBound ρ n * ‖q - q'‖ := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg q) hq
  have hpos : (0 : ℝ) < 1 - ρ := by linarith
  -- powers stay in the disc
  have hpow : ∀ (x : ℂ), ‖x‖ ≤ ρ → ∀ m : ℕ, 1 ≤ m → ‖x ^ m‖ ≤ ρ := by
    intro x hx m hm
    rw [norm_pow]
    calc ‖x‖ ^ m ≤ ρ ^ m := pow_le_pow_left₀ (norm_nonneg x) hx m
      _ ≤ ρ ^ 1 := pow_le_pow_of_le_one hρ0 hρ1.le hm
      _ = ρ := pow_one ρ
  -- the two logarithmic differences
  have h1 : ‖Complex.log (1 - q ^ (n + 1)) - Complex.log (1 - q' ^ (n + 1))‖
      ≤ ((n + 1) * ρ ^ n * ‖q - q'‖) / (1 - ρ) := by
    refine (norm_clog_one_sub_sub_le hρ1 (hpow q hq _ (by omega)) (hpow q' hq' _ (by omega))).trans ?_
    have hb := norm_pow_sub_pow_le hq hq' (n + 1)
    simp only [Nat.add_sub_cancel] at hb
    have hb' : ‖q ^ (n + 1) - q' ^ (n + 1)‖ ≤ ((n : ℝ) + 1) * ρ ^ n * ‖q - q'‖ := by
      push_cast at hb; linarith
    gcongr
  have h2 : ‖Complex.log (1 - q ^ (5 * (n + 1))) - Complex.log (1 - q' ^ (5 * (n + 1)))‖
      ≤ (5 * (n + 1) * ρ ^ n * ‖q - q'‖) / (1 - ρ) := by
    refine (norm_clog_one_sub_sub_le hρ1 (hpow q hq _ (by omega))
      (hpow q' hq' _ (by omega))).trans ?_
    have hb := norm_pow_sub_pow_le hq hq' (5 * (n + 1))
    have hmono : ρ ^ (5 * (n + 1) - 1) ≤ ρ ^ n :=
      pow_le_pow_of_le_one hρ0 hρ1.le (by omega)
    have hnn : (0 : ℝ) ≤ ‖q - q'‖ := norm_nonneg _
    have h5 : (0 : ℝ) ≤ 5 * ((n : ℝ) + 1) := by positivity
    have hstep : ‖q ^ (5 * (n + 1)) - q' ^ (5 * (n + 1))‖
        ≤ 5 * ((n : ℝ) + 1) * ρ ^ n * ‖q - q'‖ := by
      refine hb.trans ?_
      have hcast : ((5 * (n + 1) : ℕ) : ℝ) = 5 * ((n : ℝ) + 1) := by push_cast; ring
      rw [hcast]
      exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left hmono h5) hnn
    gcongr
  have hexpand : etaFactorCLog q n - etaFactorCLog q' n
      = 6 * (Complex.log (1 - q ^ (n + 1)) - Complex.log (1 - q' ^ (n + 1)))
        - 6 * (Complex.log (1 - q ^ (5 * (n + 1))) - Complex.log (1 - q' ^ (5 * (n + 1)))) := by
    simp [etaFactorCLog]; ring
  rw [hexpand]
  set L : ℝ := ‖q - q'‖ with hL
  set X : ℝ := (((n : ℝ) + 1) * ρ ^ n * L) / (1 - ρ) with hX
  set Y : ℝ := (5 * ((n : ℝ) + 1) * ρ ^ n * L) / (1 - ρ) with hY
  have htri := norm_sub_le (6 * (Complex.log (1 - q ^ (n + 1)) - Complex.log (1 - q' ^ (n + 1))))
    (6 * (Complex.log (1 - q ^ (5 * (n + 1))) - Complex.log (1 - q' ^ (5 * (n + 1)))))
  rw [norm_mul, norm_mul, show ‖(6 : ℂ)‖ = 6 by simp] at htri
  have hsum : 6 * ‖Complex.log (1 - q ^ (n + 1)) - Complex.log (1 - q' ^ (n + 1))‖
      + 6 * ‖Complex.log (1 - q ^ (5 * (n + 1))) - Complex.log (1 - q' ^ (5 * (n + 1)))‖
      ≤ 6 * X + 6 * Y := by linarith [h1, h2]
  have hval : 6 * X + 6 * Y = etaLipBound ρ n * L := by
    rw [hX, hY]
    unfold etaLipBound
    field_simp
    ring
  linarith [htri, hsum, hval.le, hval.ge]

theorem summable_etaLipBound {ρ : ℝ} (hρ0 : 0 ≤ ρ) (hρ1 : ρ < 1) : Summable (etaLipBound ρ) := by
  have hnorm : ‖ρ‖ < 1 := by rw [Real.norm_eq_abs, abs_of_nonneg hρ0]; exact hρ1
  have hgeom : Summable (fun n : ℕ => ρ ^ n) := summable_geometric_of_lt_one hρ0 hρ1
  have hmul : Summable (fun n : ℕ => (n : ℝ) * ρ ^ n) :=
    (summable_pow_mul_geometric_of_norm_lt_one 1 hnorm).congr (fun n => by simp)
  have h := (hmul.add hgeom).mul_left (36 / (1 - ρ))
  refine h.congr fun n => ?_
  unfold etaLipBound
  field_simp

/-- `Σₙ etaLipBound ρ n = 36/(1 − ρ)³`. -/
theorem tsum_etaLipBound {ρ : ℝ} (hρ0 : 0 ≤ ρ) (hρ1 : ρ < 1) :
    ∑' n, etaLipBound ρ n = 36 / (1 - ρ) ^ 3 := by
  have hpos : (0 : ℝ) < 1 - ρ := by linarith
  have hnorm : ‖ρ‖ < 1 := by rw [Real.norm_eq_abs, abs_of_nonneg hρ0]; exact hρ1
  have hgeom : Summable (fun n : ℕ => ρ ^ n) := summable_geometric_of_lt_one hρ0 hρ1
  have hmul : Summable (fun n : ℕ => (n : ℝ) * ρ ^ n) :=
    (summable_pow_mul_geometric_of_norm_lt_one 1 hnorm).congr (fun n => by simp)
  have key : ∑' n : ℕ, ((n : ℝ) + 1) * ρ ^ n = 1 / (1 - ρ) ^ 2 := by
    rw [tsum_congr (fun n : ℕ => by ring : ∀ n : ℕ, ((n : ℝ) + 1) * ρ ^ n
        = (n : ℝ) * ρ ^ n + ρ ^ n),
      hmul.tsum_add hgeom, tsum_coe_mul_geometric_of_norm_lt_one hnorm,
      tsum_geometric_of_lt_one hρ0 hρ1]
    field_simp
    ring
  rw [tsum_congr (fun n : ℕ => by unfold etaLipBound; field_simp :
      ∀ n : ℕ, etaLipBound ρ n = (36 / (1 - ρ)) * (((n : ℝ) + 1) * ρ ^ n)),
    tsum_mul_left, key]
  field_simp

/-- **The exponent of the eta quotient is Lipschitz on `‖q‖ ≤ ρ < 1`**, with the
explicit constant `36/(1 − ρ)³`. -/
theorem norm_tsum_etaFactorCLog_sub_le {ρ : ℝ} (hρ1 : ρ < 1) {q q' : ℂ}
    (hq : ‖q‖ ≤ ρ) (hq' : ‖q'‖ ≤ ρ) :
    ‖(∑' n, etaFactorCLog q n) - ∑' n, etaFactorCLog q' n‖ ≤ 36 / (1 - ρ) ^ 3 * ‖q - q'‖ := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg q) hq
  have hq1 : ‖q‖ < 1 := lt_of_le_of_lt hq hρ1
  have hq1' : ‖q'‖ < 1 := lt_of_le_of_lt hq' hρ1
  have hs := summable_etaFactorCLog hq1
  have hs' := summable_etaFactorCLog hq1'
  have hbound : Summable (fun n => etaLipBound ρ n * ‖q - q'‖) :=
    (summable_etaLipBound hρ0 hρ1).mul_right _
  rw [← hs.tsum_sub hs']
  refine (norm_tsum_le_tsum_norm ?_).trans ?_
  · refine Summable.of_nonneg_of_le (fun n => norm_nonneg _)
      (fun n => norm_etaFactorCLog_sub_le hρ1 hq hq' n) hbound
  · have hmono : ∑' n, ‖etaFactorCLog q n - etaFactorCLog q' n‖
        ≤ ∑' n, etaLipBound ρ n * ‖q - q'‖ := by
      refine Summable.tsum_mono ?_ hbound (fun n => norm_etaFactorCLog_sub_le hρ1 hq hq' n)
      exact Summable.of_nonneg_of_le (fun n => norm_nonneg _)
        (fun n => norm_etaFactorCLog_sub_le hρ1 hq hq' n) hbound
    rw [tsum_mul_right, tsum_etaLipBound hρ0 hρ1] at hmono
    exact hmono

/-! ## 3. `1/t` as an everywhere-defined regular function -/

/-- `x(q) = 1/t(q) = q · exp(−Σₙ etaFactorCLog q n)`.  Unlike `(hauptmodul q)⁻¹`
this formula is regular at `q = 0`, where it vanishes. -/
noncomputable def hauptmodulInv (q : ℂ) : ℂ := q * Complex.exp (-(∑' n, etaFactorCLog q n))

theorem hauptmodulInv_zero : hauptmodulInv 0 = 0 := by simp [hauptmodulInv]

/-- On the punctured unit disc, `hauptmodulInv` is the reciprocal of the
Hauptmodul. -/
theorem hauptmodulInv_eq_inv_hauptmodul {q : ℂ} (hq : ‖q‖ < 1) :
    hauptmodulInv q = (hauptmodul q)⁻¹ := by
  rw [hauptmodul, tprod_etaFactor hq, hauptmodulInv, mul_inv, inv_inv, Complex.exp_neg]

/-- `|Re Σₙ etaFactorCLog q n| ≤ 12ρ/(1 − ρ)²` for `‖q‖ ≤ ρ < 1`. -/
theorem abs_re_tsum_etaFactorCLog_le {ρ : ℝ} (hρ1 : ρ < 1) {q : ℂ} (hq : ‖q‖ ≤ ρ) :
    |(∑' n, etaFactorCLog q n).re| ≤ 12 * ρ / (1 - ρ) ^ 2 := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg q) hq
  have hq1 : ‖q‖ < 1 := lt_of_le_of_lt hq hρ1
  have hsum := summable_etaFactorLog hρ1 hq
  have hbound := summable_etaBound hρ0 hρ1
  have habsum : Summable (fun n => |etaFactorLog q n|) := hsum.abs
  have hre : (∑' n, etaFactorCLog q n).re = ∑' n, etaFactorLog q n := by
    rw [Complex.re_tsum (summable_etaFactorCLog hq1)]
    exact tsum_congr fun n => re_etaFactorCLog q n
  rw [hre, ← tsum_etaBound hρ0 hρ1]
  have hnorm : |∑' n, etaFactorLog q n| ≤ ∑' n, |etaFactorLog q n| := by
    simpa [Real.norm_eq_abs] using
      norm_tsum_le_tsum_norm (f := etaFactorLog q) (by simpa [Real.norm_eq_abs] using habsum)
  exact hnorm.trans (habsum.tsum_mono hbound (fun n => abs_etaFactorLog_le hρ1 hq n))

theorem norm_hauptmodulInv_le {ρ : ℝ} (hρ1 : ρ < 1) {q : ℂ} (hq : ‖q‖ ≤ ρ) :
    ‖hauptmodulInv q‖ ≤ ρ * Real.exp (12 * ρ / (1 - ρ) ^ 2) := by
  have hb := abs_le.1 (abs_re_tsum_etaFactorCLog_le hρ1 hq)
  rw [hauptmodulInv, norm_mul, Complex.norm_exp, Complex.neg_re]
  have h1 : Real.exp (-(∑' n, etaFactorCLog q n).re) ≤ Real.exp (12 * ρ / (1 - ρ) ^ 2) :=
    Real.exp_le_exp.2 (by linarith [hb.1])
  exact mul_le_mul hq h1 (Real.exp_pos _).le (le_trans (norm_nonneg q) hq)

/-- The Lipschitz constant of `x = 1/t` on the closed disc of radius `ρ`. -/
noncomputable def hauptmodulInvLip (ρ : ℝ) : ℝ :=
  Real.exp (12 * ρ / (1 - ρ) ^ 2) * (1 + ρ * (36 / (1 - ρ) ^ 3))

/-- **`x = 1/t` is Lipschitz on the closed disc of radius `ρ < 1`**, with the
explicit constant `hauptmodulInvLip ρ`. -/
theorem norm_hauptmodulInv_sub_le {ρ : ℝ} (hρ1 : ρ < 1) {q q' : ℂ}
    (hq : ‖q‖ ≤ ρ) (hq' : ‖q'‖ ≤ ρ) :
    ‖hauptmodulInv q - hauptmodulInv q'‖ ≤ hauptmodulInvLip ρ * ‖q - q'‖ := by
  have hρ0 : 0 ≤ ρ := le_trans (norm_nonneg q) hq
  have hpos : (0 : ℝ) < 1 - ρ := by linarith
  set B : ℝ := 12 * ρ / (1 - ρ) ^ 2 with hB
  set S : ℂ := ∑' n, etaFactorCLog q n with hS
  set S' : ℂ := ∑' n, etaFactorCLog q' n with hS'
  have hBre : (-S).re ≤ B := by
    have := abs_le.1 (abs_re_tsum_etaFactorCLog_le hρ1 hq)
    rw [Complex.neg_re]; linarith [this.1]
  have hBre' : (-S').re ≤ B := by
    have := abs_le.1 (abs_re_tsum_etaFactorCLog_le hρ1 hq')
    rw [Complex.neg_re]; linarith [this.1]
  have hEnorm : ‖Complex.exp (-S)‖ ≤ Real.exp B := by
    rw [Complex.norm_exp]; exact Real.exp_le_exp.2 hBre
  have hEdiff : ‖Complex.exp (-S) - Complex.exp (-S')‖
      ≤ Real.exp B * ((36 / (1 - ρ) ^ 3) * ‖q - q'‖) := by
    refine (norm_cexp_sub_cexp_le hBre hBre').trans ?_
    have : ‖-S - -S'‖ = ‖S - S'‖ := by rw [show -S - -S' = -(S - S') by ring, norm_neg]
    rw [this]
    exact mul_le_mul_of_nonneg_left (norm_tsum_etaFactorCLog_sub_le hρ1 hq hq')
      (Real.exp_pos _).le
  have hsplit : hauptmodulInv q - hauptmodulInv q'
      = (q - q') * Complex.exp (-S) + q' * (Complex.exp (-S) - Complex.exp (-S')) := by
    simp only [hauptmodulInv, ← hS, ← hS']; ring
  calc ‖hauptmodulInv q - hauptmodulInv q'‖
      ≤ ‖(q - q') * Complex.exp (-S)‖ + ‖q' * (Complex.exp (-S) - Complex.exp (-S'))‖ := by
        rw [hsplit]; exact norm_add_le _ _
    _ = ‖q - q'‖ * ‖Complex.exp (-S)‖ + ‖q'‖ * ‖Complex.exp (-S) - Complex.exp (-S')‖ := by
        rw [norm_mul, norm_mul]
    _ ≤ ‖q - q'‖ * Real.exp B + ρ * (Real.exp B * ((36 / (1 - ρ) ^ 3) * ‖q - q'‖)) := by
        gcongr
    _ = hauptmodulInvLip ρ * ‖q - q'‖ := by unfold hauptmodulInvLip; rw [← hB]; ring

/-! ## 4. The published template is Lipschitz on the closed unit disc -/

open Finset in
theorem hasDerivAt_logPsi (a : ℕ → ℝ) (z : ℂ) :
    HasDerivAt (Published.logPsi a)
      (∑ k ∈ range 41, (a k : ℂ) * ((k : ℂ) * z ^ (k - 1))) z := by
  unfold Published.logPsi
  exact HasDerivAt.fun_sum fun k _ => ((hasDerivAt_pow k z).const_mul (a k : ℂ))

open Finset in
/-- The `ℓ¹`-norm of the published coefficients, with the rounding allowance:
`‖Σ_k c_k z^k‖ ≤ 1.19` on the closed unit disc. -/
theorem norm_logPsi_le {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ} (hz : ‖z‖ ≤ 1) :
    ‖Published.logPsi a z‖ ≤ 119 / 100 := by
  have hterm : ∀ k ∈ range 41, ‖(a k : ℂ) * z ^ k‖
      ≤ |(Published.pubC k : ℝ)| + (Published.roundErr : ℝ) := by
    intro k _
    rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs]
    calc |a k| * ‖z‖ ^ k ≤ |a k| * 1 := by
          have : ‖z‖ ^ k ≤ 1 := pow_le_one₀ (norm_nonneg z) hz
          exact mul_le_mul_of_nonneg_left this (abs_nonneg _)
      _ = |a k| := mul_one _
      _ ≤ _ := Published.abs_coeff_le h k
  have hsum : ∑ k ∈ range 41, (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ))
      ≤ 119 / 100 := by
    have : ∑ k ∈ range 41, (|Published.pubC k| + Published.roundErr)
        = 1189904810 / 1000000000 + 41 / 1000000000 := by
      norm_num [Finset.sum_range_succ, Published.pubC, Published.roundErr]
    have hcast : ∑ k ∈ range 41, (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ))
        = ((∑ k ∈ range 41, (|Published.pubC k| + Published.roundErr) : ℚ) : ℝ) := by
      push_cast
      rfl
    rw [hcast, this]
    norm_num
  calc ‖Published.logPsi a z‖ ≤ ∑ k ∈ range 41, ‖(a k : ℂ) * z ^ k‖ :=
        norm_sum_le _ _
    _ ≤ ∑ k ∈ range 41, (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ)) :=
        Finset.sum_le_sum hterm
    _ ≤ 119 / 100 := hsum

open Finset in
/-- The `ℓ¹`-norm of the derivative coefficients: `‖Σ_k k c_k z^{k−1}‖ ≤ 4.36`
on the closed unit disc. -/
theorem norm_deriv_logPsi_le {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ} (hz : ‖z‖ ≤ 1) :
    ‖∑ k ∈ range 41, (a k : ℂ) * ((k : ℂ) * z ^ (k - 1))‖ ≤ 436 / 100 := by
  have hterm : ∀ k ∈ range 41, ‖(a k : ℂ) * ((k : ℂ) * z ^ (k - 1))‖
      ≤ (k : ℝ) * (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ)) := by
    intro k _
    rw [norm_mul, norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs,
      Complex.norm_natCast]
    have hp : ‖z‖ ^ (k - 1) ≤ 1 := pow_le_one₀ (norm_nonneg z) hz
    have hk : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
    calc |a k| * ((k : ℝ) * ‖z‖ ^ (k - 1)) ≤ |a k| * ((k : ℝ) * 1) := by
          gcongr
      _ = (k : ℝ) * |a k| := by ring
      _ ≤ (k : ℝ) * (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ)) :=
          mul_le_mul_of_nonneg_left (Published.abs_coeff_le h k) hk
  have hsum : ∑ k ∈ range 41, (k : ℝ) * (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ))
      ≤ 436 / 100 := by
    have hq : ∑ k ∈ range 41, (k : ℚ) * (|Published.pubC k| + Published.roundErr)
        = 4358940702 / 1000000000 + 820 / 1000000000 := by
      norm_num [Finset.sum_range_succ, Published.pubC, Published.roundErr]
    have hcast : ∑ k ∈ range 41, (k : ℝ) * (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ))
        = ((∑ k ∈ range 41, (k : ℚ) * (|Published.pubC k| + Published.roundErr) : ℚ) : ℝ) := by
      push_cast
      rfl
    rw [hcast, hq]
    norm_num
  calc ‖∑ k ∈ range 41, (a k : ℂ) * ((k : ℂ) * z ^ (k - 1))‖
      ≤ ∑ k ∈ range 41, ‖(a k : ℂ) * ((k : ℂ) * z ^ (k - 1))‖ := norm_sum_le _ _
    _ ≤ ∑ k ∈ range 41, (k : ℝ) * (|(Published.pubC k : ℝ)| + (Published.roundErr : ℝ)) :=
        Finset.sum_le_sum hterm
    _ ≤ 436 / 100 := hsum

theorem exp_119_le : Real.exp (119 / 100) ≤ 739 / 100 := by
  have h1 : Real.exp (119 / 100) ≤ Real.exp 2 := Real.exp_le_exp.2 (by norm_num)
  have h2 : Real.exp 2 = Real.exp 1 ^ 2 := by
    rw [← Real.exp_nat_mul]; norm_num
  have h3 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
  have h4 : (0 : ℝ) < Real.exp 1 := Real.exp_pos 1
  nlinarith [h1, h2, h3, h4]

/-- **The published template is Lipschitz on the closed unit disc**, with the
explicit constant `40`. -/
theorem norm_psi_sub_le {a : ℕ → ℝ} (h : Published.Approximates a) {z w : ℂ}
    (hz : ‖z‖ ≤ 1) (hw : ‖w‖ ≤ 1) :
    ‖Published.psi a z - Published.psi a w‖ ≤ 40 * ‖z - w‖ := by
  refine norm_sub_le_of_deriv_le (convex_closedBall (0 : ℂ) 1)
    (f := Published.psi a)
    (f' := fun x => Complex.exp (Published.logPsi a x)
      + x * (Complex.exp (Published.logPsi a x)
        * ∑ k ∈ Finset.range 41, (a k : ℂ) * ((k : ℂ) * x ^ (k - 1))))
    (fun x _ => ?_) (fun x hx => ?_)
    (mem_closedBall_of_norm_le hz) (mem_closedBall_of_norm_le hw)
  · have hd := ((hasDerivAt_logPsi a x).cexp)
    have := (hasDerivAt_id x).mul hd
    simpa [Published.psi, mul_comm, mul_left_comm, mul_assoc] using this
  · have hx : ‖x‖ ≤ 1 := by simpa [Metric.mem_closedBall] using hx
    have hE : ‖Complex.exp (Published.logPsi a x)‖ ≤ 739 / 100 := by
      rw [Complex.norm_exp]
      refine le_trans (Real.exp_le_exp.2 ?_) exp_119_le
      exact le_trans (Complex.re_le_norm _) (norm_logPsi_le h hx)
    have hD := norm_deriv_logPsi_le h hx
    have hEpos : (0 : ℝ) ≤ ‖Complex.exp (Published.logPsi a x)‖ := norm_nonneg _
    calc ‖Complex.exp (Published.logPsi a x)
            + x * (Complex.exp (Published.logPsi a x)
              * ∑ k ∈ Finset.range 41, (a k : ℂ) * ((k : ℂ) * x ^ (k - 1)))‖
        ≤ ‖Complex.exp (Published.logPsi a x)‖
          + ‖x‖ * (‖Complex.exp (Published.logPsi a x)‖
            * ‖∑ k ∈ Finset.range 41, (a k : ℂ) * ((k : ℂ) * x ^ (k - 1))‖) := by
          refine (norm_add_le _ _).trans ?_
          rw [norm_mul, norm_mul]
      _ ≤ 739 / 100 + 1 * (739 / 100 * (436 / 100)) := by
          gcongr
      _ ≤ 40 := by norm_num

/-! ## 5. The map `F = (1/t) ∘ ψ` on the closed unit disc -/

/-- `F = x ∘ ψ = (1/t) ∘ ψ`, the live normalisation of the draft.  It is defined
on all of `ℂ` by the formula, and agrees with `(φ a)⁻¹` on the punctured closed
unit disc. -/
noncomputable def Fmap (a : ℕ → ℝ) (z : ℂ) : ℂ := hauptmodulInv (Published.psi a z)

theorem Fmap_zero (a : ℕ → ℝ) : Fmap a 0 = 0 := by
  rw [Fmap, psi_zero, hauptmodulInv_zero]

/-- `F` is the reciprocal of `φ = t ∘ ψ` away from the origin. -/
theorem Fmap_eq_phi_inv {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ} (hz : ‖z‖ ≤ 1) :
    Fmap a z = (phi a z)⁻¹ :=
  hauptmodulInv_eq_inv_hauptmodul (norm_psi_lt_one_of_le_one h hz)

theorem exp_five_thousand_bound :
    12 * (psiRadius : ℝ) / (1 - (psiRadius : ℝ)) ^ 2 ≤ 5178 := by
  norm_num [psiRadius]

/-- **Crude certified sup bound**: `‖F‖ ≤ exp 5178` on the closed unit disc. -/
theorem norm_Fmap_le {a : ℕ → ℝ} (h : Published.Approximates a) {z : ℂ} (hz : ‖z‖ ≤ 1) :
    ‖Fmap a z‖ ≤ Real.exp 5178 := by
  have hq := norm_psi_le_psiRadius h hz
  refine (norm_hauptmodulInv_le psiRadius_lt_one hq).trans ?_
  have h1 : Real.exp (12 * (psiRadius : ℝ) / (1 - (psiRadius : ℝ)) ^ 2) ≤ Real.exp 5178 :=
    Real.exp_le_exp.2 exp_five_thousand_bound
  have h2 : (psiRadius : ℝ) ≤ 1 := le_of_lt psiRadius_lt_one
  calc (psiRadius : ℝ) * Real.exp (12 * (psiRadius : ℝ) / (1 - (psiRadius : ℝ)) ^ 2)
      ≤ 1 * Real.exp 5178 := by
        exact mul_le_mul h2 h1 (Real.exp_pos _).le zero_le_one
    _ = Real.exp 5178 := one_mul _

theorem exp_twentytwo_bound : (1 + (psiRadius : ℝ) * (36 / (1 - (psiRadius : ℝ)) ^ 3)) * 40
    ≤ Real.exp 22 := by
  have h3 : (2.7182818283 : ℝ) < Real.exp 1 := Real.exp_one_gt_d9
  have h22 : Real.exp 22 = Real.exp 1 ^ 22 := by
    rw [← Real.exp_nat_mul]; norm_num
  have hpow : (2.7 : ℝ) ^ 22 ≤ Real.exp 1 ^ 22 := by
    refine pow_le_pow_left₀ (by norm_num) ?_ 22
    linarith
  have hnum : (1 + (psiRadius : ℝ) * (36 / (1 - (psiRadius : ℝ)) ^ 3)) * 40 ≤ (2.7 : ℝ) ^ 22 := by
    norm_num [psiRadius]
  rw [h22]
  linarith

/-- **`F` is Lipschitz on the closed unit disc**, with the (crude) explicit
constant `exp 5200`. -/
theorem norm_Fmap_sub_le {a : ℕ → ℝ} (h : Published.Approximates a) {z w : ℂ}
    (hz : ‖z‖ ≤ 1) (hw : ‖w‖ ≤ 1) :
    ‖Fmap a z - Fmap a w‖ ≤ Real.exp 5200 * ‖z - w‖ := by
  have hq := norm_psi_le_psiRadius h hz
  have hq' := norm_psi_le_psiRadius h hw
  have h1 := norm_hauptmodulInv_sub_le psiRadius_lt_one hq hq'
  have h2 := norm_psi_sub_le h hz hw
  have hLpos : (0 : ℝ) ≤ hauptmodulInvLip (psiRadius : ℝ) := by
    unfold hauptmodulInvLip
    have : (0 : ℝ) ≤ 36 / (1 - (psiRadius : ℝ)) ^ 3 := by norm_num [psiRadius]
    have hρ : (0 : ℝ) ≤ (psiRadius : ℝ) := psiRadius_pos.le
    positivity
  have hchain : ‖Fmap a z - Fmap a w‖
      ≤ hauptmodulInvLip (psiRadius : ℝ) * (40 * ‖z - w‖) := by
    refine h1.trans ?_
    exact mul_le_mul_of_nonneg_left h2 hLpos
  refine hchain.trans ?_
  have hconst : hauptmodulInvLip (psiRadius : ℝ) * 40 ≤ Real.exp 5200 := by
    unfold hauptmodulInvLip
    have hA : Real.exp (12 * (psiRadius : ℝ) / (1 - (psiRadius : ℝ)) ^ 2) ≤ Real.exp 5178 :=
      Real.exp_le_exp.2 exp_five_thousand_bound
    have hB := exp_twentytwo_bound
    have hnn : (0 : ℝ) ≤ (1 + (psiRadius : ℝ) * (36 / (1 - (psiRadius : ℝ)) ^ 3)) * 40 := by
      norm_num [psiRadius]
    calc Real.exp (12 * (psiRadius : ℝ) / (1 - (psiRadius : ℝ)) ^ 2)
          * (1 + (psiRadius : ℝ) * (36 / (1 - (psiRadius : ℝ)) ^ 3)) * 40
        = Real.exp (12 * (psiRadius : ℝ) / (1 - (psiRadius : ℝ)) ^ 2)
          * ((1 + (psiRadius : ℝ) * (36 / (1 - (psiRadius : ℝ)) ^ 3)) * 40) := by ring
      _ ≤ Real.exp 5178 * Real.exp 22 := by
          exact mul_le_mul hA hB hnn (Real.exp_pos _).le
      _ = Real.exp 5200 := by rw [← Real.exp_add]; norm_num
  calc hauptmodulInvLip (psiRadius : ℝ) * (40 * ‖z - w‖)
      = (hauptmodulInvLip (psiRadius : ℝ) * 40) * ‖z - w‖ := by ring
    _ ≤ Real.exp 5200 * ‖z - w‖ := by
        exact mul_le_mul_of_nonneg_right hconst (norm_nonneg _)

/-! ## 6. The divided difference `g` -/

/-- The divided difference `g(z,w) = (f(z) − f(w))/(z − w)`. -/
noncomputable def dividedDiff (f : ℂ → ℂ) (z w : ℂ) : ℂ := (f z - f w) / (z - w)

/-- The factorisation `f(z) − f(w) = (z − w)·g(z,w)`, valid for all `z, w`
(both sides vanish on the diagonal).  This is exactly the hypothesis `hfac` of
`pairwiseEnergy_eq_of_factor`. -/
theorem dividedDiff_mul (f : ℂ → ℂ) (z w : ℂ) : f z - f w = (z - w) * dividedDiff f z w := by
  rcases eq_or_ne z w with rfl | hne
  · simp
  · rw [dividedDiff, mul_div_cancel₀ _ (sub_ne_zero.2 hne)]

theorem dividedDiff_symm (f : ℂ → ℂ) (z w : ℂ) : dividedDiff f z w = dividedDiff f w z := by
  rcases eq_or_ne z w with rfl | hne
  · rfl
  · rw [dividedDiff, dividedDiff, ← neg_sub w z, ← neg_sub (f w) (f z), neg_div_neg_eq]

/-- **The regular integrand.**  `g(z,w) = (F(z) − F(w))/(z − w)` for
`F = (1/t) ∘ ψ`: the factor left after the diagonal singularity `log‖z − w‖`
of the Bost–Charles energy has been split off. -/
noncomputable def gPhiInv (a : ℕ → ℝ) (z w : ℂ) : ℂ := dividedDiff (Fmap a) z w

theorem gPhiInv_mul (a : ℕ → ℝ) (z w : ℂ) :
    Fmap a z - Fmap a w = (z - w) * gPhiInv a z w := dividedDiff_mul _ z w

theorem gPhiInv_symm (a : ℕ → ℝ) (z w : ℂ) : gPhiInv a z w = gPhiInv a w z :=
  dividedDiff_symm _ z w

/-- **`g` is bounded on the whole closed bidisc**, by the Lipschitz constant of
`F`.  No diagonal strip has to be removed: the divided difference of a Lipschitz
function is bounded by its Lipschitz constant. -/
theorem norm_gPhiInv_le {a : ℕ → ℝ} (h : Published.Approximates a) {z w : ℂ}
    (hz : ‖z‖ ≤ 1) (hw : ‖w‖ ≤ 1) : ‖gPhiInv a z w‖ ≤ Real.exp 5200 := by
  rcases eq_or_ne z w with rfl | hne
  · simp [gPhiInv, dividedDiff, (Real.exp_pos (5200 : ℝ)).le]
  · have hd : (0 : ℝ) < ‖z - w‖ := by
      rw [norm_pos_iff]; exact sub_ne_zero.2 hne
    rw [gPhiInv, dividedDiff, norm_div, div_le_iff₀ hd]
    exact norm_Fmap_sub_le h hz hw

/-- `F` is continuous on the closed unit disc (it is Lipschitz there). -/
theorem continuousOn_Fmap {a : ℕ → ℝ} (h : Published.Approximates a) :
    ContinuousOn (Fmap a) (Metric.closedBall (0 : ℂ) 1) := by
  have hK : LipschitzOnWith ⟨Real.exp 5200, (Real.exp_pos _).le⟩ (Fmap a)
      (Metric.closedBall (0 : ℂ) 1) := by
    refine LipschitzOnWith.of_dist_le_mul fun x hx y hy => ?_
    have hx' : ‖x‖ ≤ 1 := by simpa [Metric.mem_closedBall] using hx
    have hy' : ‖y‖ ≤ 1 := by simpa [Metric.mem_closedBall] using hy
    simpa [dist_eq_norm] using norm_Fmap_sub_le h hx' hy'
  exact hK.continuousOn

/-- **`g` is continuous off the diagonal** of the closed bidisc. -/
theorem continuousOn_gPhiInv_offDiag {a : ℕ → ℝ} (h : Published.Approximates a) :
    ContinuousOn (fun p : ℂ × ℂ => gPhiInv a p.1 p.2)
      {p : ℂ × ℂ | ‖p.1‖ ≤ 1 ∧ ‖p.2‖ ≤ 1 ∧ p.1 ≠ p.2} := by
  set S : Set (ℂ × ℂ) := {p : ℂ × ℂ | ‖p.1‖ ≤ 1 ∧ ‖p.2‖ ≤ 1 ∧ p.1 ≠ p.2} with hS
  have hmem1 : ∀ p ∈ S, p.1 ∈ Metric.closedBall (0 : ℂ) 1 := by
    intro p hp; simpa [Metric.mem_closedBall] using hp.1
  have hmem2 : ∀ p ∈ S, p.2 ∈ Metric.closedBall (0 : ℂ) 1 := by
    intro p hp; simpa [Metric.mem_closedBall] using hp.2.1
  have h1 : ContinuousOn (fun p : ℂ × ℂ => Fmap a p.1) S :=
    (continuousOn_Fmap h).comp continuousOn_fst hmem1
  have h2 : ContinuousOn (fun p : ℂ × ℂ => Fmap a p.2) S :=
    (continuousOn_Fmap h).comp continuousOn_snd hmem2
  have h3 : ContinuousOn (fun p : ℂ × ℂ => p.1 - p.2) S :=
    (continuousOn_fst.sub continuousOn_snd)
  exact (h1.sub h2).div h3 fun p hp => sub_ne_zero.2 hp.2.2

/-- **An explicit modulus of continuity for `g` off a diagonal strip.**  If the
second argument stays at distance at least `d > 0` from both first arguments,
then `g(·, w)` is Lipschitz with constant `exp 5200 · (1/d + 2/d²)`. -/
theorem norm_gPhiInv_sub_le {a : ℕ → ℝ} (h : Published.Approximates a) {z z' w : ℂ}
    (hz : ‖z‖ ≤ 1) (hz' : ‖z'‖ ≤ 1) (hw : ‖w‖ ≤ 1) {d : ℝ} (hd : 0 < d)
    (h1 : d ≤ ‖z - w‖) (h2 : d ≤ ‖z' - w‖) :
    ‖gPhiInv a z w - gPhiInv a z' w‖ ≤ Real.exp 5200 * (1 / d + 2 / d ^ 2) * ‖z - z'‖ := by
  have hu : z - w ≠ 0 := by
    intro hcon; rw [hcon] at h1; simp at h1; linarith
  have hv : z' - w ≠ 0 := by
    intro hcon; rw [hcon] at h2; simp at h2; linarith
  have hunorm : (0 : ℝ) < ‖z - w‖ := lt_of_lt_of_le hd h1
  have hvnorm : (0 : ℝ) < ‖z' - w‖ := lt_of_lt_of_le hd h2
  -- the algebraic identity
  have hid : gPhiInv a z w - gPhiInv a z' w
      = (Fmap a z - Fmap a z') / (z - w)
        + (Fmap a z' - Fmap a w) * ((z' - z) / ((z - w) * (z' - w))) := by
    rw [gPhiInv, gPhiInv, dividedDiff, dividedDiff]
    field_simp
    ring
  -- the two pieces
  have hA : ‖(Fmap a z - Fmap a z') / (z - w)‖ ≤ Real.exp 5200 * (1 / d) * ‖z - z'‖ := by
    rw [norm_div, div_le_iff₀ hunorm]
    have hFL := norm_Fmap_sub_le h hz hz'
    have hstep : Real.exp 5200 * ‖z - z'‖ ≤ Real.exp 5200 * (1 / d) * ‖z - z'‖ * ‖z - w‖ := by
      have hd1 : ‖z - w‖ / d ≥ 1 := (one_le_div hd).2 h1
      have hpos : (0 : ℝ) ≤ Real.exp 5200 * ‖z - z'‖ := by positivity
      calc Real.exp 5200 * ‖z - z'‖ = (Real.exp 5200 * ‖z - z'‖) * 1 := (mul_one _).symm
        _ ≤ (Real.exp 5200 * ‖z - z'‖) * (‖z - w‖ / d) := by
            exact mul_le_mul_of_nonneg_left hd1 hpos
        _ = Real.exp 5200 * (1 / d) * ‖z - z'‖ * ‖z - w‖ := by field_simp
    linarith [hFL, hstep]
  have hB : ‖(Fmap a z' - Fmap a w) * ((z' - z) / ((z - w) * (z' - w)))‖
      ≤ Real.exp 5200 * (2 / d ^ 2) * ‖z - z'‖ := by
    have hnum : ‖Fmap a z' - Fmap a w‖ ≤ 2 * Real.exp 5178 := by
      have hx := norm_Fmap_le h hz'
      have hy := norm_Fmap_le h hw
      calc ‖Fmap a z' - Fmap a w‖ ≤ ‖Fmap a z'‖ + ‖Fmap a w‖ := norm_sub_le _ _
        _ ≤ 2 * Real.exp 5178 := by linarith
    have hden : ‖(z' - z) / ((z - w) * (z' - w))‖ ≤ ‖z - z'‖ / d ^ 2 := by
      rw [norm_div, norm_mul, ← norm_neg (z' - z), neg_sub]
      have hd2 : (0 : ℝ) < ‖z - w‖ * ‖z' - w‖ := mul_pos hunorm hvnorm
      rw [div_le_div_iff₀ hd2 (by positivity)]
      have : d ^ 2 ≤ ‖z - w‖ * ‖z' - w‖ := by
        calc d ^ 2 = d * d := sq d
          _ ≤ ‖z - w‖ * ‖z' - w‖ := by
              exact mul_le_mul h1 h2 hd.le (le_trans hd.le h1)
      exact mul_le_mul_of_nonneg_left this (norm_nonneg _)
    have h5178 : Real.exp 5178 ≤ Real.exp 5200 := Real.exp_le_exp.2 (by norm_num)
    calc ‖(Fmap a z' - Fmap a w) * ((z' - z) / ((z - w) * (z' - w)))‖
        = ‖Fmap a z' - Fmap a w‖ * ‖(z' - z) / ((z - w) * (z' - w))‖ := norm_mul _ _
      _ ≤ (2 * Real.exp 5178) * (‖z - z'‖ / d ^ 2) := by
          exact mul_le_mul hnum hden (norm_nonneg _) (by positivity)
      _ ≤ (2 * Real.exp 5200) * (‖z - z'‖ / d ^ 2) := by
          have : (0 : ℝ) ≤ ‖z - z'‖ / d ^ 2 := by positivity
          nlinarith [h5178, this]
      _ = Real.exp 5200 * (2 / d ^ 2) * ‖z - z'‖ := by field_simp
  calc ‖gPhiInv a z w - gPhiInv a z' w‖
      ≤ ‖(Fmap a z - Fmap a z') / (z - w)‖
        + ‖(Fmap a z' - Fmap a w) * ((z' - z) / ((z - w) * (z' - w)))‖ := by
        rw [hid]; exact norm_add_le _ _
    _ ≤ Real.exp 5200 * (1 / d) * ‖z - z'‖ + Real.exp 5200 * (2 / d ^ 2) * ‖z - z'‖ := by
        linarith [hA, hB]
    _ = Real.exp 5200 * (1 / d + 2 / d ^ 2) * ‖z - z'‖ := by ring

/-! ## 7. From a diagonal strip in the angles to a distance on the circle -/

theorem norm_circleMap_sub_circleMap (θ ψ : ℝ) :
    ‖circleMap 0 1 θ - circleMap 0 1 ψ‖ = 2 * |Real.sin ((θ - ψ) / 2)| := by
  have hθ : circleMap 0 1 θ = Complex.exp (θ * Complex.I) := by
    simp [circleMap]
  have hψ : circleMap 0 1 ψ = Complex.exp (ψ * Complex.I) := by
    simp [circleMap]
  set s : ℝ := (θ + ψ) / 2 with hs
  set t : ℝ := (θ - ψ) / 2 with ht
  have hsum : (θ : ℂ) = (s : ℂ) + (t : ℂ) := by
    rw [hs, ht]; push_cast; ring
  have hdiff : (ψ : ℂ) = (s : ℂ) - (t : ℂ) := by
    rw [hs, ht]; push_cast; ring
  rw [hθ, hψ, hsum, hdiff]
  have hfac : Complex.exp (((s : ℂ) + t) * Complex.I) - Complex.exp (((s : ℂ) - t) * Complex.I)
      = Complex.exp ((s : ℂ) * Complex.I)
        * (Complex.exp ((t : ℂ) * Complex.I) - Complex.exp ((-(t : ℂ)) * Complex.I)) := by
    rw [mul_sub, ← Complex.exp_add, ← Complex.exp_add]
    ring_nf
  have htwo : Complex.exp ((t : ℂ) * Complex.I) - Complex.exp ((-(t : ℂ)) * Complex.I)
      = 2 * Complex.I * Complex.sin (t : ℂ) := by
    rw [Complex.exp_mul_I, Complex.exp_mul_I, Complex.cos_neg, Complex.sin_neg]
    ring
  rw [hfac, htwo, norm_mul, Complex.norm_exp_ofReal_mul_I, one_mul, norm_mul, norm_mul,
    ← Complex.ofReal_sin, Complex.norm_real, Real.norm_eq_abs]
  simp

/-- Off the diagonal strip `|θ − ψ| ≥ δ` (measured within one period), points on
the unit circle are at distance at least `2 sin(δ/2)`. -/
theorem norm_circleMap_sub_circleMap_ge {δ θ ψ : ℝ} (hδ0 : 0 ≤ δ)
    (hlow : δ ≤ |θ - ψ|) (hhigh : |θ - ψ| ≤ 2 * π - δ) :
    2 * Real.sin (δ / 2) ≤ ‖circleMap 0 1 θ - circleMap 0 1 ψ‖ := by
  have hpi := Real.pi_pos
  set u : ℝ := |θ - ψ| / 2 with hu
  have hu0 : δ / 2 ≤ u := by rw [hu]; linarith
  have hu1 : u ≤ π - δ / 2 := by rw [hu]; linarith
  have hδπ : δ ≤ π := by linarith
  have hsin : Real.sin (δ / 2) ≤ Real.sin u := by
    by_cases hcase : u ≤ π / 2
    · exact Real.sin_le_sin_of_le_of_le_pi_div_two (by linarith) hcase hu0
    · have h1 : Real.sin u = Real.sin (π - u) := (Real.sin_pi_sub u).symm
      rw [h1]
      exact Real.sin_le_sin_of_le_of_le_pi_div_two (by linarith) (by linarith) (by linarith)
  have hu0' : 0 ≤ u := le_trans (by linarith) hu0
  have huπ : u ≤ π := by linarith
  have hsinu : 0 ≤ Real.sin u := Real.sin_nonneg_of_nonneg_of_le_pi hu0' huπ
  have habs : |Real.sin ((θ - ψ) / 2)| = Real.sin u := by
    rcases abs_cases (θ - ψ) with ⟨heq, _⟩ | ⟨heq, _⟩
    · have hval : (θ - ψ) / 2 = u := by rw [hu, heq]
      rw [hval, abs_of_nonneg hsinu]
    · have hval : (θ - ψ) / 2 = -u := by rw [hu, heq]; ring
      rw [hval, Real.sin_neg, abs_neg, abs_of_nonneg hsinu]
  rw [norm_circleMap_sub_circleMap, habs]
  linarith [hsin]

/-! ## 8. The two statements on the torus -/

/-- The factorisation in exactly the form required by
`pairwiseEnergy_eq_of_factor`: on the unit circle,
`F(e^{iθ}) − F(e^{iψ}) = (e^{iθ} − e^{iψ})·g(e^{iθ}, e^{iψ})`. -/
theorem gPhiInv_factorisation (a : ℕ → ℝ) (θ ψ : ℝ) :
    Fmap a (circleMap 0 1 θ) - Fmap a (circleMap 0 1 ψ)
      = (circleMap 0 1 θ - circleMap 0 1 ψ)
        * gPhiInv a (circleMap 0 1 θ) (circleMap 0 1 ψ) :=
  gPhiInv_mul a _ _

/-- **`g` is bounded on the torus.**  (In fact on the whole closed bidisc; the
diagonal needs no special treatment because `F` is Lipschitz.) -/
theorem norm_gPhiInv_circleMap_le {a : ℕ → ℝ} (h : Published.Approximates a) (θ ψ : ℝ) :
    ‖gPhiInv a (circleMap 0 1 θ) (circleMap 0 1 ψ)‖ ≤ Real.exp 5200 :=
  norm_gPhiInv_le h (le_of_eq (norm_circleMap_one θ)) (le_of_eq (norm_circleMap_one ψ))

/-- **Lipschitz control of `g` off the diagonal strip `|θ − ψ| ≥ δ`.**  For
`0 < δ < 2π` and angles `θ, θ'` both at angular distance at least `δ` from `ψ`,

`‖g(e^{iθ}, e^{iψ}) − g(e^{iθ'}, e^{iψ})‖ ≤ exp 5200 · (1/d + 2/d²) · ‖e^{iθ} − e^{iθ'}‖`,
`d = 2 sin(δ/2)`. -/
theorem norm_gPhiInv_circleMap_sub_le {a : ℕ → ℝ} (h : Published.Approximates a)
    {δ θ θ' ψ : ℝ} (hδ0 : 0 < δ) (hδπ : δ < 2 * π)
    (h1 : δ ≤ |θ - ψ|) (h1' : |θ - ψ| ≤ 2 * π - δ)
    (h2 : δ ≤ |θ' - ψ|) (h2' : |θ' - ψ| ≤ 2 * π - δ) :
    ‖gPhiInv a (circleMap 0 1 θ) (circleMap 0 1 ψ)
        - gPhiInv a (circleMap 0 1 θ') (circleMap 0 1 ψ)‖
      ≤ Real.exp 5200 * (1 / (2 * Real.sin (δ / 2)) + 2 / (2 * Real.sin (δ / 2)) ^ 2)
        * ‖circleMap 0 1 θ - circleMap 0 1 θ'‖ := by
  have hpi := Real.pi_pos
  have hsin : 0 < Real.sin (δ / 2) :=
    Real.sin_pos_of_pos_of_lt_pi (by linarith) (by linarith)
  have hd : 0 < 2 * Real.sin (δ / 2) := by linarith
  exact norm_gPhiInv_sub_le h (le_of_eq (norm_circleMap_one θ))
    (le_of_eq (norm_circleMap_one θ')) (le_of_eq (norm_circleMap_one ψ)) hd
    (norm_circleMap_sub_circleMap_ge hδ0.le h1 h1')
    (norm_circleMap_sub_circleMap_ge hδ0.le h2 h2')

end Zeta5.Hauptmodul
