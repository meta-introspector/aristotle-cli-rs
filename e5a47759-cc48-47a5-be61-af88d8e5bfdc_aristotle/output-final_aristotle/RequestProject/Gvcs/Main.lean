import RequestProject.Gvcs.Hydraulics
import RequestProject.Gvcs.Stability
import RequestProject.Gvcs.Cylinder
import RequestProject.Gvcs.Power
import RequestProject.Gvcs.Traction
import RequestProject.Gvcs.Dynamics

/-!
# A worked LifeTrac configuration

The files `Kinematics`, `Hydraulics` and `Stability` develop the general
theory.  Here we instantiate it on a concrete, LifeTrac-like machine (all
quantities in SI units: metres, seconds, newtons, cubic metres per revolution)
and derive quantitative statements about it.

Configuration of one side of the drive train:

* gear pump of displacement `3·10⁻⁵ m³/rev` (30 cc/rev) at volumetric
  efficiency `0.9`;
* two wheel motors in parallel, displacement `3.75·10⁻⁴ m³/rev` (375 cc/rev),
  volumetric efficiency `0.95`, mechanical efficiency `0.9`;
* wheel rolling radius `0.3 m`;
* engine/pump speed `50 rev/s` (3000 rpm).
-/

namespace LifeTrac

open Real

noncomputable section

/-- The pump of one drive circuit. -/
def examplePump : Pump where
  disp := 3 / 100000
  volEff := 9 / 10
  disp_pos := by norm_num
  volEff_pos := by norm_num
  volEff_le_one := by norm_num

/-- A wheel motor. -/
def exampleMotor : Motor where
  disp := 3 / 8000
  volEff := 19 / 20
  mechEff := 9 / 10
  disp_pos := by norm_num
  volEff_pos := by norm_num
  volEff_le_one := by norm_num
  mechEff_pos := by norm_num
  mechEff_le_one := by norm_num

/-- One side (two wheels) of the LifeTrac drive train. -/
def exampleDrive : Drive where
  pump := examplePump
  motor := exampleMotor
  count := 2
  wheelRadius := 3 / 10
  count_pos := by norm_num
  wheelRadius_pos := by norm_num

/-- The chassis: track width 1.5 m. -/
def exampleChassis : Chassis where
  track := 3 / 2
  track_pos := by norm_num

/-- The complete machine. -/
def exampleTractor : Tractor where
  chassis := exampleChassis
  left := exampleDrive
  right := exampleDrive

/-- Ground speed of the example machine at 3000 rpm, in closed form. -/
theorem exampleDrive_groundSpeed :
    exampleDrive.groundSpeed 50 = 513 / 500 * π := by
  rw [Drive.groundSpeed_eq]
  simp only [exampleDrive, examplePump, exampleMotor]
  norm_num
  ring

/-- At 3000 rpm the example machine travels between 3.22 and 3.23 m/s
(about 11.6 km/h). -/
theorem exampleDrive_groundSpeed_bounds :
    3.22 < exampleDrive.groundSpeed 50 ∧ exampleDrive.groundSpeed 50 < 3.23 := by
  rw [exampleDrive_groundSpeed]
  constructor
  · nlinarith [pi_gt_d6, pi_lt_d6]
  · nlinarith [pi_gt_d6, pi_lt_d6]

/-- Driving both circuits at the same pump speed takes the tractor straight
ahead, at the ground speed of a single side. -/
theorem exampleTractor_straight (n : ℝ) :
    exampleTractor.angVel n n = 0 ∧
      exampleTractor.linVel n n = exampleDrive.groundSpeed n := by
  refine ⟨exampleTractor.angVel_eq_zero_of_symmetric rfl n, ?_⟩
  simp only [Tractor.linVel, Chassis.linVel, exampleTractor]
  ring

/-- Running the two circuits in opposite directions spins the machine on the
spot: no translation, nonzero yaw rate. -/
theorem exampleTractor_spin :
    exampleTractor.linVel (-50) 50 = 0 ∧ exampleTractor.angVel (-50) 50 ≠ 0 := by
  refine ⟨exampleTractor.linVel_eq_zero_of_counterrotating rfl 50, ?_⟩
  simp only [Tractor.angVel, Chassis.angVel, exampleTractor, exampleChassis,
    ne_eq, div_eq_zero_iff]
  push_neg
  constructor
  · have h : exampleDrive.groundSpeed (-50) = -(513 / 500 * π) := by
      rw [Drive.groundSpeed_eq]
      simp only [exampleDrive, examplePump, exampleMotor]
      norm_num
      ring
    rw [h, exampleDrive_groundSpeed]
    have := pi_gt_d6
    intro hc
    nlinarith
  · norm_num

/-- Static side view of the example machine: total weight 15696 N (mass
1600 kg), centre of mass 0.8 m behind the front axle and 0.7 m ahead of the
rear axle. -/
def exampleSideView : SideView where
  weight := 15696
  comToFront := 4 / 5
  comToRear := 7 / 10
  weight_pos := by norm_num
  comToFront_pos := by norm_num
  comToRear_pos := by norm_num

/-- The unloaded machine puts 7325 N on the front axle and 8371 N on the rear
axle (to within a newton), and the two loads add up to its weight. -/
theorem exampleSideView_axleLoads :
    exampleSideView.frontAxleLoad = 36624 / 5 ∧
      exampleSideView.rearAxleLoad = 41856 / 5 ∧
      exampleSideView.frontAxleLoad + exampleSideView.rearAxleLoad = 15696 := by
  refine ⟨?_, ?_, exampleSideView.axleLoad_add⟩ <;>
    · simp only [SideView.frontAxleLoad, SideView.rearAxleLoad,
        SideView.wheelbase, exampleSideView]
      norm_num

/-- With the payload one metre ahead of the front axle the loader can lift
12556.8 N (about 1280 kg) before the rear wheels lift off; at two metres the
capacity is halved. -/
theorem exampleSideView_capacity :
    exampleSideView.maxPayload 1 = 62784 / 5 ∧
      exampleSideView.maxPayload 2 = 31392 / 5 := by
  constructor <;>
    · simp only [SideView.maxPayload, exampleSideView]
      norm_num

/-- A payload of 10000 N at one metre reach keeps the rear wheels on the
ground; 13000 N at the same reach does not. -/
theorem exampleSideView_payload_check :
    0 ≤ exampleSideView.rearAxleLoadWithPayload 10000 1 ∧
      ¬ (0 ≤ exampleSideView.rearAxleLoadWithPayload 13000 1) := by
  constructor
  · rw [exampleSideView.rear_wheels_grounded_iff (by norm_num : (0:ℝ) < 1)]
    simp only [exampleSideView]
    norm_num
  · rw [exampleSideView.rear_wheels_grounded_iff (by norm_num : (0:ℝ) < 1)]
    simp only [exampleSideView]
    norm_num

/-- With the centre of mass 0.75 m from the downhill wheels (half of the 1.5 m
track) and 0.9 m above the ground, the machine is stable on a 30° side slope
but not on a 45° one. -/
theorem exampleTractor_side_slope :
    overturningMoment 1600 9.81 (9 / 10) (π / 6)
        ≤ restoringMoment 1600 9.81 (3 / 4) (π / 6) ∧
      ¬ (overturningMoment 1600 9.81 (9 / 10) (π / 4)
        ≤ restoringMoment 1600 9.81 (3 / 4) (π / 4)) := by
  constructor
  · rw [stable_on_slope_iff (by norm_num) (by norm_num) (by norm_num)
      (by positivity) (by linarith [pi_pos])]
    rw [tan_pi_div_six]
    rw [div_le_div_iff₀ (by norm_num) (by norm_num)]
    nlinarith [Real.sq_sqrt (by norm_num : (3:ℝ) ≥ 0),
      Real.sqrt_nonneg 3, Real.sqrt_lt_sqrt (by norm_num : (0:ℝ) ≤ 3)
        (by norm_num : (3:ℝ) < 4)]
  · rw [stable_on_slope_iff (by norm_num) (by norm_num) (by norm_num)
      (by positivity) (by linarith [pi_pos])]
    rw [tan_pi_div_four]
    norm_num

/-! ## The loader circuit of the example machine

A lift cylinder of 80 mm bore and 40 mm rod diameter (radii 0.04 m and 0.02 m)
with a 0.6 m stroke, working at a relief setting of 140 bar (1.4·10⁷ Pa), fed
with the full pump flow of 1.35·10⁻³ m³/s (30 cc/rev at 3000 rpm and 90 %
volumetric efficiency).  The cylinder acts on the loader arm 0.35 m from the
pivot and the load hangs 1.4 m from it. -/

/-- A loader lift cylinder of the example machine. -/
def exampleCylinder : Cylinder where
  bore := 1 / 25
  rod := 1 / 50
  stroke := 3 / 5
  rod_pos := by norm_num
  rod_lt_bore := by norm_num
  stroke_pos := by norm_num

/-- The loader arm geometry: a four-to-one reduction. -/
def exampleArm : LoaderArm where
  cylArm := 7 / 20
  loadArm := 7 / 5
  cylArm_pos := by norm_num
  loadArm_pos := by norm_num

/-- Piston areas of the example cylinder: `π/625 ≈ 50.3 cm²` on the cap side
and three quarters of that on the rod side. -/
theorem exampleCylinder_areas :
    exampleCylinder.capArea = π / 625 ∧
      exampleCylinder.rodArea = 3 * π / 2500 ∧
      exampleCylinder.capArea = 4 / 3 * exampleCylinder.rodArea := by
  refine ⟨?_, ?_, ?_⟩ <;>
    · simp only [Cylinder.capArea, Cylinder.rodArea, exampleCylinder]
      ring

/-- At 140 bar the cylinder pushes with `22400 π ≈ 70.4 kN` and pulls with
three quarters of that. -/
theorem exampleCylinder_forces :
    exampleCylinder.extendForce 14000000 = 22400 * π ∧
      exampleCylinder.retractForce 14000000 = 16800 * π ∧
      70000 < exampleCylinder.extendForce 14000000 ∧
      exampleCylinder.extendForce 14000000 < 70400 := by
  have h1 : exampleCylinder.extendForce 14000000 = 22400 * π := by
    simp only [Cylinder.extendForce, Cylinder.capArea, exampleCylinder]; ring
  have h2 : exampleCylinder.retractForce 14000000 = 16800 * π := by
    simp only [Cylinder.retractForce, Cylinder.rodArea, exampleCylinder]; ring
  refine ⟨h1, h2, ?_, ?_⟩ <;> rw [h1]
  · nlinarith [pi_gt_d6]
  · nlinarith [pi_lt_d6]

/-- With the full pump flow the cylinder extends in `32π/45 ≈ 2.23 s` and
retracts in three quarters of that time, about 1.68 s. -/
theorem exampleCylinder_times :
    exampleCylinder.extendTime (27 / 20000) = 32 * π / 45 ∧
      exampleCylinder.retractTime (27 / 20000) = 8 * π / 15 ∧
      exampleCylinder.retractTime (27 / 20000)
        < exampleCylinder.extendTime (27 / 20000) := by
  refine ⟨?_, ?_, exampleCylinder.retractTime_lt_extendTime (by norm_num)⟩ <;>
    · simp only [Cylinder.extendTime, Cylinder.retractTime,
        Cylinder.extendVolume, Cylinder.retractVolume, Cylinder.capArea,
        Cylinder.rodArea, exampleCylinder]
      ring

/-- **The loader is stability limited, not power limited.**  Two lift cylinders
at 140 bar could exert `11200 π ≈ 35.2 kN` at the bucket, far more than the
12 556.8 N at which the rear wheels of the example machine lift off; so the
usable capacity is the tipping limit. -/
theorem exampleLoader_capacity_is_stability_limited :
    exampleArm.liftForce (exampleCylinder.extendForce 14000000) = 5600 * π ∧
      exampleSideView.maxPayload 1
        < 2 * exampleArm.liftForce (exampleCylinder.extendForce 14000000) := by
  have h : exampleArm.liftForce (exampleCylinder.extendForce 14000000)
      = 5600 * π := by
    simp only [LoaderArm.liftForce, Cylinder.extendForce, Cylinder.capArea,
      exampleArm, exampleCylinder]
    ring
  refine ⟨h, ?_⟩
  rw [h]
  simp only [SideView.maxPayload, exampleSideView]
  nlinarith [pi_gt_d6]

/-! ## Traction of the example machine

On firm ground (`μ = 0.7`) with the whole 15 696 N of the machine on its four
driven wheels. -/

/-- Each side of the drive train develops `15750/π ≈ 5013 N` at 140 bar, so the
machine as a whole pushes with `31500/π ≈ 10 kN`. -/
theorem exampleDrive_sideForce :
    exampleDrive.sideForce 14000000 = 15750 / π := by
  have hpi := pi_pos.ne'
  rw [Drive.sideForce_eq]
  simp only [exampleDrive, exampleMotor]
  field_simp
  ring

/-- **The example machine is power limited, not traction limited**: on firm
ground its wheels do not spin, because the 10 kN the hydraulics can push is
less than the 10 987 N the ground can take. -/
theorem exampleTractor_not_traction_limited :
    2 * exampleDrive.sideForce 14000000 < frictionLimit (7 / 10) 15696 ∧
      drawbarPull (7 / 10) 15696 (2 * exampleDrive.sideForce 14000000)
        = 2 * exampleDrive.sideForce 14000000 := by
  have hpi := pi_pos
  have h : 2 * exampleDrive.sideForce 14000000 < frictionLimit (7 / 10) 15696 := by
    rw [exampleDrive_sideForce, frictionLimit]
    rw [show (2:ℝ) * (15750 / π) = 31500 / π by ring, div_lt_iff₀ hpi]
    nlinarith [pi_gt_d6]
  exact ⟨h, drawbarPull_eq_drive h.le⟩

/-- On firm ground the machine climbs a 30° grade without slipping (it needs
`tan 30° ≈ 0.577 ≤ 0.7`), but not a 45° one. -/
theorem exampleTractor_gradeability :
    gradeResistance 15696 (π / 6)
        ≤ frictionLimit (7 / 10) (slopeNormalLoad 15696 (π / 6)) ∧
      ¬ (gradeResistance 15696 (π / 4)
        ≤ frictionLimit (7 / 10) (slopeNormalLoad 15696 (π / 4))) := by
  constructor
  · rw [climb_no_slip_iff (by norm_num) (by positivity) (by linarith [pi_pos]),
      tan_pi_div_six, div_le_iff₀ (by positivity)]
    nlinarith [Real.sq_sqrt (by norm_num : (3:ℝ) ≥ 0), Real.sqrt_nonneg 3,
      Real.sqrt_lt_sqrt (by norm_num : (0:ℝ) ≤ 3) (by norm_num : (3:ℝ) < 4)]
  · rw [climb_no_slip_iff (by norm_num) (by positivity) (by linarith [pi_pos]),
      tan_pi_div_four]
    norm_num

/-- **The example machine can spin on the spot on firm ground.**  With a 1.2 m
wheelbase and a 1.5 m track it needs a force difference of 8789.76 N between
its two sides to overcome the scrub of the four wheels, and running one circuit
backwards makes `31500/π ≈ 10 kN` available. -/
theorem exampleTractor_can_spin :
    skidResistingMoment (7 / 10) 15696 (6 / 5)
      ≤ steerMoment (-exampleDrive.sideForce 14000000)
          (exampleDrive.sideForce 14000000) (3 / 2) := by
  rw [can_skid_steer_iff (by norm_num : (0:ℝ) < 3 / 2), exampleDrive_sideForce]
  have hpi := pi_pos
  rw [show (15750:ℝ) / π - -(15750 / π) = 31500 / π by ring, le_div_iff₀ hpi]
  nlinarith [pi_lt_d6]

/-! ## Longitudinal dynamics of the example machine

Gravity `g = 9.81 m/s²`, centre of mass 0.9 m above the ground, ground friction
coefficient `μ = 0.7`. -/

/-- **The example machine slips before it wheelies.**  Its front axle would
only lift at `g · 0.7 / 0.9 ≈ 7.63 m/s²`, but on ground with `μ = 0.7` it can
never accelerate faster than `μ g ≈ 6.87 m/s²`; so whatever the ground allows,
the front wheels stay down. -/
theorem exampleTractor_no_wheelie {a : ℝ}
    (h : (exampleSideView.weight / (981 / 100)) * a
      ≤ frictionLimit (7 / 10) exampleSideView.weight) :
    0 ≤ exampleSideView.frontAxleLoadAccel (981 / 100) (9 / 10) a := by
  refine exampleSideView.no_wheelie_of_friction_small (by norm_num) (by norm_num)
    ?_ h
  simp only [exampleSideView]
  norm_num

/-- Braking from full speed (`1.026 π ≈ 3.22 m/s`) on ground with `μ = 0.7`,
the machine stops in about 0.76 m. -/
theorem exampleTractor_stopping_distance :
    0.75 < stoppingDistance (513 / 500 * π) (7 / 10 * (981 / 100)) ∧
      stoppingDistance (513 / 500 * π) (7 / 10 * (981 / 100)) < 0.76 := by
  have hrw : stoppingDistance (513 / 500 * π) (7 / 10 * (981 / 100))
      = (513 / 500 * π) ^ 2 / (6867 / 500) := by
    unfold stoppingDistance
    norm_num
  rw [hrw]
  constructor
  · rw [lt_div_iff₀ (by norm_num)]
    nlinarith [pi_gt_d6, pi_pos]
  · rw [div_lt_iff₀ (by norm_num)]
    nlinarith [pi_lt_d6, pi_pos]

end

end LifeTrac
