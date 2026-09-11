import RequestProject.Gvcs.Circuit
import RequestProject.Gvcs.Structure

/-!
# Valves, orifices and pressure containment

Between the pump and the actuators sit the control valves.  Two things matter
for the machine: how a restriction turns pressure into flow (and how much power
that wastes), and how much pressure the hoses and tubes can be asked to hold.

This file formalizes

* the orifice equation `Q = Cd · A · √(2 Δp / ρ)`, its square-root character
  (four times the pressure gives twice the flow), the inverse relation
  `Δp = ρ Q² / (2 Cd² A²)`, the fact that the two are mutually inverse, and the
  cubic growth of the power a meter-in restriction throws away;
* the relief valve: whatever flow the actuators do not take is dumped at the
  relief setting and becomes heat, and the two shares add up to the pump's
  power exactly;
* Barlow's formula for a thin-walled hose or tube — hoop stress `p d / (2 t)`,
  burst pressure `2 t σ / d` — the criterion for containing a given pressure,
  and the usual four-to-one working margin.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## Flow through an orifice -/

/-- Flow through a sharp-edged orifice of area `A` and discharge coefficient
`cd` in a fluid of density `rho` under a pressure difference `dp`. -/
def orificeFlow (cd A rho dp : ℝ) : ℝ := cd * A * √(2 * dp / rho)

theorem orificeFlow_nonneg {cd A rho dp : ℝ} (hcd : 0 ≤ cd) (hA : 0 ≤ A) :
    0 ≤ orificeFlow cd A rho dp :=
  mul_nonneg (mul_nonneg hcd hA) (Real.sqrt_nonneg _)

/-- **The orifice is a square-root law**: four times the pressure difference
gives only twice the flow. -/
theorem orificeFlow_quadruple_pressure (cd A rho dp : ℝ) :
    orificeFlow cd A rho (4 * dp) = 2 * orificeFlow cd A rho dp := by
  have h : 2 * (4 * dp) / rho = 2 ^ 2 * (2 * dp / rho) := by ring
  unfold orificeFlow
  rw [h, Real.sqrt_mul (by positivity), Real.sqrt_sq (by norm_num)]
  ring

/-- More pressure across the orifice, more flow. -/
theorem orificeFlow_mono {cd A rho dp₁ dp₂ : ℝ} (hcd : 0 ≤ cd) (hA : 0 ≤ A)
    (hrho : 0 < rho) (h : dp₁ ≤ dp₂) :
    orificeFlow cd A rho dp₁ ≤ orificeFlow cd A rho dp₂ := by
  unfold orificeFlow
  have : √(2 * dp₁ / rho) ≤ √(2 * dp₂ / rho) := by
    apply Real.sqrt_le_sqrt
    apply div_le_div_of_nonneg_right _ hrho.le
    linarith
  exact mul_le_mul_of_nonneg_left this (mul_nonneg hcd hA)

/-- The pressure a given flow costs when it is squeezed through the orifice. -/
def orificeDrop (cd A rho Q : ℝ) : ℝ := rho * Q ^ 2 / (2 * cd ^ 2 * A ^ 2)

/-- **The two descriptions agree.**  Pushing `Q` through the orifice costs
`orificeDrop`, and that pressure difference produces exactly `Q` again. -/
theorem orificeFlow_orificeDrop {cd A rho Q : ℝ} (hcd : 0 < cd) (hA : 0 < A)
    (hrho : 0 < rho) (hQ : 0 ≤ Q) :
    orificeFlow cd A rho (orificeDrop cd A rho Q) = Q := by
  have hinner : 2 * orificeDrop cd A rho Q / rho = (Q / (cd * A)) ^ 2 := by
    unfold orificeDrop
    field_simp
  unfold orificeFlow
  rw [hinner, Real.sqrt_sq (by positivity)]
  field_simp

/-- **Metering wastes power like the cube of the flow.**  The power thrown away
at a restriction is `ρ Q³ / (2 Cd² A²)`: halving the speed of an actuator by
throttling saves eight times the loss. -/
theorem orifice_power_cubic (cd A rho Q : ℝ) :
    hydPower (orificeDrop cd A rho Q) Q = rho * Q ^ 3 / (2 * cd ^ 2 * A ^ 2) := by
  unfold hydPower orificeDrop
  ring

/-- A smaller orifice costs more pressure at the same flow. -/
theorem orificeDrop_antitone_area {cd A₁ A₂ rho Q : ℝ} (hcd : 0 < cd)
    (hA : 0 < A₁) (hrho : 0 < rho) (h : A₁ ≤ A₂) :
    orificeDrop cd A₂ rho Q ≤ orificeDrop cd A₁ rho Q := by
  unfold orificeDrop
  apply div_le_div_of_nonneg_left (by positivity) (by positivity)
  have : A₁ ^ 2 ≤ A₂ ^ 2 := by nlinarith
  nlinarith [sq_nonneg cd, mul_pos hcd hcd]

/-! ## The relief valve -/

/-- Power dumped across the relief valve when the actuators take only `Qused`
of the pump's `Qpump` at the relief setting `pmax`. -/
def reliefHeat (pmax Qpump Qused : ℝ) : ℝ := pmax * (Qpump - Qused)

theorem reliefHeat_nonneg {pmax Qpump Qused : ℝ} (hp : 0 ≤ pmax)
    (h : Qused ≤ Qpump) : 0 ≤ reliefHeat pmax Qpump Qused :=
  mul_nonneg hp (by linarith)

/-- **Nothing is lost, everything is turned into heat.**  The pump's power at
the relief setting is exactly the useful power plus the power dumped over the
valve. -/
theorem reliefHeat_balance (pmax Qpump Qused : ℝ) :
    hydPower pmax Qpump = hydPower pmax Qused + reliefHeat pmax Qpump Qused := by
  unfold hydPower reliefHeat
  ring

/-- **Standing on the relief valve heats the oil at full engine power.**  With
the actuators stalled the whole of the pump's output goes over the valve. -/
theorem reliefHeat_full (pmax Qpump : ℝ) :
    reliefHeat pmax Qpump 0 = hydPower pmax Qpump := by
  unfold reliefHeat hydPower
  ring

/-- The heat dumped by the relief valve raises the reservoir temperature at a
rate fixed by the fluid and the amount of it in the tank. -/
theorem reliefHeat_heatingRate (f : Fluid) (mass pmax Qpump Qused : ℝ) :
    heatingRate f mass (reliefHeat pmax Qpump Qused)
      = pmax * (Qpump - Qused) / (mass * f.heatCap) := by
  unfold heatingRate reliefHeat
  ring

/-! ## Containing the pressure: Barlow's formula -/

/-- Hoop stress in a thin-walled tube of inside diameter `d` and wall thickness
`t` holding an internal pressure `p`. -/
def hoopStress (p d t : ℝ) : ℝ := p * d / (2 * t)

/-- The pressure at which the hoop stress reaches the ultimate strength
`sigma` of the material. -/
def burstPressure (sigma d t : ℝ) : ℝ := 2 * t * sigma / d

/-- **Barlow's criterion.**  A tube contains the pressure `p` exactly while `p`
stays below its burst pressure. -/
theorem hoopStress_le_iff {p d t sigma : ℝ} (hd : 0 < d) (ht : 0 < t) :
    hoopStress p d t ≤ sigma ↔ p ≤ burstPressure sigma d t := by
  unfold hoopStress burstPressure
  rw [div_le_iff₀ (by positivity), le_div_iff₀ hd]
  constructor <;> intro h <;> nlinarith [h]

/-- A heavier wall holds more pressure. -/
theorem burstPressure_mono_wall {sigma d t₁ t₂ : ℝ} (hsigma : 0 ≤ sigma)
    (hd : 0 < d) (h : t₁ ≤ t₂) :
    burstPressure sigma d t₁ ≤ burstPressure sigma d t₂ := by
  unfold burstPressure
  apply div_le_div_of_nonneg_right _ hd.le
  nlinarith

/-- **Big hose, low pressure.**  At the same wall thickness a wider tube bursts
sooner: this is why high-pressure lines are the small ones. -/
theorem burstPressure_antitone_diameter {sigma d₁ d₂ t : ℝ} (hsigma : 0 ≤ sigma)
    (ht : 0 ≤ t) (h₁ : 0 < d₁) (h : d₁ ≤ d₂) :
    burstPressure sigma d₂ t ≤ burstPressure sigma d₁ t := by
  unfold burstPressure
  exact div_le_div_of_nonneg_left (by positivity) h₁ h

/-- **The four-to-one rule.**  A hose rated by the usual hydraulic convention —
a burst pressure of at least four times the working pressure — is exactly one
whose factor of safety against bursting is at least four. -/
theorem burst_safety_factor_iff {p d t sigma : ℝ} (hp : 0 < p) :
    4 * p ≤ burstPressure sigma d t ↔ 4 ≤ safetyFactor (burstPressure sigma d t) p := by
  rw [safetyFactor_ge_iff hp (by norm_num), le_div_iff₀ (by norm_num)]
  constructor <;> intro h <;> linarith

end

end LifeTrac
