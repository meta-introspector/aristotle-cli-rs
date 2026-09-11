import Mathlib
import RequestProject.Imported.Loose.DulaViazovska
import RequestProject.Imported.Loose.SharpLowerBound

/-!
# DULA-VIAZOVSKA v11.18: Kernel Summation
Formalizing the global stability of the 28.87 floor.
Constructing a permanent spectral witness through modular kernel superposition.
-/

open Real Complex MeasureTheory
open scoped BigOperators

-- 1. DEFINE THE KERNEL SUM
/--
The DULA Kernel Sum S(t) superimposes modular bumps at periodic intervals δ.
This represents the 1D shadow of the Leech Lattice Theta series.
-/
noncomputable def dula_kernel_sum (t δ : ℝ) : ℂ :=
  ∑' n : ℤ, dula_h_star t (n * δ)

/-! ## Helper lemmas -/

/-
PROBLEM
Each term of the kernel sum has nonneg real part.

PROVIDED SOLUTION
Unfold dula_h_star. The real part is 29.4525 * exp(-(t-k)²). Both 29.4525 and exp are nonneg, so their product is nonneg.
-/
lemma dula_h_star_re_nonneg (t k : ℝ) : (dula_h_star t k).re ≥ 0 := by
  exact mul_nonneg ( by norm_num ) ( Real.exp_nonneg _ )

/-
PROBLEM
The imaginary part of dula_h_star is zero.

PROVIDED SOLUTION
Unfold dula_h_star. The imaginary part is 0 by definition.
-/
lemma dula_h_star_im_zero (t k : ℝ) : (dula_h_star t k).im = 0 := by
  simp [dula_h_star]

/-
PROBLEM
dula_h_star at equal arguments gives the peak value.

PROVIDED SOLUTION
Unfold dula_h_star. At t=k, (t-k)²=0, exp(0)=1, so re = 29.4525 * 1 = 29.4525.
-/
lemma dula_h_star_peak (t : ℝ) : (dula_h_star t t).re = 29.4525 := by
  unfold dula_h_star; norm_num;

/-
PROBLEM
The kernel sum terms are summable.

PROVIDED SOLUTION
The terms are dula_h_star t (n * δ) = ⟨29.4525 * exp(-(t - nδ)²), 0⟩. To show summability of this ℤ → ℂ function, it suffices to show the norm is summable. The norm equals |29.4525 * exp(-(t - nδ)²)| = 29.4525 * exp(-(t - nδ)²) since both are positive. For large |n|, (t - nδ)² grows like n²δ², so exp(-(t-nδ)²) decays super-exponentially. Use comparison with a geometric series or Summable of exp(-cn²). Alternatively, use hasSum/summable machinery for Gaussian-type sums. A clean approach: show ‖dula_h_star t (n*δ)‖ ≤ 29.4525 for all n, and that the terms go to 0 fast enough. Actually, use that the function n ↦ exp(-(t - nδ)²) is bounded by exp(-c*n²+C) for some constants, and this is summable.
-/
lemma dula_kernel_summable (t δ : ℝ) (hδ : δ ≠ 0) :
    Summable (fun n : ℤ => dula_h_star t (↑n * δ)) := by
  refine' .of_norm _;
  -- The series $\sum_{n=-\infty}^{\infty} e^{-(t - n\delta)^2}$ is a Gaussian series, which converges.
  have h_gaussian : Summable (fun n : ℤ => Real.exp (-(t - n * δ)^2)) := by
    have h_gaussian : Summable (fun n : ℤ => Real.exp (-n^2 * δ^2 / 2)) := by
      have h_gaussian : Summable (fun n : ℕ => Real.exp (-n^2 * δ^2 / 2)) := by
        have h_gaussian : Summable (fun n : ℕ => Real.exp (-n * δ^2 / 2)) := by
          have h_gaussian : Summable (fun n : ℕ => (Real.exp (-δ^2 / 2))^n) := by
            exact summable_geometric_of_lt_one ( by positivity ) ( by rw [ Real.exp_lt_one_iff ] ; nlinarith [ mul_self_pos.2 hδ ] );
          exact h_gaussian.congr fun n => by rw [ ← Real.exp_nat_mul ] ; ring;
        exact h_gaussian.of_nonneg_of_le ( fun n => by positivity ) fun n => by gcongr ; norm_cast ; nlinarith;
      have h_split : Summable (fun n : ℤ => Real.exp (-n^2 * δ^2 / 2)) ↔ Summable (fun n : ℕ => Real.exp (-n^2 * δ^2 / 2)) ∧ Summable (fun n : ℕ => Real.exp (-(-n : ℤ)^2 * δ^2 / 2)) := by
        exact?;
      aesop;
    have h_bound : ∀ n : ℤ, Real.exp (-(t - n * δ)^2) ≤ Real.exp (-n^2 * δ^2 / 2) * Real.exp (t^2) := by
      intro n; rw [ ← Real.exp_add ] ; exact Real.exp_le_exp.mpr ( by nlinarith [ sq_nonneg ( t - n * δ / 2 ) ] ) ;
    exact Summable.of_nonneg_of_le ( fun n => Real.exp_nonneg _ ) h_bound ( h_gaussian.mul_right _ );
  convert h_gaussian.mul_left ( 29.4525 : ℝ ) using 2 ; norm_num [ dula_h_star ] ; ring;
  norm_num [ Complex.norm_def, Complex.normSq ];
  rw [ Real.sqrt_mul_self ( by positivity ) ]

/-
PROBLEM
For nonneg summable series over ℤ, the tsum is ≥ any single term's re.

PROVIDED SOLUTION
Since all terms have nonneg real part and zero imaginary part, the complex numbers are actually nonneg reals. The tsum of nonneg reals is ≥ any individual term. More precisely: (∑' n, f n).re = ∑' n, (f n).re (by continuity of re, i.e., Complex.re is a continuous linear map so commutes with tsum). Then ∑' n, (f n).re ≥ (f m).re by le_tsum applied to the real-valued summable series, using that all terms are nonneg.
-/
lemma tsum_re_ge_single_term {f : ℤ → ℂ} (hf : Summable f)
    (hnn : ∀ n, (f n).re ≥ 0) (hfim : ∀ n, (f n).im = 0) (m : ℤ) :
    (∑' n, f n).re ≥ (f m).re := by
  have h_re_tsum : (∑' n, f n).re = ∑' n, (f n).re := by
    convert Complex.re_tsum hf;
  exact h_re_tsum.symm ▸ Summable.le_tsum ( show Summable fun n => ( f n |> Complex.re ) from by simpa using hf.norm.of_nonneg_of_le ( fun n => by aesop ) ( fun n => by simpa [ abs_of_nonneg ( hnn n ) ] using Complex.abs_re_le_norm ( f n ) ) ) m ( fun n _ => hnn n )

/-
PROBLEM
For any real t and positive δ, there is an integer n with |t - nδ| ≤ δ/2.

PROVIDED SOLUTION
Use n = round(t/δ), i.e., the nearest integer to t/δ. Then |t/δ - n| ≤ 1/2, so |t - nδ| ≤ δ/2. Use Int.floor or round. Specifically, let n = ⌊t/δ + 1/2⌋ or use that for any real x, there exists an integer n with |x - n| ≤ 1/2 (by taking n = round x). Then multiply by δ.
-/
lemma exists_nearest_lattice_point (t δ : ℝ) (hδ : δ > 0) :
    ∃ n : ℤ, |t - ↑n * δ| ≤ δ / 2 := by
  exact ⟨ ⌊t / δ + 1 / 2⌋, by rw [ abs_le ] ; constructor <;> nlinarith [ Int.floor_le ( t / δ + 1 / 2 ), Int.lt_floor_add_one ( t / δ + 1 / 2 ), mul_div_cancel₀ t hδ.ne' ] ⟩

/-
PROBLEM
Lower bound: 29.4525 * exp(-x²) ≥ 29.4525 when x = 0 (peak).

PROVIDED SOLUTION
Unfold dula_spectral_buffer. We need 29.4525 ≥ 28.87. Use norm_num.
-/
lemma dula_peak_ge_buffer : (29.4525 : ℝ) ≥ dula_spectral_buffer := by
  exact le_of_lt <| by unfold dula_spectral_buffer; norm_num;

/-
PROBLEM
2. THE CONSTRUCTIVE INTERFERENCE PROPERTY

The "Permanent Floor" theorem: There exists a spacing δ such that the
Kernel Sum remains strictly above the 28.87 buffer for all t.

PROVIDED SOLUTION
For any t, use exists_nearest_lattice_point to find n₀ with |t - n₀*δ| ≤ δ/2. Then use tsum_re_ge_single_term (with dula_kernel_summable and dula_h_star_re_nonneg and dula_h_star_im_zero) to get (dula_kernel_sum t δ).re ≥ (dula_h_star t (n₀ * δ)).re. Now (dula_h_star t (n₀*δ)).re = 29.4525 * exp(-(t - n₀*δ)²). Since |t - n₀*δ| ≤ δ/2 < 1/2 (because δ < 1), we have (t-n₀*δ)² ≤ 1/4. So exp(-(t-n₀*δ)²) ≥ exp(-1/4). But actually we need 29.4525 * exp(-(t-n₀*δ)²) ≥ 28.87. Since (t-n₀*δ)² ≤ (δ/2)² < 1/4, we have exp(-(t-n₀*δ)²) ≥ exp(-1/4). So it suffices to show 29.4525 * exp(-1/4) ≥ 28.87. Now exp(-1/4) ≥ 0.7788, so 29.4525 * 0.7788 ≈ 22.94... Wait, that's NOT ≥ 28.87!

So actually, a single term is not enough. We need the n₀ term to give the full peak value. If n₀ is chosen so that t = n₀*δ exactly, then exp(0) = 1, but t won't always equal n₀*δ exactly.

Actually, the theorem as stated cannot hold with a single term bound. But it CAN hold because the sum over ALL integers is large. Actually, let me reconsider the math.

Wait - actually, the sum ∑ₙ 29.4525 * exp(-(t - nδ)²) for small δ IS very large. For δ → 0, the sum → ∞ like √π * 29.4525 / δ. But for δ close to 1, the minimum of the sum at the midpoint between two lattice points is approximately 2 * 29.4525 * exp(-δ²/4) plus tail terms.

For δ = 0.99: min ≈ 2 * 29.4525 * exp(-0.245) + tail ≈ 2 * 29.4525 * 0.783 + ... ≈ 46.1.

So the bound holds because the sum of the TWO nearest terms already exceeds 28.87. With tsum_re_ge_single_term we can only get one term. We need a version for two terms, or for a finite partial sum.

Better approach: use the single nearest term bound. At the nearest lattice point n₀, |t - n₀δ| ≤ δ/2. When t = n₀δ exactly (which is achievable), exp(0) = 1, so the term is 29.4525. Otherwise exp(-(t-n₀δ)²) < 1. BUT: the tsum includes ALL terms, which are ALL nonneg, so tsum ≥ single term at n₀. And at n₀ the term is 29.4525 * exp(-(t-n₀δ)²) ≥ 29.4525 * exp(-1/4) ≈ 22.94.

Hmm, 22.94 < 28.87. A single-term bound is not enough!

Alternative: Actually let me reconsider. Maybe we should use that dula_kernel_sum t δ ≥ dula_h_star t t (taking n = round(t/δ) isn't the right move - we need n such that nδ = t, but that only works if t/δ is an integer).

Wait - if we take n₀ such that n₀δ is closest to t, then |t - n₀δ| ≤ δ/2. The term value is 29.4525 * exp(-(t-n₀δ)²). This is maximized when t = n₀δ (giving 29.4525) and minimized when |t - n₀δ| = δ/2 (giving 29.4525 * exp(-δ²/4)).

For the theorem to hold with a SINGLE term, we need 29.4525 * exp(-δ²/4) ≥ 28.87. This gives exp(-δ²/4) ≥ 28.87/29.4525 ≈ 0.9802. So -δ²/4 ≥ ln(0.9802) ≈ -0.02. So δ² ≤ 0.08, δ ≤ 0.283.

So for δ ≤ 0.283 a single term suffices, but for δ close to 1 it does not.

For the full range δ ∈ (0,1), we need at least 2 terms. Let me add a helper lemma for sum of two terms.

Actually, a simpler approach: use the fact that the tsum over ℤ of nonneg terms is ≥ the sum over any finite subset. Take the subset {n₀, n₀+1} where n₀ = ⌊t/δ⌋. Then t is between n₀δ and (n₀+1)δ, with the closer one at distance ≤ δ/2. Both terms contribute, and together they give ≥ 29.4525 * (exp(-(t-n₀δ)²) + exp(-(t-(n₀+1)δ)²)). The minimum of this is at t = (n₀+1/2)δ, giving 2 * 29.4525 * exp(-δ²/4) ≥ 2 * 29.4525 * exp(-1/4) ≈ 45.9 > 28.87 ✓

So the strategy is:
1. Find n₀ = ⌊t/δ⌋
2. Show the sum of terms at n₀ and n₀+1 is ≥ dula_spectral_buffer
3. Use that the tsum ≥ this two-term sum

We need a lemma: tsum ≥ sum over {n₀, n₀+1}. This follows from sum_le_tsum for nonneg Summable series.

We also need: 2 * 29.4525 * exp(-1/4) ≥ 28.87. Let's verify: exp(-0.25) ≈ 0.7788. 2 * 29.4525 * 0.7788 ≈ 45.93. Yes.

But we also need to show that exp(-(t-n₀δ)²) + exp(-(t-(n₀+1)δ)²) ≥ 2*exp(-δ²/4).

Actually this is by AM-GM or by the fact that the minimum of f(x) = exp(-x²) + exp(-(δ-x)²) for x ∈ [0,δ] is at x = δ/2 (by symmetry and convexity argument). At x = δ/2, f = 2*exp(-δ²/4).

Hmm, this is getting complex. Let me try a different, simpler approach.

SIMPLER APPROACH: Use only the nearest term. The nearest lattice point has |t - n₀δ| ≤ δ/2. The term value is 29.4525 * exp(-(t-n₀δ)²). Now exp(-x²) is decreasing for x > 0, and x = |t-n₀δ| ≤ δ/2 < 1/2. So exp(-(t-n₀δ)²) ≥ exp(-δ²/4) ≥ exp(-1/4). And 29.4525 * exp(-1/4) ≈ 22.94 < 28.87. Not enough with one term.

TWO-TERM APPROACH: More complex but valid. Let me think if we can simplify the two-term bound.

Let n₀ = ⌊t/δ⌋. Set x = t - n₀δ ∈ [0, δ). The two terms at n₀ and n₀+1 give:
29.4525 * (exp(-x²) + exp(-(x-δ)²))

For x ∈ [0, δ], by the function g(x) = exp(-x²) + exp(-(x-δ)²), g is symmetric about δ/2 and its minimum is at x = δ/2 where g(δ/2) = 2*exp(-δ²/4).

For δ ∈ (0, 1): g(δ/2) = 2*exp(-δ²/4) ≥ 2*exp(-1/4) > 2*0.77 = 1.54.

So 29.4525 * g(x) ≥ 29.4525 * 2 * exp(-1/4) ≈ 45.9 > 28.87 ✓

But actually we don't even need the tight bound. We just need exp(-x²) ≥ exp(-δ²/4) for x ∈ [0, δ/2], and exp(-(x-δ)²) ≥ exp(-δ²/4) for x ∈ [δ/2, δ]. So: g(x) ≥ exp(-δ²/4) for all x. Then 29.4525 * exp(-δ²/4) ≥ 29.4525 * exp(-1/4) ≈ 22.94... still < 28.87.

Hmm no, we need the full two-term bound. g(x) ≥ 2*exp(-δ²/4) uses the fact that BOTH terms contribute at least exp(-δ²/4) when x = δ/2. But when x ≠ δ/2, one term could be much larger.

Actually, the minimum of g on [0, δ] is at x = δ/2 (by symmetry and the second derivative test). At x = δ/2: g = 2*exp(-δ²/4). So g(x) ≥ 2*exp(-δ²/4) for all x ∈ [0, δ].

But proving this minimality formally is hard. Let me try a different approach:

For x ∈ [0, δ]: exp(-x²) ≥ exp(-δ²) (since x ≤ δ, x² ≤ δ²) and exp(-(x-δ)²) ≥ exp(-δ²) (since |x-δ| ≤ δ). So g(x) ≥ 2*exp(-δ²). For δ < 1: g(x) ≥ 2*exp(-1) ≈ 2*0.368 = 0.736. So 29.4525 * 0.736 ≈ 21.7. Still < 28.87.

Hmm, that bound is too loose. Let me try using that we also have more than 2 terms.

Actually, let's use more terms. With n₀, n₀±1, n₀±2, etc., the sum gets larger. But the formal bookkeeping gets harder.

Wait, I had the right idea before. At the midpoint x = δ/2, each of the two nearest terms is exp(-δ²/4), and together they give 2*exp(-δ²/4). For δ = 1: 2*exp(-1/4) ≈ 1.558. So 29.4525 * 1.558 ≈ 45.9 > 28.87.

But I need to prove g(x) ≥ 2*exp(-δ²/4) for all x ∈ [0, δ]. This is:
exp(-x²) + exp(-(x-δ)²) ≥ 2*exp(-δ²/4)

Setting y = x - δ/2 (so y ∈ [-δ/2, δ/2]):
exp(-(y+δ/2)²) + exp(-(y-δ/2)²) ≥ 2*exp(-δ²/4)

exp(-y² - yδ - δ²/4) + exp(-y² + yδ - δ²/4) ≥ 2*exp(-δ²/4)

exp(-δ²/4) * exp(-y²) * (exp(-yδ) + exp(yδ)) ≥ 2*exp(-δ²/4)

exp(-y²) * 2*cosh(yδ) ≥ 2

This requires exp(-y²) * cosh(yδ) ≥ 1, which holds since cosh(yδ) ≥ 1 and... no, exp(-y²) ≤ 1 and cosh ≥ 1, but their product isn't necessarily ≥ 1.

At y = 0: exp(0) * cosh(0) = 1. So the inequality is tight at y = 0, meaning g(x) = 2*exp(-δ²/4) at x = δ/2, and the function may go below that at other points.

Wait, let's check: at x = 0, g(0) = exp(0) + exp(-δ²) = 1 + exp(-δ²). And 2*exp(-δ²/4) = 2*exp(-δ²/4). Is 1 + exp(-δ²) ≥ 2*exp(-δ²/4)? By AM-GM: (1 + exp(-δ²))/2 ≥ √(exp(-δ²)) = exp(-δ²/2). And exp(-δ²/4) ≤ ... hmm this doesn't directly give it.

Actually, by the convexity of exp: exp(-x²) is log-concave, and...

Let me use a completely different approach. By AM-GM:
exp(-x²) + exp(-(x-δ)²) ≥ 2*√(exp(-x² - (x-δ)²)) = 2*exp(-(x² + (x-δ)²)/2)

Now x² + (x-δ)² = 2x² - 2xδ + δ² = 2(x - δ/2)² + δ²/2.

So exp(-(x² + (x-δ)²)/2) = exp(-(x-δ/2)² - δ²/4) ≤ exp(-δ²/4).

So g(x) ≥ 2*exp(-(x-δ/2)² - δ²/4) which is LESS than 2*exp(-δ²/4). The AM-GM goes in the wrong direction here.

Actually let me just try: the minimum of g on [0,δ] is at x = δ/2 (by symmetry), where g = 2*exp(-δ²/4). To prove this is a minimum, note that g'(x) = -2x*exp(-x²) - 2(x-δ)*exp(-(x-δ)²). At x = δ/2: g'(δ/2) = -δ*exp(-δ²/4) + δ*exp(-δ²/4) = 0. And g''(δ/2) > 0 (it's a sum of positive terms). So it's a local minimum. And at the endpoints g(0) = 1 + exp(-δ²) and g(δ) = exp(-δ²) + 1, both equal 1 + exp(-δ²) ≥ 2*exp(-δ²/4) by AM-GM on 1 and exp(-δ²): (1 + exp(-δ²))/2 ≥ √exp(-δ²) = exp(-δ²/2) ≥ exp(-δ²/4)? No, exp(-δ²/2) ≤ exp(-δ²/4).

Hmm, actually: 1 + exp(-δ²) ≥ 2*exp(-δ²/4)?
LHS at δ=1: 1 + e^{-1} ≈ 1.368. RHS: 2*e^{-1/4} ≈ 1.558.
1.368 < 1.558! So 1 + exp(-δ²) < 2*exp(-δ²/4) for δ = 1!

This means g(0) < g(δ/2)! So the minimum is actually at the endpoints, not at δ/2!

Wait, that contradicts what I said before. Let me recheck.g(0) = exp(0) + exp(-δ²) = 1 + exp(-δ²)g(δ/2) = 2*exp(-δ²/4)For δ = 1: g(0) = 1 + e^{-1} ≈ 1.3679, g(1/2) = 2*e^{-1/4} ≈ 1.5576.So g(0) < g(δ/2). The minimum is at the ENDPOINTS, not the midpoint!

So my earlier analysis was wrong. g'(x) = 0 at x = δ/2 by symmetry, but g''(δ/2) could be negative (local maximum) or positive (local minimum).

g''(x) = (-2 + 4x²)*exp(-x²) + (-2 + 4(x-δ)²)*exp(-(x-δ)²)
g''(δ/2) = 2*(-2 + δ²)*exp(-δ²/4)

For δ < √2: -2 + δ² < 0, so g''(δ/2) < 0. The midpoint is a LOCAL MAXIMUM, not minimum!

So for δ ∈ (0, √2), the minimum of g on [0, δ] is at the endpoints: g_min = 1 + exp(-δ²).

For δ ∈ (0, 1): g_min = 1 + exp(-δ²) ≥ 1 + exp(-1) ≈ 1.368.
So 29.4525 * g_min ≥ 29.4525 * (1 + exp(-1)) ≈ 29.4525 * 1.3679 ≈ 40.3 > 28.87. ✓

So the proof strategy should be:
1. For any t, find n₀ = ⌊t/δ⌋ so that t ∈ [n₀δ, (n₀+1)δ).
2. The sum ≥ terms at n₀ and n₀+1 (by sum_le_tsum for nonneg summable series).
3. Terms at n₀ and n₀+1 = 29.4525 * (exp(-(t-n₀δ)²) + exp(-(t-(n₀+1)δ)²))
4. Set x = t - n₀δ ∈ [0, δ). exp(-x²) + exp(-(x-δ)²) ≥ 1 + exp(-δ²) (since exp(-x²) ≥ exp(-δ²) and exp(-(x-δ)²) ≥ exp(-δ²), and one of them ≥ 1... no wait).

Actually: exp(-x²) ≥ 1 when x = 0, and it decreases. exp(-(x-δ)²) ≥ 1 when x = δ.For x ∈ [0, δ]: x² ≤ x*δ (since x ≤ δ), and (x-δ)² ≤ (δ-x)*δ = δ² - xδ.Hmm, let me just use: for x ∈ [0, δ]:
- exp(-x²) ≥ exp(-x*δ) (since x ≤ δ implies x² ≤ xδ... wait no, x² ≤ xδ iff x ≤ δ, which is true)

Wait: for 0 ≤ x ≤ δ: x² = x*x ≤ x*δ. So -x² ≥ -xδ, so exp(-x²) ≥ exp(-xδ).

Similarly: (x-δ)² = (δ-x)² = (δ-x)(δ-x) ≤ (δ-x)*δ. So exp(-(x-δ)²) ≥ exp(-(δ-x)*δ) = exp(-δ²+xδ).

So g(x) ≥ exp(-xδ) + exp(-δ²+xδ) = exp(-xδ) + exp(-δ²)*exp(xδ).

Let u = exp(xδ) ∈ [1, exp(δ²)]. Then g(x) ≥ 1/u + u*exp(-δ²) = h(u).

h'(u) = -1/u² + exp(-δ²) = 0 when u² = exp(δ²), i.e., u = exp(δ²/2).

h(exp(δ²/2)) = exp(-δ²/2) + exp(-δ²/2) = 2*exp(-δ²/2).

For δ ∈ (0,1): 2*exp(-δ²/2) ≥ 2*exp(-1/2) ≈ 1.213. So 29.4525 * 1.213 ≈ 35.7 > 28.87. ✓

But we need to check if u = exp(δ²/2) ∈ [1, exp(δ²)] and if h is minimized there.

Actually, this is getting very complicated to formalize. Let me try a totally different approach.

SIMPLEST APPROACH: Use just that g(x) = exp(-x²) + exp(-(x-δ)²) ≥ 1 for x ∈ [0, δ].

Proof: At x=0, g(0) = 1 + exp(-δ²) > 1. At x=δ, g(δ) = exp(-δ²) + 1 > 1. And g is continuous on a compact interval. But showing g(x) ≥ 1 for all x ∈ [0,δ] requires more work.

g(x) = exp(-x²) + exp(-(x-δ)²). For x ∈ [0, δ/2]: exp(-x²) ≥ exp(-δ²/4) (since x ≤ δ/2). For x ∈ [δ/2, δ]: exp(-(x-δ)²) ≥ exp(-δ²/4).

So for all x ∈ [0, δ]: max(exp(-x²), exp(-(x-δ)²)) ≥ exp(-δ²/4).
Thus g(x) ≥ exp(-δ²/4) ≥ exp(-1/4) ≈ 0.778.

That gives 29.4525 * exp(-1/4) ≈ 22.94, still < 28.87 for a single term...but g has TWO terms, so g ≥ exp(-δ²/4) is just the single-term bound.

OK I think the cleanest approach that's formalizable is:

For x ∈ [0, δ/2]: exp(-x²) ≥ exp(-δ²/4) and exp(-(x-δ)²) ≥ exp(-δ²) ≥ exp(-1).
So g(x) ≥ exp(-δ²/4) + exp(-δ²) ≥ exp(-1/4) + exp(-1) ≈ 0.779 + 0.368 = 1.147.
29.4525 * 1.147 ≈ 33.8 > 28.87. ✓

For x ∈ [δ/2, δ]: by symmetry, same bound.

But actually we also need the sum of MORE terms beyond n₀ and n₀+1.

Hmm, let me reconsider. We have:
Sum ≥ term at n₀ + term at n₀+1 = 29.4525 * g(t - n₀δ)

For t - n₀δ ∈ [0, δ):
g(x) = exp(-x²) + exp(-(x-δ)²) for x ∈ [0, δ)

Lower bound on g(x): at the worst case, we can use g(x) ≥ 1 + exp(-δ²) (endpoint) or g(x) ≥ 2*exp(-δ²/4) (midpoint, which is actually the maximum not minimum)...

I showed above that the minimum of g on [0,δ] is at the endpoints: g_min = 1 + exp(-δ²). For δ < 1: g_min = 1 + exp(-δ²) > 1 + exp(-1) ≈ 1.368. So 29.4525 * (1 + exp(-1)) ≈ 40.3 > 28.87.

Wait but I need to PROVE g(x) ≥ 1 + exp(-δ²) for all x ∈ [0, δ]. But g(δ/2) = 2*exp(-δ²/4). For δ = 1: 2*exp(-1/4) ≈ 1.558 and 1 + exp(-1) ≈ 1.368. So g(δ/2) > g(0), which is consistent.

So g achieves its minimum at the endpoints and g(x) ≥ 1 + exp(-δ²) for all x ∈ [0,δ]. But proving this requires calculus (showing critical points are maxima). This is very hard to formalize.

Let me try yet another approach: just bound g(x) ≥ 1 for all x ∈ [0, δ].

g(x) = exp(-x²) + exp(-(x-δ)²) ≥ 1 for x ∈ [0, δ].

Proof: exp(-x²) ≥ 1 - x² (by the inequality eˣ ≥ 1 + x, so e^{-x²} ≥ 1 - x² when x² ≤ 1).
exp(-(x-δ)²) ≥ 1 - (x-δ)² similarly.
Sum ≥ 2 - x² - (x-δ)² = 2 - x² - x² + 2xδ - δ² = 2 - 2x² + 2xδ - δ².
= 2 - 2x(x-δ) - δ².
For x ∈ [0, δ]: x(x-δ) ≤ 0, so 2x(x-δ) ≤ 0, so -2x(x-δ) ≥ 0.
Thus sum ≥ 2 - δ² ≥ 2 - 1 = 1 for δ ≤ 1. ✓

So: g(x) ≥ 2 - 2x² + 2xδ - δ² = 2 - 2x(x-δ) - δ² ≥ 2 - δ² ≥ 1 when δ ≤ 1.

Then 29.4525 * g(x) ≥ 29.4525 * 1 = 29.4525 > 28.87 ✓

So the proof plan is:
1. For any t, let n₀ = ⌊t/δ⌋. Then x = t - n₀δ ∈ [0, δ).
2. The tsum ≥ sum of terms at n₀ and n₀+1 (sum_le_tsum for nonneg summable ℤ-indexed series).
3. Terms at n₀ and n₀+1 have real part = 29.4525 * (exp(-x²) + exp(-(x-δ)²)).
4. exp(-x²) ≥ 1 - x² and exp(-(x-δ)²) ≥ 1 - (x-δ)² (using exp(-y) ≥ 1-y for y ≥ 0).
5. Sum ≥ 29.4525 * (2 - x² - (x-δ)²) = 29.4525 * (2 - 2x² + 2xδ - δ²).
6. For x ∈ [0, δ): 2x² - 2xδ = 2x(x-δ) ≤ 0 (since x ≥ 0, x-δ < 0). So 2 - 2x² + 2xδ - δ² ≥ 2 - δ² ≥ 2 - 1 = 1 (since δ < 1).
7. So the sum ≥ 29.4525 ≥ 28.87.

This is a clean proof! Let me decompose it into helper lemmas.

OK actually, the key issue is step 2: extracting two terms from the tsum. The current helper lemma `tsum_re_ge_single_term` only gives one term. I need a two-term version.

Let me restructure the helpers.
-/
theorem dula_permanent_floor (δ : ℝ) (hδ : δ > 0 ∧ δ < 1.0) :
    ∀ t : ℝ, (dula_kernel_sum t δ).re ≥ dula_spectral_buffer := by
  intro t
  unfold dula_kernel_sum dula_spectral_buffer
  have hsum_ge_two_terms : (dula_kernel_sum t δ).re ≥ (dula_h_star t (⌊t / δ⌋ * δ)).re + (dula_h_star t ((⌊t / δ⌋ + 1) * δ)).re := by
    have hsum_ge_two_terms : (dula_kernel_sum t δ).re ≥ (∑' n : ℤ, (dula_h_star t (n * δ)).re) := by
      rw [ ← Complex.re_tsum ] ; aesop;
      exact dula_kernel_summable t δ hδ.1.ne';
    have hsum_ge_two_terms : (∑' n : ℤ, (dula_h_star t (n * δ)).re) ≥ (∑ n ∈ ({⌊t / δ⌋, ⌊t / δ⌋ + 1} : Finset ℤ), (dula_h_star t (n * δ)).re) := by
      apply_rules [ Summable.sum_le_tsum ];
      · exact fun n hn => dula_h_star_re_nonneg _ _;
      · have hsum_ge_two_terms : Summable (fun n : ℤ => dula_h_star t (n * δ)) := by
          apply dula_kernel_summable t δ hδ.left.ne';
        convert Complex.reCLM.summable hsum_ge_two_terms using 1;
    simp_all +decide;
    linarith;
  -- Now use the given bounds on the terms to conclude the proof.
  have h_term_bounds : (dula_h_star t (⌊t / δ⌋ * δ)).re + (dula_h_star t ((⌊t / δ⌋ + 1) * δ)).re ≥ 29.4525 * (2 - 2 * (t - ⌊t / δ⌋ * δ)^2 + 2 * (t - ⌊t / δ⌋ * δ) * δ - δ^2) := by
    unfold dula_h_star; norm_num ; ring_nf ; norm_num;
    nlinarith [ Real.add_one_le_exp ( t * δ * ⌊t * δ⁻¹⌋ * 2 + ( -t ^ 2 - δ ^ 2 * ⌊t * δ⁻¹⌋ ^ 2 ) ), Real.add_one_le_exp ( t * δ * 2 + t * δ * ⌊t * δ⁻¹⌋ * 2 + ( -t ^ 2 - δ ^ 2 ) + ( - ( δ ^ 2 * ⌊t * δ⁻¹⌋ * 2 ) - δ ^ 2 * ⌊t * δ⁻¹⌋ ^ 2 ) ) ];
  -- Now use the given bounds on the terms to conclude the proof. We'll show that the expression inside the parentheses is at least 1.
  have h_expr_ge_one : 2 - 2 * (t - ⌊t / δ⌋ * δ)^2 + 2 * (t - ⌊t / δ⌋ * δ) * δ - δ^2 ≥ 1 := by
    nlinarith only [ show ( t - ⌊t / δ⌋ * δ ) ≥ 0 by nlinarith [ Int.floor_le ( t / δ ), mul_div_cancel₀ t hδ.1.ne' ], show ( t - ⌊t / δ⌋ * δ ) ≤ δ by nlinarith [ Int.lt_floor_add_one ( t / δ ), mul_div_cancel₀ t hδ.1.ne' ], hδ.2 ];
  linarith!

/-
PROBLEM
3. ELIMINATION OF THE SPECTRAL LEAK

Theorem: Global Kernel Summation eliminates the vacuous spectral leak.
The zeros are pinned to the critical line not just locally, but globally.

PROVIDED SOLUTION
Take δ = 1/2. Then δ > 0 and δ < 1, so hδ : δ > 0 ∧ δ < 1.0 holds. By dula_permanent_floor, for all t, (dula_kernel_sum t (1/2)).re ≥ dula_spectral_buffer = 28.87 > 0. So (dula_kernel_sum t (1/2)).re > 0.
-/
theorem global_red_wall_crossing :
    ∃ δ > 0, ∀ t : ℝ, (dula_kernel_sum t δ).re > 0 := by
  use 1 / 2, by norm_num, by
    intro t
    have := dula_permanent_floor (1 / 2) ⟨by norm_num, by norm_num⟩ t
    generalize_proofs at *; (
    exact lt_of_lt_of_le ( by norm_num [ dula_spectral_buffer ] ) this);