import RequestProject.Gvcs.Hydraulic.Operating

/-!
# From the circuit to the ground: the actuators of the whole model

The network model of `Hydraulic.Machine` accounts for the power that reaches
each actuator; this file says what the actuators do with it, and closes the
chain that runs

```
engine shaft → pump → hose → valve → motors / cylinders → wheels and loader.
```

* `Machine.tractivePower_eq`: the mechanical power at the ground contacts of
  one side is the hydraulic power into its motors, scaled by the volumetric
  and mechanical efficiencies of those motors — the displacements, the number
  of motors and the wheel radius all cancel.
* `Machine.liftMechPower_eq`: the loader cylinders, taken as ideal, put out
  exactly the branch power `liftPower`.
* `Machine.mechOutput_le_usefulPower`, `Machine.mechOutput_le_pumpPower` and
  `Machine.mechOutput_le_shaftPower`: everything the machine does — pushing at
  the wheels, lifting at the loader — is bounded by the power the engine puts
  into the pump, the shortfall being exactly the motor losses plus the
  circuit losses computed in `Hydraulic.Machine`.
* Lift kinematics under a command, and worked numbers for the machine
  `lifeTrac0`.
-/

namespace LifeTrac.Hydraulic

open Real

noncomputable section

namespace Machine

variable (m : Machine)

/-! ## The wheel motors -/

/-- Mechanical power at the ground contacts of one side of the machine, as a
function of the pressure across its wheel motors and the flow into them. -/
def tractivePower (dp Q : ℝ) : ℝ := m.drive.sideForce dp * m.sideSpeed Q

/-- **Force times speed at the ground.**  The tractive power of a side is the
hydraulic power delivered to that side's motors, less only their volumetric and
mechanical losses. -/
theorem tractivePower_eq (dp Q : ℝ) :
    m.tractivePower dp Q
      = hydPower dp Q * (m.drive.motor.volEff * m.drive.motor.mechEff) := by
  have h1 : (m.drive.count : ℝ) ≠ 0 := by
    have : (0:ℝ) < m.drive.count := by exact_mod_cast m.drive.count_pos
    exact this.ne'
  have h2 := m.drive.motor.disp_pos.ne'
  have h3 := m.drive.wheelRadius_pos.ne'
  have h4 := pi_pos.ne'
  rw [tractivePower, Drive.sideForce_eq, sideSpeed_eq, speedGain, hydPower]
  field_simp

/-- **The wheels cannot give back more than the oil brings them.** -/
theorem tractivePower_le_hydPower {dp Q : ℝ} (hp : 0 ≤ dp) (hQ : 0 ≤ Q) :
    m.tractivePower dp Q ≤ hydPower dp Q := by
  have he : m.drive.motor.volEff * m.drive.motor.mechEff ≤ 1 :=
    mul_le_one₀ m.drive.motor.volEff_le_one m.drive.motor.mechEff_pos.le
      m.drive.motor.mechEff_le_one
  have hPQ : 0 ≤ hydPower dp Q := mul_nonneg hp hQ
  rw [tractivePower_eq]
  nlinarith

/-! ## The loader cylinders -/

/-- Speed at which the lift cylinders extend under flow `Q`. -/
def liftSpeed (Q : ℝ) : ℝ := m.liftCyl.extendSpeed Q

/-- Mechanical power out of the lift cylinders: rod force times rod speed. -/
def liftMechPower (dp Q : ℝ) : ℝ := m.liftCyl.extendForce dp * m.liftSpeed Q

/-- An ideal cylinder passes its branch power straight through. -/
theorem liftMechPower_eq (dp Q : ℝ) : m.liftMechPower dp Q = hydPower dp Q :=
  m.liftCyl.extend_power dp Q

/-! ## What the whole machine puts out -/

/-- The mechanical power the machine delivers in a given state of its circuit:
at the two sets of wheels, and at the loader rods. -/
def mechOutput (p : Pressures) (f : Flows) : ℝ :=
  m.tractivePower (p.leftIn - p.tank) f.left
    + m.tractivePower (p.rightIn - p.tank) f.right
    + m.liftMechPower (p.liftIn - p.tank) f.lift

/-- **The machine's mechanical output is bounded by the power reaching the
actuators**, the difference being the losses inside the wheel motors. -/
theorem mechOutput_le_usefulPower {p : Pressures} {f : Flows}
    (hs : Feasible p f) : m.mechOutput p f ≤ usefulPower p f := by
  have hL := m.tractivePower_le_hydPower (dp := p.leftIn - p.tank) (Q := f.left)
    (by have := hs.tank_le_leftIn; linarith) hs.left_nonneg
  have hR := m.tractivePower_le_hydPower (dp := p.rightIn - p.tank) (Q := f.right)
    (by have := hs.tank_le_rightIn; linarith) hs.right_nonneg
  have hLift := m.liftMechPower_eq (p.liftIn - p.tank) f.lift
  simp only [mechOutput, usefulPower, leftDrivePower, rightDrivePower,
    liftPower, hydPower] at *
  linarith

/-- **Nothing comes out of the machine that the pump did not put in.** -/
theorem mechOutput_le_pumpPower {p : Pressures} {f : Flows} (hs : Feasible p f) :
    m.mechOutput p f ≤ pumpPower p f :=
  le_trans (m.mechOutput_le_usefulPower hs) (usefulPower_le_pumpPower hs)

/-- **The whole hydraulic model in one inequality.**  Whatever the operator
does, the mechanical power the machine delivers at its wheels and its loader is
at most the power the engine puts into the pump shaft: every step of the chain
— pump slip, hose friction, valve throttling, relief dumping, motor losses —
can only take power out. -/
theorem mechOutput_le_shaftPower (pu : Pump) (k : ℝ) {p : Pressures} {f : Flows}
    (hs : Feasible p f) (hflow : f.pumpFlow = pu.flow k) (hk : 0 ≤ k) :
    m.mechOutput p f ≤ pu.shaftPower (p.pumpOut - p.tank) k :=
  le_trans (m.mechOutput_le_pumpPower hs)
    (pumpPower_le_shaftPower pu k hs hflow hk)

/-- The same, for the machine as operated: engine speed `n`, command `cmd`,
loads `loadL`, `loadR`, `loadLift`. -/
theorem operating_mechOutput_le_shaftPower (n : ℝ) (cmd : Command) (hn : 0 ≤ n)
    {loadL loadR loadLift : ℝ} (hL : 0 ≤ loadL) (hR : 0 ≤ loadR)
    (hLift : 0 ≤ loadLift) :
    m.mechOutput (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd)
      ≤ m.pump.shaftPower
          ((m.pressures n cmd loadL loadR loadLift).pumpOut
            - (m.pressures n cmd loadL loadR loadLift).tank) n :=
  m.mechOutput_le_shaftPower m.pump n (m.feasible hn hL hR hLift)
    (m.pumpFlow_eq n cmd) hn

/-! ## Lift kinematics under a command -/

/-- Rod speed of the loader at engine speed `n` under command `cmd`. -/
def commandedLiftSpeed (n : ℝ) (cmd : Command) : ℝ :=
  m.liftSpeed ((m.flows n cmd).lift)

/-- Time to run the loader through its full stroke at engine speed `n` under
command `cmd`. -/
def liftTime (n : ℝ) (cmd : Command) : ℝ :=
  m.liftCyl.stroke / m.commandedLiftSpeed n cmd

/-- The loader rises at a speed proportional to the share of the flow it is
given. -/
theorem commandedLiftSpeed_eq (n : ℝ) (cmd : Command) :
    m.commandedLiftSpeed n cmd
      = cmd.lift * m.pump.flow n / m.liftCyl.capArea := by
  simp only [commandedLiftSpeed, liftSpeed, Cylinder.extendSpeed, flows]

end Machine

/-! ## The worked machine -/

/-- All the flow to the loader. -/
def fullLift : Command where
  left := 0
  right := 0
  lift := 1
  left_nonneg := by norm_num
  right_nonneg := by norm_num
  lift_nonneg := by norm_num
  sum_le_one := by norm_num

/-- With the whole 2.7 l/s to the loader, the rods extend at `1.6875/π ≈ 0.54`
metres per second. -/
theorem lifeTrac0_liftSpeed :
    lifeTrac0.commandedLiftSpeed 50 fullLift = 1.6875 / π := by
  have hpi := pi_ne_zero
  rw [Machine.commandedLiftSpeed_eq]
  simp only [lifeTrac0, bigPump, fullLift, Pump.flow, exampleCylinder,
    Cylinder.capArea]
  field_simp
  ring

/-- So the 0.6 m stroke takes about 1.1 seconds. -/
theorem lifeTrac0_liftTime :
    lifeTrac0.liftTime 50 fullLift = 0.6 * π / 1.6875 ∧
      lifeTrac0.liftTime 50 fullLift < 6 / 5 := by
  have hpi := pi_ne_zero
  have h : lifeTrac0.liftTime 50 fullLift = 0.6 * π / 1.6875 := by
    rw [Machine.liftTime, lifeTrac0_liftSpeed]
    simp only [lifeTrac0, exampleCylinder]
    field_simp
    ring
  refine ⟨h, ?_⟩
  rw [h, div_lt_iff₀ (by norm_num : (0:ℝ) < 1.6875)]
  nlinarith [pi_lt_d6]

end

end LifeTrac.Hydraulic
