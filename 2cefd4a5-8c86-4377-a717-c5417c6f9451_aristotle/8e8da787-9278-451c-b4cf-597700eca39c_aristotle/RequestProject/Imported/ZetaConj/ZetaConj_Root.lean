import Mathlib

open Complex MeasureTheory Set HurwitzZeta
open scoped BigOperators

noncomputable section

/-
The completed Riemann zeta satisfies Schwarz reflection:
    Λ(conj s) = conj(Λ(s)).
-/
lemma completedRiemannZeta_conj (s : ℂ) :
    completedRiemannZeta (starRingEnd ℂ s) = starRingEnd ℂ (completedRiemannZeta s) := by
  rw [ completedRiemannZeta_eq, completedRiemannZeta_eq ];
  -- By definition of $f_modif$, we know that $f_modif(t)$ is real-valued.
  have h_f_modif_real : ∀ t : ℝ, 0 < t → (hurwitzEvenFEPair 0).f_modif t = starRingEnd ℂ ((hurwitzEvenFEPair 0).f_modif t) := by
    simp +decide [ WeakFEPair.f_modif, hurwitzEvenFEPair ];
    intro t ht; by_cases h : 1 < t <;> by_cases h' : 0 < t ∧ t < 1 <;> simp +decide [ h, h' ] ;
  -- Apply the fact that the Mellin transform of a real-valued function is real.
  have h_mellin_real : ∀ t : ℝ, 0 < t → (t : ℂ) ^ ((starRingEnd ℂ s) / 2 - 1) * (hurwitzEvenFEPair 0).f_modif t = starRingEnd ℂ ((t : ℂ) ^ (s / 2 - 1) * (hurwitzEvenFEPair 0).f_modif t) := by
    intro t ht
    have h_conj : (t : ℂ) ^ ((starRingEnd ℂ s) / 2 - 1) = starRingEnd ℂ ((t : ℂ) ^ (s / 2 - 1)) := by
      rw [ Complex.cpow_def_of_ne_zero ( Complex.ofReal_ne_zero.mpr ht.ne' ), Complex.cpow_def_of_ne_zero ( Complex.ofReal_ne_zero.mpr ht.ne' ) ];
      norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, Complex.log_re, Complex.log_im ];
      norm_num [ Complex.arg_ofReal_of_nonneg ht.le ] ; ring ; norm_num;
    grind;
  -- Apply the fact that the integral of a real-valued function is real.
  have h_integral_real : ∫ t in Set.Ioi (0 : ℝ), (t : ℂ) ^ ((starRingEnd ℂ s) / 2 - 1) * (hurwitzEvenFEPair 0).f_modif t = starRingEnd ℂ (∫ t in Set.Ioi (0 : ℝ), (t : ℂ) ^ (s / 2 - 1) * (hurwitzEvenFEPair 0).f_modif t) := by
    rw [ ← integral_conj ];
    exact MeasureTheory.setIntegral_congr_fun measurableSet_Ioi fun x hx => h_mellin_real x hx;
  unfold completedRiemannZeta₀;
  unfold completedHurwitzZetaEven₀; norm_num [ h_integral_real ] ; ring;
  unfold WeakFEPair.Λ₀; norm_num [ h_integral_real ] ; ring;
  convert congr_arg ( · * ( 1 / 2 : ℂ ) ) h_integral_real using 1 <;> norm_num [ mellin ] ; ring;
  erw [ Complex.conj_ofReal ] ; norm_num ; ring

end