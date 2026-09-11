import RequestProject.Gvcs.Kinematics

/-!
# The hydraulic drive train of the LifeTrac tractor

LifeTrac is driven hydrostatically: an engine turns a fixed-displacement gear
pump, and the resulting oil flow is routed (through the steering valves) to the
hydraulic wheel motors, two on the left side and two on the right side of the
machine, the motors of one side being fed in parallel.

We model

* a `Pump`, characterised by its displacement (volume of oil per revolution)
  and volumetric efficiency,
* a `Motor`, characterised by its displacement, its volumetric and its
  mechanical efficiency,
* a `Drive`, i.e. one side of the tractor: a pump feeding `n` motors in
  parallel, each turning a wheel of a given radius.

and prove the standard relations of hydrostatic transmission: flow, shaft
speed, output torque, tractive force, the pressure-relief bound on the
available force, and conservation of energy (the mechanical power delivered
never exceeds the hydraulic power supplied, with equality exactly for a
lossless unit).
-/

namespace LifeTrac

open Real

/-- A fixed-displacement hydraulic pump. `disp` is the swept volume per
revolution, `volEff` its volumetric efficiency. -/
structure Pump where
  /-- Displacement: volume of oil delivered per revolution. -/
  disp : ℝ
  /-- Volumetric efficiency. -/
  volEff : ℝ
  disp_pos : 0 < disp
  volEff_pos : 0 < volEff
  volEff_le_one : volEff ≤ 1

/-- A fixed-displacement hydraulic motor. -/
structure Motor where
  /-- Displacement: volume of oil swallowed per revolution. -/
  disp : ℝ
  /-- Volumetric efficiency. -/
  volEff : ℝ
  /-- Mechanical (torque) efficiency. -/
  mechEff : ℝ
  disp_pos : 0 < disp
  volEff_pos : 0 < volEff
  volEff_le_one : volEff ≤ 1
  mechEff_pos : 0 < mechEff
  mechEff_le_one : mechEff ≤ 1

noncomputable section

/-- Flow delivered by a pump running at `n` revolutions per unit time. -/
def Pump.flow (p : Pump) (n : ℝ) : ℝ := p.disp * n * p.volEff

theorem Pump.flow_nonneg (p : Pump) {n : ℝ} (hn : 0 ≤ n) : 0 ≤ p.flow n :=
  mul_nonneg (mul_nonneg p.disp_pos.le hn) p.volEff_pos.le

theorem Pump.flow_mono (p : Pump) {n₁ n₂ : ℝ} (h : n₁ ≤ n₂) :
    p.flow n₁ ≤ p.flow n₂ := by
  simp only [Pump.flow]
  exact mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_left h p.disp_pos.le)
    p.volEff_pos.le

/-- Shaft speed (revolutions per unit time) of a motor fed with flow `Q`. -/
def Motor.speed (m : Motor) (Q : ℝ) : ℝ := Q * m.volEff / m.disp

/-- Angular velocity in radians per unit time of a motor fed with flow `Q`. -/
def Motor.angSpeed (m : Motor) (Q : ℝ) : ℝ := 2 * π * m.speed Q

/-- Output torque of a motor working across a pressure difference `Δp`.
This is the textbook relation `T = Δp · D / (2π)`, corrected by the mechanical
efficiency. -/
def Motor.torque (m : Motor) (Δp : ℝ) : ℝ := Δp * m.disp * m.mechEff / (2 * π)

theorem Motor.speed_mono (m : Motor) {Q₁ Q₂ : ℝ} (h : Q₁ ≤ Q₂) :
    m.speed Q₁ ≤ m.speed Q₂ := by
  have hd := m.disp_pos
  have he := m.volEff_pos
  simp only [Motor.speed]
  gcongr

theorem Motor.torque_mono (m : Motor) {p₁ p₂ : ℝ} (h : p₁ ≤ p₂) :
    m.torque p₁ ≤ m.torque p₂ := by
  have hd := m.disp_pos
  have he := m.mechEff_pos
  have hpi := pi_pos
  simp only [Motor.torque]
  gcongr

/-- Hydraulic power supplied to a unit: pressure difference times flow. -/
def hydPower (Δp Q : ℝ) : ℝ := Δp * Q

/-- Mechanical power delivered at the motor shaft: torque times angular
velocity. -/
def Motor.mechPower (m : Motor) (Δp Q : ℝ) : ℝ := m.torque Δp * m.angSpeed Q

theorem Motor.mechPower_eq (m : Motor) (Δp Q : ℝ) :
    m.mechPower Δp Q = Δp * Q * (m.volEff * m.mechEff) := by
  have hd := m.disp_pos.ne'
  have hpi := pi_pos.ne'
  simp only [Motor.mechPower, Motor.torque, Motor.angSpeed, Motor.speed]
  field_simp

/-- **Conservation of energy for a hydraulic motor.**  The mechanical power
delivered at the shaft never exceeds the hydraulic power supplied. -/
theorem Motor.mechPower_le_hydPower (m : Motor) {Δp Q : ℝ} (hp : 0 ≤ Δp)
    (hQ : 0 ≤ Q) : m.mechPower Δp Q ≤ hydPower Δp Q := by
  rw [m.mechPower_eq, hydPower]
  have h1 : m.volEff * m.mechEff ≤ 1 :=
    mul_le_one₀ m.volEff_le_one m.mechEff_pos.le m.mechEff_le_one
  nlinarith [mul_nonneg hp hQ]

/-- A lossless motor converts hydraulic power into mechanical power exactly. -/
theorem Motor.mechPower_eq_hydPower (m : Motor) (h₁ : m.volEff = 1)
    (h₂ : m.mechEff = 1) (Δp Q : ℝ) : m.mechPower Δp Q = hydPower Δp Q := by
  rw [m.mechPower_eq, hydPower, h₁, h₂]; ring

/-- One driven side of the tractor: a pump feeding `count` identical wheel
motors in parallel, each driving a wheel of radius `wheelRadius`. -/
structure Drive where
  /-- The pump feeding this circuit. -/
  pump : Pump
  /-- The wheel motor type used on this circuit. -/
  motor : Motor
  /-- Number of motors fed in parallel by the pump. -/
  count : ℕ
  /-- Rolling radius of a driven wheel. -/
  wheelRadius : ℝ
  count_pos : 0 < count
  wheelRadius_pos : 0 < wheelRadius

namespace Drive

variable (d : Drive)

/-- Flow reaching a single motor when the pump turns at `n`: the pump flow is
split evenly between the parallel motors. -/
def motorFlow (n : ℝ) : ℝ := d.pump.flow n / d.count

/-- The parallel motor flows add up to the pump flow. -/
theorem motorFlow_sum (n : ℝ) : (d.count : ℝ) * d.motorFlow n = d.pump.flow n := by
  have h : (d.count : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr d.count_pos.ne'
  rw [motorFlow]
  field_simp

/-- Wheel angular velocity (rad per unit time) at pump speed `n`. -/
def wheelAngSpeed (n : ℝ) : ℝ := d.motor.angSpeed (d.motorFlow n)

/-- Ground speed of the wheels of this side at pump speed `n`. -/
def groundSpeed (n : ℝ) : ℝ := d.wheelRadius * d.wheelAngSpeed n

theorem groundSpeed_eq (n : ℝ) :
    d.groundSpeed n = 2 * π * d.wheelRadius * d.pump.disp * d.pump.volEff
      * d.motor.volEff * n / (d.count * d.motor.disp) := by
  have h1 : (d.count : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr d.count_pos.ne'
  have h2 := d.motor.disp_pos.ne'
  simp only [groundSpeed, wheelAngSpeed, motorFlow, Motor.angSpeed, Motor.speed,
    Pump.flow]
  field_simp

/-- Ground speed is proportional to (in particular, monotone in) engine speed. -/
theorem groundSpeed_mono {n₁ n₂ : ℝ} (h : n₁ ≤ n₂) :
    d.groundSpeed n₁ ≤ d.groundSpeed n₂ := by
  have h1 : (0:ℝ) < d.count := by exact_mod_cast d.count_pos
  have h2 := d.motor.disp_pos
  have h3 := d.motor.volEff_pos
  have h4 := d.pump.disp_pos
  have h5 := d.pump.volEff_pos
  have h6 := d.wheelRadius_pos
  have h7 := pi_pos
  rw [groundSpeed_eq, groundSpeed_eq]
  gcongr

/-- Tractive force produced at the ground contact of one wheel of this side
under pressure difference `Δp`. -/
def wheelForce (Δp : ℝ) : ℝ := d.motor.torque Δp / d.wheelRadius

/-- Total tractive force of this side (all its wheels together). -/
def sideForce (Δp : ℝ) : ℝ := d.count * d.wheelForce Δp

theorem sideForce_eq (Δp : ℝ) :
    d.sideForce Δp = d.count * Δp * d.motor.disp * d.motor.mechEff
      / (2 * π * d.wheelRadius) := by
  have h1 := d.wheelRadius_pos.ne'
  have h2 := pi_pos.ne'
  simp only [sideForce, wheelForce, Motor.torque]
  field_simp

/-- **Relief-valve bound.**  If the system pressure is limited to `pmax` by the
relief valve, the tractive force of one side cannot exceed the value obtained
at `pmax`; in particular the machine cannot stall its engine by pushing
harder. -/
theorem sideForce_le_of_pressure_le {Δp pmax : ℝ} (h : Δp ≤ pmax) :
    d.sideForce Δp ≤ d.sideForce pmax := by
  have h1 := d.wheelRadius_pos
  have h2 := pi_pos
  have h3 := d.motor.disp_pos
  have h4 := d.motor.mechEff_pos
  have h5 : (0:ℝ) < d.count := by exact_mod_cast d.count_pos
  rw [sideForce_eq, sideForce_eq]
  gcongr

end Drive

/-! ### Coupling the hydraulics to the kinematics -/

/-- A complete LifeTrac: a chassis with a left and a right hydraulic drive. -/
structure Tractor where
  /-- Chassis geometry. -/
  chassis : Chassis
  /-- Left-hand drive circuit. -/
  left : Drive
  /-- Right-hand drive circuit. -/
  right : Drive

namespace Tractor

variable (T : Tractor)

/-- Forward speed produced by pump speeds `nL`, `nR` of the two circuits. -/
def linVel (nL nR : ℝ) : ℝ :=
  T.chassis.linVel (T.left.groundSpeed nL) (T.right.groundSpeed nR)

/-- Yaw rate produced by pump speeds `nL`, `nR` of the two circuits. -/
def angVel (nL nR : ℝ) : ℝ :=
  T.chassis.angVel (T.left.groundSpeed nL) (T.right.groundSpeed nR)

/-- Feeding the two circuits with identical pumps, motors and wheels at the
same speed drives the tractor straight ahead. -/
theorem angVel_eq_zero_of_symmetric (h : T.left = T.right) (n : ℝ) :
    T.angVel n n = 0 := by
  rw [angVel, Chassis.angVel_eq_zero_iff, h]

/-- Reversing one circuit (running its pump backwards at the same rate) with an
otherwise symmetric machine yields a zero-radius turn on the spot. -/
theorem linVel_eq_zero_of_counterrotating (h : T.left = T.right) (n : ℝ) :
    T.linVel (-n) n = 0 := by
  rw [linVel, Chassis.linVel_eq_zero_iff, h]
  rw [Drive.groundSpeed_eq, Drive.groundSpeed_eq]
  ring

end Tractor

end

end LifeTrac
