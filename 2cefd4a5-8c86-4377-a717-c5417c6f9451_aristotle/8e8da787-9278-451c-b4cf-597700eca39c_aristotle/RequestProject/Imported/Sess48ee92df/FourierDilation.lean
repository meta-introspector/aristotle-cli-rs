/-
# FourierDilation.lean — Fourier transform dilation identity
-/
import Mathlib

open Real MeasureTheory Complex
open scoped BigOperators FourierTransform

noncomputable section

namespace FourierDilation

variable {d : ℕ}

/-
The Fourier transform of `f(c • ·)` equals `|c|^(-d) • f̂(c⁻¹ • ·)`,
    i.e., `𝓕 (f ∘ (c • ·)) w = |c⁻¹|^d • 𝓕 f (c⁻¹ • w)` for `c ≠ 0`.

    This is the standard Fourier dilation identity.
-/
lemma fourier_comp_smul {c : ℝ} (hc : c ≠ 0)
    (f : EuclideanSpace ℝ (Fin d) → ℂ) (w : EuclideanSpace ℝ (Fin d)) :
    𝓕 (fun x => f (c • x)) w =
      ↑(|(c⁻¹) ^ (Module.finrank ℝ (EuclideanSpace ℝ (Fin d)))|) • 𝓕 f (c⁻¹ • w) := by
  have h_fourier : ∫ (v : EuclideanSpace ℝ (Fin d)), f (c • v) * (Complex.exp (-2 * Real.pi * Complex.I * (inner ℝ v w))) = |c⁻¹ ^ d| * ∫ (v : EuclideanSpace ℝ (Fin d)), f v * (Complex.exp (-2 * Real.pi * Complex.I * (inner ℝ v (c⁻¹ • w)))) := by
    have := @MeasureTheory.Measure.integral_comp_smul;
    convert this MeasureTheory.MeasureSpace.volume ( fun x => f x * Complex.exp ( -2 * Real.pi * Complex.I * ( inner ℝ x ( c⁻¹ • w ) ) ) ) c using 1;
    · simp +decide [ inner_smul_left, inner_smul_right, hc ];
    · norm_num [ abs_inv, abs_pow, Module.finrank_self ];
  simp_all +decide [ mul_comm, VectorFourier.fourierIntegral ];
  convert h_fourier using 1;
  · convert ( congr_arg ( fun x : ℂ => x ) ( MeasureTheory.integral_congr_ae ( Filter.Eventually.of_forall fun x => ?_ ) ) ) using 1;
    simp +decide [ mul_assoc, mul_comm, mul_left_comm, dotProduct, Complex.exp_re, Complex.exp_im, Real.fourierChar ];
    simp +decide [ Complex.exp_neg, mul_assoc, mul_comm, mul_left_comm, Circle.smul_def ];
  · convert rfl using 3 ; ring;
    congr ; ext ; norm_num [ mul_assoc, mul_comm, mul_left_comm, FourierTransform.fourier, fourierIntegral, inner_smul_right ];
    simp +decide [ mul_comm, mul_assoc, mul_left_comm, Real.fourierChar, fourierChar, inner_smul_right ];
    simp +decide [ mul_comm, mul_assoc, mul_left_comm, Complex.exp_neg, Circle.smul_def ]

end FourierDilation

end