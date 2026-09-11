import Mathlib
import RequestProject.Support.CompletedZetaConj
import RequestProject.Imported.ARISTOTLESUMMARY7a1e4d83A67d.DeBrangesSpace_Root

/-!
# Analysis of the de Branges kernel of `DeBrangesSpace_Root`

The imported file
`RequestProject.Imported.ARISTOTLESUMMARY7a1e4d83A67d.DeBrangesSpace_Root`
defines

  `deBrangesKernel w z = (A z * B w - B z * A w) / (π * (z - conj w))`

with `A z = Ξ z * cos (α z)` and `B z = -(Ξ z * sin (α z))`, and states two
properties of it, both left as `sorry`:

* `kernel_hermitian`         : `K w z = conj (K z w)`;
* `kernel_diagonal_positive` : `0 < (K t t).re` for real `t` with `E t ≠ 0`.

**Both statements are false as written**, and this file proves that:

* `not_kernel_hermitian` — the kernel written with `w` (rather than the
  conjugate `conj w`) in the second slot is not Hermitian; the explicit
  counterexample is `w = -3i`, `z = -2i`, where all values involved are real
  multiples of `Λ (5/2) Λ (7/2) sinh α ≠ 0` and the two sides differ by a sign.
* `not_kernel_diagonal_positive` — the kernel vanishes identically on the
  diagonal (`deBrangesKernel_self`), because its numerator is `x - x`; and `Ξ`
  does not vanish identically on the real axis (`exists_real_Xi_ne_zero`), so
  the hypothesis of the statement is satisfiable.

The file also gives the corrected kernel `deBrangesKernel'` (with `conj w` in
the second slot, the standard de Branges normalisation) and proves that this
one *is* Hermitian: `deBrangesKernel'_hermitian`.
-/

open Complex

namespace RequestProject.Support

open RequestProject.Support in
/-- `Ξ` at the point `-(y : ℝ) * I` is `Λ (1/2 + y)`. -/
lemma Xi_neg_mul_I (y : ℝ) : Xi (-(y : ℂ) * Complex.I) = completedRiemannZeta (1 / 2 + (y : ℂ)) := by
  unfold Xi xi
  congr 1
  simp [Complex.ext_iff]

lemma completedRiemannZeta_ne_zero_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    completedRiemannZeta s ≠ 0 := by
  have hs0 : s ≠ 0 := by
    intro h; rw [h] at hs; simp at hs; linarith
  have hG : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by linarith)
  have hz : riemannZeta s ≠ 0 := riemannZeta_ne_zero_of_one_lt_re hs
  have : completedRiemannZeta s = riemannZeta s * Gammaℝ s := by
    rw [riemannZeta_def_of_ne_zero hs0, div_mul_cancel₀ _ hG]
  rw [this]
  exact mul_ne_zero hz hG

/-- The numerator of the de Branges kernel in closed form. -/
lemma kernel_numerator (z w : ℂ) :
    A_leech z * B_leech w - B_leech z * A_leech w
      = Xi z * Xi w * Complex.sin ((alpha_leech : ℂ) * (z - w)) := by
  unfold A_leech B_leech
  rw [mul_sub, Complex.sin_sub]
  ring

end RequestProject.Support

section Counterexamples
open RequestProject.Support

lemma Xi_two_I : Xi ((-2 : ℂ) * Complex.I) = completedRiemannZeta (5/2) := by
  have := Xi_neg_mul_I 2
  norm_num at this ⊢
  convert this using 2

lemma Xi_three_I : Xi ((-3 : ℂ) * Complex.I) = completedRiemannZeta (7/2) := by
  have := Xi_neg_mul_I 3
  norm_num at this ⊢
  convert this using 2

lemma completedZeta_real_conj {x : ℝ} (hx : 1 < x) :
    starRingEnd ℂ (completedRiemannZeta (x : ℂ)) = completedRiemannZeta (x : ℂ) :=
  completedZeta_conj_of_real hx

theorem not_kernel_hermitian :
    ¬ (∀ w z : ℂ, deBrangesKernel w z = starRingEnd ℂ (deBrangesKernel z w)) := by
  intro h
  have h52 : completedRiemannZeta (5/2 : ℂ) ≠ 0 := by
    apply completedRiemannZeta_ne_zero_of_one_lt_re; norm_num
  have h72 : completedRiemannZeta (7/2 : ℂ) ≠ 0 := by
    apply completedRiemannZeta_ne_zero_of_one_lt_re; norm_num
  have hc52 : starRingEnd ℂ (completedRiemannZeta (5/2 : ℂ)) = completedRiemannZeta (5/2 : ℂ) := by
    have := completedZeta_conj_of_real (x := (5/2 : ℝ)) (by norm_num)
    norm_num at this ⊢
    exact this
  have hc72 : starRingEnd ℂ (completedRiemannZeta (7/2 : ℂ)) = completedRiemannZeta (7/2 : ℂ) := by
    have := completedZeta_conj_of_real (x := (7/2 : ℝ)) (by norm_num)
    norm_num at this ⊢
    exact this
  have hsinh : Real.sinh alpha_leech ≠ 0 := by
    have h := alpha_leech_pos
    have : (0:ℝ) < Real.sinh alpha_leech := Mathlib.Meta.Positivity.sinh_pos_of_pos h
    exact this.ne'
  have key := h ((-3 : ℂ) * Complex.I) ((-2 : ℂ) * Complex.I)
  unfold deBrangesKernel at key
  rw [kernel_numerator, kernel_numerator, Xi_two_I, Xi_three_I] at key
  have hS : Complex.sin ((alpha_leech : ℂ) * Complex.I)
      = ((Real.sinh alpha_leech : ℝ) : ℂ) * Complex.I := by
    rw [Complex.sin_mul_I, Complex.ofReal_sinh]
  rw [show ((-2:ℂ) * Complex.I - -3 * Complex.I) = Complex.I by ring,
     show ((-3:ℂ) * Complex.I - -2 * Complex.I) = -Complex.I by ring,
     mul_neg, Complex.sin_neg, hS] at key
  simp only [map_mul, map_div₀, map_neg, Complex.conj_I, Complex.conj_ofReal,
    hc52, hc72] at key
  have c2 : (starRingEnd ℂ) (2:ℂ) = 2 := conj_eq_iff_re.mpr rfl
  have c3 : (starRingEnd ℂ) (3:ℂ) = 3 := conj_eq_iff_re.mpr rfl
  rw [c2, c3, show ((-2:ℂ) * Complex.I - -(3:ℂ) * -Complex.I) = -5 * Complex.I by ring,
    show ((-3:ℂ) * Complex.I - -(2:ℂ) * -Complex.I) = -5 * Complex.I by ring,
    show (starRingEnd ℂ) ((-5:ℂ) * Complex.I) = 5 * Complex.I by
      simp [Complex.ext_iff]] at key
  have hπ : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have hsinhC : ((Real.sinh alpha_leech : ℝ) : ℂ) ≠ 0 := by
    exact_mod_cast hsinh
  field_simp at key
  norm_num at key

/-- `Ξ` does not vanish identically on the real axis. -/
theorem exists_real_Xi_ne_zero : ∃ t : ℝ, Xi (t : ℂ) ≠ 0 := by
  by_contra hcon
  push_neg at hcon
  -- then `ζ` vanishes on the whole critical line
  have hzeta : ∀ t : ℝ, riemannZeta (1/2 + Complex.I * (t : ℂ)) = 0 := by
    intro t
    have h1 := hcon t
    unfold Xi xi at h1
    have hs0 : (1/2 + Complex.I * (t : ℂ)) ≠ 0 := by
      intro h
      have := congrArg Complex.re h
      simp [Complex.add_re, Complex.mul_re] at this
    rw [riemannZeta_def_of_ne_zero hs0, h1, zero_div]
  -- hence `ζ = 0` on `ℂ \ {1}` by the identity theorem
  have hU : IsOpen ({(1:ℂ)}ᶜ : Set ℂ) := isOpen_compl_singleton
  have hconn : IsPreconnected ({(1:ℂ)}ᶜ : Set ℂ) := by
    have hrank : 1 < Module.rank ℝ ℂ := by
      simp [Complex.rank_real_complex]
    exact (isConnected_compl_singleton_of_one_lt_rank hrank (1:ℂ)).isPreconnected
  have han : AnalyticOnNhd ℂ riemannZeta ({(1:ℂ)}ᶜ) := by
    apply DifferentiableOn.analyticOnNhd _ hU
    intro z hz
    exact (differentiableAt_riemannZeta (by simpa using hz)).differentiableWithinAt
  have hmem : (1/2 : ℂ) ∈ ({(1:ℂ)}ᶜ : Set ℂ) := by
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
    intro h; norm_num at h
  have hfreq : ∃ᶠ z in nhdsWithin (1/2 : ℂ) {(1/2 : ℂ)}ᶜ, riemannZeta z = 0 := by
    have hlim : Filter.Tendsto (fun n : ℕ => (1/2 + Complex.I * ((1 / ((n : ℝ) + 1) : ℝ) : ℂ)))
        Filter.atTop (nhds (1/2 : ℂ)) := by
      have h0 : Filter.Tendsto (fun n : ℕ => ((1 / ((n : ℝ) + 1) : ℝ) : ℂ)) Filter.atTop (nhds 0) := by
        have : Filter.Tendsto (fun n : ℕ => (1 / ((n : ℝ) + 1))) Filter.atTop (nhds (0:ℝ)) :=
          tendsto_one_div_add_atTop_nhds_zero_nat
        exact (Complex.continuous_ofReal.tendsto 0).comp this
      simpa using (tendsto_const_nhds (x := (1/2 : ℂ)) (f := (Filter.atTop : Filter ℕ))).add
        (h0.const_mul Complex.I)
    have hne : Filter.Tendsto (fun n : ℕ => (1/2 + Complex.I * ((1 / ((n : ℝ) + 1) : ℝ) : ℂ)))
        Filter.atTop (nhdsWithin (1/2 : ℂ) {(1/2 : ℂ)}ᶜ) := by
      apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within _ hlim
      filter_upwards with n
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      intro hEq
      have h2 : Complex.I * ((1 / ((n : ℝ) + 1) : ℝ) : ℂ) = 0 := by
        have := sub_eq_zero.mpr hEq
        simpa using this
      have h3 : ((1 / ((n : ℝ) + 1) : ℝ) : ℂ) = 0 := by
        simpa [Complex.I_ne_zero] using h2
      have h4 : (1 / ((n : ℝ) + 1)) = 0 := by exact_mod_cast h3
      have : (0:ℝ) < 1 / ((n : ℝ) + 1) := by positivity
      linarith
    exact hne.frequently (Filter.Frequently.of_forall fun n => hzeta _)
  have hzero := han.eqOn_zero_of_preconnected_of_frequently_eq_zero hconn hmem hfreq
  have h2 : riemannZeta 2 = 0 := by
    refine hzero ?_
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
    intro h; norm_num at h
  exact riemannZeta_ne_zero_of_one_lt_re (by norm_num) h2

/-- The de Branges kernel of this file vanishes on the diagonal (its numerator does). -/
theorem deBrangesKernel_self (z : ℂ) : deBrangesKernel z z = 0 := by
  unfold deBrangesKernel
  rw [show A_leech z * B_leech z - B_leech z * A_leech z = 0 by ring, zero_div]

/-- Consequently the diagonal positivity statement of `DeBrangesSpace_Root` is false. -/
theorem not_kernel_diagonal_positive :
    ¬ (∀ t : ℝ, E_leech (t : ℂ) ≠ 0 → (deBrangesKernel (t : ℂ) (t : ℂ)).re > 0) := by
  intro h
  obtain ⟨t, ht⟩ := exists_real_Xi_ne_zero
  have hE : E_leech (t : ℂ) ≠ 0 := by
    intro hE0
    exact ht ((E_leech_zero_iff (t : ℂ)).mp hE0)
  have := h t hE
  rw [deBrangesKernel_self] at this
  simp at this

/-! ### The corrected (Hermitian) de Branges kernel -/

/-- The de Branges reproducing kernel in the standard normalisation: the second
argument of `A` and `B` is the *conjugate* `conj w`.  Compare `deBrangesKernel`
in `DeBrangesSpace_Root`, which uses `w` and is therefore not Hermitian. -/
noncomputable def deBrangesKernel' (w z : ℂ) : ℂ :=
  (A_leech z * B_leech (starRingEnd ℂ w) - B_leech z * A_leech (starRingEnd ℂ w)) /
    (Real.pi * (z - starRingEnd ℂ w))

/-- The corrected kernel is Hermitian: `K (w, z) = conj (K (z, w))`. -/
theorem deBrangesKernel'_hermitian (w z : ℂ) :
    deBrangesKernel' w z = starRingEnd ℂ (deBrangesKernel' z w) := by
  unfold deBrangesKernel'
  rw [kernel_numerator, kernel_numerator, map_div₀, map_mul, map_mul, map_mul, map_sub,
    Complex.conj_ofReal, ← Complex.sin_conj, map_mul, map_sub, Complex.conj_ofReal]
  simp only [← Xi_conj, Complex.conj_conj]
  rw [show ((alpha_leech : ℂ) * (starRingEnd ℂ w - z)) = -((alpha_leech : ℂ) * (z - starRingEnd ℂ w))
      by ring, Complex.sin_neg]
  rw [show ((Real.pi : ℂ) * (starRingEnd ℂ w - z)) = -((Real.pi : ℂ) * (z - starRingEnd ℂ w))
      by ring]
  rw [show (Xi (starRingEnd ℂ w) * Xi z * -Complex.sin ((alpha_leech : ℂ) * (z - starRingEnd ℂ w)))
      = -(Xi z * Xi (starRingEnd ℂ w) * Complex.sin ((alpha_leech : ℂ) * (z - starRingEnd ℂ w)))
      by ring]
  rw [neg_div_neg_eq]

end Counterexamples
