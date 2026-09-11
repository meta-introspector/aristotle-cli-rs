import RequestProject.Gvcs.Field
import RequestProject.Gvcs.Power

/-!
# The engine: fuel, endurance and the cost of a job

The last link in the chain is the engine.  It is characterised here by its
rated power and by its brake specific fuel consumption `bsfc` — the mass of
fuel it burns per unit of work at the crankshaft.

We prove

* the fuel rate is proportional to the power taken, and the fuel burnt over a
  period is the fuel rate times the time;
* the endurance of a tank falls as the power rises;
* how big an engine a given drawbar job needs, and hence the top speed at which
  an implement of a given draft can be pulled;
* and the fact a farmer cares about: the fuel needed to work a plot depends on
  the draft, the area, the working width and the efficiency of the machine, but
  **not** on the speed chosen — driving faster finishes the job sooner and
  burns the same fuel.

Powers are in watts, energies in joules, fuel masses in kilograms.
-/

namespace LifeTrac

open Real

noncomputable section

/-- An internal-combustion engine: its rated shaft power and its brake specific
fuel consumption (kilograms of fuel per joule of shaft work). -/
structure Engine where
  /-- Rated shaft power. -/
  ratedPower : ℝ
  /-- Brake specific fuel consumption: fuel mass per unit of shaft work. -/
  bsfc : ℝ
  ratedPower_pos : 0 < ratedPower
  bsfc_pos : 0 < bsfc

/-- Shaft power that must be produced to pull a draft of `draft` at speed `v`,
through a driveline of overall efficiency `eff`. -/
def powerNeeded (draft v eff : ℝ) : ℝ := draft * v / eff

namespace Engine

variable (e : Engine)

/-- Fuel burnt per unit time when the engine delivers `power`. -/
def fuelRate (power : ℝ) : ℝ := e.bsfc * power

/-- Fuel burnt in producing a given amount of shaft work. -/
def fuelForWork (energy : ℝ) : ℝ := e.bsfc * energy

theorem fuelRate_nonneg {power : ℝ} (hp : 0 ≤ power) : 0 ≤ e.fuelRate power :=
  mul_nonneg e.bsfc_pos.le hp

theorem fuelRate_mono {p₁ p₂ : ℝ} (h : p₁ ≤ p₂) : e.fuelRate p₁ ≤ e.fuelRate p₂ :=
  mul_le_mul_of_nonneg_left h e.bsfc_pos.le

/-- Fuel burnt is the fuel rate times the time. -/
theorem fuelForWork_eq (power time : ℝ) :
    e.fuelForWork (power * time) = e.fuelRate power * time := by
  unfold fuelForWork fuelRate; ring

/-- How long a tank of `tankMass` kilograms lasts at a given power. -/
def endurance (tankMass power : ℝ) : ℝ := tankMass / e.fuelRate power

/-- **Working harder empties the tank sooner.** -/
theorem endurance_antitone {tankMass p₁ p₂ : ℝ} (hm : 0 ≤ tankMass)
    (h₁ : 0 < p₁) (h : p₁ ≤ p₂) :
    e.endurance tankMass p₂ ≤ e.endurance tankMass p₁ := by
  have hb := e.bsfc_pos
  unfold endurance fuelRate
  apply div_le_div_of_nonneg_left hm (by positivity)
  exact mul_le_mul_of_nonneg_left h hb.le

/-- The tank really does last that long: the fuel burnt over the endurance is
the whole tank. -/
theorem fuelRate_mul_endurance {tankMass power : ℝ} (hp : 0 < power) :
    e.fuelRate power * e.endurance tankMass power = tankMass := by
  have hb := e.bsfc_pos
  have h : e.fuelRate power ≠ 0 := by
    unfold fuelRate; positivity
  unfold endurance
  field_simp

/-! ### Pulling an implement -/

/-- **Top speed with an implement.**  The engine can pull a draft of `draft`
exactly up to the speed `ratedPower · eff / draft`. -/
theorem powerNeeded_le_iff {draft v eff : ℝ} (hd : 0 < draft) (heff : 0 < eff) :
    powerNeeded draft v eff ≤ e.ratedPower ↔
      v ≤ e.ratedPower * eff / draft := by
  unfold powerNeeded
  rw [div_le_iff₀ heff, le_div_iff₀ hd]
  constructor <;> intro h <;> nlinarith [h]

/-- A heavier implement can only be pulled more slowly. -/
theorem maxSpeed_antitone_draft {d₁ d₂ eff : ℝ} (heff : 0 < eff) (h₁ : 0 < d₁)
    (h : d₁ ≤ d₂) :
    e.ratedPower * eff / d₂ ≤ e.ratedPower * eff / d₁ := by
  have := e.ratedPower_pos
  exact div_le_div_of_nonneg_left (by positivity) h₁ h

/-- Fuel needed to work a plot with an implement of the given draft and working
width, through a driveline of efficiency `eff`. -/
def fuelForPlot (p : Plot) (draft w eff : ℝ) : ℝ :=
  e.bsfc * (draft * p.area / w) / eff

/-- **Speed costs nothing in fuel.**  Whatever speed `v` is chosen, the engine
work spent on the drawbar over the job — power needed times productive time —
is the same, so the fuel burnt is `fuelForPlot`, independent of `v`. -/
theorem fuelForWork_powerNeeded (p : Plot) {draft w v eff : ℝ} (hv : v ≠ 0) :
    e.fuelForWork (powerNeeded draft v eff * p.idealTime w v)
      = e.fuelForPlot p draft w eff := by
  unfold fuelForWork powerNeeded fuelForPlot Plot.idealTime
  field_simp

/-- Twice the field, twice the fuel. -/
theorem fuelForPlot_smul (p q : Plot) {draft w eff : ℝ} (h : q.area = 2 * p.area) :
    e.fuelForPlot q draft w eff = 2 * e.fuelForPlot p draft w eff := by
  unfold fuelForPlot
  rw [h]; ring

/-- **A wider implement saves fuel** as well as time: the fuel for the job is
inversely proportional to the working width. -/
theorem fuelForPlot_antitone_width (p : Plot) {draft w₁ w₂ eff : ℝ}
    (hd : 0 ≤ draft) (heff : 0 < eff) (h₁ : 0 < w₁) (h : w₁ ≤ w₂) :
    e.fuelForPlot p draft w₂ eff ≤ e.fuelForPlot p draft w₁ eff := by
  have hb := e.bsfc_pos
  have ha := p.area_pos
  unfold fuelForPlot
  apply div_le_div_of_nonneg_right _ heff.le
  apply mul_le_mul_of_nonneg_left _ hb.le
  exact div_le_div_of_nonneg_left (by positivity) h₁ h

end Engine

end

end LifeTrac
