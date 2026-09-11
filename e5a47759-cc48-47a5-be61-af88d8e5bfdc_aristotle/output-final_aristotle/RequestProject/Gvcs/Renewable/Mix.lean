import RequestProject.Gvcs.Renewable.Muscle
import RequestProject.Gvcs.Energy

/-!
# The mix: what it takes to build a tractor out of wind, water, sun and muscle

`RequestProject/Energy.lean` prices the machine: **one LifeTrac costs
13 914.60 kWh** from bare ore.  The other files of `Renewable/` price the
sources.  This one puts the two together and asks the only question that
matters to a village with no grid: *can we build it, and how long will it
take?*

The portfolio is six entries, each a mean delivered power and the hours a day
it delivers, and every figure traces back to a theorem elsewhere in this
directory:

| source | mean power | hours/day | kWh/day |
|---|---|---|---|
| windmill, 6 m rotor | 700 W | 24 | 16.8 |
| overshot water wheel | 700 W | 24 | 16.8 |
| solar boiler, 20 m² of mirrors | 4200 W | 6 | 25.2 |
| photovoltaics, 3 kWp | 3000 W | 4.5 | 13.5 |
| four people on pedals | 285 W | 4 | 1.14 |
| four oxen in a yoke | 1970 W | 5 | 9.85 |

The results:

* `year_builds_a_tractor` — the six together build one machine a year over,
  with more than twice the energy to spare.
* `no_single_source_builds_it_in_a_year` — and **not one of the six could do it
  alone**: the mix is not a luxury, it is the design.
* `muscle_alone_insufficient` — legs and oxen together reach less than a third
  of the bill; muscle runs the shop, it does not build the machine.
* `firm_sources_cover_the_shop` — on a still, sunless winter day the water
  wheel and the animals still carry the shop's 20 kWh, so work never stops.
* `sun_and_wind_are_two_thirds` — but the light and the wind are what actually
  pay for the tractor: they raise nearly two thirds of the total.
-/

namespace LifeTrac
namespace Renewable

open Workflow
open Workflow.Item

/-- One entry of the village's energy portfolio. -/
structure Source where
  /-- What it is. -/
  name : String
  /-- Mean power while it runs, watts. -/
  power : ℚ
  /-- Hours a day it runs. -/
  hours : ℚ

/-- Energy from one source in a day, kWh. -/
def Source.daily (s : Source) : ℚ := s.power * s.hours / 1000

/-- Energy from one source in a year, kWh. -/
def Source.yearly (s : Source) : ℚ := 365 * s.daily

/-- A six-metre windmill on a decent site: 3.5 kW at 8 m/s, a capacity factor
of one fifth, so 700 W around the clock. -/
def windmillSource : Source := ⟨"windmill", 700, 24⟩

/-- An overshot wheel on a small stream: 700 W, day and night. -/
def waterWheelSource : Source := ⟨"water wheel", 700, 24⟩

/-- Twenty square metres of mirrors, a receiver at 600 K and an engine taking
a third of the concentrated light: 4.2 kW of shaft power for six hours. -/
def solarBoilerSource : Source := ⟨"solar boiler", 4200, 6⟩

/-- Three kilowatts of modules at four and a half peak sun hours. -/
def pvSource : Source := ⟨"photovoltaics", 3000, 9 / 2⟩

/-- Four people on pedal generators, four hours each. -/
def pedalSource : Source := ⟨"pedals", 4 * pedalShaftPower humanContinuous, 4⟩

/-- Four oxen in a yoke, five hours. -/
def oxenSource : Source := ⟨"oxen", teamPower 4, 5⟩

/-- The village portfolio. -/
def villagePortfolio : List Source :=
  [windmillSource, waterWheelSource, solarBoilerSource, pvSource, pedalSource, oxenSource]

/-- Total energy the village raises in a day, kWh. -/
def dailyTotal : ℚ := (villagePortfolio.map Source.daily).sum

/-- The village raises between 83 and 84 kilowatt-hours a day. -/
theorem dailyTotal_bounds : 83 < dailyTotal ∧ dailyTotal < 84 := by
  unfold dailyTotal villagePortfolio Source.daily windmillSource waterWheelSource
    solarBoilerSource pvSource pedalSource oxenSource teamPower teamFactor
    pedalShaftPower chainEff humanContinuous DraftAnimal.power DraftAnimal.pull ox gee
  constructor <;> norm_num

/-- **A year of wind, water, sun and muscle builds the machine** — with more
than twice the energy over. -/
theorem year_builds_a_tractor : totalEnergy lifeTrac 1 < 365 * dailyTotal := by
  rw [lifeTrac_totalEnergy]
  have h := dailyTotal_bounds.1
  linarith

/-- Indeed it builds two and leaves change. -/
theorem year_builds_two_tractors : totalEnergy lifeTrac 2 < 365 * dailyTotal := by
  rw [totalEnergy_smul, lifeTrac_totalEnergy]
  have h := dailyTotal_bounds.1
  linarith

/-- **No single source could do it.**  Every one of the six, run for a whole
year on its own, falls short of one machine: the mix is the design. -/
theorem no_single_source_builds_it_in_a_year :
    ∀ s ∈ villagePortfolio, s.yearly < totalEnergy lifeTrac 1 := by
  rw [lifeTrac_totalEnergy]
  intro s hs
  fin_cases hs <;>
    simp only [Source.yearly, Source.daily, windmillSource, waterWheelSource,
      solarBoilerSource, pvSource, pedalSource, oxenSource, teamPower, teamFactor,
      pedalShaftPower, chainEff, humanContinuous, DraftAnimal.power, DraftAnimal.pull,
      ox, gee] <;>
    norm_num

/-- **Muscle runs the shop; it does not build the machine.**  A year of pedals
and oxen together comes to less than a third of the bill. -/
theorem muscle_alone_insufficient :
    3 * (pedalSource.yearly + oxenSource.yearly) < totalEnergy lifeTrac 1 := by
  rw [lifeTrac_totalEnergy]
  unfold Source.yearly Source.daily pedalSource oxenSource teamPower teamFactor
    pedalShaftPower chainEff humanContinuous DraftAnimal.power DraftAnimal.pull ox gee
  norm_num

/-- Daily electrical and mechanical demand of the workshop itself, kWh. -/
def shopDaily : ℚ := 20

/-- **Work never stops.**  On a still, overcast winter day — no wind, no sun —
the water wheel, the pedals and the oxen still carry the shop. -/
theorem firm_sources_cover_the_shop :
    shopDaily < waterWheelSource.daily + pedalSource.daily + oxenSource.daily := by
  unfold shopDaily Source.daily waterWheelSource pedalSource oxenSource teamPower
    teamFactor pedalShaftPower chainEff humanContinuous DraftAnimal.power
    DraftAnimal.pull ox gee
  norm_num

/-- **But the sun and the wind pay for the tractor.**  Between them the
windmill, the mirrors and the modules raise nearly two thirds — more than
65 % — of everything the village makes. -/
theorem sun_and_wind_are_two_thirds :
    13 / 20 * dailyTotal <
      windmillSource.daily + solarBoilerSource.daily + pvSource.daily := by
  unfold dailyTotal villagePortfolio Source.daily windmillSource waterWheelSource
    solarBoilerSource pvSource pedalSource oxenSource teamPower teamFactor
    pedalShaftPower chainEff humanContinuous DraftAnimal.power DraftAnimal.pull ox gee
  norm_num

/-- How many days of the whole portfolio one machine costs: fewer than a
hundred and seventy. -/
theorem days_to_build_a_tractor : totalEnergy lifeTrac 1 / dailyTotal < 170 := by
  rw [lifeTrac_totalEnergy, div_lt_iff₀ (by linarith [dailyTotal_bounds.1])]
  have h := dailyTotal_bounds.1
  linarith

end Renewable
end LifeTrac
