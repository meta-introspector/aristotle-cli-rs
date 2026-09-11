import RequestProject.Gvcs.Power

/-!
# Hose losses and the thermal budget of the hydraulic circuit

The pressure the pump makes is not the pressure that reaches the wheel motors:
some of it is spent pushing the oil down the hoses.  That lost pressure does
not disappear — it heats the fluid, which is why a hydrostatic machine needs a
reservoir and, if it is worked hard, a cooler.

This file formalizes

* laminar (Hagen–Poiseuille) pressure loss in a hose, `Δp = 8 μ L Q / (π r⁴)`,
  and how brutally it depends on the hose bore;
* the mean flow velocity and the Reynolds number, with the laminar criterion
  turned into an explicit bound on the flow;
* hoses in series;
* the pressure actually available at the motors, and the tractive force that is
  therefore lost to plumbing;
* the heat put into the oil and the reservoir needed to absorb it.

Units are SI throughout: metres, seconds, pascals, `m³/s`, `Pa·s`, `kg/m³`.
-/

namespace LifeTrac

open Real

noncomputable section

/-- A hydraulic hose: a circular pipe of inner radius `radius` and length
`length`. -/
structure Hose where
  /-- Inner radius of the hose. -/
  radius : ℝ
  /-- Length of the hose run. -/
  length : ℝ
  radius_pos : 0 < radius
  length_pos : 0 < length

/-- The working fluid: dynamic viscosity `visc`, density `dens`, specific heat
capacity `heatCap`. -/
structure Fluid where
  /-- Dynamic viscosity. -/
  visc : ℝ
  /-- Density. -/
  dens : ℝ
  /-- Specific heat capacity. -/
  heatCap : ℝ
  visc_pos : 0 < visc
  dens_pos : 0 < dens
  heatCap_pos : 0 < heatCap

namespace Hose

variable (h : Hose)

/-- Cross-sectional area of the bore. -/
def area : ℝ := π * h.radius ^ 2

theorem area_pos : 0 < h.area := by
  have := h.radius_pos
  unfold area; positivity

/-- Mean velocity of the oil in the hose at flow `Q`. -/
def velocity (Q : ℝ) : ℝ := Q / h.area

theorem velocity_eq (Q : ℝ) : h.velocity Q = Q / (π * h.radius ^ 2) := rfl

/-- **Hagen–Poiseuille.**  Pressure lost along the hose in laminar flow. -/
def pressureDrop (f : Fluid) (Q : ℝ) : ℝ :=
  8 * f.visc * h.length * Q / (π * h.radius ^ 4)

theorem pressureDrop_nonneg (f : Fluid) {Q : ℝ} (hQ : 0 ≤ Q) :
    0 ≤ h.pressureDrop f Q := by
  have := h.radius_pos
  have := f.visc_pos
  have := h.length_pos
  unfold pressureDrop
  positivity

/-- The loss is proportional to the flow. -/
theorem pressureDrop_mono (f : Fluid) {Q₁ Q₂ : ℝ} (hQ : Q₁ ≤ Q₂) :
    h.pressureDrop f Q₁ ≤ h.pressureDrop f Q₂ := by
  have h1 := h.radius_pos
  have h2 := f.visc_pos
  have h3 := h.length_pos
  unfold pressureDrop
  gcongr

/-- **Hose bore matters enormously.**  Halving the inner radius of a hose
multiplies the pressure it wastes by sixteen. -/
theorem pressureDrop_half_radius (f : Fluid) (Q : ℝ) (h' : Hose)
    (hr : h'.radius = h.radius / 2) (hl : h'.length = h.length) :
    h'.pressureDrop f Q = 16 * h.pressureDrop f Q := by
  have hp := pi_pos.ne'
  have hrp := h.radius_pos.ne'
  unfold pressureDrop
  rw [hr, hl]
  field_simp
  norm_num

/-- Scaling the bore of a hose by `k` divides its loss by `k⁴`. -/
theorem pressureDrop_scale_radius (f : Fluid) (Q k : ℝ) (h' : Hose)
    (hk : 0 < k) (hr : h'.radius = k * h.radius) (hl : h'.length = h.length) :
    k ^ 4 * h'.pressureDrop f Q = h.pressureDrop f Q := by
  have hp := pi_pos.ne'
  have hrp := h.radius_pos.ne'
  unfold pressureDrop
  rw [hr, hl]
  field_simp

/-- **Power wasted in the hose** is the pressure it drops times the flow, and
it is never negative: plumbing always costs. -/
theorem hydPower_pressureDrop_nonneg (f : Fluid) {Q : ℝ} (hQ : 0 ≤ Q) :
    0 ≤ hydPower (h.pressureDrop f Q) Q :=
  mul_nonneg (h.pressureDrop_nonneg f hQ) hQ

/-- The wasted power grows with the *square* of the flow. -/
theorem hydPower_pressureDrop_eq (f : Fluid) (Q : ℝ) :
    hydPower (h.pressureDrop f Q) Q
      = 8 * f.visc * h.length * Q ^ 2 / (π * h.radius ^ 4) := by
  unfold hydPower pressureDrop
  ring

/-- Reynolds number of the flow in the hose, `Re = ρ v d / μ` with `d = 2r`. -/
def reynolds (f : Fluid) (Q : ℝ) : ℝ :=
  f.dens * h.velocity Q * (2 * h.radius) / f.visc

theorem reynolds_eq (f : Fluid) (Q : ℝ) :
    h.reynolds f Q = 2 * f.dens * Q / (π * h.radius * f.visc) := by
  have hp := pi_pos.ne'
  have hr := h.radius_pos.ne'
  have hv := f.visc_pos.ne'
  unfold reynolds velocity area
  field_simp

/-- **The laminar criterion as a flow limit.**  The flow in the hose stays
below the critical Reynolds number `2300` — so that the Hagen–Poiseuille law
applies — exactly while `Q < 1150 π r μ / ρ`. -/
theorem reynolds_lt_iff (f : Fluid) (Q : ℝ) :
    h.reynolds f Q < 2300 ↔ Q < 1150 * π * h.radius * f.visc / f.dens := by
  have hp := pi_pos
  have hr := h.radius_pos
  have hv := f.visc_pos
  have hd := f.dens_pos
  rw [reynolds_eq, div_lt_iff₀ (by positivity), lt_div_iff₀ hd]
  constructor <;> intro hx <;> nlinarith [hx]

end Hose

/-! ## Hoses in series -/

/-- The loss down two hoses in series is the sum of the two losses. -/
theorem pressureDrop_series (h₁ h₂ h : Hose) (f : Fluid) (Q : ℝ)
    (hr₁ : h.radius = h₁.radius) (hr₂ : h.radius = h₂.radius)
    (hl : h.length = h₁.length + h₂.length) :
    h.pressureDrop f Q = h₁.pressureDrop f Q + h₂.pressureDrop f Q := by
  unfold Hose.pressureDrop
  rw [hl, ← hr₁, ← hr₂]
  ring

/-! ## What is left for the motors -/

/-- The pressure that actually reaches the motors: what the pump makes, less
what the supply hose eats. -/
def Hose.motorPressure (h : Hose) (f : Fluid) (pumpPressure Q : ℝ) : ℝ :=
  pumpPressure - h.pressureDrop f Q

theorem Hose.motorPressure_le (h : Hose) (f : Fluid) {pumpPressure Q : ℝ}
    (hQ : 0 ≤ Q) : h.motorPressure f pumpPressure Q ≤ pumpPressure := by
  have := h.pressureDrop_nonneg f hQ
  unfold motorPressure; linarith

/-- **Plumbing costs pull.**  The tractive force developed with the hose losses
taken into account never exceeds the force computed from the pump pressure
alone. -/
theorem Drive.sideForce_motorPressure_le (d : Drive) (h : Hose) (f : Fluid)
    {pumpPressure Q : ℝ} (hQ : 0 ≤ Q) :
    d.sideForce (h.motorPressure f pumpPressure Q) ≤ d.sideForce pumpPressure :=
  d.sideForce_le_of_pressure_le (h.motorPressure_le f hQ)

/-- **The circuit balance.**  The hydraulic power leaving the pump splits
exactly into the power delivered at the motors and the power burnt in the
hose. -/
theorem power_balance (h : Hose) (f : Fluid) (pumpPressure Q : ℝ) :
    hydPower pumpPressure Q
      = hydPower (h.motorPressure f pumpPressure Q) Q
        + hydPower (h.pressureDrop f Q) Q := by
  unfold hydPower Hose.motorPressure
  ring

/-! ## Heating the oil -/

/-- Rate at which the temperature of a reservoir holding `mass` of fluid rises
when `power` is dissipated into it. -/
def heatingRate (f : Fluid) (mass power : ℝ) : ℝ := power / (mass * f.heatCap)

/-- **Reservoir sizing.**  The oil temperature climbs no faster than `limit`
degrees per unit time exactly when the reservoir holds at least
`power / (c · limit)` of fluid. -/
theorem heatingRate_le_iff (f : Fluid) {mass power limit : ℝ} (hm : 0 < mass)
    (hl : 0 < limit) :
    heatingRate f mass power ≤ limit ↔ power / (f.heatCap * limit) ≤ mass := by
  have hc := f.heatCap_pos
  rw [heatingRate, div_le_iff₀ (by positivity), div_le_iff₀ (by positivity)]
  constructor <;> intro hx <;> nlinarith [hx]

/-- A bigger reservoir heats up more slowly. -/
theorem heatingRate_antitone (f : Fluid) {m₁ m₂ power : ℝ} (hp : 0 ≤ power)
    (h₁ : 0 < m₁) (h : m₁ ≤ m₂) :
    heatingRate f m₂ power ≤ heatingRate f m₁ power := by
  have hc := f.heatCap_pos
  unfold heatingRate
  apply div_le_div_of_nonneg_left hp (by positivity)
  nlinarith

/-- **Where the heat comes from.**  All of the power lost in the hose ends up
in the oil, so the temperature rise of the reservoir is set by the flow, the
hose and the fluid alone. -/
theorem heatingRate_hose (h : Hose) (f : Fluid) (mass Q : ℝ) :
    heatingRate f mass (hydPower (h.pressureDrop f Q) Q)
      = 8 * f.visc * h.length * Q ^ 2 / (π * h.radius ^ 4 * mass * f.heatCap) := by
  rw [heatingRate, h.hydPower_pressureDrop_eq f Q]
  ring

end

end LifeTrac
