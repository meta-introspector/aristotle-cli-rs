import RequestProject.Gvcs.Hydraulic.Actuators

/-!
# The circuit in time: compressibility, stored energy, and the pressure rise

Everything so far has been steady: `Circuit.KCL` says the junctions do not
accumulate oil, and Tellegen's theorem then balances the powers exactly.  Oil
is not quite incompressible, though, and a hose is not quite rigid; between
them they give each junction of the machine a small hydraulic capacitance
`C = V / β` (line volume over bulk modulus).  On the time scale of a valve
slamming shut, that capacitance is what the pump pushes against, and it is why
the pressure takes a few milliseconds — not zero time — to reach the relief
setting.

This file adds that layer to the model:

* `dynamicLaw`: at each junction, `C · dp/dt = ` net inflow ` + ` external
  injection.  With `C = 0` (or with the pressures held constant) this is
  exactly `Circuit.KCL`.
* `storedEnergy`, `hasDerivAt_storedEnergy`: the energy `∑ C p² / 2` held in
  the compressed oil, and its rate of change.
* `energy_balance`: the power injected into the circuit equals the power the
  branches take plus the rate at which energy is stored.  Tellegen's theorem is
  the steady case.
* `deadhead_rise` and `deadhead_time_to_relief`: a deadheaded pump against a
  capacitance, and how long it takes the pressure to reach the relief setting —
  with the numbers for the worked machine, about three and a half
  milliseconds.
-/

namespace LifeTrac.Hydraulic

open Finset

noncomputable section

variable {V B : Type*} [Fintype V] [DecidableEq V] [Fintype B]

/-- The energy stored in the compressed oil at the junctions: at a junction of
capacitance `C` held at pressure `p`, the compression work `C p² / 2`. -/
def storedEnergy (cap p : V → ℝ) : ℝ := ∑ v, cap v * (p v) ^ 2 / 2

omit [DecidableEq V] [Fintype B] in
/-- Differentiating the stored energy along a motion of the pressures. -/
theorem hasDerivAt_storedEnergy (cap : V → ℝ) (p : ℝ → V → ℝ) (dp : V → ℝ)
    (t : ℝ) (hp : ∀ v, HasDerivAt (fun s => p s v) (dp v) t) :
    HasDerivAt (fun s => storedEnergy cap (p s)) (∑ v, cap v * p t v * dp v) t := by
  have h : ∀ v ∈ (univ : Finset V),
      HasDerivAt (fun s => cap v * (p s v) ^ 2 / 2) (cap v * p t v * dp v) t := by
    intro v _
    have h2 : HasDerivAt (fun s => (p s v) ^ 2) (2 * p t v * dp v) t := by
      have := (hp v).pow 2
      convert this using 1
      push_cast
      ring
    have h3 := (h2.const_mul (cap v)).div_const 2
    convert h3 using 1
    ring
  have hsum := HasDerivAt.sum h
  have hfun : (∑ v : V, fun s => cap v * (p s v) ^ 2 / 2)
      = fun s => storedEnergy cap (p s) := by
    funext s
    simp [storedEnergy, Finset.sum_apply]
  rwa [hfun] at hsum

namespace Circuit

variable (c : Circuit V B)

/-- The dynamic law at the junctions: what flows in, less what flows out, less
what is injected from outside, compresses the oil already there.  `ext v` is an
external injection at `v` (for instance the reservoir feeding the pump inlet
from the free surface). -/
def dynamicLaw (cap : V → ℝ) (dp : V → ℝ) (Q : B → ℝ) (ext : V → ℝ) : Prop :=
  ∀ v, cap v * dp v = c.netInflow Q v + ext v

omit [Fintype V] in
/-- A steady state — no capacitance in play, no external injection — is exactly
a state satisfying Kirchhoff's current law. -/
theorem dynamicLaw_steady {cap dp : V → ℝ} {Q : B → ℝ}
    (h : c.dynamicLaw cap dp Q 0) (hz : ∀ v, cap v * dp v = 0) : c.KCL Q := by
  intro v
  have := h v
  simp only [Pi.zero_apply, add_zero, hz v] at this
  exact this.symm

/-- **Energy balance of the circuit in time.**  The power injected from outside
goes partly into the branches (as useful work and as heat) and partly into
compressing the oil; nothing else happens to it. -/
theorem energy_balance (cap : V → ℝ) (p : ℝ → V → ℝ) (Q : ℝ → B → ℝ)
    (dp : V → ℝ) (ext : V → ℝ) (t : ℝ)
    (hp : ∀ v, HasDerivAt (fun s => p s v) (dp v) t)
    (hlaw : c.dynamicLaw cap dp (Q t) ext) :
    HasDerivAt (fun s => storedEnergy cap (p s))
      ((∑ v, p t v * ext v) - ∑ b, c.power (p t) (Q t) b) t := by
  have hderiv := hasDerivAt_storedEnergy cap p dp t hp
  have hsum : ∑ v, cap v * p t v * dp v
      = (∑ v, p t v * ext v) - ∑ b, c.power (p t) (Q t) b := by
    have h1 : ∑ v, cap v * p t v * dp v
        = ∑ v, (p t v * c.netInflow (Q t) v + p t v * ext v) := by
      refine Finset.sum_congr rfl fun v _ => ?_
      have := hlaw v
      calc cap v * p t v * dp v = p t v * (cap v * dp v) := by ring
        _ = p t v * (c.netInflow (Q t) v + ext v) := by rw [this]
        _ = p t v * c.netInflow (Q t) v + p t v * ext v := by ring
    rw [h1, Finset.sum_add_distrib, c.sum_pressure_mul_netInflow (p t) (Q t)]
    ring
  rwa [hsum] at hderiv

/-- With no external injection and the pressures momentarily at rest, the
energy stored is stationary and Tellegen's theorem is recovered. -/
theorem tellegen_of_dynamic (cap : V → ℝ) (p : V → ℝ) (Q : B → ℝ)
    (h : c.dynamicLaw cap 0 Q 0) : ∑ b, c.power p Q b = 0 := by
  refine c.tellegen ?_ p
  intro v
  have := h v
  simpa using this.symm

end Circuit

end

/-! ## Deadheading the pump

The simplest transient of the machine: the operator centres every valve while
the engine is running.  The pump keeps delivering into a closed volume, the oil
and the hoses compress, and the pressure climbs until the relief valve cracks.
-/

noncomputable section

open Real

/-- The hydraulic capacitance of a line of volume `vol` in oil of bulk modulus
`beta`: the volume of oil the line will swallow per unit of pressure. -/
def capacitance (vol beta : ℝ) : ℝ := vol / beta

theorem capacitance_pos {vol beta : ℝ} (hv : 0 < vol) (hb : 0 < beta) :
    0 < capacitance vol beta := div_pos hv hb

/-- Pressure in a deadheaded line: starting from `p0`, a pump delivering `Q`
into a capacitance `C` raises the pressure at the constant rate `Q / C`. -/
def deadheadPressure (C Q p0 t : ℝ) : ℝ := p0 + Q / C * t

/-- **The deadheaded line is the dynamic law with one junction.**  Its pressure
rises at exactly the rate the capacitance imposes. -/
theorem deadhead_rise (C Q p0 t : ℝ) :
    HasDerivAt (deadheadPressure C Q p0) (Q / C) t := by
  have h := (hasDerivAt_const t p0).add ((hasDerivAt_id t).const_mul (Q / C))
  rw [show (0 : ℝ) + Q / C * 1 = Q / C by ring] at h
  exact h

/-- Written as the dynamic law: the capacitance times the rate of rise is the
flow the pump is putting in. -/
theorem deadhead_dynamicLaw {C : ℝ} (hC : C ≠ 0) (Q : ℝ) : C * (Q / C) = Q := by
  field_simp

/-- **How long the pressure takes to reach the relief setting.**  With a pump
flow `Q` into a line of capacitance `C`, the answer is `C (pmax - p0) / Q`. -/
theorem deadhead_time_to_relief {C Q p0 pmax t : ℝ} (hC : 0 < C) (hQ : 0 < Q) :
    deadheadPressure C Q p0 t = pmax ↔ t = C * (pmax - p0) / Q := by
  rw [deadheadPressure]
  constructor
  · intro h
    field_simp at h ⊢
    linarith
  · intro h
    subst h
    field_simp
    ring

/-- For the worked machine: one litre of line and hose, oil of bulk modulus
1.5 GPa, the pump delivering 2.7 l/s and the relief set at 140 bar.  The
pressure reaches the relief setting in about 3.5 milliseconds — fast, but not
instant, which is why the relief valve has time to open and why the spike is
survivable. -/
theorem lifeTrac0_deadhead_time (t : ℝ) :
    deadheadPressure (capacitance (1 / 1000) 1500000000) (27 / 10000) 0 t
        = 14000000 ↔ t = 28 / 8100 := by
  have hC : (0:ℝ) < capacitance (1 / 1000) 1500000000 :=
    capacitance_pos (by norm_num) (by norm_num)
  rw [deadhead_time_to_relief hC (by norm_num : (0:ℝ) < 27 / 10000)]
  have h : capacitance (1 / 1000) 1500000000 * (14000000 - 0) / (27 / 10000)
      = 28 / 8100 := by
    simp only [capacitance]; norm_num
  rw [h]

/-- That is under four milliseconds. -/
theorem lifeTrac0_deadhead_time_lt : (28 : ℝ) / 8100 < 4 / 1000 := by norm_num

end

end LifeTrac.Hydraulic
