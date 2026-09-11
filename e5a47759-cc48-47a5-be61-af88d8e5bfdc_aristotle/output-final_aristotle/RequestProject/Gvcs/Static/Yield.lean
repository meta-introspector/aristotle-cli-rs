import RequestProject.Gvcs.Static.Shear

/-!
# When does the steel actually give way?  Combined stress and the yield criteria

A loader arm that is bent *and* twisted at once carries a direct stress `σ`
along the member and a shear stress `τ` across it at the same point.  Neither
of the two on its own decides whether the metal yields; the combination does.
This file develops the standard plane-stress theory needed to test a member
that is bent and twisted together:

* the **principal stresses** `σ/2 ± √((σ/2)² + τ²)` — the largest tension and
  the largest compression at the point — with their sum `σ` and product `-τ²`;
* the **maximum shear stress** `√((σ/2)² + τ²)`, half the difference of the
  principal stresses;
* the two yield criteria used in practice: **Tresca**, `√(σ² + 4τ²) ≤ σ_y`, and
  **von Mises**, `√(σ² + 3τ²) ≤ σ_y`;
* the relation between them: von Mises never exceeds Tresca, so Tresca is
  always the conservative check, and they agree exactly when there is no shear;
* the shear yield strength `σ_y/√3 ≈ 0.577 σ_y` that von Mises predicts, which
  is where the allowable shear stresses used in the other files come from;
* the **equivalent bending moment** `√(M² + ¾T²)` of a round shaft under a
  bending moment `M` and a torque `T` at once.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## Plane stress at a point: `σ` along the member, `τ` across it -/

/-- The radius of Mohr's circle, `√((σ/2)² + τ²)`: also the greatest shear
stress on any plane through the point. -/
def maxShearStress (sigma tau : ℝ) : ℝ := √((sigma / 2) ^ 2 + tau ^ 2)

/-- The larger principal stress. -/
def principalMax (sigma tau : ℝ) : ℝ := sigma / 2 + maxShearStress sigma tau

/-- The smaller principal stress. -/
def principalMin (sigma tau : ℝ) : ℝ := sigma / 2 - maxShearStress sigma tau

theorem maxShearStress_nonneg (sigma tau : ℝ) : 0 ≤ maxShearStress sigma tau :=
  Real.sqrt_nonneg _

theorem maxShearStress_sq (sigma tau : ℝ) :
    maxShearStress sigma tau ^ 2 = (sigma / 2) ^ 2 + tau ^ 2 :=
  Real.sq_sqrt (by positivity)

/-- **The invariants of the stress state.** The two principal stresses add up
to the direct stress. -/
theorem principal_add (sigma tau : ℝ) :
    principalMax sigma tau + principalMin sigma tau = sigma := by
  unfold principalMax principalMin; ring

/-- … and multiply to `-τ²`. -/
theorem principal_mul (sigma tau : ℝ) :
    principalMax sigma tau * principalMin sigma tau = -tau ^ 2 := by
  unfold principalMax principalMin
  have h := maxShearStress_sq sigma tau
  nlinarith [h]

theorem principalMin_le_principalMax (sigma tau : ℝ) :
    principalMin sigma tau ≤ principalMax sigma tau := by
  have := maxShearStress_nonneg sigma tau
  unfold principalMax principalMin; linarith

/-- **Mohr's circle**: the maximum shear stress is half the difference of the
principal stresses. -/
theorem principal_sub (sigma tau : ℝ) :
    principalMax sigma tau - principalMin sigma tau = 2 * maxShearStress sigma tau := by
  unfold principalMax principalMin; ring

/-- With no shear, the principal stresses are the direct stress and zero. -/
theorem principalMax_of_no_shear {sigma : ℝ} (h : 0 ≤ sigma) :
    principalMax sigma 0 = sigma := by
  unfold principalMax maxShearStress
  rw [show (sigma / 2) ^ 2 + (0:ℝ) ^ 2 = (sigma / 2) ^ 2 by ring,
    Real.sqrt_sq (by linarith)]
  ring

/-- **Pure shear is a state of equal tension and compression at 45°** — the
reason a twisted bar cracks on a helix. -/
theorem principal_of_pure_shear {tau : ℝ} (h : 0 ≤ tau) :
    principalMax 0 tau = tau ∧ principalMin 0 tau = -tau := by
  have hs : maxShearStress 0 tau = tau := by
    unfold maxShearStress
    rw [show ((0:ℝ) / 2) ^ 2 + tau ^ 2 = tau ^ 2 by ring, Real.sqrt_sq h]
  refine ⟨?_, ?_⟩
  · unfold principalMax; rw [hs]; ring
  · unfold principalMin; rw [hs]; ring

/-! ## The two yield criteria -/

/-- Tresca (maximum shear stress) equivalent stress `√(σ² + 4τ²)`: the metal
yields when this reaches the tensile yield strength. -/
def trescaStress (sigma tau : ℝ) : ℝ := √(sigma ^ 2 + 4 * tau ^ 2)

/-- Von Mises (distortion energy) equivalent stress `√(σ² + 3τ²)`. -/
def vonMisesStress (sigma tau : ℝ) : ℝ := √(sigma ^ 2 + 3 * tau ^ 2)

theorem trescaStress_nonneg (sigma tau : ℝ) : 0 ≤ trescaStress sigma tau :=
  Real.sqrt_nonneg _

theorem vonMisesStress_nonneg (sigma tau : ℝ) : 0 ≤ vonMisesStress sigma tau :=
  Real.sqrt_nonneg _

/-- Tresca's equivalent stress is exactly twice the maximum shear stress. -/
theorem trescaStress_eq_two_mul_maxShear (sigma tau : ℝ) :
    trescaStress sigma tau = 2 * maxShearStress sigma tau := by
  unfold trescaStress maxShearStress
  rw [show sigma ^ 2 + 4 * tau ^ 2 = 4 * ((sigma / 2) ^ 2 + tau ^ 2) by ring,
    show (4:ℝ) = 2 ^ 2 by norm_num, Real.sqrt_mul (by positivity),
    Real.sqrt_sq (by norm_num)]

/-- **Tresca is the conservative criterion**: its equivalent stress is never
smaller than the von Mises one, so a design that passes Tresca passes von
Mises too. -/
theorem vonMises_le_tresca (sigma tau : ℝ) :
    vonMisesStress sigma tau ≤ trescaStress sigma tau := by
  unfold vonMisesStress trescaStress
  apply Real.sqrt_le_sqrt
  nlinarith [sq_nonneg tau]

/-- **The two criteria agree exactly in the absence of shear**, and differ
whenever there is any. -/
theorem vonMises_eq_tresca_iff (sigma tau : ℝ) :
    vonMisesStress sigma tau = trescaStress sigma tau ↔ tau = 0 := by
  constructor
  · intro h
    unfold vonMisesStress trescaStress at h
    have h2 : sigma ^ 2 + 3 * tau ^ 2 = sigma ^ 2 + 4 * tau ^ 2 := by
      have h1 : (0:ℝ) ≤ sigma ^ 2 + 3 * tau ^ 2 := by positivity
      have h2 : (0:ℝ) ≤ sigma ^ 2 + 4 * tau ^ 2 := by positivity
      have := congrArg (· ^ 2) h
      simpa [Real.sq_sqrt h1, Real.sq_sqrt h2] using this
    have : tau ^ 2 = 0 := by linarith
    exact pow_eq_zero_iff (n := 2) (by norm_num) |>.1 this
  · rintro rfl
    unfold vonMisesStress trescaStress
    norm_num

/-- The von Mises check in the form actually used in a calculation: no square
roots, just `σ² + 3τ² ≤ σ_y²`. -/
theorem vonMises_le_iff {sigma tau sy : ℝ} (hy : 0 ≤ sy) :
    vonMisesStress sigma tau ≤ sy ↔ sigma ^ 2 + 3 * tau ^ 2 ≤ sy ^ 2 := by
  unfold vonMisesStress
  rw [show sy = √(sy ^ 2) from (Real.sqrt_sq hy).symm]
  rw [Real.sqrt_le_sqrt_iff (by positivity)]
  rw [Real.sq_sqrt (by positivity)]

/-- Under pure tension the von Mises stress is the tension itself: the
criterion is calibrated on the tensile test. -/
theorem vonMises_pure_tension {sigma : ℝ} (h : 0 ≤ sigma) :
    vonMisesStress sigma 0 = sigma := by
  unfold vonMisesStress
  rw [show sigma ^ 2 + 3 * (0:ℝ) ^ 2 = sigma ^ 2 by ring, Real.sqrt_sq h]

/-- Under pure shear the von Mises stress is `√3 τ`. -/
theorem vonMises_pure_shear {tau : ℝ} (h : 0 ≤ tau) :
    vonMisesStress 0 tau = √3 * tau := by
  unfold vonMisesStress
  rw [show (0:ℝ) ^ 2 + 3 * tau ^ 2 = 3 * tau ^ 2 by ring,
    Real.sqrt_mul (by norm_num), Real.sqrt_sq h]

/-- The shear yield strength predicted by von Mises, `σ_y/√3 ≈ 0.577 σ_y`.
This is the number the allowable shear stresses of the other files stand
for. -/
def shearYield (sy : ℝ) : ℝ := sy / √3

/-- **The 0.577 rule.** A material of tensile yield strength `σ_y` yields in
pure shear exactly at `σ_y/√3`. -/
theorem pure_shear_safe_iff {tau sy : ℝ} (h : 0 ≤ tau) :
    vonMisesStress 0 tau ≤ sy ↔ tau ≤ shearYield sy := by
  rw [vonMises_pure_shear h, shearYield, le_div_iff₀ (by positivity), mul_comm]

/-- `σ_y/√3` really is between `0.577 σ_y` and `0.578 σ_y`. -/
theorem shearYield_approx {sy : ℝ} (hy : 0 ≤ sy) :
    577 / 1000 * sy ≤ shearYield sy ∧ shearYield sy ≤ 578 / 1000 * sy := by
  have h3 : (0:ℝ) < √3 := Real.sqrt_pos.2 (by norm_num)
  have hlo : √3 ≤ 1000 / 577 := by
    rw [show (1000:ℝ) / 577 = √((1000 / 577) ^ 2) from
      (Real.sqrt_sq (by norm_num)).symm]
    apply Real.sqrt_le_sqrt; norm_num
  have hhi : (1000 : ℝ) / 578 ≤ √3 := by
    rw [show (1000:ℝ) / 578 = √((1000 / 578) ^ 2) from
      (Real.sqrt_sq (by norm_num)).symm]
    apply Real.sqrt_le_sqrt; norm_num
  constructor
  · rw [shearYield, le_div_iff₀ h3]
    nlinarith
  · rw [shearYield, div_le_iff₀ h3]
    nlinarith

/-! ## A round shaft bent and twisted at once -/

/-- Elastic section modulus of a round shaft in bending, `I / rₒ`; for a
circular section it is exactly half the torsional modulus. -/
def Shaft.bendingModulus (s : Shaft) : ℝ := s.polarInertia / (2 * s.outer)

theorem Shaft.torsionModulus_eq_two_mul_bending (s : Shaft) :
    s.torsionModulus = 2 * s.bendingModulus := by
  have h := s.outer_pos
  unfold Shaft.torsionModulus Shaft.bendingModulus
  field_simp

theorem Shaft.bendingModulus_pos (s : Shaft) : 0 < s.bendingModulus := by
  have h := s.outer_pos
  have hJ := s.polarInertia_pos
  unfold Shaft.bendingModulus
  positivity

/-- The **equivalent bending moment** `√(M² + ¾T²)`: the pure bending moment
that would work the shaft as hard as the combination of a bending moment `M`
and a torque `T`. -/
def equivalentMoment (M T : ℝ) : ℝ := √(M ^ 2 + 3 / 4 * T ^ 2)

/-- **The design formula for a shaft that is bent and twisted at once.** The
von Mises stress produced by a bending moment `M` together with a torque `T`
is the equivalent moment divided by the ordinary bending modulus. -/
theorem vonMises_of_bending_and_torsion (s : Shaft) (M T : ℝ) :
    vonMisesStress (M / s.bendingModulus) (T / s.torsionModulus)
      = equivalentMoment M T / s.bendingModulus := by
  have hW := s.bendingModulus_pos
  have hWne := hW.ne'
  rw [s.torsionModulus_eq_two_mul_bending]
  unfold vonMisesStress equivalentMoment
  rw [show (M / s.bendingModulus) ^ 2 + 3 * (T / (2 * s.bendingModulus)) ^ 2
      = (M ^ 2 + 3 / 4 * T ^ 2) / s.bendingModulus ^ 2 by field_simp; ring,
    Real.sqrt_div' _ (by positivity), Real.sqrt_sq hW.le]

/-- The shaft is safe under the combined loading exactly when the equivalent
moment is within the ordinary bending capacity. -/
theorem shaft_combined_safe_iff (s : Shaft) {M T sy : ℝ} :
    vonMisesStress (M / s.bendingModulus) (T / s.torsionModulus) ≤ sy ↔
      equivalentMoment M T ≤ sy * s.bendingModulus := by
  have hW := s.bendingModulus_pos
  rw [vonMises_of_bending_and_torsion, div_le_iff₀ hW, mul_comm]

/-- With no torque the equivalent moment is the bending moment, and with no
bending it is `(√3/2) T`. -/
theorem equivalentMoment_of_no_torsion {M : ℝ} (h : 0 ≤ M) :
    equivalentMoment M 0 = M := by
  unfold equivalentMoment
  rw [show M ^ 2 + 3 / 4 * (0:ℝ) ^ 2 = M ^ 2 by ring, Real.sqrt_sq h]

theorem equivalentMoment_mono_torsion {M T₁ T₂ : ℝ} (h0 : 0 ≤ T₁) (h : T₁ ≤ T₂) :
    equivalentMoment M T₁ ≤ equivalentMoment M T₂ := by
  unfold equivalentMoment
  apply Real.sqrt_le_sqrt
  nlinarith

end

end LifeTrac
