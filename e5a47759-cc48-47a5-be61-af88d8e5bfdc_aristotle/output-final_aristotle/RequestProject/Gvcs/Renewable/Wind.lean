import Mathlib

/-!
# Wind: windmills, and the Betz limit

The workshop of this project has so far been fed by wood, by photovoltaics and
by the head of a solar-lifted water tank.  This file adds the oldest prime
mover of all: a rotor in a moving fluid.

The theory is the one-dimensional **actuator disc**.  A stream of density `ρ`
crossing an area `A` at speed `v` carries the kinetic power

```
P_wind = ½ ρ A v³
```

(`streamPower`).  A rotor slows the stream down: writing `a` for the *axial
induction factor*, the air at the disc moves at `v(1−a)` and far downstream at
`v(1−2a)`.  Mass conservation and the momentum theorem then give the power
taken out of the stream as

```
P = 2 ρ A v³ a (1−a)²  =  C_p(a) · P_wind,     C_p(a) = 4a(1−a)²
```

(`discPower`, `discPower_eq_coeff`).  The main theorem, **Betz's law**
(`powerCoeff_le_betz`, `betz_limit`), is that `C_p ≤ 16/27`: *no* rotor, of any
design, can take more than about 59.3 % of the wind that blows through it, and
the bound is attained exactly when the rotor slows the wind to two thirds of
free stream at the disc and one third far downstream
(`powerCoeff_eq_betz_iff`, `betz_disc_speed`, `betz_wake_speed`).

Everything else here is the practical arithmetic that follows: power goes as
the *cube* of the wind speed and the *square* of the rotor diameter
(`streamPower_speed_scale`, `rotorPower_radius_scale`), the shaft torque at a
given tip-speed ratio (`torque_eq`), the thrust the tower has to carry and its
own maximum (`thrust_le_max`), and a worked 6-metre farm windmill and a
water-current turbine of the same size — the same theory serves both, because
nothing above knows whether the fluid is air or water (`waterRotor_beats_windRotor`).
-/

namespace LifeTrac
namespace Renewable

open Real

noncomputable section

/-! ## The power in a moving stream -/

/-- Kinetic power carried by a stream of density `ρ` (kg/m³) crossing an area
`A` (m²) at speed `v` (m/s): `½ ρ A v³`, in watts. -/
def streamPower (ρ A v : ℝ) : ℝ := ρ * A * v ^ 3 / 2

/-- Area swept by a rotor of radius `R`. -/
def discArea (R : ℝ) : ℝ := π * R ^ 2

theorem discArea_pos {R : ℝ} (hR : 0 < R) : 0 < discArea R :=
  mul_pos pi_pos (pow_pos hR 2)

theorem discArea_nonneg {R : ℝ} (hR : 0 ≤ R) : 0 ≤ discArea R :=
  mul_nonneg pi_pos.le (pow_nonneg hR 2)

theorem streamPower_nonneg {ρ A v : ℝ} (hρ : 0 ≤ ρ) (hA : 0 ≤ A) (hv : 0 ≤ v) :
    0 ≤ streamPower ρ A v := by
  have : 0 ≤ v ^ 3 := pow_nonneg hv 3
  unfold streamPower; positivity

theorem streamPower_pos {ρ A v : ℝ} (hρ : 0 < ρ) (hA : 0 < A) (hv : 0 < v) :
    0 < streamPower ρ A v := by
  unfold streamPower; positivity

/-- **The cube law.**  Doubling the wind speed multiplies the available power
by eight. -/
theorem streamPower_speed_scale (ρ A v c : ℝ) :
    streamPower ρ A (c * v) = c ^ 3 * streamPower ρ A v := by
  unfold streamPower; ring

/-- **The square law.**  Doubling the rotor radius — or the diameter —
quadruples the available power. -/
theorem rotorPower_radius_scale (ρ v R c : ℝ) :
    streamPower ρ (discArea (c * R)) v = c ^ 2 * streamPower ρ (discArea R) v := by
  unfold streamPower discArea; ring

/-- Power is strictly increasing in the wind speed. -/
theorem streamPower_strictMono {ρ A v w : ℝ} (hρ : 0 < ρ) (hA : 0 < A)
    (hv : 0 ≤ v) (hvw : v < w) : streamPower ρ A v < streamPower ρ A w := by
  have hw : 0 < w := lt_of_le_of_lt hv hvw
  have h3 : v ^ 3 < w ^ 3 := by
    nlinarith [mul_pos (sub_pos.2 hvw) (by positivity : (0:ℝ) < w ^ 2 + w * v + v ^ 2)]
  unfold streamPower
  have : ρ * A > 0 := mul_pos hρ hA
  nlinarith

/-! ## The actuator disc -/

/-- Speed of the fluid at the disc, for axial induction factor `a`. -/
def discSpeed (v a : ℝ) : ℝ := v * (1 - a)

/-- Speed of the fluid far downstream, for axial induction factor `a`: the
disc takes half its total slowing-down before the rotor and half after it. -/
def wakeSpeed (v a : ℝ) : ℝ := v * (1 - 2 * a)

/-- The speed at the disc is the mean of the free-stream and wake speeds —
the content of the momentum theorem for an actuator disc. -/
theorem discSpeed_eq_mean (v a : ℝ) : discSpeed v a = (v + wakeSpeed v a) / 2 := by
  unfold discSpeed wakeSpeed; ring

/-- The **power coefficient** of an actuator disc: the fraction of the stream
power that a disc with induction factor `a` extracts. -/
def powerCoeff (a : ℝ) : ℝ := 4 * a * (1 - a) ^ 2

/-- Power extracted by an actuator disc of area `A` from a stream of density
`ρ` and speed `v` at induction factor `a`.  It is the mass flow `ρ A v(1−a)`
times the loss of kinetic energy per unit mass `½(v² − v²(1−2a)²)`. -/
def discPower (ρ A v a : ℝ) : ℝ := 2 * ρ * A * v ^ 3 * a * (1 - a) ^ 2

/-- The extracted power is indeed mass flow times the drop in specific kinetic
energy across the disc. -/
theorem discPower_eq_massFlow (ρ A v a : ℝ) :
    discPower ρ A v a =
      (ρ * A * discSpeed v a) * ((v ^ 2 - wakeSpeed v a ^ 2) / 2) := by
  unfold discPower discSpeed wakeSpeed; ring

/-- The extracted power is the power coefficient times the stream power. -/
theorem discPower_eq_coeff (ρ A v a : ℝ) :
    discPower ρ A v a = powerCoeff a * streamPower ρ A v := by
  unfold discPower powerCoeff streamPower; ring

/-- **Betz's law.**  The power coefficient of an actuator disc never exceeds
`16/27 ≈ 0.593`.  (The hypothesis `a ≤ 4/3` is far weaker than the physical
range `0 ≤ a ≤ 1`; beyond `a = 1/2` the momentum theory has already broken
down, because the wake would flow backwards.) -/
theorem powerCoeff_le_betz {a : ℝ} (ha : a ≤ 4 / 3) : powerCoeff a ≤ 16 / 27 := by
  have key : 16 / 27 - powerCoeff a = 4 * (a - 1 / 3) ^ 2 * (4 / 3 - a) := by
    unfold powerCoeff; ring
  nlinarith [sq_nonneg (a - 1 / 3)]

/-- The Betz optimum: an induction factor of one third. -/
theorem powerCoeff_third : powerCoeff (1 / 3) = 16 / 27 := by
  unfold powerCoeff; norm_num

/-- The Betz value is attained *only* at `a = 1/3`. -/
theorem powerCoeff_eq_betz_iff {a : ℝ} (ha : a < 4 / 3) :
    powerCoeff a = 16 / 27 ↔ a = 1 / 3 := by
  constructor
  · intro h
    have key : 4 * (a - 1 / 3) ^ 2 * (4 / 3 - a) = 0 := by
      have : 16 / 27 - powerCoeff a = 4 * (a - 1 / 3) ^ 2 * (4 / 3 - a) := by
        unfold powerCoeff; ring
      linarith [this, h]
    have h1 : (a - 1 / 3) ^ 2 = 0 := by
      rcases mul_eq_zero.1 key with h2 | h2
      · rcases mul_eq_zero.1 h2 with h3 | h3
        · norm_num at h3
        · exact h3
      · linarith
    have := pow_eq_zero_iff (n := 2) (by norm_num) |>.1 h1
    linarith
  · rintro rfl; exact powerCoeff_third

/-- **The Betz limit in power.**  A rotor of swept area `A` takes at most
`16/27` of the wind power crossing it. -/
theorem betz_limit {ρ A v a : ℝ} (hρ : 0 ≤ ρ) (hA : 0 ≤ A) (hv : 0 ≤ v)
    (ha : a ≤ 4 / 3) :
    discPower ρ A v a ≤ 16 / 27 * streamPower ρ A v := by
  rw [discPower_eq_coeff]
  exact mul_le_mul_of_nonneg_right (powerCoeff_le_betz ha)
    (streamPower_nonneg hρ hA hv)

/-- At the Betz optimum the wind leaves the disc at two thirds of free
stream. -/
theorem betz_disc_speed (v : ℝ) : discSpeed v (1 / 3) = 2 * v / 3 := by
  unfold discSpeed; ring

/-- ...and one third of free stream far downstream. -/
theorem betz_wake_speed (v : ℝ) : wakeSpeed v (1 / 3) = v / 3 := by
  unfold wakeSpeed; ring

/-- A rotor that stopped the wind dead (`a = 1/2`, wake at rest) would take
only half of it: no flow means no power. -/
theorem powerCoeff_half : powerCoeff (1 / 2) = 1 / 2 := by
  unfold powerCoeff; norm_num

/-- A rotor that does not slow the wind at all takes nothing. -/
theorem powerCoeff_zero : powerCoeff 0 = 0 := by unfold powerCoeff; norm_num

/-! ## Thrust on the tower -/

/-- Axial thrust on the disc, `2 ρ A v² a (1−a)`: the momentum the rotor takes
out of the stream per unit time, which the tower has to carry. -/
def discThrust (ρ A v a : ℝ) : ℝ := 2 * ρ * A * v ^ 2 * a * (1 - a)

/-- Thrust coefficient, referred to the dynamic pressure on the disc. -/
def thrustCoeff (a : ℝ) : ℝ := 4 * a * (1 - a)

theorem discThrust_eq_coeff (ρ A v a : ℝ) :
    discThrust ρ A v a = thrustCoeff a * (ρ * A * v ^ 2 / 2) := by
  unfold discThrust thrustCoeff; ring

/-- **The thrust maximum.**  Unlike the power coefficient, the thrust
coefficient of the momentum theory peaks at `a = 1/2`, where it equals one:
the tower load is at worst the full dynamic pressure on the disc. -/
theorem thrustCoeff_le_one (a : ℝ) : thrustCoeff a ≤ 1 := by
  have : 1 - thrustCoeff a = (2 * a - 1) ^ 2 := by unfold thrustCoeff; ring
  nlinarith [sq_nonneg (2 * a - 1)]

theorem thrustCoeff_half : thrustCoeff (1 / 2) = 1 := by unfold thrustCoeff; norm_num

theorem thrust_le_max {ρ A v a : ℝ} (hρ : 0 ≤ ρ) (hA : 0 ≤ A) :
    discThrust ρ A v a ≤ ρ * A * v ^ 2 / 2 := by
  rw [discThrust_eq_coeff]
  have h : 0 ≤ ρ * A * v ^ 2 / 2 := by positivity
  nlinarith [thrustCoeff_le_one a]

/-- At the Betz optimum the thrust coefficient is `8/9`. -/
theorem thrustCoeff_betz : thrustCoeff (1 / 3) = 8 / 9 := by
  unfold thrustCoeff; norm_num

/-! ## Shaft torque and tip-speed ratio -/

/-- Tip-speed ratio: the speed of the blade tip divided by the wind speed. -/
def tipSpeedRatio (ω R v : ℝ) : ℝ := ω * R / v

/-- Shaft torque of a rotor running at angular speed `ω` and delivering power
`P`.  With `P = C_p · ½ρπR²v³` and `λ = ωR/v` this is the standard
`τ = C_p/λ · ½ ρ π R³ v²`. -/
theorem torque_eq {ρ v R ω Cp : ℝ} (hω : ω ≠ 0) (hv : v ≠ 0) (hR : R ≠ 0) :
    Cp * streamPower ρ (discArea R) v / ω =
      Cp / tipSpeedRatio ω R v * (ρ * π * R ^ 3 * v ^ 2 / 2) := by
  unfold streamPower discArea tipSpeedRatio
  field_simp

/-- A slow rotor makes big torque: at fixed power, halving the shaft speed
doubles the torque. -/
theorem torque_antitone {P ω₁ ω₂ : ℝ} (hP : 0 < P) (h₁ : 0 < ω₁) (h : ω₁ < ω₂) :
    P / ω₂ < P / ω₁ := by
  exact div_lt_div_of_pos_left hP h₁ h

/-! ## A farm windmill, and the same rotor in a stream -/

/-- Density of air at sea level, kg/m³. -/
def airDensity : ℝ := 1.225

/-- Density of fresh water, kg/m³. -/
def waterDensity : ℝ := 1000

/-- A six-metre rotor: `R = 3 m`. -/
def farmRotorRadius : ℝ := 3

/-- A realistic three-blade machine reaches about 40 % of the wind power —
two thirds of the Betz limit. -/
def farmRotorCp : ℝ := 0.4

theorem farmRotorCp_le_betz : farmRotorCp ≤ 16 / 27 := by
  unfold farmRotorCp; norm_num

/-- Shaft power of the farm windmill in a wind of speed `v`. -/
def windmillPower (v : ℝ) : ℝ :=
  farmRotorCp * streamPower airDensity (discArea farmRotorRadius) v

/-- In a fresh breeze of 8 m/s the six-metre windmill makes between 3.5 and
3.6 kilowatts. -/
theorem windmillPower_eight : 3500 < windmillPower 8 ∧ windmillPower 8 < 3600 := by
  unfold windmillPower streamPower discArea farmRotorCp airDensity farmRotorRadius
  constructor <;> nlinarith [pi_gt_d6, pi_lt_d2]

/-- The windmill is physically admissible: it stays under the Betz limit. -/
theorem windmillPower_le_betz {v : ℝ} (hv : 0 ≤ v) :
    windmillPower v ≤ 16 / 27 * streamPower airDensity (discArea farmRotorRadius) v := by
  unfold windmillPower
  have hs : 0 ≤ streamPower airDensity (discArea farmRotorRadius) v :=
    streamPower_nonneg (by unfold airDensity; norm_num)
      (discArea_nonneg (by unfold farmRotorRadius; norm_num)) hv
  exact mul_le_mul_of_nonneg_right farmRotorCp_le_betz hs

/-- A calm day is worth almost nothing: at 4 m/s the same machine makes an
eighth of its 8 m/s output. -/
theorem windmill_halved_wind (v : ℝ) : windmillPower v = 8 * windmillPower (v / 2) := by
  unfold windmillPower streamPower
  ring

/-- Nothing in the actuator-disc theory knows whether the fluid is air or
water.  **A water current is worth vastly more than a wind of the same
speed**: at equal speed and equal disc, the ratio of the powers is the ratio of
the densities, more than eight hundred to one. -/
theorem waterRotor_beats_windRotor {A v : ℝ} (hA : 0 < A) (hv : 0 < v) :
    800 * streamPower airDensity A v < streamPower waterDensity A v := by
  unfold streamPower airDensity waterDensity
  have h3 : 0 < v ^ 3 := pow_pos hv 3
  nlinarith

/-- A two-metre-radius water wheel in a 1.5 m/s stream, at the same 40 %
coefficient, makes more than three kilowatts — the power of a small
workshop. -/
theorem streamTurbine_power :
    3000 < farmRotorCp * streamPower waterDensity (discArea 2) 1.5 := by
  unfold farmRotorCp streamPower waterDensity discArea
  nlinarith [pi_gt_d6]

/-! ## Energy over time, and the capacity factor -/

/-- Energy, in watt-hours, produced by a constant power `P` (watts) over `h`
hours. -/
def energyOver (P h : ℝ) : ℝ := P * h

/-- Capacity factor: mean output divided by rated output. -/
def capacityFactor (mean rated : ℝ) : ℝ := mean / rated

theorem capacityFactor_le_one {mean rated : ℝ} (h : 0 < rated) (hm : mean ≤ rated) :
    capacityFactor mean rated ≤ 1 :=
  (div_le_one h).2 hm

/-- **The cube law is why siting matters.**  A site with 25 % more wind yields
almost twice the energy: `1.25³ ≈ 1.95`. -/
theorem windier_site_yield (ρ A v : ℝ) (hρ : 0 < ρ) (hA : 0 < A) (hv : 0 < v) :
    1.9 * streamPower ρ A v < streamPower ρ A (1.25 * v) := by
  rw [streamPower_speed_scale]
  have h : 0 < streamPower ρ A v := streamPower_pos hρ hA hv
  nlinarith

end

end Renewable
end LifeTrac
