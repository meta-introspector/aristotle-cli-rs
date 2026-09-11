import RequestProject.Gvcs.Valves

/-!
# Hydraulic networks

The other hydraulics files in this development treat the components of the
LifeTrac circuit one at a time: the pump (`Hydraulics`), the hoses
(`Circuit`), the valves and the relief (`Valves`), the cylinders
(`Cylinder`).  This file supplies the frame in which a *whole* circuit lives:
a finite directed graph whose vertices are the junctions of the plumbing and
whose edges are the components, carrying a flow each and separated by a
pressure difference each.

Two laws hold of such a network.

* **Conservation of volume** (Kirchhoff's current law): oil is incompressible,
  so at every junction the flows in balance the flows out.  We take this as the
  definition of an admissible flow, `Circuit.KCL`, and derive from it the *cut
  law*: across any dividing line drawn through the machine, as much oil crosses
  one way as the other.
* **Conservation of energy** (Tellegen's theorem): if the pressures at the
  junctions come from a single well-defined pressure at each junction — that
  is, if pressure is a potential — then the hydraulic powers `Δp · Q` of the
  components sum to zero.  Nothing is assumed about *how* each component
  relates its flow to its pressure drop; the result is a consequence of the
  topology alone.

Tellegen's theorem is what makes a power budget for the machine possible: split
the branches into the sources (the pump) and the rest, and the theorem says
that the power the pump puts in is exactly the power the rest of the circuit
takes out — as useful work at the motors and cylinders, and as heat everywhere
else.
-/

namespace LifeTrac.Hydraulic

open Finset

/-- A hydraulic circuit: a finite directed multigraph.  `V` indexes the
junctions (nodes) of the plumbing, `B` indexes the components (branches);
branch `b` is plumbed from node `tail b` to node `head b`, and a positive flow
on `b` means oil moving in that direction. -/
structure Circuit (V B : Type*) where
  /-- The node a branch leaves. -/
  tail : B → V
  /-- The node a branch enters. -/
  head : B → V

namespace Circuit

variable {V B : Type*} [Fintype V] [DecidableEq V] [Fintype B]
variable (c : Circuit V B)

/-- The incidence coefficient of node `v` and branch `b`: `+1` if the branch
delivers oil to `v`, `-1` if it takes oil away, `0` if it does not touch `v`
(and `0` for a self-loop, which neither delivers nor takes). -/
def incidence (v : V) (b : B) : ℝ :=
  (if c.head b = v then 1 else 0) - (if c.tail b = v then 1 else 0)

/-- The net volumetric flow *into* node `v` under the branch flows `Q`. -/
def netInflow (Q : B → ℝ) (v : V) : ℝ := ∑ b, c.incidence v b * Q b

/-- Kirchhoff's current law for an incompressible fluid: no junction of the
plumbing accumulates oil. -/
def KCL (Q : B → ℝ) : Prop := ∀ v, c.netInflow Q v = 0

/-- The pressure drop across a branch, given a pressure at each node. -/
def drop (p : V → ℝ) (b : B) : ℝ := p (c.tail b) - p (c.head b)

/-- The hydraulic power a branch absorbs: pressure drop times flow.  A
component that resists flow absorbs positive power; the pump, which raises the
pressure of the oil passing through it, absorbs negative power, i.e. supplies
it. -/
def power (p : V → ℝ) (Q : B → ℝ) (b : B) : ℝ := c.drop p b * Q b

omit [Fintype V] [Fintype B] in
@[simp] theorem incidence_self_loop {v : V} {b : B} (h : c.tail b = c.head b) :
    c.incidence v b = 0 := by
  simp [incidence, h]

omit [Fintype V] [DecidableEq V] [Fintype B] in
@[simp] theorem drop_self_loop {p : V → ℝ} {b : B} (h : c.tail b = c.head b) :
    c.drop p b = 0 := by simp [drop, h]

omit [Fintype B] in
/-- Summing the incidence coefficients of a branch over all nodes gives zero:
what a branch takes from one node it gives to another. -/
theorem sum_incidence (b : B) : ∑ v, c.incidence v b = 0 := by
  simp [incidence, Finset.sum_sub_distrib]

/-- Summing the net inflows over *all* nodes gives zero, whatever the flows. -/
theorem sum_netInflow (Q : B → ℝ) : ∑ v, c.netInflow Q v = 0 := by
  simp only [netInflow]
  rw [Finset.sum_comm]
  refine Finset.sum_eq_zero fun b _ => ?_
  rw [← Finset.sum_mul, c.sum_incidence b, zero_mul]

/-- The pressure-weighted sum of the net inflows is the negative of the total
power absorbed: the algebraic heart of Tellegen's theorem. -/
theorem sum_pressure_mul_netInflow (p : V → ℝ) (Q : B → ℝ) :
    ∑ v, p v * c.netInflow Q v = -∑ b, c.power p Q b := by
  simp only [netInflow, power, drop, Finset.mul_sum]
  rw [Finset.sum_comm, ← Finset.sum_neg_distrib]
  refine Finset.sum_congr rfl fun b _ => ?_
  have h : ∑ v, p v * (c.incidence v b * Q b)
      = (∑ v, p v * c.incidence v b) * Q b := by
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl fun v _ => by ring
  have h2 : ∑ v, p v * c.incidence v b = p (c.head b) - p (c.tail b) := by
    simp [incidence, mul_sub, Finset.sum_sub_distrib]
  rw [h, h2]; ring

/-- **Tellegen's theorem** for a hydraulic network.  If the flows conserve
volume and the pressures are a single-valued potential on the junctions, then
the hydraulic powers of the components sum to zero: the circuit as a whole
neither creates nor destroys energy. -/
theorem tellegen {Q : B → ℝ} (hQ : c.KCL Q) (p : V → ℝ) :
    ∑ b, c.power p Q b = 0 := by
  have key := c.sum_pressure_mul_netInflow p Q
  have hz : ∑ v, p v * c.netInflow Q v = 0 :=
    Finset.sum_eq_zero fun v _ => by rw [hQ v, mul_zero]
  rw [hz] at key
  linarith

/-! ### Sources and loads

For a power budget one splits the branches in two: the *sources* (in LifeTrac,
the single pump branch) and everything else.  Tellegen's theorem then says the
power supplied equals the power absorbed. -/

variable [DecidableEq B]

/-- The power supplied by the branches in `S` (the negative of the power they
absorb). -/
def supplied (p : V → ℝ) (Q : B → ℝ) (S : Finset B) : ℝ := -∑ b ∈ S, c.power p Q b

/-- The power absorbed by the branches outside `S`. -/
def absorbed (p : V → ℝ) (Q : B → ℝ) (S : Finset B) : ℝ :=
  ∑ b ∈ Sᶜ, c.power p Q b

/-- **The power budget of a circuit.**  Whatever the split, the power supplied
by one part of the circuit is the power absorbed by the other. -/
theorem supplied_eq_absorbed {Q : B → ℝ} (hQ : c.KCL Q) (p : V → ℝ)
    (S : Finset B) : c.supplied p Q S = c.absorbed p Q S := by
  have h := c.tellegen hQ p
  have hsplit : ∑ b ∈ S, c.power p Q b + ∑ b ∈ Sᶜ, c.power p Q b
      = ∑ b, c.power p Q b := Finset.sum_add_sum_compl S _
  simp only [supplied, absorbed]
  linarith

/-! ### The cut law -/

/-- Flow entering a region of the machine, counted branch by branch. -/
def inflowSum (Q : B → ℝ) (S : Finset V) : ℝ :=
  ∑ b ∈ univ.filter (fun b => c.head b ∈ S), Q b

/-- Flow leaving a region of the machine, counted branch by branch. -/
def outflowSum (Q : B → ℝ) (S : Finset V) : ℝ :=
  ∑ b ∈ univ.filter (fun b => c.tail b ∈ S), Q b

omit [Fintype V] [DecidableEq B] in
/-- The net inflow to a region of nodes, expanded branch by branch. -/
theorem sum_netInflow_region (Q : B → ℝ) (S : Finset V) :
    ∑ v ∈ S, c.netInflow Q v = c.inflowSum Q S - c.outflowSum Q S := by
  classical
  simp only [netInflow, inflowSum, outflowSum]
  rw [Finset.sum_comm]
  have step : ∀ b : B, ∑ v ∈ S, c.incidence v b * Q b
      = (if c.head b ∈ S then Q b else 0) - (if c.tail b ∈ S then Q b else 0) := by
    intro b
    simp only [incidence, sub_mul, Finset.sum_sub_distrib, ite_mul, one_mul,
      zero_mul, Finset.sum_ite_eq', eq_comm]
  simp only [step, Finset.sum_sub_distrib, ← Finset.sum_filter]

omit [Fintype V] [DecidableEq B] in
/-- **The cut law.**  Oil is conserved region by region: as much flow enters
any set of junctions as leaves it. -/
theorem inflowSum_eq_outflowSum {Q : B → ℝ} (hQ : c.KCL Q) (S : Finset V) :
    c.inflowSum Q S = c.outflowSum Q S := by
  have h := c.sum_netInflow_region Q S
  rw [Finset.sum_eq_zero fun v _ => hQ v] at h
  linarith

omit [Fintype V] [DecidableEq B] in
/-- The cut law in the form one draws on a diagram: across a line separating
the junctions `S` from the rest of the machine, the flow crossing outwards
equals the flow crossing inwards. -/
theorem cut_balance {Q : B → ℝ} (hQ : c.KCL Q) (S : Finset V) :
    ∑ b ∈ univ.filter (fun b => c.tail b ∈ S ∧ c.head b ∉ S), Q b
      = ∑ b ∈ univ.filter (fun b => c.head b ∈ S ∧ c.tail b ∉ S), Q b := by
  classical
  have hin := Finset.sum_filter_add_sum_filter_not
    (univ.filter (fun b => c.head b ∈ S)) (fun b => c.tail b ∈ S) Q
  have hout := Finset.sum_filter_add_sum_filter_not
    (univ.filter (fun b => c.tail b ∈ S)) (fun b => c.head b ∈ S) Q
  rw [Finset.filter_filter, Finset.filter_filter] at hin hout
  have hcomm : ∑ b ∈ univ.filter (fun b => c.head b ∈ S ∧ c.tail b ∈ S), Q b
      = ∑ b ∈ univ.filter (fun b => c.tail b ∈ S ∧ c.head b ∈ S), Q b := by
    refine Finset.sum_congr ?_ fun _ _ => rfl
    apply Finset.filter_congr
    intro b _
    exact ⟨fun h => ⟨h.2, h.1⟩, fun h => ⟨h.2, h.1⟩⟩
  have h := c.inflowSum_eq_outflowSum hQ S
  simp only [inflowSum, outflowSum] at h
  rw [← hin, ← hout] at h
  rw [hcomm] at h
  linarith

end Circuit

end LifeTrac.Hydraulic
