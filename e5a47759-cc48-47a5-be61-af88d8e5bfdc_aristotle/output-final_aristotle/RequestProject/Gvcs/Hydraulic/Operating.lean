import RequestProject.Gvcs.Hydraulic.Machine
import RequestProject.Gvcs.Fluids
import RequestProject.Gvcs.Worked

/-!
# Operating the whole hydraulic model

`Hydraulic.Machine` fixes the plumbing and proves what holds of *any* state of
it.  Here the state stops being arbitrary: a machine (pump, wheel motors, lift
cylinders, hose, oil, chassis, relief setting) plus an engine speed, an
operator's command and the loads on the three services determines one flow
vector and one pressure vector, and every quantity of interest is then a
function of those data.

The operator's command is a triple of fractions of the pump's output — how
much of the flow goes to the left drive, to the right drive, and to the loader
— with the balance going over the relief valve.  This is what a
pressure-compensated proportional valve bank does; the pressure each valve then
has to throttle is whatever the difference between the supply gallery and its
actuator happens to be, and that is what the model computes.

Results.

* `Machine.pumpFlow_eq`: the four flows always add up to the pump's delivery.
* `Machine.feasible`: the computed state is a feasible state of the circuit —
  so every theorem of `Hydraulic.Machine` applies to it, in particular the
  power budget and `usefulPower_le_pumpPower`.
* `Machine.supplyLoss_eq`, `Machine.reliefLoss_eq`: the branch losses of the
  network model agree with the component models of `Circuit` and `Valves`
  (Hagen–Poiseuille in the hose, `reliefHeat` over the relief valve).
* `Machine.sideForce_le_relief`: the relief setting bounds the tractive force.
* `Machine.angVel_eq_zero_iff`, `Machine.linVel_le`: steering and the speed
  envelope, driven by the same command.
* A worked machine, `lifeTrac0`, with numbers for flow, road speed, tractive
  force and oil heating.
-/

namespace LifeTrac.Hydraulic

open Real

noncomputable section

/-- A complete LifeTrac hydraulic machine: one pump, two identical drive sides,
the loader cylinders, the pressure hose, the oil, the chassis and the relief
setting. -/
structure Machine where
  /-- The gear pump, driven by the engine. -/
  pump : Pump
  /-- The wheel-motor hardware of one side (both sides are alike). -/
  drive : Drive
  /-- A lift cylinder of the loader. -/
  liftCyl : Cylinder
  /-- The pressure hose from pump to valve bank. -/
  supplyHose : Hose
  /-- The hydraulic oil. -/
  oil : Fluid
  /-- The chassis the drives push. -/
  chassis : Chassis
  /-- Relief valve setting. -/
  reliefSet : ℝ
  reliefSet_pos : 0 < reliefSet

/-- An operator's command: the fraction of the pump's flow sent to each of the
three services.  What is left over goes over the relief valve. -/
structure Command where
  /-- Fraction of the flow to the left-hand drive. -/
  left : ℝ
  /-- Fraction of the flow to the right-hand drive. -/
  right : ℝ
  /-- Fraction of the flow to the loader. -/
  lift : ℝ
  left_nonneg : 0 ≤ left
  right_nonneg : 0 ≤ right
  lift_nonneg : 0 ≤ lift
  sum_le_one : left + right + lift ≤ 1

namespace Machine

variable (m : Machine) (n : ℝ) (cmd : Command)

/-- The flows the machine runs at engine speed `n` under command `cmd`. -/
def flows : Flows where
  left := cmd.left * m.pump.flow n
  right := cmd.right * m.pump.flow n
  lift := cmd.lift * m.pump.flow n
  relief := (1 - (cmd.left + cmd.right + cmd.lift)) * m.pump.flow n

/-- The pump delivers exactly what the services and the relief take. -/
theorem pumpFlow_eq : (m.flows n cmd).pumpFlow = m.pump.flow n := by
  simp only [Flows.pumpFlow, Flows.demand, flows]; ring

/-- What goes down the pressure hose. -/
theorem demand_eq :
    (m.flows n cmd).demand = (cmd.left + cmd.right + cmd.lift) * m.pump.flow n := by
  simp only [Flows.demand, flows]; ring

/-- The pressures the machine settles at, given the pressure each service's
load demands at its actuator.  Tank is the datum; the supply gallery sits at
the highest of the three demands (the service that needs it most has its valve
wide open, the others throttle the difference); the pump outlet sits one
hose-loss above the gallery. -/
def pressures (loadL loadR loadLift : ℝ) : Pressures where
  tank := 0
  pumpOut := max (max loadL loadR) loadLift
    + m.supplyHose.pressureDrop m.oil ((m.flows n cmd).demand)
  manifold := max (max loadL loadR) loadLift
  leftIn := loadL
  rightIn := loadR
  liftIn := loadLift

theorem flow_left_nonneg (hn : 0 ≤ n) : 0 ≤ (m.flows n cmd).left :=
  mul_nonneg cmd.left_nonneg (m.pump.flow_nonneg hn)

theorem flow_right_nonneg (hn : 0 ≤ n) : 0 ≤ (m.flows n cmd).right :=
  mul_nonneg cmd.right_nonneg (m.pump.flow_nonneg hn)

theorem flow_lift_nonneg (hn : 0 ≤ n) : 0 ≤ (m.flows n cmd).lift :=
  mul_nonneg cmd.lift_nonneg (m.pump.flow_nonneg hn)

/-- **The relief valve takes the balance.**  Whatever the operator does not ask
for comes back over the relief, never the other way. -/
theorem flow_relief_nonneg (hn : 0 ≤ n) : 0 ≤ (m.flows n cmd).relief :=
  mul_nonneg (by have := cmd.sum_le_one; linarith) (m.pump.flow_nonneg hn)

theorem demand_nonneg (hn : 0 ≤ n) : 0 ≤ (m.flows n cmd).demand := by
  have h1 := m.flow_left_nonneg n cmd hn
  have h2 := m.flow_right_nonneg n cmd hn
  have h3 := m.flow_lift_nonneg n cmd hn
  simp only [Flows.demand]; linarith

/-- **The computed state is a state of the circuit.**  Under a non-negative
engine speed and non-negative loads, the flows and pressures the model produces
satisfy every sign condition of `Feasible` — so the power budget, the bound
`usefulPower ≤ pumpPower` and the rest of `Hydraulic.Machine` apply to the
machine as operated. -/
theorem feasible {n : ℝ} {cmd : Command} (hn : 0 ≤ n) {loadL loadR loadLift : ℝ} (hL : 0 ≤ loadL)
    (hR : 0 ≤ loadR) (hLift : 0 ≤ loadLift) :
    Feasible (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd) where
  left_nonneg := m.flow_left_nonneg n cmd hn
  right_nonneg := m.flow_right_nonneg n cmd hn
  lift_nonneg := m.flow_lift_nonneg n cmd hn
  relief_nonneg := m.flow_relief_nonneg n cmd hn
  manifold_le_pumpOut := by
    have := m.supplyHose.pressureDrop_nonneg m.oil (m.demand_nonneg n cmd hn)
    simp only [pressures]; linarith
  leftIn_le_manifold := le_trans (le_max_left _ _) (le_max_left _ _)
  rightIn_le_manifold := le_trans (le_max_right _ _) (le_max_left _ _)
  liftIn_le_manifold := le_max_right _ _
  tank_le_leftIn := hL
  tank_le_rightIn := hR
  tank_le_liftIn := hLift

/-! ## The losses of the operated machine are the losses of the components -/

/-- The hose branch of the network loses exactly the Hagen–Poiseuille power of
`Circuit`. -/
theorem supplyLoss_eq (loadL loadR loadLift : ℝ) :
    supplyLoss (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd)
      = hydPower (m.supplyHose.pressureDrop m.oil ((m.flows n cmd).demand))
          ((m.flows n cmd).demand) := by
  simp only [supplyLoss, pressures, hydPower]
  ring

/-- The relief branch of the network wastes exactly the `reliefHeat` of
`Valves`: the whole of the unused flow, dumped at the pump's pressure. -/
theorem reliefLoss_eq (loadL loadR loadLift : ℝ) :
    reliefLoss (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd)
      = reliefHeat ((m.pressures n cmd loadL loadR loadLift).pumpOut)
          ((m.flows n cmd).pumpFlow) ((m.flows n cmd).demand) := by
  simp only [reliefLoss, reliefHeat, pressures, Flows.pumpFlow]
  ring

/-- **The power budget of the operated machine**: the pump's hydraulic output
splits, with nothing left over, into relief heat, hose loss, the three valve
losses and the power delivered to the two drives and the loader. -/
theorem operating_power_budget (loadL loadR loadLift : ℝ) :
    pumpPower (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd)
      = lossPower (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd)
        + usefulPower (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd) :=
  power_budget _ _

/-- **Nothing leaves the machine that the engine did not put in.**  At the
operated state, the power reaching the wheels and the loader is at most the
power the engine puts into the pump shaft. -/
theorem operating_usefulPower_le_shaftPower (hn : 0 ≤ n) {loadL loadR loadLift : ℝ}
    (hL : 0 ≤ loadL) (hR : 0 ≤ loadR) (hLift : 0 ≤ loadLift) :
    usefulPower (m.pressures n cmd loadL loadR loadLift) (m.flows n cmd)
      ≤ m.pump.shaftPower
          ((m.pressures n cmd loadL loadR loadLift).pumpOut
            - (m.pressures n cmd loadL loadR loadLift).tank) n :=
  usefulPower_le_shaftPower m.pump n (m.feasible hn hL hR hLift)
    (m.pumpFlow_eq n cmd) hn

/-! ## What the machine can push -/

/-- **The relief setting bounds the tractive force.**  If the pump outlet is
held at or below the relief setting, neither side can push harder than the
force the relief pressure buys. -/
theorem sideForce_le_relief (hn : 0 ≤ n) {loadL loadR loadLift : ℝ}
    (hrel : (m.pressures n cmd loadL loadR loadLift).pumpOut ≤ m.reliefSet) :
    m.drive.sideForce loadL ≤ m.drive.sideForce m.reliefSet := by
  refine m.drive.sideForce_le_of_pressure_le (le_trans ?_ hrel)
  have h1 : loadL ≤ max (max loadL loadR) loadLift :=
    le_trans (le_max_left _ _) (le_max_left _ _)
  have h2 := m.supplyHose.pressureDrop_nonneg m.oil (m.demand_nonneg n cmd hn)
  simp only [pressures]
  linarith

/-! ## Sizing the valves: the commanded split is realizable

The model asks each service valve to pass a commanded share of the flow while
holding whatever pressure difference the state produces.  A sharp-edged orifice
can do that: this is the opening it needs, and the orifice equation of `Valves`
then returns exactly the commanded flow. -/

/-- The orifice opening a valve needs in order to pass flow `Q` against a
pressure difference `dp`, in a fluid of density `rho`, at discharge coefficient
`cd`. -/
def valveArea (cd rho Q dp : ℝ) : ℝ := Q * √(rho / (2 * dp)) / cd

/-- **The valve can be sized.**  Opened to `valveArea`, an orifice passes
exactly the flow asked of it. -/
theorem orificeFlow_valveArea {cd rho Q dp : ℝ} (hcd : 0 < cd) (hrho : 0 < rho)
    (hdp : 0 < dp) : orificeFlow cd (valveArea cd rho Q dp) rho dp = Q := by
  have h1 : (0:ℝ) ≤ rho / (2 * dp) := by positivity
  have h2 : √(rho / (2 * dp)) * √(2 * dp / rho) = 1 := by
    rw [← Real.sqrt_mul h1]
    rw [show rho / (2 * dp) * (2 * dp / rho) = 1 by field_simp]
    exact Real.sqrt_one
  simp only [orificeFlow, valveArea]
  field_simp
  rw [mul_assoc, h2, mul_one]

/-- A valve opened wider passes the same flow at a smaller loss: the opening
needed falls as the pressure difference available rises. -/
theorem valveArea_antitone {cd rho Q dp₁ dp₂ : ℝ} (hcd : 0 < cd) (hrho : 0 < rho)
    (hQ : 0 ≤ Q) (hdp : 0 < dp₁) (h : dp₁ ≤ dp₂) :
    valveArea cd rho Q dp₂ ≤ valveArea cd rho Q dp₁ := by
  have hdp2 : 0 < dp₂ := lt_of_lt_of_le hdp h
  have hle : rho / (2 * dp₂) ≤ rho / (2 * dp₁) := by
    apply div_le_div_of_nonneg_left hrho.le (by positivity)
    linarith
  have := Real.sqrt_le_sqrt hle
  unfold valveArea
  gcongr

/-! ## Steering: one command, two speeds -/

/-- Ground speed of a side of the machine fed with flow `Q`. -/
def sideSpeed (Q : ℝ) : ℝ :=
  m.drive.wheelRadius * m.drive.motor.angSpeed (Q / m.drive.count)

/-- The gain from flow to road speed. -/
def speedGain : ℝ :=
  2 * π * m.drive.wheelRadius * m.drive.motor.volEff
    / (m.drive.count * m.drive.motor.disp)

theorem speedGain_pos : 0 < m.speedGain := by
  have h1 : (0:ℝ) < m.drive.count := by exact_mod_cast m.drive.count_pos
  have := m.drive.wheelRadius_pos
  have := m.drive.motor.volEff_pos
  have := m.drive.motor.disp_pos
  have := pi_pos
  unfold speedGain
  positivity

theorem sideSpeed_eq (Q : ℝ) : m.sideSpeed Q = m.speedGain * Q := by
  have h1 : (m.drive.count : ℝ) ≠ 0 := by
    have : (0:ℝ) < m.drive.count := by exact_mod_cast m.drive.count_pos
    exact this.ne'
  have h2 := m.drive.motor.disp_pos.ne'
  simp only [sideSpeed, speedGain, Motor.angSpeed, Motor.speed]
  field_simp

/-- The flow-fed side speed agrees with the engine-fed `Drive.groundSpeed` of
`Hydraulics` when the flow is the one that drive's pump delivers. -/
theorem sideSpeed_pump (k : ℝ) :
    m.sideSpeed (m.drive.pump.flow k) = m.drive.groundSpeed k := rfl

/-- Forward speed of the machine under a command. -/
def linVel : ℝ :=
  m.chassis.linVel (m.sideSpeed ((m.flows n cmd).left))
    (m.sideSpeed ((m.flows n cmd).right))

/-- Yaw rate of the machine under a command. -/
def angVel : ℝ :=
  m.chassis.angVel (m.sideSpeed ((m.flows n cmd).left))
    (m.sideSpeed ((m.flows n cmd).right))

/-- **Straight ahead exactly when the two sides are commanded alike.**  With
the pump actually turning, the machine goes straight iff the operator asks for
the same fraction of the flow on both sides. -/
theorem angVel_eq_zero_iff (hn : 0 < n) :
    m.angVel n cmd = 0 ↔ cmd.left = cmd.right := by
  have hQ : 0 < m.pump.flow n :=
    mul_pos (mul_pos m.pump.disp_pos hn) m.pump.volEff_pos
  have hg := m.speedGain_pos
  rw [angVel, Chassis.angVel_eq_zero_iff, sideSpeed_eq, sideSpeed_eq]
  simp only [flows]
  constructor
  · intro h
    have : (cmd.left - cmd.right) * (m.speedGain * m.pump.flow n) = 0 := by
      nlinarith [h]
    rcases mul_eq_zero.mp this with h' | h'
    · linarith
    · exact absurd h' (by positivity)
  · intro h; rw [h]

/-- **The speed envelope.**  However the flow is shared, the forward speed is
at most what the whole pump output would give to one side, and the machine
cannot exceed that by any combination of commands. -/
theorem linVel_le (hn : 0 ≤ n) :
    m.linVel n cmd ≤ m.speedGain * m.pump.flow n := by
  have hQ : 0 ≤ m.pump.flow n := m.pump.flow_nonneg hn
  have hg := m.speedGain_pos
  have hsum := cmd.sum_le_one
  have h3 := cmd.lift_nonneg
  have hlr : cmd.left + cmd.right ≤ 1 := by linarith
  rw [linVel, Chassis.linVel, sideSpeed_eq, sideSpeed_eq]
  simp only [flows]
  nlinarith [mul_nonneg hg.le hQ]

end Machine

/-! ## A worked machine

A 60 cc/rev gear pump at 3000 rpm (50 rev/s), 90 % volumetrically efficient,
feeding four 375 cc/rev wheel motors on 0.3 m wheels, over a 1.5 m track, with
the relief set at 140 bar.  Split evenly, each side gets what the single-side
pump of `Worked` delivers. -/

/-- The pump of the worked machine: 60 cc per revolution. -/
def bigPump : Pump where
  disp := 6 / 100000
  volEff := 9 / 10
  disp_pos := by norm_num
  volEff_pos := by norm_num
  volEff_le_one := by norm_num

/-- The worked machine. -/
def lifeTrac0 : Machine where
  pump := bigPump
  drive := exampleDrive
  liftCyl := exampleCylinder
  supplyHose := exampleHose
  oil := Fluids.mineralISO46
  chassis := exampleChassis
  reliefSet := 14000000
  reliefSet_pos := by norm_num

/-- Half the flow to each side, nothing to the loader. -/
def straightAhead : Command where
  left := 1 / 2
  right := 1 / 2
  lift := 0
  left_nonneg := by norm_num
  right_nonneg := by norm_num
  lift_nonneg := by norm_num
  sum_le_one := by norm_num

/-- At 3000 rpm the pump delivers 2.7 litres per second (162 litres per
minute). -/
theorem lifeTrac0_pumpFlow :
    (lifeTrac0.flows 50 straightAhead).pumpFlow = 27 / 10000 := by
  rw [Machine.pumpFlow_eq]
  simp only [lifeTrac0, bigPump, Pump.flow]
  norm_num

/-- Driving straight, each side receives exactly the flow of the single-side
pump of `Worked`. -/
theorem lifeTrac0_side_flow :
    (lifeTrac0.flows 50 straightAhead).left = examplePump.flow 50 := by
  simp only [Machine.flows, straightAhead, lifeTrac0, bigPump, examplePump,
    Pump.flow]
  norm_num

/-- Road speed driving straight at 3000 rpm: `1.026 π ≈ 3.22 m/s`, i.e. about
11.6 km/h. -/
theorem lifeTrac0_linVel :
    lifeTrac0.linVel 50 straightAhead = 513 / 500 * π := by
  have h1 : (lifeTrac0.flows 50 straightAhead).left = 27 / 20000 := by
    simp only [Machine.flows, straightAhead, lifeTrac0, bigPump, Pump.flow]
    norm_num
  have h2 : (lifeTrac0.flows 50 straightAhead).right = 27 / 20000 := by
    simp only [Machine.flows, straightAhead, lifeTrac0, bigPump, Pump.flow]
    norm_num
  rw [Machine.linVel, h1, h2, Machine.sideSpeed_eq, Chassis.linVel,
    Machine.speedGain]
  simp only [lifeTrac0, exampleDrive, exampleMotor]
  norm_num
  ring

/-- Numerically: the machine tops out at a little over 3.2 m/s. -/
theorem lifeTrac0_linVel_bounds :
    3 < lifeTrac0.linVel 50 straightAhead ∧
      lifeTrac0.linVel 50 straightAhead < 33 / 10 := by
  rw [lifeTrac0_linVel]
  constructor
  · nlinarith [pi_gt_d6]
  · nlinarith [pi_lt_d6]

/-- Driving straight is straight: the yaw rate vanishes. -/
theorem lifeTrac0_straight : lifeTrac0.angVel 50 straightAhead = 0 :=
  (lifeTrac0.angVel_eq_zero_iff 50 straightAhead (by norm_num)).2 rfl

/-- With the relief set at 140 bar, one side of the machine can push at most
`15750/π ≈ 5013 N`, so the machine at most about 10 kN. -/
theorem lifeTrac0_sideForce_relief :
    lifeTrac0.drive.sideForce lifeTrac0.reliefSet = 15750 / π := by
  have hpi := pi_ne_zero
  rw [Drive.sideForce_eq]
  simp only [lifeTrac0, exampleDrive, exampleMotor]
  field_simp
  ring

/-! ### A complete worked state

Driving straight at 3000 rpm with both sets of wheel motors seeing 100 bar and
the loader idle. -/

/-- Pressure lost in three metres of 20 mm hose at 2.7 l/s of ISO 46:
`259200/π ≈ 0.83 bar`. -/
theorem lifeTrac0_hoseDrop :
    lifeTrac0.supplyHose.pressureDrop lifeTrac0.oil
        ((lifeTrac0.flows 50 straightAhead).demand) = 259200 / π ∧
      lifeTrac0.supplyHose.pressureDrop lifeTrac0.oil
        ((lifeTrac0.flows 50 straightAhead).demand) < 100000 := by
  have hpi := pi_ne_zero
  have hd : (lifeTrac0.flows 50 straightAhead).demand = 27 / 10000 := by
    rw [Machine.demand_eq]
    simp only [lifeTrac0, bigPump, straightAhead, Pump.flow]
    norm_num
  have h : lifeTrac0.supplyHose.pressureDrop lifeTrac0.oil
      ((lifeTrac0.flows 50 straightAhead).demand) = 259200 / π := by
    rw [hd]
    simp only [Hose.pressureDrop, lifeTrac0, exampleHose, Fluids.mineralISO46]
    field_simp
    ring
  refine ⟨h, ?_⟩
  rw [h, div_lt_iff₀ pi_pos]
  nlinarith [pi_gt_d6]

/-- So the hose wastes `699.84/π ≈ 223 W` as heat, whatever the loads. -/
theorem lifeTrac0_supplyLoss (loadL loadR loadLift : ℝ) :
    supplyLoss (lifeTrac0.pressures 50 straightAhead loadL loadR loadLift)
        (lifeTrac0.flows 50 straightAhead) = 69984 / (100 * π) := by
  have hpi := pi_ne_zero
  have hd : (lifeTrac0.flows 50 straightAhead).demand = 27 / 10000 := by
    rw [Machine.demand_eq]
    simp only [lifeTrac0, bigPump, straightAhead, Pump.flow]
    norm_num
  rw [supplyLoss]
  simp only [Machine.pressures]
  rw [lifeTrac0_hoseDrop.1, hd]
  field_simp
  ring

/-- With both sides at 100 bar the wheel motors receive 27 kW between them. -/
theorem lifeTrac0_usefulPower :
    usefulPower (lifeTrac0.pressures 50 straightAhead 10000000 10000000 0)
      (lifeTrac0.flows 50 straightAhead) = 27000 := by
  simp only [usefulPower, leftDrivePower, rightDrivePower, liftPower,
    Machine.pressures, Machine.flows, lifeTrac0, bigPump, straightAhead,
    Pump.flow]
  norm_num

/-- **The worked machine, end to end.**  At that state the pump is putting
`27000 + 699.84/π ≈ 27.2 kW` into the oil, of which all but the hose loss
reaches the wheels: the circuit is better than 99 % efficient when the whole
flow is being used, the losses that matter being the ones that appear when it
is not. -/
theorem lifeTrac0_pumpPower :
    pumpPower (lifeTrac0.pressures 50 straightAhead 10000000 10000000 0)
        (lifeTrac0.flows 50 straightAhead) = 27000 + 69984 / (100 * π) ∧
      usefulPower (lifeTrac0.pressures 50 straightAhead 10000000 10000000 0)
          (lifeTrac0.flows 50 straightAhead)
        ≤ pumpPower (lifeTrac0.pressures 50 straightAhead 10000000 10000000 0)
          (lifeTrac0.flows 50 straightAhead) := by
  have hbudget := power_budget
    (lifeTrac0.pressures 50 straightAhead 10000000 10000000 0)
    (lifeTrac0.flows 50 straightAhead)
  have hfeas := lifeTrac0.feasible (n := 50) (cmd := straightAhead) (by norm_num)
    (by norm_num : (0:ℝ) ≤ 10000000) (by norm_num : (0:ℝ) ≤ 10000000)
    (by norm_num : (0:ℝ) ≤ (0:ℝ))
  refine ⟨?_, usefulPower_le_pumpPower hfeas⟩
  have hloss : lossPower (lifeTrac0.pressures 50 straightAhead 10000000 10000000 0)
      (lifeTrac0.flows 50 straightAhead) = 69984 / (100 * π) := by
    have hs := lifeTrac0_supplyLoss 10000000 10000000 0
    simp only [lossPower, reliefLoss, leftValveLoss, rightValveLoss,
      liftValveLoss, Machine.pressures, Machine.flows, lifeTrac0, bigPump,
      straightAhead, Pump.flow] at hs ⊢
    norm_num at hs ⊢
    linarith [hs]
  rw [hbudget, hloss, lifeTrac0_usefulPower]
  ring

end

end LifeTrac.Hydraulic
