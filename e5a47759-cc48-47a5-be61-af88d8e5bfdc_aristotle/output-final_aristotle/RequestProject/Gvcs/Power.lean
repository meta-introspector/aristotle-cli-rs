import RequestProject.Gvcs.Cylinder
import RequestProject.Gvcs.Traction

/-!
# The power budget of the LifeTrac tractor

Everything the machine does — driving, lifting, pushing — is paid for by the
engine through the pump.  This file assembles the power accounting of the whole
hydrostatic chain:

```
engine shaft  --(pump)-->  hydraulic power Δp·Q  --(motors, cylinders)-->  work
```

We prove that each conversion loses (never creates) power, that the tractive
power at the ground is the hydraulic power scaled by the motor efficiencies,
and the resulting speed/force trade-off: with the pump speed and the relief
pressure fixed, the product of ground speed and tractive force is bounded, so
gearing down for pull costs speed exactly proportionally.
-/

namespace LifeTrac

open Real

noncomputable section

namespace Pump

variable (p : Pump)

/-- Mechanical power that must be supplied at the pump shaft to sustain a
pressure difference `Δp` at `n` revolutions per unit time: the full swept
volume has to be pressurised, including the fraction that leaks back. -/
def shaftPower (Δp n : ℝ) : ℝ := Δp * p.disp * n

/-- Torque the engine must supply to the pump. -/
def shaftTorque (Δp : ℝ) : ℝ := Δp * p.disp / (2 * π)

/-- Shaft power is torque times angular velocity. -/
theorem shaftPower_eq_torque_mul_angSpeed (Δp n : ℝ) :
    p.shaftPower Δp n = p.shaftTorque Δp * (2 * π * n) := by
  have := pi_pos.ne'
  unfold shaftPower shaftTorque
  field_simp

/-- **The pump loses power.**  The hydraulic power it delivers never exceeds
the mechanical power taken from the engine. -/
theorem hydPower_le_shaftPower {Δp n : ℝ} (hp : 0 ≤ Δp) (hn : 0 ≤ n) :
    hydPower Δp (p.flow n) ≤ p.shaftPower Δp n := by
  have hd := p.disp_pos
  have h1 := p.volEff_le_one
  have h2 := p.volEff_pos
  unfold hydPower shaftPower Pump.flow
  nlinarith [mul_nonneg (mul_nonneg hp hd.le) hn]

/-- A pump with no internal leakage converts the engine's power into hydraulic
power exactly. -/
theorem hydPower_eq_shaftPower (h : p.volEff = 1) (Δp n : ℝ) :
    hydPower Δp (p.flow n) = p.shaftPower Δp n := by
  unfold hydPower shaftPower Pump.flow
  rw [h]; ring

end Pump

namespace Drive

variable (d : Drive)

/-- Mechanical power delivered at the ground contacts of one side of the
machine: tractive force times ground speed. -/
def tractivePower (Δp n : ℝ) : ℝ := d.sideForce Δp * d.groundSpeed n

/-- The tractive power is the hydraulic power supplied, scaled by the
volumetric and mechanical efficiencies of the wheel motors.  Note that the
displacements, the gear count and the wheel radius all cancel: they trade force
against speed but do not change the power. -/
theorem tractivePower_eq (Δp n : ℝ) :
    d.tractivePower Δp n = hydPower Δp (d.pump.flow n)
      * (d.motor.volEff * d.motor.mechEff) := by
  have h1 : (d.count : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr d.count_pos.ne'
  have h2 := d.motor.disp_pos.ne'
  have h3 := d.wheelRadius_pos.ne'
  have h4 := pi_pos.ne'
  unfold tractivePower hydPower Pump.flow
  rw [sideForce_eq, groundSpeed_eq]
  field_simp

/-- **The drive train loses power.**  The mechanical power at the ground never
exceeds the hydraulic power supplied by the pump. -/
theorem tractivePower_le_hydPower {Δp n : ℝ} (hp : 0 ≤ Δp) (hn : 0 ≤ n) :
    d.tractivePower Δp n ≤ hydPower Δp (d.pump.flow n) := by
  have hQ : 0 ≤ d.pump.flow n := d.pump.flow_nonneg hn
  have hPQ : 0 ≤ hydPower Δp (d.pump.flow n) := mul_nonneg hp hQ
  have he : d.motor.volEff * d.motor.mechEff ≤ 1 :=
    mul_le_one₀ d.motor.volEff_le_one d.motor.mechEff_pos.le d.motor.mechEff_le_one
  rw [tractivePower_eq]
  nlinarith

/-- **The complete chain: ground power never exceeds engine power.** -/
theorem tractivePower_le_shaftPower {Δp n : ℝ} (hp : 0 ≤ Δp) (hn : 0 ≤ n) :
    d.tractivePower Δp n ≤ d.pump.shaftPower Δp n :=
  le_trans (d.tractivePower_le_hydPower hp hn) (d.pump.hydPower_le_shaftPower hp hn)

/-- **Speed/force trade-off.**  With the pump turning at `n` and the relief
valve limiting the pressure to `pmax`, the product of tractive force and ground
speed cannot exceed the hydraulic power available at the relief setting: pull
can only be bought with speed. -/
theorem sideForce_mul_groundSpeed_le {Δp pmax n : ℝ} (hp : 0 ≤ Δp)
    (hn : 0 ≤ n) (h : Δp ≤ pmax) :
    d.sideForce Δp * d.groundSpeed n ≤ pmax * d.pump.flow n := by
  have h1 : d.tractivePower Δp n ≤ hydPower Δp (d.pump.flow n) :=
    d.tractivePower_le_hydPower hp hn
  have h2 : hydPower Δp (d.pump.flow n) ≤ pmax * d.pump.flow n :=
    mul_le_mul_of_nonneg_right h (d.pump.flow_nonneg hn)
  exact le_trans h1 h2

/-- Trading force for speed at constant power: changing the wheel radius or the
number of wheel motors scales the tractive force and the ground speed
inversely, leaving their product — the power — unchanged. -/
theorem tractivePower_indep_gearing (d' : Drive) (hp : d.pump = d'.pump)
    (hm : d.motor = d'.motor) (Δp n : ℝ) :
    d.tractivePower Δp n = d'.tractivePower Δp n := by
  rw [tractivePower_eq, tractivePower_eq, hp, hm]

end Drive

/-! ### Sharing the pump between driving and lifting

On a LifeTrac the same pump feeds the wheel motors and the loader cylinders,
so the flow (and hence the power) has to be shared: lifting fast means driving
slowly. -/

/-- Splitting a pump flow `Q` between a drive circuit receiving `Qd` and a
lift circuit receiving `Q - Qd`, the powers add up to the hydraulic power
available. -/
theorem power_split (Δp Q Qd : ℝ) :
    hydPower Δp Qd + hydPower Δp (Q - Qd) = hydPower Δp Q := by
  unfold hydPower; ring

/-- **Lifting competes with driving.**  If the loader cylinder is given the
flow `Qc` out of the pump's `Q`, the rod extends at `Qc / capArea` while the
drive gets only `Q - Qc`; the sum of the lifting power and the hydraulic power
left for the wheels is the total power available. -/
theorem lift_and_drive_power (c : Cylinder) (Δp Q Qc : ℝ) :
    c.extendForce Δp * c.extendSpeed Qc + hydPower Δp (Q - Qc)
      = hydPower Δp Q := by
  rw [c.extend_power, power_split]

end

end LifeTrac
