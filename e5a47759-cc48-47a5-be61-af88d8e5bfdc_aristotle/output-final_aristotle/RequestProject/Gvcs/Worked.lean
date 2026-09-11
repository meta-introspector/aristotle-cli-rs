import RequestProject.Gvcs.Main
import RequestProject.Gvcs.Structure
import RequestProject.Gvcs.Circuit
import RequestProject.Gvcs.Field
import RequestProject.Gvcs.Valves
import RequestProject.Gvcs.Engine
import RequestProject.Gvcs.Welds
import RequestProject.Gvcs.Excavation

/-!
# The worked machine, continued: steel, plumbing, field work and fuel

`Main.lean` fixes a concrete LifeTrac-like machine and works out its drive
train, its stability, its loader and its dynamics.  This file carries the same
example through the rest of the theory: the sizing of the steel it is welded
from, the losses in its plumbing, a day's work in a ten-hectare field, the
behaviour of its valves and the fuel it burns, and the rate at which it can
work a pit.
-/

namespace LifeTrac

open Real

noncomputable section

/-! ## Structural sizing of the example machine

The frame and the loader arms are welded from 100 × 100 × 6 mm square steel
tube; the steel is taken to yield at 250 MPa and to have a Young's modulus of
200 GPa. -/

/-- The frame tube: 100 mm square, 6 mm wall. -/
def exampleTube : SquareTube where
  width := 1 / 10
  wall := 3 / 500
  wall_pos := by norm_num
  wall_lt_half_width := by norm_num

/-- Section properties of the frame tube: 22.56 cm² of steel, a second moment
of area of 333.6 cm⁴ and a section modulus of 66.7 cm³. -/
theorem exampleTube_section :
    exampleTube.area = 141 / 62500 ∧
      exampleTube.inertia = 52123 / 15625000000 ∧
      exampleTube.sectionModulus = 52123 / 781250000 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    · simp only [SquareTube.area, SquareTube.inertia, SquareTube.sectionModulus,
        SquareTube.innerWidth, exampleTube]
      norm_num

/-- One such tube used as a 1.4 m cantilever reaches the yield stress at a tip
load of `416984/35 ≈ 11.9 kN`. -/
theorem exampleTube_maxTipLoad :
    exampleTube.maxTipLoad 250000000 (7 / 5) = 416984 / 35 ∧
      11913 < exampleTube.maxTipLoad 250000000 (7 / 5) ∧
      exampleTube.maxTipLoad 250000000 (7 / 5) < 11914 := by
  have h : exampleTube.maxTipLoad 250000000 (7 / 5) = 416984 / 35 := by
    simp only [SquareTube.maxTipLoad, SquareTube.sectionModulus,
      SquareTube.inertia, SquareTube.innerWidth, exampleTube]
    norm_num
  refine ⟨h, ?_, ?_⟩ <;> rw [h] <;> norm_num

/-- **The loader arms are strong enough for the payload the machine can lift.**
The tipping limit at one metre reach is 12 556.8 N; shared between the two arm
tubes that is 6278.4 N each, which the section carries with a factor of safety
of more than 1.8 against yield. -/
theorem exampleTube_loader_arm_safe :
    exampleSideView.maxPayload 1 / 2 ≤ exampleTube.maxTipLoad 250000000 (7 / 5) ∧
      18 / 10 ≤ safetyFactor (exampleTube.maxTipLoad 250000000 (7 / 5))
        (exampleSideView.maxPayload 1 / 2) := by
  have hm : exampleSideView.maxPayload 1 = 62784 / 5 := by
    simp only [SideView.maxPayload, exampleSideView]; norm_num
  have h := exampleTube_maxTipLoad.1
  constructor
  · rw [hm, h]; norm_num
  · rw [safetyFactor_ge_iff (by rw [hm]; norm_num) (by norm_num), hm, h]
    norm_num

/-- Under its share of that payload the tip of a 1.4 m arm tube sags about
8.6 mm. -/
theorem exampleTube_deflection :
    exampleTube.tipDeflection 200000000000 (62784 / 10) (7 / 5)
        = 112161 / 13030750 ∧
      exampleTube.tipDeflection 200000000000 (62784 / 10) (7 / 5) < 9 / 1000 := by
  have h : exampleTube.tipDeflection 200000000000 (62784 / 10) (7 / 5)
      = 112161 / 13030750 := by
    simp only [SquareTube.tipDeflection, SquareTube.inertia,
      SquareTube.innerWidth, exampleTube]
    norm_num
  exact ⟨h, by rw [h]; norm_num⟩

/-- **The lift cylinder rod is nowhere near buckling.**  Fully extended, the
20 mm rod of the example cylinder is an Euler strut good for `200000π³/9 ≈
689 kN`, ten times the `22400π ≈ 70 kN` the cylinder pushes at 140 bar; in
pressure terms the rod would only go unstable at about 1370 bar. -/
theorem exampleCylinder_rod_no_buckling :
    eulerLoad 200000000000 exampleCylinder.rod 1 exampleCylinder.stroke
        = 200000 / 9 * π ^ 3 ∧
      exampleCylinder.extendForce 14000000
        < eulerLoad 200000000000 exampleCylinder.rod 1 exampleCylinder.stroke ∧
      14000000 < exampleCylinder.bucklingPressure 200000000000 1 := by
  have h : eulerLoad 200000000000 exampleCylinder.rod 1 exampleCylinder.stroke
      = 200000 / 9 * π ^ 3 := by
    simp only [eulerLoad, roundInertia, exampleCylinder]
    norm_num
    ring
  have hF : exampleCylinder.extendForce 14000000 = 22400 * π := by
    simp only [Cylinder.extendForce, Cylinder.capArea, exampleCylinder]; ring
  have hlt : exampleCylinder.extendForce 14000000
      < eulerLoad 200000000000 exampleCylinder.rod 1 exampleCylinder.stroke := by
    rw [h, hF]
    have h3 : (3:ℝ) < π := pi_gt_three
    have hA : 3 * π < π ^ 2 := by nlinarith [pi_pos]
    have hB : 3 * π ^ 2 < π ^ 3 := by nlinarith [pi_pos]
    nlinarith [pi_pos]
  exact ⟨h, hlt, (exampleCylinder.extendForce_lt_eulerLoad_iff).1 hlt⟩

/-! ## The plumbing of the example machine

A three-metre run of 20 mm bore hose carries the full pump flow of
`1.35·10⁻³ m³/s`; the oil has viscosity 0.05 Pa·s, density 870 kg/m³ and
specific heat 1900 J/(kg·K), and the reservoir holds 40 litres (34.8 kg). -/

/-- The supply hose: 10 mm inner radius, 3 m long. -/
def exampleHose : Hose where
  radius := 1 / 100
  length := 3
  radius_pos := by norm_num
  length_pos := by norm_num

/-- The hydraulic oil. -/
def exampleOil : Fluid where
  visc := 1 / 20
  dens := 870
  heatCap := 1900
  visc_pos := by norm_num
  dens_pos := by norm_num
  heatCap_pos := by norm_num

/-- **The flow in the hose is laminar**, so the Hagen–Poiseuille law applies:
the oil moves at `27/(2π) ≈ 4.30 m/s` and the Reynolds number is
`4698/π ≈ 1495`, well below the critical 2300. -/
theorem exampleHose_laminar :
    exampleHose.velocity (27 / 20000) = 27 / (2 * π) ∧
      exampleHose.reynolds exampleOil (27 / 20000) = 4698 / π ∧
      exampleHose.reynolds exampleOil (27 / 20000) < 2300 := by
  have hpi := pi_pos
  have hv : exampleHose.velocity (27 / 20000) = 27 / (2 * π) := by
    simp only [Hose.velocity, Hose.area, exampleHose]
    field_simp
    ring
  have hr : exampleHose.reynolds exampleOil (27 / 20000) = 4698 / π := by
    rw [Hose.reynolds_eq]
    simp only [exampleHose, exampleOil]
    field_simp
    ring
  refine ⟨hv, hr, ?_⟩
  rw [hr, div_lt_iff₀ hpi]
  nlinarith [pi_gt_three]

/-- **The hose costs about half a bar.**  It drops `162000/π ≈ 51.6 kPa`, less
than half a percent of the 140 bar the pump makes, and burns `2187/(10π) ≈
69.6 W` doing it. -/
theorem exampleHose_pressureDrop :
    exampleHose.pressureDrop exampleOil (27 / 20000) = 162000 / π ∧
      51500 < exampleHose.pressureDrop exampleOil (27 / 20000) ∧
      exampleHose.pressureDrop exampleOil (27 / 20000) < 14000000 / 250 ∧
      hydPower (exampleHose.pressureDrop exampleOil (27 / 20000)) (27 / 20000)
        = 2187 / (10 * π) := by
  have hpi := pi_pos
  have h : exampleHose.pressureDrop exampleOil (27 / 20000) = 162000 / π := by
    simp only [Hose.pressureDrop, exampleHose, exampleOil]
    field_simp
    ring
  refine ⟨h, ?_, ?_, ?_⟩
  · rw [h, lt_div_iff₀ hpi]
    nlinarith [pi_lt_d6]
  · rw [h, div_lt_iff₀ hpi]
    nlinarith [pi_gt_d6]
  · rw [hydPower, h]
    field_simp
    ring

/-- **The oil warms slowly.**  All of the hose loss goes into the 34.8 kg of
oil in the tank, which heats at `729/(220400π) ≈ 1.05 mK/s`, under four degrees
an hour. -/
theorem exampleHose_heating :
    heatingRate exampleOil (348 / 10)
        (hydPower (exampleHose.pressureDrop exampleOil (27 / 20000)) (27 / 20000))
      = 729 / (220400 * π) ∧
    heatingRate exampleOil (348 / 10)
        (hydPower (exampleHose.pressureDrop exampleOil (27 / 20000)) (27 / 20000))
      * 3600 < 4 := by
  have hpi := pi_pos
  have h : heatingRate exampleOil (348 / 10)
      (hydPower (exampleHose.pressureDrop exampleOil (27 / 20000)) (27 / 20000))
      = 729 / (220400 * π) := by
    rw [heatingRate, exampleHose.hydPower_pressureDrop_eq]
    simp only [exampleHose, exampleOil]
    field_simp
    ring
  refine ⟨h, ?_⟩
  rw [h, div_mul_eq_mul_div, div_lt_iff₀ (by positivity)]
  nlinarith [pi_gt_three]

/-! ## A day in the field

A ten-hectare rectangular plot, 400 m along the passes and 250 m across, worked
with a two-metre implement at 1.5 m/s.  At the headland the machine spins on
the spot with its wheels at 1 m/s. -/

/-- The example plot: 400 m × 250 m, ten hectares. -/
def examplePlot : Plot where
  length := 400
  width := 250
  length_pos := by norm_num
  width_pos := by norm_num

/-- Working it with a two-metre implement takes 125 passes and 50 km of
driving. -/
theorem examplePlot_coverage :
    examplePlot.area = 100000 ∧
      examplePlot.passes 2 = 125 ∧
      examplePlot.pathLength 2 = 50000 := by
  refine ⟨by simp [Plot.area, examplePlot]; norm_num, ?_, ?_⟩
  · simp [Plot.passes, examplePlot]; norm_num
  · rw [Plot.pathLength_eq]
    simp [Plot.area, examplePlot]
    norm_num

/-- **Field efficiency of the example job.**  The passes take `100000/3 s ≈
9 h 15 min`; the 124 headland spins add `93π ≈ 292 s`, so more than 99 % of the
working time is spent covering ground. -/
theorem examplePlot_efficiency :
    examplePlot.idealTime 2 (3 / 2) = 100000 / 3 ∧
      examplePlot.workTime 2 (3 / 2) (spinTurnTime (3 / 2) 1)
        = 100000 / 3 + 93 * π ∧
      99 / 100 < examplePlot.fieldEfficiency 2 (3 / 2) (spinTurnTime (3 / 2) 1) := by
  have hi : examplePlot.idealTime 2 (3 / 2) = 100000 / 3 := by
    simp [Plot.idealTime, Plot.area, examplePlot]
    norm_num
  have hw : examplePlot.workTime 2 (3 / 2) (spinTurnTime (3 / 2) 1)
      = 100000 / 3 + 93 * π := by
    rw [Plot.workTime_eq, hi]
    simp [Plot.passes, spinTurnTime, examplePlot]
    ring
  refine ⟨hi, hw, ?_⟩
  have hpos : (0:ℝ) < 100000 / 3 + 93 * π := by positivity
  rw [Plot.fieldEfficiency, hi, hw, lt_div_iff₀ hpos]
  nlinarith [pi_lt_d6]

/-- **Speed does not save fuel at the drawbar.**  Pulling an implement of
5000 N draft through the plot costs 250 MJ of work however fast the machine is
driven. -/
theorem examplePlot_draft_energy :
    5000 * examplePlot.pathLength 2 = 250000000 := by
  rw [examplePlot_coverage.2.2]
  norm_num

/-! ## Valves: relief heat and burst margin of the example machine -/

/-- **Standing on the relief valve boils the oil.**  With the actuators stalled
at the 140 bar relief setting, the whole 18.9 kW of the pump goes over the
valve into the 34.8 kg of oil in the tank, which then warms at `315/1102 ≈
0.29 K/s` — more than 17 degrees a minute, three hundred times the rate the
hoses manage. -/
theorem exampleRelief_heat :
    reliefHeat 14000000 (27 / 20000) 0 = 18900 ∧
      heatingRate exampleOil (348 / 10) (reliefHeat 14000000 (27 / 20000) 0)
        = 315 / 1102 ∧
      17 < heatingRate exampleOil (348 / 10)
        (reliefHeat 14000000 (27 / 20000) 0) * 60 := by
  have h1 : reliefHeat 14000000 (27 / 20000) 0 = 18900 := by
    unfold reliefHeat; norm_num
  have h2 : heatingRate exampleOil (348 / 10)
      (reliefHeat 14000000 (27 / 20000) 0) = 315 / 1102 := by
    rw [heatingRate, h1]
    simp only [exampleOil]
    norm_num
  exact ⟨h1, h2, by rw [h2]; norm_num⟩

/-- **The hoses have plenty of margin.**  A 10 mm bore hose with a 2 mm wall of
material good for 400 MPa bursts at 1600 bar by Barlow's formula, more than
eleven times the 140 bar relief setting — comfortably inside the customary
four-to-one rule. -/
theorem exampleHose_burst_margin :
    burstPressure 400000000 (1 / 100) (1 / 500) = 160000000 ∧
      4 * 14000000 ≤ burstPressure 400000000 (1 / 100) (1 / 500) ∧
      4 ≤ safetyFactor (burstPressure 400000000 (1 / 100) (1 / 500)) 14000000 := by
  have h : burstPressure 400000000 (1 / 100) (1 / 500) = 160000000 := by
    unfold burstPressure; norm_num
  have h4 : (4:ℝ) * 14000000 ≤ burstPressure 400000000 (1 / 100) (1 / 500) := by
    rw [h]; norm_num
  exact ⟨h, h4, (burst_safety_factor_iff (by norm_num)).1 h4⟩

/-! ## The engine of the example machine

A 24 hp (18 kW) diesel burning 0.25 kg of fuel per kilowatt-hour, i.e.
`1/14400000` kg per joule, with 40 kg (about 48 litres) in the tank. -/

/-- The engine driving the pump. -/
def exampleEngine : Engine where
  ratedPower := 18000
  bsfc := 1 / 14400000
  ratedPower_pos := by norm_num
  bsfc_pos := by norm_num

/-- At full power the engine burns `1/800 kg/s` — 4.5 kg (about 5.3 litres) an
hour — so a 40 kg tank lasts 32 000 s, nearly nine hours. -/
theorem exampleEngine_fuel :
    exampleEngine.fuelRate 18000 = 1 / 800 ∧
      exampleEngine.endurance 40 18000 = 32000 := by
  have h1 : exampleEngine.fuelRate 18000 = 1 / 800 := by
    simp only [Engine.fuelRate, exampleEngine]; norm_num
  refine ⟨h1, ?_⟩
  rw [Engine.endurance, h1]
  norm_num

/-- **Top speed with a 5000 N implement.**  Through a driveline of 70 %
efficiency the engine can pull it up to 2.52 m/s — about 9 km/h, and less than
the 3.22 m/s the transmission would otherwise allow. -/
theorem exampleEngine_topSpeed (v : ℝ) :
    powerNeeded 5000 v (7 / 10) ≤ exampleEngine.ratedPower ↔ v ≤ 63 / 25 := by
  rw [exampleEngine.powerNeeded_le_iff (by norm_num) (by norm_num)]
  simp only [exampleEngine]
  norm_num

/-- **The fuel bill for the ten-hectare job.**  Pulling the 5000 N implement
through the example plot costs `3125/126 ≈ 24.8 kg` of fuel — under 30 litres,
about 3 litres a hectare — whatever speed the machine is driven at. -/
theorem exampleEngine_fuelForPlot :
    exampleEngine.fuelForPlot examplePlot 5000 2 (7 / 10) = 3125 / 126 ∧
      exampleEngine.fuelForPlot examplePlot 5000 2 (7 / 10) < 25 := by
  have h : exampleEngine.fuelForPlot examplePlot 5000 2 (7 / 10) = 3125 / 126 := by
    simp only [Engine.fuelForPlot, Plot.area, exampleEngine, examplePlot]
    norm_num
  exact ⟨h, by rw [h]; norm_num⟩

/-! ## The welds of the example frame

The joints are fillet welds laid right round the 100 mm tube, in weld metal
with an allowable shear stress of 150 MPa. -/

/-- A 6 mm fillet right round the frame tube holds `180000√2 ≈ 254 kN` in
shear — but that is *not* quite the full strength of the tube it joins: with a
6 mm wall, a 6 mm leg develops only about three quarters of the section, and an
8 mm leg is needed to make the joint stronger than the member. -/
theorem exampleWeld_capacity :
    perimeterWeld exampleTube (3 / 500) 150000000 = 180000 * √2 ∧
      ¬ (exampleTube.area * 150000000
          ≤ perimeterWeld exampleTube (3 / 500) 150000000) ∧
      exampleTube.area * 150000000
        ≤ perimeterWeld exampleTube (1 / 125) 150000000 := by
  have h2 : (0:ℝ) < √2 := Real.sqrt_pos.mpr (by norm_num)
  have hsq : √2 * √2 = 2 := Real.mul_self_sqrt (by norm_num)
  have hcap : perimeterWeld exampleTube (3 / 500) 150000000 = 180000 * √2 := by
    rw [perimeterWeld_eq, filletThroat]
    simp only [exampleTube]
    field_simp
    nlinarith [hsq]
  refine ⟨hcap, ?_, ?_⟩
  · rw [perimeterWeld_ge_section_iff (by norm_num), filletThroat]
    simp only [exampleTube]
    push_neg
    rw [div_mul_eq_mul_div, div_lt_iff₀ h2]
    nlinarith [hsq, h2]
  · rw [perimeterWeld_ge_section_iff (by norm_num), filletThroat]
    simp only [exampleTube]
    have key : (1:ℝ) / 125 / √2 * (1 / 10) = (1 / 1250) / √2 := by ring
    rw [key, le_div_iff₀ h2]
    nlinarith [hsq, h2, sq_nonneg (√2 - 200 / 141)]

/-! ## The example machine at the face

A 0.3 m³ rock bucket in ore of 1600 kg/m³ loose density, a fifty-second
load-haul-dump cycle to a stockpile thirty metres away, and a single ripper
tooth 100 mm wide in ground whose specific ripping resistance is 400 kPa.  The
drawbar pull available is the 10 kN of `exampleTractor_pull` (rounded down).
These are the numbers behind the rates booked in the mining workflows. -/

/-- The rock bucket of the example machine: 0.3 m³ struck, filled to 85 %, in
material of loose density 1600 kg/m³. -/
def exampleBucket : Bucket where
  volume := 3 / 10
  fillFactor := 17 / 20
  density := 1600
  volume_pos := by norm_num
  fillFactor_pos := by norm_num
  fillFactor_le_one := by norm_num
  density_pos := by norm_num

/-- One bucket load is 408 kg, that is 4002.48 N. -/
theorem exampleBucket_payload :
    exampleBucket.payload = 408 ∧ exampleBucket.load (981 / 100) = 400248 / 100 := by
  constructor <;>
    · simp only [Bucket.load, Bucket.payload, exampleBucket]
      norm_num

/-- **A full bucket does not tip the machine.**  At one metre of reach the
loader may carry 12 556.8 N; a full bucket of ore weighs less than a third of
that, and it is still safe at two metres. -/
theorem exampleBucket_safe :
    exampleBucket.load (981 / 100) ≤ exampleSideView.maxPayload 1 ∧
      exampleBucket.load (981 / 100) ≤ exampleSideView.maxPayload 2 := by
  constructor <;>
    · simp only [Bucket.load, Bucket.payload, exampleBucket, SideView.maxPayload,
        exampleSideView]
      norm_num

/-- The dig cycle: twenty seconds to fill, fifteen to dump and re-position, and
a thirty-metre haul each way at 2 m/s. -/
def exampleDigCycle : DigCycle where
  fillTime := 20
  dumpTime := 15
  haul := 30
  speed := 2
  fillTime_pos := by norm_num
  dumpTime_pos := by norm_num
  haul_nonneg := by norm_num
  speed_pos := by norm_num

/-- The cycle takes 65 seconds, so the machine loads out 22 597 kg an hour. -/
theorem exampleDigCycle_rate :
    exampleDigCycle.cycleTime = 65 ∧
      exampleDigCycle.loadRate exampleBucket = 1468800 / 65 := by
  have hc : exampleDigCycle.cycleTime = 65 := by
    simp only [DigCycle.cycleTime, exampleDigCycle]
    norm_num
  refine ⟨hc, ?_⟩
  simp only [DigCycle.loadRate, hc, Bucket.payload, exampleBucket]
  norm_num

/-- **How deep the tooth can go.**  With 10 kN of drawbar pull a 100 mm tooth
can be pulled at 250 mm in ground of 400 kPa specific resistance, but not at
300 mm. -/
theorem exampleRip_depth :
    ripResistance 400000 (1 / 10) (1 / 4) ≤ 10000 ∧
      ¬ (ripResistance 400000 (1 / 10) (3 / 10) ≤ 10000) := by
  constructor <;>
    · simp only [ripResistance]
      norm_num

/-- **And the machine really can pull it.**  The 10 kN assumed above is
available: on firm ground the hydraulics push 31 500/π ≈ 10 026 N, which is
more than the tooth needs at 250 mm. -/
theorem exampleRip_within_pull :
    ripResistance 400000 (1 / 10) (1 / 4) ≤ 2 * exampleDrive.sideForce 14000000 := by
  rw [exampleDrive_sideForce, show (2:ℝ) * (15750 / π) = 31500 / π by ring,
    le_div_iff₀ pi_pos]
  simp only [ripResistance]
  nlinarith [pi_lt_d6]

/-- **The pit rate of the example machine.**  Ripping at 250 mm and 0.5 m/s in
rock of bank density 2000 kg/m³, even with the tooth in the ground only a tenth
of the time, loosens 9 t/h, and the bucket loads out 22.6 t/h; so the pit runs
at 9 t/h, four and a half times the two tonnes an hour that the iron workflow
of the mining model books for ripping and loading. -/
theorem examplePit_rate :
    ripRate (1 / 10) (1 / 4) (1 / 2) 2000 (1 / 10) = 9000 ∧
      pitRate (ripRate (1 / 10) (1 / 4) (1 / 2) 2000 (1 / 10))
          (exampleDigCycle.loadRate exampleBucket) = 9000 ∧
        (2000 : ℝ) < pitRate (ripRate (1 / 10) (1 / 4) (1 / 2) 2000 (1 / 10))
          (exampleDigCycle.loadRate exampleBucket) := by
  have hrip : ripRate (1 / 10) (1 / 4) (1 / 2) 2000 (1 / 10) = 9000 := by
    simp only [ripRate]
    norm_num
  have hload : exampleDigCycle.loadRate exampleBucket = 1468800 / 65 :=
    exampleDigCycle_rate.2
  have hmin : pitRate (ripRate (1 / 10) (1 / 4) (1 / 2) 2000 (1 / 10))
      (exampleDigCycle.loadRate exampleBucket) = 9000 := by
    rw [pitRate_eq_loosen (by rw [hrip, hload]; norm_num), hrip]
  exact ⟨hrip, hmin, by rw [hmin]; norm_num⟩


end

end LifeTrac
