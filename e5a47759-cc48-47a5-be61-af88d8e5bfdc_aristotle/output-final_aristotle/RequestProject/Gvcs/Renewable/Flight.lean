import RequestProject.Gvcs.Renewable.Rotor

/-!
# Wings, and the drone that never lands

`Renewable/Rotor.lean` is about machines that hold themselves up by throwing
air downwards.  A wing does the same job by moving forwards, and it is far
cheaper: this file proves how much cheaper, and what follows.

* `levelPower k b v = k v³ + b/v` — the two halves of the drag of any aircraft:
  parasite drag, growing as the cube of speed, and induced drag, the price of
  making lift, falling as the inverse of it.  `levelPower_min` finds the
  **minimum-power speed** exactly: it is the speed at which `3k v⁴ = b`, i.e.
  where induced drag is three times parasite drag, and `minPowerSpeed_spec`
  shows such a speed exists.  `levelPower_min_value` gives the power there.
* `rangeSpeed_gt_endurancePower_speed`: the speed that maximises *range* is
  `⁴√3 ≈ 1.32` times the speed that maximises *endurance*.  Fly slow to loiter,
  faster to travel — the two are not the same speed, and the ratio is a pure
  number.
* `cruisePower`: at a glide ratio `L/D`, holding a weight `W` up at speed `v`
  costs `W v /(L/D)` — and `wing_beats_rotor` puts numbers on it: the same two
  kilograms that cost a quadcopter 170 watts to hover cost a wing **twenty**
  to cruise.
* `SolarAircraft`: wings covered in cells.  `perpetual_flight_iff` is the
  condition for a solar aeroplane to fly for ever — panel area times irradiance
  times efficiency at least the power to stay up — and the pair
  `solarWing_flies_forever` / `solarQuadcopter_cannot` shows that the wing
  clears it three times over while the rotorcraft, on the same wing area and
  the same sun, is not close.
-/

namespace LifeTrac
namespace Renewable

open Real

noncomputable section

/-! ## The power curve of a wing -/

/-- Power required for level flight: parasite drag `k v³` plus induced drag
`b / v`. -/
def levelPower (k b v : ℝ) : ℝ := k * v ^ 3 + b / v

/-- The minimum-power speed: where `3 k v⁴ = b`. -/
def IsMinPowerSpeed (k b u : ℝ) : Prop := 0 < u ∧ 3 * k * u ^ 4 = b

/-- Such a speed exists for any real aircraft. -/
theorem minPowerSpeed_spec {k b : ℝ} (hk : 0 < k) (hb : 0 < b) :
    IsMinPowerSpeed k b ((b / (3 * k)) ^ ((1 : ℝ) / 4)) := by
  have hpos : 0 < b / (3 * k) := by positivity
  refine ⟨rpow_pos_of_pos hpos _, ?_⟩
  have h4 : ((b / (3 * k)) ^ ((1 : ℝ) / 4)) ^ (4 : ℕ) = b / (3 * k) := by
    rw [← rpow_natCast ((b / (3 * k)) ^ ((1 : ℝ) / 4)) 4, ← rpow_mul hpos.le]
    norm_num
  rw [h4]
  field_simp

/-- **The minimum-power speed really is the minimum.**  At the speed where
induced drag is three times parasite drag, no other speed does better. -/
theorem levelPower_min {k b u v : ℝ} (hk : 0 < k)
    (hu : IsMinPowerSpeed k b u) (hv : 0 < v) :
    levelPower k b u ≤ levelPower k b v := by
  obtain ⟨hu0, hub⟩ := hu
  unfold levelPower
  rw [← hub]
  have key : k * v ^ 3 + 3 * k * u ^ 4 / v - (k * u ^ 3 + 3 * k * u ^ 4 / u)
      = k * (v - u) ^ 2 * (v ^ 2 + 2 * u * v + 3 * u ^ 2) / v := by
    field_simp
    ring
  have h1 : 0 ≤ k * (v - u) ^ 2 * (v ^ 2 + 2 * u * v + 3 * u ^ 2) / v := by
    have : 0 ≤ v ^ 2 + 2 * u * v + 3 * u ^ 2 := by nlinarith [sq_nonneg (u + v)]
    positivity
  linarith [key, h1]

/-- The power at the minimum-power speed. -/
theorem levelPower_min_value {k b u : ℝ} (hu : IsMinPowerSpeed k b u) :
    levelPower k b u = 4 * k * u ^ 3 := by
  obtain ⟨hu0, hub⟩ := hu
  unfold levelPower
  rw [← hub]
  field_simp
  ring

/-- The speed for greatest *range* is where drag itself, not power, is least:
`k v⁴ = b`. -/
def IsRangeSpeed (k b u : ℝ) : Prop := 0 < u ∧ k * u ^ 4 = b

/-- **Fly slow to loiter, faster to travel.**  The best-range speed is the
fourth root of three — about 1.32 — times the best-endurance speed. -/
theorem rangeSpeed_gt_endurancePower_speed {k b u w : ℝ} (hk : 0 < k)
    (hu : IsMinPowerSpeed k b u) (hw : IsRangeSpeed k b w) : u < w ∧ w ^ 4 = 3 * u ^ 4 := by
  obtain ⟨hu0, hub⟩ := hu
  obtain ⟨hw0, hwb⟩ := hw
  have h4 : w ^ 4 = 3 * u ^ 4 := by
    have h : k * w ^ 4 = k * (3 * u ^ 4) := by rw [hwb, ← hub]; ring
    exact mul_left_cancel₀ hk.ne' h
  refine ⟨?_, h4⟩
  by_contra hcon
  push_neg at hcon
  have hle : w ^ 4 ≤ u ^ 4 := pow_le_pow_left₀ hw0.le hcon 4
  have := pow_pos hu0 4
  linarith

/-! ## Glide ratio -/

/-- Power to keep a weight `W` flying at speed `v` with lift-to-drag ratio
`ld`: drag is `W / ld`, and power is drag times speed. -/
def cruisePower (W v ld : ℝ) : ℝ := W * v / ld

/-- A better glider costs less power. -/
theorem cruisePower_antitone_ld {W v a c : ℝ} (hW : 0 < W) (hv : 0 < v)
    (ha : 0 < a) (h : a < c) : cruisePower W v c < cruisePower W v a := by
  unfold cruisePower
  exact div_lt_div_of_pos_left (by positivity) ha h

/-- **A wing is an order of magnitude cheaper than a rotor.**  Two kilograms
at a glide ratio of twelve, cruising at twelve metres a second, need under
twenty-five watts; the same two kilograms hovering on 25 cm propellers need
more than a hundred and seventy. -/
theorem wing_beats_rotor :
    cruisePower 19.62 12 12 < hoverPower 19.62 airDensity 0.196 := by
  have h := quadcopter_hoverPower_bounds.1
  unfold cruisePower
  norm_num
  linarith

/-! ## The solar aeroplane -/

/-- A solar aircraft: wing area carrying cells, cell efficiency, the
irradiance of the day, and the power it needs to stay up. -/
structure SolarAircraft where
  /-- Area of cells, m². -/
  cellArea : ℝ
  /-- Cell efficiency. -/
  cellEff : ℝ
  /-- Irradiance, W/m². -/
  irradiance : ℝ
  /-- Power needed to stay airborne, W. -/
  needed : ℝ

namespace SolarAircraft

variable (a : SolarAircraft)

/-- Electrical power the wing collects. -/
def collected : ℝ := a.cellArea * a.cellEff * a.irradiance

/-- **The condition for flight without landing**: collect at least what you
spend. -/
def FliesForever : Prop := a.needed ≤ a.collected

theorem perpetual_flight_iff :
    a.FliesForever ↔ a.needed ≤ a.cellArea * a.cellEff * a.irradiance := Iff.rfl

/-- More cells never hurt. -/
theorem collected_mono {b : SolarAircraft} (hEff : 0 ≤ a.cellEff)
    (hG : 0 ≤ a.irradiance) (h1 : a.cellArea ≤ b.cellArea)
    (h2 : a.cellEff = b.cellEff) (h3 : a.irradiance = b.irradiance) :
    a.collected ≤ b.collected := by
  unfold collected
  rw [← h2, ← h3]
  have : 0 ≤ a.cellEff * a.irradiance := mul_nonneg hEff hG
  nlinarith

end SolarAircraft

/-- The solar wing: half a square metre of 20 % cells on an 800 W/m² day,
needing 24.5 W to cruise. -/
def solarWing : SolarAircraft := ⟨0.5, 0.2, 800, cruisePower 19.62 12 12⟩

/-- The same cells and the same sun, but hovering: it needs more than 170 W. -/
def solarQuadcopter : SolarAircraft := ⟨0.5, 0.2, 800, hoverPower 19.62 airDensity 0.196⟩

/-- **The wing flies for ever.**  Eighty watts collected against under
twenty-five needed — it can fly all day and charge a battery for the night. -/
theorem solarWing_flies_forever : solarWing.FliesForever := by
  unfold SolarAircraft.FliesForever SolarAircraft.collected solarWing cruisePower
  norm_num

/-- ...with more than three times the margin it needs. -/
theorem solarWing_margin : 3 * solarWing.needed < solarWing.collected := by
  unfold SolarAircraft.collected solarWing cruisePower
  norm_num

/-- **The rotorcraft cannot.**  On the same wing area, the same cells and the
same sun, a hovering quadcopter of the same mass falls short by a factor of
two: sunlight will not keep a rotor in the air. -/
theorem solarQuadcopter_cannot : ¬ solarQuadcopter.FliesForever := by
  unfold SolarAircraft.FliesForever SolarAircraft.collected solarQuadcopter
  have h := quadcopter_hoverPower_bounds.1
  push_neg
  norm_num
  linarith

end

end Renewable
end LifeTrac
