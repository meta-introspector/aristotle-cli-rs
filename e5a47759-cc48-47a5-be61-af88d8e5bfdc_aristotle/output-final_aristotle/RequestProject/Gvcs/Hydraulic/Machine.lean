import RequestProject.Gvcs.Hydraulic.Network
import RequestProject.Gvcs.Power

/-!
# The whole hydraulic circuit of LifeTrac

`Hydraulic.Network` gives the general laws of a hydraulic network; the other
files give the components one at a time.  Here the machine is plumbed
together: one circuit containing every component, and every quantity of the
machine read off from a single flow vector and a single pressure vector.

The circuit has six junctions,

```
tank ──pump──▶ pumpOut ──supply hose──▶ manifold ──▶ leftIn / rightIn / liftIn
  ▲               │                                       │
  └────relief ────┘                                       │
  └──────────── return from the actuators ────────────────┘
```

and nine components: the pump, the relief valve, the supply hose, and — for
each of the three services (left drive, right drive, loader lift) — its
directional/proportional valve and the actuator it feeds.  The two wheel
motors of a side are the single branch `leftMotors` (resp. `rightMotors`),
matching the `Drive` model, in which the motors of one side run in parallel.

What is proved here.

* `flows_KCL`: any flow vector of the shape the plumbing allows conserves
  volume at all six junctions.
* `power_budget`: the hydraulic power the pump puts into the oil is exactly
  the sum of the eight other branch powers — relief heat, hose loss, three
  valve losses, and the power taken by the two drives and the loader.  This is
  Tellegen's theorem instantiated on the machine.
* `useful_le_pumpPower`: consequently, once the losses are known to be
  non-negative (pressure falls in the direction of flow), the power reaching
  the actuators is at most the power the pump supplies, with equality exactly
  when every loss vanishes.
* `pumpPower_le_shaftPower`: and the pump's own hydraulic output is at most
  the engine power turning it.
* `machine_heatingRate`: everything not delivered to an actuator heats the
  oil, at a rate this file computes.
-/

namespace LifeTrac.Hydraulic

open Real Finset

/-! ## The junctions and the components -/

/-- The junctions of the LifeTrac plumbing. -/
abbrev Node := Fin 6

/-- The components of the LifeTrac circuit. -/
abbrev Branch := Fin 9

namespace Node

/-- The reservoir, and with it the whole return side of the circuit. -/
abbrev tank : Node := 0
/-- The pump outlet, where the relief valve is teed in. -/
abbrev pumpOut : Node := 1
/-- The valve bank's supply gallery, at the end of the pressure hose. -/
abbrev manifold : Node := 2
/-- Between the left-hand valve and the left-hand wheel motors. -/
abbrev leftIn : Node := 3
/-- Between the right-hand valve and the right-hand wheel motors. -/
abbrev rightIn : Node := 4
/-- Between the loader valve and the lift cylinders. -/
abbrev liftIn : Node := 5

end Node

namespace Branch

/-- The gear pump: it lifts oil from tank pressure to working pressure. -/
abbrev pump : Branch := 0
/-- The relief valve: the path back to tank taken by unused flow. -/
abbrev relief : Branch := 1
/-- The pressure hose from the pump to the valve bank. -/
abbrev supply : Branch := 2
/-- The proportional valve of the left-hand drive. -/
abbrev leftValve : Branch := 3
/-- The two left-hand wheel motors, in parallel. -/
abbrev leftMotors : Branch := 4
/-- The proportional valve of the right-hand drive. -/
abbrev rightValve : Branch := 5
/-- The two right-hand wheel motors, in parallel. -/
abbrev rightMotors : Branch := 6
/-- The loader valve. -/
abbrev liftValve : Branch := 7
/-- The lift cylinders. -/
abbrev liftCyl : Branch := 8

end Branch

/-- The LifeTrac hydraulic circuit: which component is plumbed between which
junctions. -/
def lifeTracCircuit : Circuit Node Branch where
  tail := ![Node.tank, Node.pumpOut, Node.pumpOut, Node.manifold, Node.leftIn,
            Node.manifold, Node.rightIn, Node.manifold, Node.liftIn]
  head := ![Node.pumpOut, Node.tank, Node.manifold, Node.leftIn, Node.tank,
            Node.rightIn, Node.tank, Node.liftIn, Node.tank]

/-! ## The state of the circuit

A state is fixed by four flows — one for each service and one for the relief
valve — and by six pressures. -/

/-- The independent flows in the circuit: what each service draws, and what
the relief valve dumps. -/
structure Flows where
  /-- Flow to the left-hand drive. -/
  left : ℝ
  /-- Flow to the right-hand drive. -/
  right : ℝ
  /-- Flow to the lift cylinders. -/
  lift : ℝ
  /-- Flow dumped over the relief valve. -/
  relief : ℝ

namespace Flows

variable (f : Flows)

/-- The flow the three services take between them, i.e. what goes down the
pressure hose. -/
def demand : ℝ := f.left + f.right + f.lift

/-- The flow the pump must deliver. -/
def pumpFlow : ℝ := f.demand + f.relief

/-- The flow on each branch of the circuit. -/
def branch : Branch → ℝ :=
  ![f.pumpFlow, f.relief, f.demand, f.left, f.left, f.right, f.right,
    f.lift, f.lift]

end Flows

/-- The pressure at each junction. -/
structure Pressures where
  /-- Reservoir (return) pressure. -/
  tank : ℝ
  /-- Pressure at the pump outlet. -/
  pumpOut : ℝ
  /-- Pressure at the valve bank. -/
  manifold : ℝ
  /-- Pressure feeding the left-hand motors. -/
  leftIn : ℝ
  /-- Pressure feeding the right-hand motors. -/
  rightIn : ℝ
  /-- Pressure feeding the lift cylinders. -/
  liftIn : ℝ

namespace Pressures

variable (p : Pressures)

/-- The pressure at each junction, as a function on the nodes. -/
def node : Node → ℝ :=
  ![p.tank, p.pumpOut, p.manifold, p.leftIn, p.rightIn, p.liftIn]

end Pressures

/-! ## Conservation of volume -/

/-- **The machine conserves oil.**  Whatever the four independent flows, the
resulting branch flows satisfy Kirchhoff's current law at every one of the six
junctions: no junction of the plumbing accumulates oil. -/
theorem flows_KCL (f : Flows) : lifeTracCircuit.KCL f.branch := by
  intro v
  fin_cases v <;>
    simp +decide [Circuit.netInflow, Circuit.incidence, lifeTracCircuit,
      Flows.branch, Flows.pumpFlow, Flows.demand, Fin.sum_univ_succ] <;> ring

/-! ## The power of each component -/

variable (p : Pressures) (f : Flows)

/-- Hydraulic power put into the oil by the pump. -/
def pumpPower : ℝ := (p.pumpOut - p.tank) * f.pumpFlow

/-- Power thrown away over the relief valve; it becomes heat in the oil. -/
def reliefLoss : ℝ := (p.pumpOut - p.tank) * f.relief

/-- Power lost to friction in the pressure hose. -/
def supplyLoss : ℝ := (p.pumpOut - p.manifold) * f.demand

/-- Power throttled away in the left-hand drive valve. -/
def leftValveLoss : ℝ := (p.manifold - p.leftIn) * f.left

/-- Power throttled away in the right-hand drive valve. -/
def rightValveLoss : ℝ := (p.manifold - p.rightIn) * f.right

/-- Power throttled away in the loader valve. -/
def liftValveLoss : ℝ := (p.manifold - p.liftIn) * f.lift

/-- Hydraulic power reaching the left-hand wheel motors. -/
def leftDrivePower : ℝ := (p.leftIn - p.tank) * f.left

/-- Hydraulic power reaching the right-hand wheel motors. -/
def rightDrivePower : ℝ := (p.rightIn - p.tank) * f.right

/-- Hydraulic power reaching the lift cylinders. -/
def liftPower : ℝ := (p.liftIn - p.tank) * f.lift

/-- The power delivered to the three services: the point of the machine. -/
def usefulPower : ℝ := leftDrivePower p f + rightDrivePower p f + liftPower p f

/-- The power the circuit wastes: relief, hose and valves. -/
def lossPower : ℝ :=
  reliefLoss p f + supplyLoss p f + leftValveLoss p f + rightValveLoss p f
    + liftValveLoss p f

/-- **The power budget of the machine.**  The hydraulic power the pump puts
into the oil is exactly what the rest of the circuit takes out: the relief
heat, the hose loss, the three valve losses, and the power delivered to the
two drives and to the loader.  This is Tellegen's theorem for
`lifeTracCircuit`. -/
theorem power_budget : pumpPower p f = lossPower p f + usefulPower p f := by
  have h := lifeTracCircuit.tellegen (flows_KCL f) p.node
  simp only [Circuit.power, Circuit.drop, lifeTracCircuit, Pressures.node,
    Flows.branch, Fin.sum_univ_succ, Fin.sum_univ_zero] at h
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_succ] at h
  simp only [pumpPower, lossPower, usefulPower, reliefLoss, supplyLoss,
    leftValveLoss, rightValveLoss, liftValveLoss, leftDrivePower,
    rightDrivePower, liftPower, Flows.pumpFlow, Flows.demand] at *
  linarith

/-- The same budget stated through the network API: the pump branch supplies
exactly what the other eight branches absorb. -/
theorem supplied_pump_eq_absorbed :
    lifeTracCircuit.supplied p.node f.branch {Branch.pump}
      = lifeTracCircuit.absorbed p.node f.branch {Branch.pump} :=
  lifeTracCircuit.supplied_eq_absorbed (flows_KCL f) p.node _

/-- The pump branch supplies precisely `pumpPower`. -/
theorem supplied_pump_eq :
    lifeTracCircuit.supplied p.node f.branch {Branch.pump} = pumpPower p f := by
  simp [Circuit.supplied, Circuit.power, Circuit.drop, lifeTracCircuit,
    Pressures.node, Flows.branch, pumpPower]
  ring

/-! ## Feasible states, and where the power goes

A state of the circuit is *feasible* when the oil moves the way the plumbing
intends: every service draws a non-negative flow, the relief dumps a
non-negative flow, and the pressure falls at every step from the pump outlet
through the hose and the valve to the actuator and back to tank. -/

/-- A state of the circuit in which oil flows forwards and pressure falls in
the direction of flow. -/
structure Feasible (p : Pressures) (f : Flows) : Prop where
  /-- The left-hand drive is not being driven backwards by its load. -/
  left_nonneg : 0 ≤ f.left
  /-- The right-hand drive is not being driven backwards by its load. -/
  right_nonneg : 0 ≤ f.right
  /-- The loader is not being driven backwards by its load. -/
  lift_nonneg : 0 ≤ f.lift
  /-- The relief valve does not suck oil back into the pressure line. -/
  relief_nonneg : 0 ≤ f.relief
  /-- The hose loses pressure. -/
  manifold_le_pumpOut : p.manifold ≤ p.pumpOut
  /-- The left-hand valve loses pressure. -/
  leftIn_le_manifold : p.leftIn ≤ p.manifold
  /-- The right-hand valve loses pressure. -/
  rightIn_le_manifold : p.rightIn ≤ p.manifold
  /-- The loader valve loses pressure. -/
  liftIn_le_manifold : p.liftIn ≤ p.manifold
  /-- The left-hand motors are above tank pressure. -/
  tank_le_leftIn : p.tank ≤ p.leftIn
  /-- The right-hand motors are above tank pressure. -/
  tank_le_rightIn : p.tank ≤ p.rightIn
  /-- The lift cylinders are above tank pressure. -/
  tank_le_liftIn : p.tank ≤ p.liftIn

namespace Feasible

variable {p f} (hs : Feasible p f)

include hs

theorem demand_nonneg : 0 ≤ f.demand :=
  by have := hs.left_nonneg; have := hs.right_nonneg; have := hs.lift_nonneg
     simp only [Flows.demand]; linarith

theorem pumpFlow_nonneg : 0 ≤ f.pumpFlow := by
  have := hs.demand_nonneg; have := hs.relief_nonneg
  simp only [Flows.pumpFlow]; linarith

theorem tank_le_pumpOut : p.tank ≤ p.pumpOut := by
  have := hs.manifold_le_pumpOut; have := hs.leftIn_le_manifold
  have := hs.tank_le_leftIn; linarith

theorem reliefLoss_nonneg : 0 ≤ reliefLoss p f :=
  mul_nonneg (by have := hs.tank_le_pumpOut; linarith) hs.relief_nonneg

theorem supplyLoss_nonneg : 0 ≤ supplyLoss p f :=
  mul_nonneg (by have := hs.manifold_le_pumpOut; linarith) hs.demand_nonneg

theorem leftValveLoss_nonneg : 0 ≤ leftValveLoss p f :=
  mul_nonneg (by have := hs.leftIn_le_manifold; linarith) hs.left_nonneg

theorem rightValveLoss_nonneg : 0 ≤ rightValveLoss p f :=
  mul_nonneg (by have := hs.rightIn_le_manifold; linarith) hs.right_nonneg

theorem liftValveLoss_nonneg : 0 ≤ liftValveLoss p f :=
  mul_nonneg (by have := hs.liftIn_le_manifold; linarith) hs.lift_nonneg

theorem leftDrivePower_nonneg : 0 ≤ leftDrivePower p f :=
  mul_nonneg (by have := hs.tank_le_leftIn; linarith) hs.left_nonneg

theorem rightDrivePower_nonneg : 0 ≤ rightDrivePower p f :=
  mul_nonneg (by have := hs.tank_le_rightIn; linarith) hs.right_nonneg

theorem liftPower_nonneg : 0 ≤ liftPower p f :=
  mul_nonneg (by have := hs.tank_le_liftIn; linarith) hs.lift_nonneg

theorem lossPower_nonneg : 0 ≤ lossPower p f := by
  have := hs.reliefLoss_nonneg; have := hs.supplyLoss_nonneg
  have := hs.leftValveLoss_nonneg; have := hs.rightValveLoss_nonneg
  have := hs.liftValveLoss_nonneg
  simp only [lossPower]; linarith

theorem usefulPower_nonneg : 0 ≤ usefulPower p f := by
  have := hs.leftDrivePower_nonneg; have := hs.rightDrivePower_nonneg
  have := hs.liftPower_nonneg
  simp only [usefulPower]; linarith

end Feasible

/-- **Nothing gets out that did not go in.**  In a feasible state the power
delivered to the drives and the loader is at most the power the pump puts into
the oil. -/
theorem usefulPower_le_pumpPower {p f} (hs : Feasible p f) :
    usefulPower p f ≤ pumpPower p f := by
  have h := power_budget p f
  have := hs.lossPower_nonneg
  linarith

/-- The shortfall is exactly the losses. -/
theorem pumpPower_sub_usefulPower {p f} :
    pumpPower p f - usefulPower p f = lossPower p f := by
  have := power_budget p f; linarith

/-- Equality in `usefulPower_le_pumpPower` holds exactly when nothing is
wasted: nothing over the relief, no pressure lost in the hose, nothing
throttled in the three valves. -/
theorem usefulPower_eq_pumpPower_iff {p f} (hs : Feasible p f) :
    usefulPower p f = pumpPower p f ↔
      (reliefLoss p f = 0 ∧ supplyLoss p f = 0 ∧ leftValveLoss p f = 0 ∧
        rightValveLoss p f = 0 ∧ liftValveLoss p f = 0) := by
  have hb := power_budget p f
  constructor
  · intro h
    have hzero : lossPower p f = 0 := by linarith
    have h1 := hs.reliefLoss_nonneg
    have h2 := hs.supplyLoss_nonneg
    have h3 := hs.leftValveLoss_nonneg
    have h4 := hs.rightValveLoss_nonneg
    have h5 := hs.liftValveLoss_nonneg
    simp only [lossPower] at hzero
    refine ⟨by linarith, by linarith, by linarith, by linarith, by linarith⟩
  · rintro ⟨h1, h2, h3, h4, h5⟩
    simp only [lossPower, h1, h2, h3, h4, h5] at hb
    linarith

/-! ## The engine at the top of the chain -/

/-- The pump cannot put more into the oil than the engine puts into the pump:
`Pump.shaftPower` bounds `pumpPower`, provided the state of the circuit is the
one the pump is actually producing. -/
theorem pumpPower_le_shaftPower (pu : Pump) (n : ℝ) {p f} (hs : Feasible p f)
    (hflow : f.pumpFlow = pu.flow n) (hn : 0 ≤ n) :
    pumpPower p f ≤ pu.shaftPower (p.pumpOut - p.tank) n := by
  have hdp : 0 ≤ p.pumpOut - p.tank := by have := hs.tank_le_pumpOut; linarith
  have h := pu.hydPower_le_shaftPower (Δp := p.pumpOut - p.tank) hdp hn
  simpa [pumpPower, hflow, hydPower, mul_comm] using h

/-- The whole chain in one line: what comes out at the wheels and the loader is
at most what the engine puts in at the pump shaft. -/
theorem usefulPower_le_shaftPower (pu : Pump) (n : ℝ) {p f} (hs : Feasible p f)
    (hflow : f.pumpFlow = pu.flow n) (hn : 0 ≤ n) :
    usefulPower p f ≤ pu.shaftPower (p.pumpOut - p.tank) n :=
  le_trans (usefulPower_le_pumpPower hs) (pumpPower_le_shaftPower pu n hs hflow hn)

/-! ## Where the wasted power goes: into the oil -/

/-- Every watt the circuit wastes ends up as heat in the oil, and so as a rate
of temperature rise of the reservoir contents: `lossPower / (mass · c)`. -/
theorem machine_heatingRate (fl : Fluid) (mass : ℝ) (p : Pressures) (f : Flows) :
    heatingRate fl mass (pumpPower p f - usefulPower p f)
      = heatingRate fl mass (lossPower p f) := by
  rw [pumpPower_sub_usefulPower]

/-- **Sizing the reservoir for the whole machine.**  The oil temperature climbs
no faster than `limit` exactly when the reservoir holds at least
`lossPower / (c · limit)` of oil — the losses of every component counted
together. -/
theorem machine_reservoir_sizing (fl : Fluid) {mass limit : ℝ} (hm : 0 < mass)
    (hl : 0 < limit) (p : Pressures) (f : Flows) :
    heatingRate fl mass (lossPower p f) ≤ limit ↔
      lossPower p f / (fl.heatCap * limit) ≤ mass :=
  heatingRate_le_iff fl hm hl

end LifeTrac.Hydraulic
