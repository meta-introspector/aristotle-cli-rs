import Mathlib

open Complex MeasureTheory Set HurwitzZeta
open scoped BigOperators

noncomputable section

/-- For positive real `t` and any `s : ℂ`, `(t:ℂ)^conj(s) = conj((t:ℂ)^s)`. -/
lemma ofReal_cpow_conj (t : ℝ) (ht : 0 < t) (s : ℂ) :
    (t : ℂ) ^ (starRingEnd ℂ s) = starRingEnd ℂ ((t : ℂ) ^ s) := by
  rw [cpow_conj]
  · simp
  · rw [arg_ofReal_of_nonneg ht.le]; exact Real.pi_pos.ne

/-
The f_modif of `hurwitzEvenFEPair 0` is real-valued: for all `t : ℝ`,
    `(hurwitzEvenFEPair 0).f_modif t` is the image of a real number under `ofReal`.
-/
lemma hurwitzEvenFEPair_zero_f_modif_real (t : ℝ) :
    starRingEnd ℂ ((hurwitzEvenFEPair 0).f_modif t) = (hurwitzEvenFEPair 0).f_modif t := by
  unfold hurwitzEvenFEPair;
  unfold WeakFEPair.f_modif;
  norm_num [ Set.indicator ];
  split_ifs <;> norm_num [ Complex.ext_iff ]

/-
The Mellin transform of `(hurwitzEvenFEPair 0).f_modif` satisfies Schwarz reflection.
-/
lemma mellin_hurwitzEvenFEPair_zero_conj (s : ℂ) :
    mellin (hurwitzEvenFEPair 0).f_modif (starRingEnd ℂ s) =
    starRingEnd ℂ (mellin (hurwitzEvenFEPair 0).f_modif s) := by
  convert integral_conj;
  refine' MeasureTheory.setIntegral_congr_fun measurableSet_Ioi fun x hx => _;
  have := ofReal_cpow_conj x hx ( s - 1 ) ; simp_all +decide [ Complex.cpow_sub, Complex.cpow_add, Complex.cpow_one, Complex.cpow_neg, mul_comm, mul_assoc, mul_left_comm, smul_eq_mul ] ;
  rw [ mul_comm, hurwitzEvenFEPair_zero_f_modif_real ]

/-
`completedRiemannZeta₀` satisfies Schwarz reflection.
-/
lemma completedRiemannZeta₀_conj (s : ℂ) :
    completedRiemannZeta₀ (starRingEnd ℂ s) = starRingEnd ℂ (completedRiemannZeta₀ s) := by
  have := @mellin_hurwitzEvenFEPair_zero_conj;
  convert congr_arg ( fun x : ℂ => x / 2 ) ( this ( s / 2 ) ) using 1;
  · simp +decide [ completedRiemannZeta₀, completedHurwitzZetaEven₀ ];
    erw [ Complex.conj_ofReal ] ; norm_num;
    exact Complex.ext rfl rfl;
  · unfold completedRiemannZeta₀ completedHurwitzZetaEven₀;
    unfold WeakFEPair.Λ₀; norm_num;
    erw [ Complex.conj_ofReal ] ; norm_num

/-
The completed Riemann zeta satisfies Schwarz reflection:
    Λ(conj s) = conj(Λ(s)).
-/
lemma completedRiemannZeta_conj (s : ℂ) :
    completedRiemannZeta (starRingEnd ℂ s) = starRingEnd ℂ (completedRiemannZeta s) := by
  -- Use the fact that $completedRiemannZeta₀$ satisfies Schwarz reflection.
  have h₀ : completedRiemannZeta₀ (starRingEnd ℂ s) = starRingEnd ℂ (completedRiemannZeta₀ s) := by
    exact completedRiemannZeta₀_conj s;
  grind +suggestions

end