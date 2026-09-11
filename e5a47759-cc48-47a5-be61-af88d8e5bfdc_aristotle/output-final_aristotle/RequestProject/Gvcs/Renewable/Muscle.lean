import Mathlib

/-!
# Muscle: pedals, oxen and the land they eat

Before the wind and the sun there was muscle, and a workshop that has neither
mains nor fuel still has muscle.  This file gives the arithmetic of the two
kinds that matter — a person on pedals, and a grazing animal in a yoke — and
compares them, honestly, with each other and with the land they need.

**Pedals.**  `humanContinuous = 75 W` all day, `humanHour = 150 W` for an hour,
`humanSprint = 700 W` for seconds.  A chain drive keeps 95 % of it
(`pedalShaftPower`).  What that buys is small: `litre_of_diesel_is_a_month` —
one litre of diesel carries as much energy as **133 hours** of pedalling, so a
five-litre jerrycan is a person-year of legs.  The crank is a lever
(`pedalForce_eq`), and at a given power the pedal force falls as the cadence
rises (`pedalForce_antitone_cadence`) — the reason cyclists spin.  A flywheel
smooths the pulses, and `flywheel_burst_ok` bounds the burst it can supply.

**Draft animals.**  A `DraftAnimal` pulls a fixed fraction of its own weight
and walks at a fixed speed, so `pull = f·m·g` and `power = pull·speed`.  A
600 kg ox at 12 % and 0.9 m/s makes 636 W and 3.2 kWh in a five-hour day
(`ox_power_bounds`, `ox_dailyWork_bounds`); it is worth **eight pedallers**
(`ox_beats_eight_pedallers`).  A horse comes out at almost exactly one
horsepower (`horse_is_one_horsepower`) — which is the definition working as
intended.  Yoked in a team the animals get in each other's way; the total is
maximised at **seven** (`team_max_at_seven`), while the power per animal falls
from the first extra one (`teamFactor_strictAnti`).

**The land.**  The ox eats 2.5 % of its body mass in dry matter every day and
turns under 8 % of that feed energy into work (`ox_feed_efficiency_lt_eight_percent`).
At five tonnes of dry matter per hectare a year it grazes 1.1 ha
(`ox_hectares_bounds`) for some 800 kWh of work a year.  Photovoltaics on the
same hectare would return hundreds of times that (`pv_land_beats_oxen`) — and
yet the ox is not beaten, because it also returns 50 kg of nitrogen a year in
its manure, whose embodied energy is comparable to all the work it does
(`manure_worth_as_much_as_the_work`), and because it builds itself out of grass.
-/

namespace LifeTrac
namespace Renewable

/-! ## People on pedals -/

/-- Standard gravity, m/s². -/
def gee : ℚ := 981 / 100

/-- Mechanical power a fit adult sustains for a working day, watts. -/
def humanContinuous : ℚ := 75

/-- Power the same adult holds for about an hour, watts. -/
def humanHour : ℚ := 150

/-- Power for a few seconds, watts. -/
def humanSprint : ℚ := 700

/-- Efficiency of a chain drive from pedal to output shaft. -/
def chainEff : ℚ := 19 / 20

/-- Shaft power delivered by a pedalling human. -/
def pedalShaftPower (pedal : ℚ) : ℚ := chainEff * pedal

theorem pedalShaftPower_lt {p : ℚ} (hp : 0 < p) : pedalShaftPower p < p := by
  unfold pedalShaftPower chainEff; linarith

/-- A four-hour stint on the pedals: 285 watt-hours at the shaft, under a
third of a kilowatt-hour. -/
theorem pedal_day_energy : pedalShaftPower humanContinuous * 4 = 285 := by
  unfold pedalShaftPower chainEff humanContinuous; norm_num

/-- Energy in one litre of diesel, watt-hours. -/
def dieselLitre : ℚ := 10000

/-- **One litre of diesel is three and a half working weeks of legs.**  It
takes more than 133 hours of continuous pedalling to match a single litre. -/
theorem litre_of_diesel_is_a_month :
    133 < dieselLitre / humanContinuous ∧ dieselLitre / humanContinuous < 134 := by
  unfold dieselLitre humanContinuous; constructor <;> norm_num

/-- Five litres of fuel is half a year of legs: at four hours of pedalling a
day it takes more than a hundred and sixty-five days to replace one jerrycan. -/
theorem jerrycan_is_half_a_year : 165 < 5 * dieselLitre / (humanContinuous * 4) := by
  unfold dieselLitre humanContinuous; norm_num

/-! ### The crank -/

noncomputable section

open Real

/-- Angular speed of a crank turning at `rpm` revolutions per minute. -/
def crankSpeed (rpm : ℝ) : ℝ := 2 * π * rpm / 60

/-- The force on the pedal that delivers power `p` at crank radius `r` and
cadence `rpm`. -/
def pedalForce (p r rpm : ℝ) : ℝ := p / (r * crankSpeed rpm)

/-- Power is force times pedal speed — the crank is a lever like any other. -/
theorem pedalForce_eq {p r rpm : ℝ} (hr : 0 < r) (hrpm : 0 < rpm) :
    pedalForce p r rpm * (r * crankSpeed rpm) = p := by
  unfold pedalForce crankSpeed
  have : r * (2 * π * rpm / 60) ≠ 0 := by
    have := pi_pos
    positivity
  field_simp

/-- **Spin, don't grind.**  At a fixed power a higher cadence needs a smaller
pedal force. -/
theorem pedalForce_antitone_cadence {p r a b : ℝ} (hp : 0 < p) (hr : 0 < r)
    (ha : 0 < a) (hab : a < b) : pedalForce p r b < pedalForce p r a := by
  have hpi := pi_pos
  unfold pedalForce crankSpeed
  apply div_lt_div_of_pos_left hp (by positivity)
  have : 2 * π * a / 60 < 2 * π * b / 60 := by
    apply div_lt_div_of_pos_right _ (by norm_num)
    nlinarith
  nlinarith

/-- Kinetic energy stored in a flywheel of moment of inertia `I` turning at
`ω`. -/
def flywheelEnergy (I ω : ℝ) : ℝ := I * ω ^ 2 / 2

/-- Angular speed left after a flywheel gives up `W` joules. -/
def flywheelAfter (I ω W : ℝ) : ℝ := √(ω ^ 2 - 2 * W / I)

/-- **What a flywheel can lend.**  If the burst of work asked of it is no more
than its stored energy, the flywheel survives it, and its residual speed
satisfies the energy balance exactly. -/
theorem flywheel_burst_ok {I ω W : ℝ} (hI : 0 < I)
    (h : W ≤ flywheelEnergy I ω) :
    flywheelEnergy I (flywheelAfter I ω W) = flywheelEnergy I ω - W := by
  unfold flywheelEnergy flywheelAfter at *
  have hnn : 0 ≤ ω ^ 2 - 2 * W / I := by
    rw [sub_nonneg, div_le_iff₀ hI]
    nlinarith
  rw [sq_sqrt hnn]
  field_simp

end

/-! ## Animals in a yoke -/

/-- A draft animal, described by what it weighs, what fraction of its weight
it can pull all day, how fast it walks and how long it works. -/
structure DraftAnimal where
  /-- Body mass, kg. -/
  mass : ℚ
  /-- Sustained pull as a fraction of body weight. -/
  pullFrac : ℚ
  /-- Working speed, m/s. -/
  speed : ℚ
  /-- Working hours per day. -/
  hours : ℚ

namespace DraftAnimal

variable (a : DraftAnimal)

/-- Sustained drawbar pull, newtons. -/
def pull : ℚ := a.pullFrac * a.mass * gee

/-- Sustained mechanical power, watts. -/
def power : ℚ := a.pull * a.speed

/-- Work done in a day, watt-hours. -/
def dailyWork : ℚ := a.power * a.hours

/-- Dry matter eaten per day, kg: two and a half per cent of body mass. -/
def feedDM : ℚ := a.mass / 40

/-- Energy in that feed, watt-hours, at 10 MJ of metabolisable energy per
kilogram of dry matter. -/
def feedEnergy : ℚ := a.feedDM * 2778

/-- Fraction of the feed energy that comes back out of the yoke. -/
def feedEfficiency : ℚ := a.dailyWork / a.feedEnergy

/-- Dry matter of manure per day, kg: about 60 % of intake. -/
def manureDM : ℚ := 3 * a.feedDM / 5

/-- Nitrogen returned per day, kg, at 1.5 % of manure dry matter. -/
def manureN : ℚ := 3 * a.manureDM / 200

theorem pull_pos (hm : 0 < a.mass) (hf : 0 < a.pullFrac) : 0 < a.pull := by
  unfold pull gee; positivity

/-- **Power is proportional to body weight**: two animals of the same build
and gait pull in proportion to their mass. -/
theorem power_scale (c : ℚ) :
    ({a with mass := c * a.mass} : DraftAnimal).power = c * a.power := by
  unfold power pull; simp; ring

end DraftAnimal

/-- A working ox: 600 kg, pulling 12 % of its weight at 0.9 m/s, five hours a
day. -/
def ox : DraftAnimal := ⟨600, 3 / 25, 9 / 10, 5⟩

/-- A working horse: 700 kg, 11 % at 1 m/s, six hours a day. -/
def horse : DraftAnimal := ⟨700, 11 / 100, 1, 6⟩

/-- A house cow put to light work: 450 kg, 10 % at 0.7 m/s, four hours. -/
def cow : DraftAnimal := ⟨450, 1 / 10, 7 / 10, 4⟩

/-- The ox pulls just over 700 newtons and makes just over 630 watts. -/
theorem ox_power_bounds : 630 < ox.power ∧ ox.power < 640 := by
  unfold DraftAnimal.power DraftAnimal.pull ox gee
  constructor <;> norm_num

theorem ox_pull_bounds : 700 < ox.pull ∧ ox.pull < 710 := by
  unfold DraftAnimal.pull ox gee
  constructor <;> norm_num

/-- A five-hour day of ox work is a little over three kilowatt-hours. -/
theorem ox_dailyWork_bounds : 3100 < ox.dailyWork ∧ ox.dailyWork < 3200 := by
  unfold DraftAnimal.dailyWork DraftAnimal.power DraftAnimal.pull ox gee
  constructor <;> norm_num

/-- **One ox is eight people.**  The ox delivers more than eight times what a
person sustains on pedals. -/
theorem ox_beats_eight_pedallers : 8 * humanContinuous < ox.power := by
  unfold DraftAnimal.power DraftAnimal.pull ox gee humanContinuous
  norm_num

/-- **A horse is one horsepower.**  Watt's unit, 746 W, is very close to what a
working horse actually sustains. -/
theorem horse_is_one_horsepower : 740 < horse.power ∧ horse.power < 760 := by
  unfold DraftAnimal.power DraftAnimal.pull horse gee
  constructor <;> norm_num

/-- The house cow is a third of an ox — real, but modest. -/
theorem cow_power_bounds : 300 < cow.power ∧ cow.power < 320 := by
  unfold DraftAnimal.power DraftAnimal.pull cow gee
  constructor <;> norm_num

/-! ### Teams -/

/-- Yoked together, animals lose about 7.5 % of their individual pull for
every extra animal in the team. -/
def teamFactor (n : ℕ) : ℚ := 1 - 3 / 40 * ((n : ℚ) - 1)

/-- Power of a team of `n` oxen. -/
def teamPower (n : ℕ) : ℚ := n * teamFactor n * ox.power

/-- Each extra animal costs every animal in the team. -/
theorem teamFactor_strictAnti {m n : ℕ} (h : m < n) : teamFactor n < teamFactor m := by
  unfold teamFactor
  have : (m : ℚ) < n := by exact_mod_cast h
  linarith

/-- A single animal pulls its full share. -/
theorem teamFactor_one : teamFactor 1 = 1 := by unfold teamFactor; norm_num

/-- **Seven is the biggest useful team.**  Among all teams of up to fourteen
oxen, none pulls harder than a team of seven. -/
theorem team_max_at_seven (n : ℕ) (h1 : 1 ≤ n) (h2 : n ≤ 14) :
    teamPower n ≤ teamPower 7 := by
  interval_cases n <;>
    simp only [teamPower, teamFactor, DraftAnimal.power, DraftAnimal.pull, ox, gee] <;>
    norm_num

/-- The eighth ox makes the team *weaker*. -/
theorem eighth_ox_is_a_loss : teamPower 8 < teamPower 7 := by
  simp only [teamPower, teamFactor, DraftAnimal.power, DraftAnimal.pull, ox, gee]
  norm_num

/-! ### Feed, land and manure -/

/-- The ox eats fifteen kilograms of dry matter a day. -/
theorem ox_feedDM : ox.feedDM = 15 := by unfold DraftAnimal.feedDM ox; norm_num

/-- **Muscle is a poor engine.**  Less than eight per cent of what the ox eats
comes back out of the yoke — worse than any heat engine in this project. -/
theorem ox_feed_efficiency_lt_eight_percent : ox.feedEfficiency < 2 / 25 := by
  unfold DraftAnimal.feedEfficiency DraftAnimal.dailyWork DraftAnimal.power
    DraftAnimal.pull DraftAnimal.feedEnergy DraftAnimal.feedDM ox gee
  norm_num

/-- Pasture yield, kg of dry matter per hectare per year. -/
def pastureYield : ℚ := 5000

/-- Hectares of pasture one animal needs. -/
def hectaresPerAnimal (a : DraftAnimal) : ℚ := a.feedDM * 365 / pastureYield

/-- Working days in the year. -/
def workingDays : ℚ := 250

/-- Work an animal does in a year, watt-hours. -/
def yearlyWork (a : DraftAnimal) : ℚ := a.dailyWork * workingDays

/-- The ox grazes about one and one tenth hectares. -/
theorem ox_hectares_bounds :
    1 < hectaresPerAnimal ox ∧ hectaresPerAnimal ox < 6 / 5 := by
  unfold hectaresPerAnimal DraftAnimal.feedDM ox pastureYield
  constructor <;> norm_num

/-- A year of ox work is about 800 kilowatt-hours. -/
theorem ox_yearlyWork_bounds : 780000 < yearlyWork ox ∧ yearlyWork ox < 800000 := by
  unfold yearlyWork workingDays DraftAnimal.dailyWork DraftAnimal.power
    DraftAnimal.pull ox gee
  constructor <;> norm_num

/-- Yearly electrical yield of one hectare of photovoltaics, watt-hours:
500 kW of modules at 1000 full-load hours. -/
def pvHectareYear : ℚ := 500000000

/-- Yearly shaft work from one hectare of pasture, watt-hours. -/
def oxHectareYear : ℚ := yearlyWork ox / hectaresPerAnimal ox

/-- **Sunlight beats grass by a factor of hundreds.**  A hectare of modules
returns more than five hundred times the shaft work a hectare of pasture does,
because the animal must first build and feed itself. -/
theorem pv_land_beats_oxen : 500 * oxHectareYear < pvHectareYear := by
  unfold oxHectareYear pvHectareYear yearlyWork workingDays hectaresPerAnimal
    pastureYield DraftAnimal.dailyWork DraftAnimal.power DraftAnimal.pull
    DraftAnimal.feedDM ox gee
  norm_num

/-- Embodied energy of one kilogram of nitrogen fertiliser, watt-hours
(about 50 MJ). -/
def nitrogenEnergy : ℚ := 13900

/-- Energy value of the nitrogen an animal returns in a year, watt-hours. -/
def yearlyManureValue (a : DraftAnimal) : ℚ := a.manureN * 365 * nitrogenEnergy

/-- **The ox is not only an engine.**  The nitrogen in a year of its manure
carries four fifths as much embodied energy as a year of its shaft work — the
reason a grazing animal earns its hectare even though sunlight beats grass. -/
theorem manure_worth_as_much_as_the_work :
    4 / 5 * yearlyWork ox < yearlyManureValue ox ∧ yearlyManureValue ox < yearlyWork ox := by
  constructor <;>
  unfold yearlyWork yearlyManureValue workingDays nitrogenEnergy DraftAnimal.manureN
    DraftAnimal.manureDM DraftAnimal.feedDM DraftAnimal.dailyWork DraftAnimal.power
    DraftAnimal.pull ox gee <;>
  norm_num

/-- Nitrogen returned in a year, kilograms: about fifty. -/
theorem ox_yearly_nitrogen : 45 < ox.manureN * 365 ∧ ox.manureN * 365 < 55 := by
  unfold DraftAnimal.manureN DraftAnimal.manureDM DraftAnimal.feedDM ox
  constructor <;> norm_num

end Renewable
end LifeTrac
