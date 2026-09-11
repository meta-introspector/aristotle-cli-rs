import RequestProject.Gvcs.Sim.Electric
import RequestProject.Gvcs.Circuit

/-!
# The two circuits are the same circuit

`Sim/Static.lean` is written for an abstract resistive element; the machine has
two kinds of them.  This file identifies both with the network theory, so that
the theorems proved once there apply to the plumbing and to the wiring alike.

* `hose_pressureDrop_eq` — the Hagen–Poiseuille drop of `Circuit.lean` is
  Ohm's law `Δp = R Q` for the hose's hydraulic resistance;
* `hose_flow_eq` — inverted: the flow a pressure difference drives through a
  hose is the current of the corresponding one-element network;
* `hoses_series_pressureDrop` — two hoses of the same bore end to end drop what
  one hose of the summed length drops, which is the series law of `Net`;
* `hose_power_eq` — the heat the network says the hose makes is the hydraulic
  power `Δp · Q` the machine's power budget accounts for;
* `coil_current_eq` — a valve coil across the supply is likewise a one-element
  network, and `coils_parallel_current` that two of them across it draw the sum
  of their currents.
-/

namespace LifeTrac
namespace Sim

open Static Real

noncomputable section

/-- The hose of `Circuit.lean`, as an element of a static network. -/
def hoseNet (h : Hose) (f : Fluid) : Net := Net.leaf (hoseResistance f.visc h.length h.radius)

theorem hoseNet_ok (h : Hose) (f : Fluid) : (hoseNet h f).Ok :=
  Net.Ok.leaf (hoseResistance_pos f.visc_pos h.length_pos h.radius_pos)

/-- **Hydraulic Ohm's law.**  The Hagen–Poiseuille drop is the resistance of
the hose times the flow. -/
theorem hose_pressureDrop_eq (h : Hose) (f : Fluid) (Q : ℝ) :
    h.pressureDrop f Q = (hoseNet h f).resistance * Q := by
  simp only [Hose.pressureDrop, hoseNet, Net.resistance, hoseResistance]
  ring

/-- …and, inverted, the flow a given drop drives through the hose is the
current of the network. -/
theorem hose_flow_eq (h : Hose) (f : Fluid) (Q : ℝ) :
    (hoseNet h f).current (h.pressureDrop f Q) = Q := by
  have hR : (hoseNet h f).resistance ≠ 0 := Net.resistance_ne_zero (hoseNet_ok h f)
  rw [Net.current, hose_pressureDrop_eq]
  field_simp

/-- Two hoses of the same bore in series drop what one hose of the summed
length drops — the series law of the network theory. -/
theorem hoses_series_pressureDrop (h₁ h₂ h : Hose) (f : Fluid) (Q : ℝ)
    (hr : h.radius = h₁.radius) (hr' : h₂.radius = h₁.radius)
    (hl : h.length = h₁.length + h₂.length) :
    (Net.series (hoseNet h₁ f) (hoseNet h₂ f)).resistance * Q = h.pressureDrop f Q := by
  rw [hose_pressureDrop_eq]
  simp only [hoseNet, Net.resistance, hoseResistance, hr, hr', hl]
  ring

/-- The heat the network theory attributes to the hose is the hydraulic power
the machine's power budget charges to it. -/
theorem hose_power_eq (h : Hose) (f : Fluid) (Q : ℝ) :
    (hoseNet h f).dissipation (h.pressureDrop f Q) = h.pressureDrop f Q * Q := by
  rw [Net.dissipation_eq_mul_current (hoseNet_ok h f), hose_flow_eq]

/-- A valve coil across the supply is a one-element network too. -/
theorem coil_current_eq (k : Electric.Coil) (v : ℝ) :
    (Net.leaf k.res).current v = k.holdCurrent v := rfl

/-- Two coils across the same supply draw the sum of their currents — the
parallel law. -/
theorem coils_parallel_current (k k' : Electric.Coil) (v : ℝ) :
    (Net.par (Net.leaf k.res) (Net.leaf k'.res)).current v
      = k.holdCurrent v + k'.holdCurrent v :=
  k.par_of_two k' v

end

end Sim
end LifeTrac
