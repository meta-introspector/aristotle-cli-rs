import RequestProject.Gvcs.Water.Logic
import Mathlib.Tactic

/-!
# The sun as the only power station

The water computer of `Water/Logic.lean` spends exactly one thing: **head**.
Every gate that switches drops a measured slug of water from the head tank to
the pond; the water is not consumed, only lowered.  This file closes the loop
with the only pump allowed here — a solar one — and does the arithmetic.

All the quantities are rationals, so every claim below is a computation:

* `opsPerPrint`, `waterPerPrint`, `computeEnergy` — the water bill of one plate
  of printer parts: 18 408 000 gate operations, 920.4 litres circulated,
  18 058.248 joules of head spent.
* `villageLift` — four square metres of glazed collector driving a
  thermosiphon pump at one and a half per cent, six hours of an 800 W/m² day.
* `sun_lifts_more_than_the_computer_spends` and `prints_per_sunny_day` — one
  sunny day lifts fifty-seven times the head one print costs.
* `pond_makeup_small` — the loop is closed: only evaporation, under ten litres
  a print, has to be made up.
* `solarLiftParts_semiconductor_free` — and there is no photovoltaic cell, so
  no silicon, anywhere in the power station.
-/

namespace LifeTrac
namespace Water

open Steampunk (Material Part)

/-! ## Constants -/

/-- Standard gravity, m/s². -/
def gravity : ℚ := 981 / 100

/-- One litre of water is one kilogram, which is the only conversion needed. -/
def litreMass : ℚ := 1

/-- The slug of water one gate passes when it switches, in litres: capillary
bore, fifty microlitres. -/
def dropVolume : ℚ := 5 / 100000

/-- The working head of the machine, in metres: the tank sits two metres above
the gate deck. -/
def workingHead : ℚ := 2

/-- Beats of the siphon clock per instruction tick of the printer. -/
def beatsPerTick : ℕ := 4

/-- Ticks in the printer's self-print job (the figure `Steampunk/Heat.lean`
uses as well). -/
def jobTicks : ℕ := 3835

/-- Valves in the controller of the machine. -/
def controllerValves : ℕ := 1200

/-! ## What one print costs in head -/

/-- Gate operations in one print: every valve is re-evaluated on every beat. -/
def opsPerPrint : ℕ := controllerValves * beatsPerTick * jobTicks

theorem opsPerPrint_eq : opsPerPrint = 18408000 := by decide

/-- Litres of water circulated through the gate deck in one print. -/
def waterPerPrint : ℚ := (opsPerPrint : ℚ) * dropVolume

theorem waterPerPrint_eq : waterPerPrint = 4602 / 5 := by
  unfold waterPerPrint dropVolume
  rw [show ((opsPerPrint : ℚ)) = 18408000 by rw [opsPerPrint_eq]; norm_num]
  norm_num

/-- Energy, in joules, needed to raise `litres` of water by `h` metres. -/
def liftEnergy (litres h : ℚ) : ℚ := litres * litreMass * gravity * h

/-- Lifting more water takes more energy. -/
theorem liftEnergy_mono {a b h : ℚ} (hh : 0 ≤ h) (hab : a ≤ b) :
    liftEnergy a h ≤ liftEnergy b h := by
  unfold liftEnergy litreMass gravity
  have : (0:ℚ) ≤ 981 / 100 := by norm_num
  nlinarith

/-- The head spent by the computer over one print, in joules. -/
def computeEnergy : ℚ := liftEnergy waterPerPrint workingHead

theorem computeEnergy_eq : computeEnergy = 2257281 / 125 := by
  unfold computeEnergy liftEnergy litreMass gravity workingHead
  rw [waterPerPrint_eq]; norm_num

/-- Eighteen kilojoules and a bit: the whole thinking cost of a plate of
printer parts. -/
theorem computeEnergy_bounds : 18058 ≤ computeEnergy ∧ computeEnergy ≤ 18059 := by
  rw [computeEnergy_eq]; constructor <;> norm_num

/-! ## The solar lift -/

/-- A solar water lift: a glazed collector of `area` square metres under
`insolation` watts per square metre for `hours` hours, driving a thermosiphon
pump whose end-to-end efficiency (heat in to potential energy out) is `eff`. -/
structure SolarLift where
  /-- Collector area, m². -/
  area : ℚ
  /-- Insolation on the collector, W/m². -/
  insolation : ℚ
  /-- Hours of usable sun. -/
  hours : ℚ
  /-- Heat-to-head efficiency of the pump. -/
  eff : ℚ

namespace SolarLift

/-- Joules of head the lift delivers in a day. -/
def energy (S : SolarLift) : ℚ := S.area * S.insolation * S.hours * 3600 * S.eff

/-- Litres it can raise to a head of `h` metres in a day. -/
def litres (S : SolarLift) (h : ℚ) : ℚ := S.energy / (gravity * h)

/-- A bigger collector lifts more. -/
theorem energy_mono_area {S T : SolarLift} (h : S.area ≤ T.area)
    (hrest : S.insolation = T.insolation ∧ S.hours = T.hours ∧ S.eff = T.eff)
    (hpos : 0 ≤ S.insolation) (hh : 0 ≤ S.hours) (he : 0 ≤ S.eff) :
    S.energy ≤ T.energy := by
  obtain ⟨hi, hh', he'⟩ := hrest
  unfold energy
  rw [← hi, ← hh', ← he']
  have : 0 ≤ S.insolation * S.hours * 3600 * S.eff := by positivity
  nlinarith

end SolarLift

/-- The village's lift: four square metres, an 800 W/m² day, six hours, and a
thermosiphon pump at one and a half per cent. -/
def villageLift : SolarLift where
  area := 4
  insolation := 800
  hours := 6
  eff := 3 / 200

theorem villageLift_energy : villageLift.energy = 1036800 := by
  unfold SolarLift.energy villageLift; norm_num

/-- **The sun covers the thinking, fifty times over.** -/
theorem sun_lifts_more_than_the_computer_spends :
    50 * computeEnergy ≤ villageLift.energy := by
  rw [computeEnergy_eq, villageLift_energy]; norm_num

/-- **Fifty-seven prints' worth of head in one sunny day**, so the computer is
never the thing that stops the shop. -/
theorem prints_per_sunny_day : 57 * computeEnergy ≤ villageLift.energy := by
  rw [computeEnergy_eq, villageLift_energy]; norm_num

/-- And fifty-eight is too many, so fifty-seven is the honest figure. -/
theorem prints_per_sunny_day_tight : villageLift.energy < 58 * computeEnergy := by
  rw [computeEnergy_eq, villageLift_energy]; norm_num

/-- Litres the day's sun raises to the working head: over fifty thousand. -/
theorem villageLift_litres : 52000 ≤ villageLift.litres workingHead := by
  unfold SolarLift.litres workingHead gravity
  rw [villageLift_energy]; norm_num

/-! ## The loop is closed -/

/-- The fraction of circulating water lost to evaporation and splash in a
print — one per cent, generously. -/
def evaporationFrac : ℚ := 1 / 100

/-- Litres that have to be poured into the pond to make one print's losses
good. -/
def makeupPerPrint : ℚ := evaporationFrac * waterPerPrint

/-- **Water is not a consumable here.**  Everything the gates pass falls into
the pond and is lifted again; the make-up is under ten litres a print. -/
theorem pond_makeup_small : makeupPerPrint ≤ 10 := by
  unfold makeupPerPrint evaporationFrac
  rw [waterPerPrint_eq]; norm_num

/-- What is circulated dwarfs what is lost: a hundred to one. -/
theorem circulated_vs_lost : 100 * makeupPerPrint = waterPerPrint := by
  unfold makeupPerPrint evaporationFrac; ring

/-! ## The power station has no silicon in it -/

/-- The parts of the solar lift: glazing, a black copperless absorber of
blackened stone and slate, a glass standpipe, leather check-valve flaps and a
hardwood tank. -/
def solarLiftParts : List Part :=
  [ ⟨"collector glazing", .glass, 8⟩
  , ⟨"absorber slab", .stone, 4⟩
  , ⟨"standpipe", .glass, 2⟩
  , ⟨"check valve flap", .leather, 4⟩
  , ⟨"pump body", .bronze, 1⟩
  , ⟨"head tank", .hardwood, 1⟩
  , ⟨"aiming mirror", .glass, 2⟩ ]

/-- **No photovoltaics.**  Not one part of the power station is a
semiconductor: the sun's heat, not its photons on a junction, does the work. -/
theorem solarLiftParts_semiconductor_free :
    ∀ p ∈ solarLiftParts, p.mat.semiconductor = false := by decide

/-- Twenty-two pieces of glass, stone, leather, bronze and wood. -/
theorem solarLiftParts_qty : (solarLiftParts.map Part.qty).sum = 22 := by decide

/-- The whole power station, gate deck included, is free of semiconductors. -/
theorem powerAndLogic_semiconductor_free :
    ∀ p ∈ solarLiftParts ++ waterGateParts, p.mat.semiconductor = false := by decide

end Water
end LifeTrac
