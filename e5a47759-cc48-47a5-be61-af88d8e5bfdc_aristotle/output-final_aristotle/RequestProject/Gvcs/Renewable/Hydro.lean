import RequestProject.Gvcs.Renewable.Wind

/-!
# Water: wheels, heads and the ram pump

`Renewable/Wind.lean` already covers the *free stream* — a rotor in a river
obeys Betz exactly as a rotor in the wind does, only with a fluid eight hundred
times heavier.  This file covers the other way of taking power from water, the
one that built every mill town: **head**.

* `headPower`: a flow `Q` falling a height `H` carries `ρ g Q H` watts, and a
  wheel or turbine of efficiency `η ≤ 1` gets `η` of it and no more
  (`headPower_le_ideal`).  Power is linear in flow and in head separately
  (`headPower_mono_flow`, `headPower_mono_head`), so a small flow off a big
  fall is worth exactly as much as a big flow off a small one — but the pipe is
  cheaper.
* Wheels: `overshotWheel` at 80 %, `undershotWheel` at 25 %, and
  `overshot_beats_undershot_threefold` — why every mill that could afford a
  weir built one.  A wheel runs slowly, so its torque is large
  (`wheelTorque_eq`), which is why it drives millstones directly and a
  generator only through gearing.
* `ramPump`: the hydraulic ram, a pump with no engine, no electricity and one
  moving part.  `ram_energy_balance` is the conservation law that governs it —
  water delivered times lift is at most efficiency times water spilled times
  fall — and `ram_lift_costs_flow` is its practical face: lifting ten times the
  fall delivers at most a tenth of the water.
* `storedEnergy`: a tank of water is a battery, and
  `village_tank_energy_bounds` measures a modest one — enough to run a 3 kW
  shop for eleven minutes, which is why the tank buffers a mill and does not
  replace it.
-/

namespace LifeTrac
namespace Renewable

open Real

noncomputable section

/-! ## Head -/

/-- Standard gravity, m/s². -/
def gravity : ℝ := 9.81

/-- Power available from a volumetric flow `Q` (m³/s) of water falling a head
`H` (m), at conversion efficiency `eff`. -/
def headPower (eff Q H : ℝ) : ℝ := eff * waterDensity * gravity * Q * H

/-- **No machine beats the head.**  A wheel or turbine of efficiency at most
one takes at most the potential power of the falling water. -/
theorem headPower_le_ideal {eff Q H : ℝ} (h1 : eff ≤ 1) (hQ : 0 ≤ Q) (hH : 0 ≤ H) :
    headPower eff Q H ≤ headPower 1 Q H := by
  unfold headPower waterDensity gravity
  nlinarith [mul_nonneg (mul_nonneg (sub_nonneg.2 h1) hQ) hH]

theorem headPower_nonneg {eff Q H : ℝ} (he : 0 ≤ eff) (hQ : 0 ≤ Q) (hH : 0 ≤ H) :
    0 ≤ headPower eff Q H := by
  unfold headPower waterDensity gravity
  positivity

/-- More water, more power. -/
theorem headPower_mono_flow {eff Q R H : ℝ} (he : 0 < eff) (hH : 0 < H) (h : Q < R) :
    headPower eff Q H < headPower eff R H := by
  unfold headPower waterDensity gravity
  nlinarith [mul_pos (mul_pos he (sub_pos.2 h)) hH]

/-- More fall, more power. -/
theorem headPower_mono_head {eff Q H K : ℝ} (he : 0 < eff) (hQ : 0 < Q) (h : H < K) :
    headPower eff Q H < headPower eff Q K := by
  unfold headPower waterDensity gravity
  nlinarith [mul_pos (mul_pos he hQ) (sub_pos.2 h)]

/-- **Flow and head are interchangeable.**  Ten litres a second down ten metres
is the same power as a hundred litres a second down one metre. -/
theorem flow_head_tradeoff (eff Q H c : ℝ) (hc : c ≠ 0) :
    headPower eff (c * Q) (H / c) = headPower eff Q H := by
  unfold headPower
  field_simp

/-! ## Wheels -/

/-- An overshot wheel — water delivered to the top, working by weight — keeps
about 80 % of the head. -/
def overshotWheel : ℝ := 0.8

/-- An undershot wheel — a paddle in a stream, working by impulse — keeps
about 25 %. -/
def undershotWheel : ℝ := 0.25

/-- **Build the weir.**  For the same water and the same drop, an overshot
wheel returns more than three times what an undershot one does. -/
theorem overshot_beats_undershot_threefold {Q H : ℝ} (hQ : 0 < Q) (hH : 0 < H) :
    3 * headPower undershotWheel Q H < headPower overshotWheel Q H := by
  unfold headPower overshotWheel undershotWheel waterDensity gravity
  nlinarith [mul_pos hQ hH]

/-- Torque on the shaft of a wheel delivering power `P` at angular speed `ω`. -/
def wheelTorque (P ω : ℝ) : ℝ := P / ω

theorem wheelTorque_eq {P ω : ℝ} (hω : ω ≠ 0) : wheelTorque P ω * ω = P := by
  unfold wheelTorque; field_simp

/-- **A wheel is a torque machine.**  A four-metre wheel turning at five
revolutions a minute and taking 2 kW off the stream puts more than three and a
half kilonewton-metres on its shaft — which is why it drives a millstone
directly and a dynamo only through gearing. -/
theorem millwheel_torque_bounds :
    3500 < wheelTorque 2000 (2 * π * 5 / 60) ∧ wheelTorque 2000 (2 * π * 5 / 60) < 4000 := by
  unfold wheelTorque
  constructor
  · rw [lt_div_iff₀ (by positivity)]
    nlinarith [pi_lt_d2]
  · rw [div_lt_iff₀ (by positivity)]
    nlinarith [pi_gt_d6]

/-- A small overshot wheel: 30 litres a second off a three-metre fall gives
just over 700 watts — a workshop's worth of light and a lathe. -/
theorem small_wheel_power_bounds :
    700 < headPower overshotWheel 0.03 3 ∧ headPower overshotWheel 0.03 3 < 710 := by
  unfold headPower overshotWheel waterDensity gravity
  constructor <;> norm_num

/-! ## The hydraulic ram -/

/-- A hydraulic ram: `drive` cubic metres per second arriving down a fall
`fall`, of which `deliver` cubic metres per second are pushed up a lift
`lift`, at efficiency `eff`. -/
structure RamPump where
  /-- Drive flow, m³/s. -/
  drive : ℝ
  /-- Drive fall, m. -/
  fall : ℝ
  /-- Lift, m. -/
  lift : ℝ
  /-- Efficiency (D'Aubuisson). -/
  eff : ℝ
  drive_pos : 0 < drive
  fall_pos : 0 < fall
  lift_pos : 0 < lift
  eff_pos : 0 < eff
  eff_le_one : eff ≤ 1

namespace RamPump

variable (r : RamPump)

/-- What the ram can deliver, m³/s: the whole point is that this is *less*
than the drive flow, in the ratio of fall to lift. -/
def deliver : ℝ := r.eff * r.drive * r.fall / r.lift

/-- **The ram obeys conservation of energy.**  The potential power it creates
is the efficiency times the potential power it destroys. -/
theorem ram_energy_balance :
    headPower 1 r.deliver r.lift = headPower r.eff r.drive r.fall := by
  unfold deliver headPower
  have := r.lift_pos.ne'
  field_simp

/-- **Lift is paid for in flow.**  A ram lifting `k` times its own fall
delivers at most a `k`-th of its drive water. -/
theorem ram_lift_costs_flow {k : ℝ} (hk : 0 < k) (h : r.lift = k * r.fall) :
    r.deliver ≤ r.drive / k := by
  unfold deliver
  have h1 : r.eff ≤ 1 := r.eff_le_one
  have h2 : 0 < r.drive := r.drive_pos
  have h3 : 0 < r.fall := r.fall_pos
  rw [h, div_le_div_iff₀ (mul_pos hk h3) hk]
  nlinarith [mul_pos (mul_pos hk h3) h2, mul_nonneg (sub_nonneg.2 h1) (mul_pos h2 h3).le]

/-- The ram never delivers more water than it is given. -/
theorem deliver_lt_drive (h : r.fall < r.lift) : r.deliver < r.drive := by
  unfold deliver
  have h1 : r.eff ≤ 1 := r.eff_le_one
  have h2 : 0 < r.drive := r.drive_pos
  have h3 : 0 < r.fall := r.fall_pos
  rw [div_lt_iff₀ r.lift_pos]
  nlinarith [mul_pos h2 (sub_pos.2 h), mul_nonneg (sub_nonneg.2 h1) (mul_pos h2 h3).le]

end RamPump

/-- A village ram: ten litres a second falling two metres, 60 % efficient,
lifting to a tank twenty metres up. -/
def villageRam : RamPump :=
  ⟨0.01, 2, 20, 0.6, by norm_num, by norm_num, by norm_num, by norm_num, by norm_num⟩

/-- It delivers 0.6 litres a second — fifty cubic metres a day, with no fuel
and no attention. -/
theorem villageRam_deliver : villageRam.deliver = 0.0006 := by
  unfold RamPump.deliver villageRam
  norm_num

/-- Fifty cubic metres a day, in fact more: enough for a village and its
garden. -/
theorem villageRam_daily : 50 < villageRam.deliver * 86400 := by
  rw [villageRam_deliver]
  norm_num

/-! ## Water as a battery -/

/-- Energy stored by lifting `V` cubic metres of water a height `H`, in
watt-hours. -/
def storedEnergy (V H : ℝ) : ℝ := waterDensity * gravity * V * H / 3600

/-- A ten cubic metre tank twenty metres up holds about half a kilowatt-hour
— 545 watt-hours: a buffer for the mill, not a substitute for it. -/
theorem village_tank_energy_bounds :
    540 < storedEnergy 10 20 ∧ storedEnergy 10 20 < 550 := by
  unfold storedEnergy waterDensity gravity
  constructor <;> norm_num

/-- **The tank is a small battery.**  A 3 kW workshop would empty it in eleven
minutes; what the tank is really for is to hold the *water*, and to let a
250-watt ram or windmill fill it all day for a burst in the evening. -/
theorem tank_runs_shop_for_minutes : storedEnergy 10 20 / 3000 * 3600 < 700 := by
  unfold storedEnergy waterDensity gravity
  norm_num

/-- **A windmill fills the tank.**  A 250 W pumping windmill running eight
hours a day puts up two kilowatt-hours, three times what the tank holds — so
the tank overflows long before the wind gives out. -/
theorem windmill_overfills_tank : 3 * storedEnergy 10 20 < 250 * 8 := by
  unfold storedEnergy waterDensity gravity
  norm_num

end

end Renewable
end LifeTrac
