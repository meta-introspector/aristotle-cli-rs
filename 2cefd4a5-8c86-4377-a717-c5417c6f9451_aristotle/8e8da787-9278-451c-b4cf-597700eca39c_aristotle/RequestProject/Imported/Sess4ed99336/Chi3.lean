import Mathlib

/-!
# The Generalized Riemann Hypothesis for L(s, χ₃)

This file constructs the complex-valued Dirichlet character χ₃ modulo 3,
identifies its Dirichlet series with the classical L-function L(s, χ₃),
and states the Generalized Riemann Hypothesis for that L-function.

Besides the statement of GRH itself, the file records a number of unconditional
facts: L(s, χ₃) is entire, it has no zeros in the closed half-plane Re(s) ≥ 1,
its zeros in the critical strip are symmetric about the critical line Re(s) = 1/2,
and consequently GRH is equivalent to the absence of zeros in the open half-strip
½ < Re(s) < 1.
-/

open Complex DirichletCharacter

namespace Chi3

/-! ### The complex-valued character modulo 3 -/

/-- The unique non-principal Dirichlet character modulo 3, with values in ℂ.
    It is the quadratic character of the field 𝔽₃. -/
noncomputable def χ₃ : DirichletCharacter ℂ 3 :=
  (quadraticChar (ZMod 3)).ringHomComp (Int.castRingHom ℂ)

lemma χ₃_apply (x : ZMod 3) :
    χ₃ x = if x = 0 then 0 else if x = 1 then 1 else -1 := by
  -- follows from the definition of the quadratic character on 𝔽₃
  have h2 : ¬ IsSquare (2 : ZMod 3) := by decide
  have e0 : (2 : ZMod 3) ≠ 0 := by decide
  have e1 : (2 : ZMod 3) ≠ 1 := by decide
  simp only [χ₃, MulChar.ringHomComp, quadraticChar_apply, quadraticCharFun]
  -- residual case analysis on the three residues
  fin_cases x
  · norm_num
  · norm_num
  · norm_num [show ((⟨2, by norm_num⟩ : Fin 3) : ZMod 3) = (2 : ZMod 3) from rfl, h2, e0, e1]

@[simp] lemma χ₃_zero : χ₃ (0 : ZMod 3) = 0 := by rw [χ₃_apply]; simp
@[simp] lemma χ₃_one  : χ₃ (1 : ZMod 3) = 1 := by rw [χ₃_apply]; simp
@[simp] lemma χ₃_two  : χ₃ (2 : ZMod 3) = -1 := by
  rw [χ₃_apply, if_neg (by decide), if_neg (by decide)]

lemma χ₃_ne_one : χ₃ ≠ 1 := by
  intro h
  have := congr_arg (· (2 : ZMod 3)) h
  simp only [χ₃_two, MulChar.one_apply (show IsUnit (2 : ZMod 3) from by decide)] at this
  norm_num at this

/-- χ₃ is odd: χ₃(-1) = -1. -/
lemma χ₃_odd : χ₃.Odd := by
  unfold DirichletCharacter.Odd
  rw [show (-1 : ZMod 3) = 2 from rfl, χ₃_two]

/-- χ₃ is real (quadratic), hence equal to its own inverse. -/
lemma χ₃_inv : χ₃⁻¹ = χ₃ := by
  ext x
  rw [MulChar.inv_apply']
  congr 1
  -- every unit in ℤ/3ℤ is its own inverse
  revert x; decide

/-- χ₃ is primitive (conductor = level = 3). -/
lemma χ₃_isPrimitive : χ₃.IsPrimitive := by
  have hdvd : χ₃.conductor ∣ 3 := conductor_dvd_level _
  have h1 : χ₃.conductor ≠ 1 := by
    intro h
    exact χ₃_ne_one ((eq_one_iff_conductor_eq_one (by norm_num)).mpr h)
  rcases (Nat.Prime.eq_one_or_self_of_dvd (by norm_num) _ hdvd) with h | h
  · exact absurd h h1
  · exact h

/-! ### The L-function -/

/-- The Dirichlet L-function L(s, χ₃), defined on all of ℂ by analytic continuation. -/
noncomputable def L (s : ℂ) : ℂ := DirichletCharacter.LFunction χ₃ s

/-- For Re(s) > 1 the L-function coincides with its Dirichlet series. -/
lemma L_eq_LSeries {s : ℂ} (hs : 1 < s.re) :
    L s = LSeries (fun n => χ₃ (n : ZMod 3)) s := by
  rw [L, DirichletCharacter.LFunction_eq_LSeries χ₃ hs]

/-- L(s, χ₃) is an entire function. -/
lemma L_differentiable : Differentiable ℂ L :=
  DirichletCharacter.differentiable_LFunction χ₃_ne_one

/-- Unconditional zero-free region: L(s, χ₃) ≠ 0 whenever Re(s) ≥ 1. -/
theorem L_ne_zero_of_one_le_re {s : ℂ} (hs : 1 ≤ s.re) : L s ≠ 0 :=
  DirichletCharacter.LFunction_ne_zero_of_one_le_re χ₃ (Or.inl χ₃_ne_one) hs

/-- The gamma factor attached to the odd character χ₃ is non-vanishing for Re(s) > -1. -/
lemma gammaFactor_ne_zero_of_neg_one_lt_re {s : ℂ} (hs : -1 < s.re) :
    gammaFactor χ₃ s ≠ 0 := by
  rw [χ₃_odd.gammaFactor_def]
  refine Gammaℝ_ne_zero_of_re_pos ?_
  simp only [Complex.add_re, Complex.one_re]
  linarith

/-- On the half-plane Re(s) > -1 the zeros of L(s, χ₃) coincide with those of the
    completed L-function. -/
lemma L_eq_zero_iff_completed {s : ℂ} (hs : -1 < s.re) :
    L s = 0 ↔ completedLFunction χ₃ s = 0 := by
  rw [L, DirichletCharacter.LFunction_eq_completed_div_gammaFactor χ₃ s
        (Or.inr (by norm_num)), div_eq_zero_iff]
  simp [gammaFactor_ne_zero_of_neg_one_lt_re hs]

/-- Functional-equation symmetry: the completed L-function vanishes at s if and only if
    it vanishes at 1 - s. -/
theorem completed_zero_symm (s : ℂ) :
    completedLFunction χ₃ s = 0 ↔ completedLFunction χ₃ (1 - s) = 0 := by
  have FE := fun t => χ₃_isPrimitive.completedLFunction_one_sub t
  constructor
  · intro h
    rw [FE s, χ₃_inv, h, mul_zero]
  · intro h
    have h' := FE (1 - s)
    rw [χ₃_inv, h, mul_zero, sub_sub_cancel] at h'
    exact h'

/-- Symmetry of non-trivial zeros about the critical line:
    inside the critical strip, s is a zero if and only if 1 - s is a zero. -/
theorem L_zero_symm {s : ℂ} (h0 : 0 < s.re) (h1 : s.re < 1) :
    L s = 0 ↔ L (1 - s) = 0 := by
  have hs  : (-1 : ℝ) < s.re := by linarith
  have hs' : (-1 : ℝ) < (1 - s).re := by
    simp only [Complex.sub_re, Complex.one_re]; linarith
  rw [L_eq_zero_iff_completed hs, L_eq_zero_iff_completed hs']
  exact completed_zero_symm s

/-! ### Trivial zeros -/

/-- Trivial zeros: because χ₃ is odd, L(s, χ₃) vanishes at the negative odd integers. -/
lemma L_trivial_zero (n : ℕ) : L (-(2 * n) - 1) = 0 :=
  χ₃_odd.LFunction_neg_two_mul_nat_sub_one n

/-- Unconditionally, the only zeros with Re(s) ≤ 0 are the trivial zeros. -/
theorem L_zero_of_re_le_zero {s : ℂ} (hs : s.re ≤ 0) (hz : L s = 0) :
    ∃ n : ℕ, s = -(2 * n) - 1 := by
  have hre : (1 - s).re = 1 - s.re := by simp
  have h1s : 1 ≤ (1 - s).re := by rw [hre]; linarith
  have hcomp : completedLFunction χ₃ (1 - s) ≠ 0 := by
    intro h
    exact L_ne_zero_of_one_le_re h1s
      ((L_eq_zero_iff_completed (by rw [hre]; linarith)).mpr h)
  have hcs : completedLFunction χ₃ s ≠ 0 :=
    fun h => hcomp ((completed_zero_symm s).mp h)
  have hg : gammaFactor χ₃ s = 0 := by
    rw [L, DirichletCharacter.LFunction_eq_completed_div_gammaFactor χ₃ s
          (Or.inr (by norm_num)), div_eq_zero_iff] at hz
    tauto
  rw [χ₃_odd.gammaFactor_def, Gammaℝ_eq_zero_iff] at hg
  obtain ⟨n, hn⟩ := hg
  exact ⟨n, by linear_combination hn⟩

/-- Every non-trivial zero lies in the open critical strip 0 < Re(s) < 1. -/
theorem L_nontrivial_zero_mem_strip {s : ℂ} (hz : L s = 0)
    (hnt : ∀ n : ℕ, s ≠ -(2 * n) - 1) : 0 < s.re ∧ s.re < 1 := by
  refine ⟨?_, ?_⟩
  · by_contra h
    obtain ⟨n, hn⟩ := L_zero_of_re_le_zero (not_lt.mp h) hz
    exact hnt n hn
  · by_contra h
    exact L_ne_zero_of_one_le_re (not_lt.mp h) hz

/-! ### The Generalized Riemann Hypothesis -/

/-- **Generalized Riemann Hypothesis for L(s, χ₃)**:
    every zero of L(s, χ₃) that lies in the critical strip 0 < Re(s) < 1
    lies on the critical line Re(s) = 1/2.

    This is a long-standing open problem, and the statement below is left unproved
    (`sorry`).  Everything else in this file is proved unconditionally; in particular
    `GRH_iff_no_zero_right_half` reduces this statement to the absence of zeros in the
    open half-strip ½ < Re(s) < 1. -/
theorem GRH {s : ℂ} (h0 : 0 < s.re) (h1 : s.re < 1) (hs : L s = 0) :
    s.re = 1 / 2 := by
  sorry

/-- Equivalence (proved unconditionally from the functional equation):
    GRH holds if and only if L(s, χ₃) has no zeros in the open half-strip
    ½ < Re(s) < 1. -/
theorem GRH_iff_no_zero_right_half :
    (∀ s : ℂ, 0 < s.re → s.re < 1 → L s = 0 → s.re = 1 / 2) ↔
    (∀ s : ℂ, 1 / 2 < s.re → s.re < 1 → L s ≠ 0) := by
  constructor
  · intro h s h0 h1 hz
    have := h s (by linarith) h1 hz
    linarith
  · intro h s h0 h1 hz
    rcases lt_trichotomy s.re (1 / 2) with hlt | heq | hgt
    · exfalso
      have hz' : L (1 - s) = 0 := (L_zero_symm h0 h1).mp hz
      have hre : (1 - s).re = 1 - s.re := by simp
      exact h (1 - s) (by rw [hre]; linarith) (by rw [hre]; linarith) hz'
    · exact heq
    · exact absurd hz (h s hgt h1)

end Chi3

