import RequestProject.Gvcs.GVCSEcology
import Mathlib

/-!
# The Power Cube, and what the LifeTrac's own hydraulics can actually deliver

The Power Cube is the module the Global Village Construction Set runs on: an
engine bolted to a fixed-displacement pump, delivering oil through quick
couplers, so that any machine in the set can be plugged into any power source
and several cubes can be stacked for more power.

Imported here, from the Open Source Ecology wiki (pages *Power Cube*,
*Power Cube v15.6* and *Hydraulic Power*, read in August 2026):

* the rule of thumb the wiki uses throughout, `HP = PSI × GPM / 1714`;
* the specification of Power Cube v15.6 — a 28 hp engine, 3000 psi maximum,
  15.2 gpm maximum, 400 lb, a 7-gallon tank;
* the LifeTrac hydraulics primer — a 55 hp diesel driving a 29 gpm, 3600 psi
  pump, of which 24 gpm reaches the three auxiliary outlets past the steering
  flow divider, each quick coupler being rated for 12 gpm;
* the 2010 costing note — a power cube of 27 hp for $1750, so "about 100 hp of
  drive for $7k".

The arithmetic mostly checks out, and one thing does not.

* **The cube's engine fits its pump**, with about five percent in hand:
  15.2 gpm at 3000 psi asks 26.6 hp of a 28 hp engine
  (`cube_engine_is_adequate`, `cube_margin_is_thin`).
* **The tractor's does not.**  A 29 gpm pump at 3600 psi asks 60.9 hp, and the
  engine on the page is 55 hp (`lifetrac_pump_outruns_its_engine`).  The
  machine can have the flow or the pressure, not both: at 3600 psi the engine
  sustains 26.2 gpm, and at 29 gpm it sustains 3250 psi
  (`lifetrac_sustainable_flow`, `lifetrac_sustainable_pressure`).
* **The flow budget adds up**: 24 gpm past the divider plus the 5 gpm the page
  says can be tapped ahead of it is exactly the 29 gpm the pump makes
  (`flow_split_accounts_for_the_pump`).
* **One coupler is not enough** for the auxiliary flow and two are exactly
  enough (`one_coupler_is_not_enough`, `two_couplers_suffice`), which is why
  the page says to use several outlets.
* **Two cubes replace the diesel** on both counts — 30.4 gpm against 29, and
  56 hp against 55 (`two_cubes_replace_the_diesel`) — though only at the
  cube's lower 3000 psi.
* **The costing note is consistent**: four cubes of 27 hp at $1750 apiece is
  108 hp for $7000 (`four_cubes_cost_seven_thousand`).
-/

namespace LifeTrac
namespace PowerCube

noncomputable section

/-! ## The wiki's horsepower rule -/

/-- The horsepower needed to drive `gpm` gallons a minute at `psi`, by the
rule of thumb `HP = PSI × GPM / 1714` used throughout the OSE wiki. -/
def flowToHp (gpm psi : ℝ) : ℝ := psi * gpm / 1714

/-- The flow, in gallons a minute, that `hp` horsepower sustains at `psi`. -/
def hpToFlow (hp psi : ℝ) : ℝ := hp * 1714 / psi

/-- The pressure, in psi, that `hp` horsepower sustains at `gpm`. -/
def hpToPressure (hp gpm : ℝ) : ℝ := hp * 1714 / gpm

theorem flowToHp_hpToFlow (hp psi : ℝ) (h : psi ≠ 0) : flowToHp (hpToFlow hp psi) psi = hp := by
  unfold flowToHp hpToFlow; field_simp

theorem flowToHp_hpToPressure (hp gpm : ℝ) (h : gpm ≠ 0) :
    flowToHp gpm (hpToPressure hp gpm) = hp := by
  unfold flowToHp hpToPressure; field_simp

/-- Hydraulic power is monotone in flow. -/
theorem flowToHp_mono_flow {a b psi : ℝ} (hpsi : 0 < psi) (h : a < b) :
    flowToHp a psi < flowToHp b psi := by
  have h1 : psi * a < psi * b := by nlinarith
  have h2 : psi * a / 1714 < psi * b / 1714 := by linarith
  simpa [flowToHp] using h2

/-! ## Power Cube v15.6 -/

/-- Rated engine power of Power Cube v15.6, in horsepower. -/
def cubeEngineHp : ℝ := 28

/-- Maximum working pressure of the cube, in psi. -/
def cubeMaxPressure : ℝ := 3000

/-- Maximum flow of the cube, in gallons a minute. -/
def cubeMaxFlow : ℝ := 15.2

/-- Dry weight of the cube, in pounds. -/
def cubeWeight : ℝ := 400

/-- Fuel and oil tank capacity, in gallons. -/
def cubeTank : ℝ := 7

/-- Driving the cube's pump flat out at its maximum pressure takes 26.6 hp. -/
theorem cube_full_load_hp : |flowToHp cubeMaxFlow cubeMaxPressure - 26.6| < 0.05 := by
  unfold flowToHp cubeMaxFlow cubeMaxPressure
  rw [abs_sub_lt_iff]; norm_num

/-- **The cube's engine is adequate**: it can drive its own pump at maximum
flow and maximum pressure at once. -/
theorem cube_engine_is_adequate : flowToHp cubeMaxFlow cubeMaxPressure < cubeEngineHp := by
  unfold flowToHp cubeMaxFlow cubeMaxPressure cubeEngineHp; norm_num

/-- The margin is thin — under six percent of the engine. -/
theorem cube_margin_is_thin :
    cubeEngineHp - flowToHp cubeMaxFlow cubeMaxPressure < 0.06 * cubeEngineHp := by
  unfold flowToHp cubeMaxFlow cubeMaxPressure cubeEngineHp; norm_num

/-! ## The LifeTrac's own power unit -/

/-- The LifeTrac's diesel, in horsepower, as the hydraulics primer states it. -/
def lifetracEngineHp : ℝ := 55

/-- The rated flow of the LifeTrac's pump, in gallons a minute. -/
def lifetracPumpFlow : ℝ := 29

/-- The rated pressure of the LifeTrac's pump, in psi. -/
def lifetracPumpPressure : ℝ := 3600

/-- Driving that pump at its ratings would take 60.9 hp. -/
theorem lifetrac_full_load_hp :
    |flowToHp lifetracPumpFlow lifetracPumpPressure - 60.9| < 0.05 := by
  unfold flowToHp lifetracPumpFlow lifetracPumpPressure
  rw [abs_sub_lt_iff]; norm_num

/-- **The pump outruns the engine.**  Twenty-nine gallons a minute at
3600 psi asks about six more horsepower than the 55 hp diesel has, so the
tractor's rated flow and rated pressure cannot be had at the same time. -/
theorem lifetrac_pump_outruns_its_engine :
    lifetracEngineHp < flowToHp lifetracPumpFlow lifetracPumpPressure := by
  unfold flowToHp lifetracEngineHp lifetracPumpFlow lifetracPumpPressure; norm_num

/-- At full pressure the engine sustains 26.2 gpm, not 29. -/
theorem lifetrac_sustainable_flow :
    |hpToFlow lifetracEngineHp lifetracPumpPressure - 26.2| < 0.05 := by
  unfold hpToFlow lifetracEngineHp lifetracPumpPressure
  rw [abs_sub_lt_iff]; norm_num

/-- At full flow the engine sustains 3251 psi, not 3600. -/
theorem lifetrac_sustainable_pressure :
    |hpToPressure lifetracEngineHp lifetracPumpFlow - 3251| < 1 := by
  unfold hpToPressure lifetracEngineHp lifetracPumpFlow
  rw [abs_sub_lt_iff]; norm_num

/-! ## The flow budget of the tractor -/

/-- Flow reaching the auxiliary outlets, past the steering flow divider. -/
def auxiliaryFlow : ℝ := 24

/-- Flow that can be tapped ahead of the divider. -/
def preDividerFlow : ℝ := 5

/-- Flow rating of one quick coupler, in gallons a minute. -/
def couplerRating : ℝ := 12

/-- Auxiliary outlets on the machine. -/
def auxiliaryOutlets : ℕ := 3

/-- The primer's two figures account for the pump exactly. -/
theorem flow_split_accounts_for_the_pump :
    auxiliaryFlow + preDividerFlow = lifetracPumpFlow := by
  unfold auxiliaryFlow preDividerFlow lifetracPumpFlow; norm_num

/-- A single quick coupler cannot pass the auxiliary flow. -/
theorem one_coupler_is_not_enough : couplerRating < auxiliaryFlow := by
  unfold couplerRating auxiliaryFlow; norm_num

/-- Two of them pass it exactly, which is why the page says to use more than
one outlet. -/
theorem two_couplers_suffice : auxiliaryFlow ≤ 2 * couplerRating := by
  unfold couplerRating auxiliaryFlow; norm_num

/-- The machine has an outlet to spare. -/
theorem outlets_to_spare : auxiliaryFlow < auxiliaryOutlets * couplerRating := by
  unfold auxiliaryFlow auxiliaryOutlets couplerRating; norm_num

/-! ## Stacking cubes

The cube's selling point is modularity: string several together for more
hydraulic power. -/

/-- Flow available from `n` power cubes run together. -/
def stackFlow (n : ℕ) : ℝ := n * cubeMaxFlow

/-- Engine power of a stack of `n` cubes. -/
def stackHp (n : ℕ) : ℝ := n * cubeEngineHp

/-- Stacking never loses flow. -/
theorem stackFlow_mono {m n : ℕ} (h : m ≤ n) : stackFlow m ≤ stackFlow n := by
  unfold stackFlow cubeMaxFlow
  have : (m : ℝ) ≤ n := by exact_mod_cast h
  nlinarith

/-- **Two cubes replace the tractor's diesel** on both counts: 30.4 gpm
against the pump's 29, and 56 hp against the engine's 55 — though the cubes
work at 3000 psi rather than 3600. -/
theorem two_cubes_replace_the_diesel :
    lifetracPumpFlow ≤ stackFlow 2 ∧ lifetracEngineHp ≤ stackHp 2 := by
  unfold stackFlow stackHp cubeMaxFlow cubeEngineHp lifetracPumpFlow lifetracEngineHp
  norm_num

/-- One cube does not: it is barely half the tractor. -/
theorem one_cube_is_not_enough : stackFlow 1 < lifetracPumpFlow := by
  unfold stackFlow cubeMaxFlow lifetracPumpFlow; norm_num

/-! ## What a stack costs

From the 2010 cost note: a power cube of 27 hp for $1750, giving "about
100 hp of drive" for $7k. -/

/-- Cost of one power cube in the 2010 note, in dollars. -/
def cubePrice : ℝ := 1750

/-- Engine power quoted for that cube, in horsepower. -/
def cubeQuotedHp : ℝ := 27

/-- Four cubes at that price are $7000 and 108 horsepower — the note's "about
100 hp of drive for $7k". -/
theorem four_cubes_cost_seven_thousand :
    4 * cubePrice = 7000 ∧ 100 ≤ 4 * cubeQuotedHp := by
  unfold cubePrice cubeQuotedHp; norm_num

/-- Dollars per horsepower of drive, on that note's figures: under 65. -/
theorem dollars_per_hp : cubePrice / cubeQuotedHp < 65 := by
  unfold cubePrice cubeQuotedHp; norm_num

/-! ## Where the cube sits in the construction set -/

/-- The power cube is an energy machine of the GVCS, at prototype status. -/
theorem powerCube_is_energy : GVCS.Machine.powerCube.sector = .energy := rfl

theorem powerCube_is_prototyped : GVCS.Machine.powerCube.status = .prototype := rfl

/-- Nine machines of the set name the power cube as what they run on, more
than name any other machine — the modular power supply is exactly what the
wiki says it is. -/
theorem powerCube_powers_the_set :
    (Finset.univ.filter
      (fun m : GVCS.Machine => GVCS.Machine.powerCube ∈ GVCS.uses m)).card = 9 :=
  GVCS.powerCube_is_the_common_power_source

end

end PowerCube
end LifeTrac
