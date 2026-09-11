import RequestProject.Gvcs.Energy

/-!
# Where the energy comes from when there is no grid

`RequestProject/Energy.lean` says how much energy the shop needs.  This file
says where it can come from when there is no mains supply: **wood**, which the
system can burn from the first day, and **photovoltaics**, which it can only
make once it has climbed the skill tree of `RequestProject/SkillTree.lean`.

Three conversions are modelled.

* **Charcoal burning.**  A retort turns wood into charcoal at a mass yield of
  about a quarter.  Charcoal is what the coke oven and the blast furnace
  actually want, so this is the route by which the coal in the bill of
  materials can be replaced.  The retort is proved to *lose* energy — a
  kilogram of wood carries 4.2 kWh and yields charcoal carrying 2.06 kWh — so
  charcoal buys quality of heat, not quantity.
* **Heat engines.**  A wood-fired steam set and a producer-gas engine, each
  turning fuel into shaft (and hence electrical) energy at a fixed efficiency,
  both strictly less than one.  The gas engine, at twice the efficiency, needs
  half the wood.
* **Photovoltaics.**  An array of given area, cell efficiency and performance
  ratio in a place with a given number of peak sun hours.  The key result is
  that the energy payback time does not depend on how big the array is
  (`payback_indep_of_area`), and that an array is a net energy source exactly
  when it lasts longer than that (`net_positive_iff`).

The numbers are illustrative — air-dry hardwood at 15.1 MJ/kg, a coppice
yielding ten tonnes a hectare a year, 4.5 peak sun hours, 15 % cells, 300 kWh
of embodied energy per square metre of module — but every consequence drawn
from them is proved.  Energies are kilowatt-hours, masses kilograms, areas
square metres.
-/

namespace LifeTrac
namespace EnergySupply

open Workflow
open Workflow.Item

/-! ## Fuels -/

/-- A solid or liquid fuel, given by its lower heating value in kilowatt-hours
per kilogram. -/
structure Fuel where
  /-- Lower heating value, kWh per kg. -/
  lhv : ℚ
  lhv_pos : 0 < lhv

/-- Air-dry hardwood: 15.1 MJ/kg. -/
def firewood : Fuel := ⟨21/5, by norm_num⟩

/-- Lump charcoal: 29.7 MJ/kg. -/
def charcoal : Fuel := ⟨33/4, by norm_num⟩

/-- Bituminous coal: 28.8 MJ/kg — the same figure `fuelValue` uses to price
the coal in the bill of materials. -/
def coalFuel : Fuel := ⟨8, by norm_num⟩

/-- Crude oil: 41.8 MJ/kg. -/
def oilFuel : Fuel := ⟨58/5, by norm_num⟩

/-- The heat released by burning `m` kilograms of a fuel. -/
def Fuel.heat (f : Fuel) (m : ℚ) : ℚ := m * f.lhv

theorem Fuel.heat_nonneg (f : Fuel) {m : ℚ} (hm : 0 ≤ m) : 0 ≤ f.heat m :=
  mul_nonneg hm f.lhv_pos.le

theorem Fuel.heat_mono (f : Fuel) {m₁ m₂ : ℚ} (h : m₁ ≤ m₂) : f.heat m₁ ≤ f.heat m₂ :=
  mul_le_mul_of_nonneg_right h f.lhv_pos.le

/-- The mass of a fuel that carries a given amount of energy. -/
def Fuel.massFor (f : Fuel) (E : ℚ) : ℚ := E / f.lhv

@[simp] theorem Fuel.heat_massFor (f : Fuel) (E : ℚ) : f.heat (f.massFor E) = E := by
  simp only [Fuel.heat, Fuel.massFor]
  rw [div_mul_cancel₀ _ f.lhv_pos.ne']

/-- A denser fuel goes further: the same energy takes less charcoal than
wood. -/
theorem charcoal_massFor_lt_firewood {E : ℚ} (hE : 0 < E) :
    charcoal.massFor E < firewood.massFor E := by
  rw [Fuel.massFor, Fuel.massFor]
  apply div_lt_div_of_pos_left hE <;> norm_num [firewood, charcoal]

/-! ## Charcoal burning -/

/-- The mass yield of a charcoal retort: a quarter of the dry wood put in. -/
def charcoalYield : ℚ := 1/4

/-- The charcoal got from `m` kilograms of wood. -/
def charcoalFrom (m : ℚ) : ℚ := charcoalYield * m

/-- **A kilogram of wood yields 2.0625 kWh of charcoal.** -/
theorem charcoal_energy_per_kg_wood : charcoal.heat (charcoalFrom 1) = 33/16 := by
  norm_num [Fuel.heat, charcoalFrom, charcoalYield, charcoal]

/-- **The retort loses energy.**  Charcoal is a better fuel than wood per
kilogram, but making it throws away more than half of what the wood carried:
the retort is 49.1 % efficient. -/
theorem retort_loses_energy {m : ℚ} (hm : 0 < m) :
    charcoal.heat (charcoalFrom m) < firewood.heat m := by
  simp only [Fuel.heat, charcoalFrom, charcoalYield, charcoal, firewood]
  linarith

theorem retort_efficiency :
    charcoal.heat (charcoalFrom 1) / firewood.heat 1 = 55/112 := by
  norm_num [Fuel.heat, charcoalFrom, charcoalYield, charcoal, firewood]

/-- The wood that must be carbonised to deliver a given amount of energy as
charcoal. -/
def woodForCharcoalEnergy (E : ℚ) : ℚ := E / (charcoalYield * charcoal.lhv)

theorem woodForCharcoalEnergy_spec (E : ℚ) :
    charcoal.heat (charcoalFrom (woodForCharcoalEnergy E)) = E := by
  simp only [Fuel.heat, charcoalFrom, woodForCharcoalEnergy, charcoalYield, charcoal]
  ring

/-! ## Heat engines -/

/-- A prime mover with a generator on the end of it: fuel in, shaft or
electrical energy out, at a fixed efficiency strictly between nothing and
everything. -/
structure HeatEngine where
  /-- Fuel-to-shaft efficiency. -/
  eff : ℚ
  eff_pos : 0 < eff
  eff_lt_one : eff < 1

/-- A wood-fired steam engine driving a generator: 10 %. -/
def steamSet : HeatEngine := ⟨1/10, by norm_num, by norm_num⟩

/-- A producer-gas (wood gas) engine driving a generator: 20 %. -/
def woodGasSet : HeatEngine := ⟨1/5, by norm_num, by norm_num⟩

/-- The shaft energy got by burning `m` kilograms of a fuel in an engine. -/
def HeatEngine.shaftEnergy (e : HeatEngine) (f : Fuel) (m : ℚ) : ℚ := m * f.lhv * e.eff

/-- **No engine returns what it is given.**  The shaft energy is strictly less
than the heat of the fuel burnt. -/
theorem HeatEngine.shaftEnergy_lt_heat (e : HeatEngine) (f : Fuel) {m : ℚ} (hm : 0 < m) :
    e.shaftEnergy f m < f.heat m := by
  rw [HeatEngine.shaftEnergy, Fuel.heat]
  have h : 0 < m * f.lhv := mul_pos hm f.lhv_pos
  nlinarith [e.eff_lt_one]

/-- The fuel an engine must burn to deliver a given amount of shaft energy. -/
def HeatEngine.fuelFor (e : HeatEngine) (f : Fuel) (E : ℚ) : ℚ := E / (f.lhv * e.eff)

@[simp] theorem HeatEngine.shaftEnergy_fuelFor (e : HeatEngine) (f : Fuel) (E : ℚ) :
    e.shaftEnergy f (e.fuelFor f E) = E := by
  have hf := f.lhv_pos.ne'
  have he := e.eff_pos.ne'
  simp only [HeatEngine.shaftEnergy, HeatEngine.fuelFor]
  field_simp

/-- A better engine burns less fuel for the same work. -/
theorem HeatEngine.fuelFor_antitone {e₁ e₂ : HeatEngine} {f : Fuel} {E : ℚ} (hE : 0 < E)
    (h : e₁.eff < e₂.eff) : e₂.fuelFor f E < e₁.fuelFor f E := by
  rw [HeatEngine.fuelFor, HeatEngine.fuelFor]
  apply div_lt_div_of_pos_left hE (mul_pos f.lhv_pos e₁.eff_pos)
  exact mul_lt_mul_of_pos_left h f.lhv_pos

/-- **Wood gas beats steam.**  At twice the efficiency the gas engine needs
exactly half the wood — and the halving is exact. -/
theorem woodGas_halves_steam (E : ℚ) :
    woodGasSet.fuelFor firewood E = steamSet.fuelFor firewood E / 2 := by
  norm_num [HeatEngine.fuelFor, woodGasSet, steamSet, firewood]
  ring

/-! ## The forest -/

/-- Sustainable yield of a short-rotation coppice: ten tonnes of dry wood per
hectare per year. -/
def coppiceYield : ℚ := 10000

/-- The hectare-years of coppice that a mass of wood represents. -/
def hectareYears (m : ℚ) : ℚ := m / coppiceYield

/-- The same, as an area in square metres worked for one year. -/
def forestArea (m : ℚ) : ℚ := 10000 * hectareYears m

theorem forestArea_eq (m : ℚ) : forestArea m = m := by
  rw [forestArea, hectareYears, coppiceYield]
  ring

/-! ## Photovoltaics -/

/-- Peak sun hours: the daily insolation of a middling site, 4.5 kWh/m². -/
def peakSunHours : ℚ := 9/2

/-- A photovoltaic array. -/
structure PVArray where
  /-- Module area, m². -/
  area : ℚ
  /-- Cell efficiency. -/
  eff : ℚ
  /-- Performance ratio: wiring, inverter, dust and heat. -/
  perf : ℚ
  area_pos : 0 < area
  eff_pos : 0 < eff
  perf_pos : 0 < perf

/-- A workshop array: 15 % cells at a performance ratio of 0.8. -/
def shopArray (A : ℚ) (hA : 0 < A) : PVArray := ⟨A, 3/20, 4/5, hA, by norm_num, by norm_num⟩

/-- Energy delivered in a day. -/
def PVArray.dailyYield (a : PVArray) : ℚ := a.area * peakSunHours * a.eff * a.perf

/-- Energy delivered in a year. -/
def PVArray.annualYield (a : PVArray) : ℚ := 365 * a.dailyYield

theorem PVArray.annualYield_pos (a : PVArray) : 0 < a.annualYield := by
  have h1 := a.area_pos
  have h2 := a.eff_pos
  have h3 := a.perf_pos
  simp only [PVArray.annualYield, PVArray.dailyYield, peakSunHours]
  positivity

/-- Better cells deliver more, all else equal. -/
theorem PVArray.annualYield_mono_eff {a b : PVArray} (harea : a.area = b.area)
    (hperf : a.perf = b.perf) (h : a.eff < b.eff) : a.annualYield < b.annualYield := by
  have hb := b.area_pos
  have hp := b.perf_pos
  have hs : (0:ℚ) < peakSunHours := by norm_num [peakSunHours]
  have hpos : 0 < b.area * peakSunHours * b.perf := by positivity
  have key := mul_lt_mul_of_pos_left h hpos
  simp only [PVArray.annualYield, PVArray.dailyYield, harea, hperf]
  nlinarith [key]

/-- The energy it takes to make a square metre of module: 300 kWh. -/
def embodiedPerArea : ℚ := 300

/-- The energy that goes into building an array. -/
def PVArray.embodied (a : PVArray) : ℚ := embodiedPerArea * a.area

/-- The energy payback time of an array, in years. -/
def PVArray.paybackYears (a : PVArray) : ℚ := a.embodied / a.annualYield

/-- **Payback does not depend on how big the array is.**  Doubling the area
doubles both the energy it took to build and the energy it returns. -/
theorem payback_indep_of_area {a b : PVArray} (heff : a.eff = b.eff) (hperf : a.perf = b.perf) :
    a.paybackYears = b.paybackYears := by
  have ha := a.area_pos
  have hb := b.area_pos
  have hbe := b.eff_pos
  have hbp := b.perf_pos
  have hs : (0:ℚ) < peakSunHours := by norm_num [peakSunHours]
  rw [PVArray.paybackYears, PVArray.paybackYears, PVArray.embodied, PVArray.embodied,
    PVArray.annualYield, PVArray.annualYield, PVArray.dailyYield, PVArray.dailyYield, heff, hperf]
  rw [div_eq_div_iff (by positivity) (by positivity)]
  ring

/-- **The workshop array pays for itself in 1.52 years.** -/
theorem shopArray_payback {A : ℚ} (hA : 0 < A) : (shopArray A hA).paybackYears = 1000/657 := by
  rw [PVArray.paybackYears, PVArray.embodied, PVArray.annualYield, PVArray.dailyYield]
  simp only [shopArray, embodiedPerArea, peakSunHours]
  rw [div_eq_div_iff (by nlinarith) (by norm_num)]
  ring

/-- The net energy an array returns over a life of `years`. -/
def PVArray.netEnergy (a : PVArray) (years : ℚ) : ℚ := a.annualYield * years - a.embodied

/-- **An array is a net energy source exactly when it outlives its payback
time.** -/
theorem net_positive_iff (a : PVArray) (years : ℚ) :
    0 < a.netEnergy years ↔ a.paybackYears < years := by
  rw [PVArray.netEnergy, PVArray.paybackYears, div_lt_iff₀ a.annualYield_pos, sub_pos,
    mul_comm a.annualYield years]

/-- Over a twenty-five year life the workshop array returns more than fifteen
times the energy that went into it. -/
theorem shopArray_lifetime_return {A : ℚ} (hA : 0 < A) :
    15 * (shopArray A hA).embodied < (shopArray A hA).netEnergy 25 := by
  simp only [PVArray.netEnergy, PVArray.embodied, PVArray.annualYield, PVArray.dailyYield,
    shopArray, embodiedPerArea, peakSunHours]
  nlinarith

/-- The array area whose annual yield is a given amount of energy, at the
workshop specification. -/
def areaFor (E : ℚ) : ℚ := E / (365 * peakSunHours * (3/20) * (4/5))

theorem areaFor_spec {E : ℚ} (hE : 0 < E) :
    (shopArray (areaFor E) (by
      rw [areaFor]; exact div_pos hE (by norm_num [peakSunHours]))).annualYield = E := by
  rw [PVArray.annualYield, PVArray.dailyYield]
  simp only [shopArray, areaFor, peakSunHours]
  field_simp

/-! ## Running the LifeTrac bootstrap on wood

The shop needs two different things from its energy supply: **charcoal**, to
replace the coal and oil that the workflows consume as material, and **shaft
or electrical energy**, to run the furnaces, mills and machine tools.  Both
can come out of the same coppice. -/

/-- The wood carbonised to replace the fossil fuel in the bill of materials of
one machine: **5550.06 kg**. -/
theorem lifeTrac_woodForFuel :
    woodForCharcoalEnergy (fuelEnergy (plant.rawDemand lifeTrac 1)) = 572349568/103125 := by
  rw [lifeTrac_fuelEnergy, woodForCharcoalEnergy]
  norm_num [charcoalYield, charcoal]

/-- The wood gasified to run the shop for one machine: **2937.63 kg**. -/
theorem lifeTrac_woodForProcess :
    woodGasSet.fuelFor firewood (plant.chainEnergy procEnergy lifeTrac 1) = 616903111/210000 := by
  rw [lifeTrac_processEnergy, HeatEngine.fuelFor]
  norm_num [woodGasSet, firewood]

/-- All the wood one machine takes: charcoal for the furnaces and gas for the
shop. -/
def lifeTracWood : ℚ :=
  woodForCharcoalEnergy (fuelEnergy (plant.rawDemand lifeTrac 1)) +
    woodGasSet.fuelFor firewood (plant.chainEnergy procEnergy lifeTrac 1)

/-- **One LifeTrac takes 8487.69 kg of wood.** -/
theorem lifeTracWood_eq : lifeTracWood = 98032822721/11550000 := by
  rw [lifeTracWood, lifeTrac_woodForFuel, lifeTrac_woodForProcess]
  norm_num

theorem lifeTracWood_bounds : 8487 < lifeTracWood ∧ lifeTracWood < 8488 := by
  rw [lifeTracWood_eq]; constructor <;> norm_num

/-- **Five and a half kilograms of wood per kilogram of tractor**, the machine
itself weighing 1539.7 kg. -/
theorem wood_exceeds_machine_mass : 5 * (15397/10 : ℚ) < lifeTracWood := by
  rw [lifeTracWood_eq]; norm_num

/-- **Under a hectare of coppice, worked for a year, builds a tractor.** -/
theorem lifeTrac_hectareYears : hectareYears lifeTracWood < 1 := by
  rw [hectareYears, lifeTracWood_eq, coppiceYield]; norm_num

/-- The whole energy demand of one machine, met by photovoltaics instead,
needs **70.6 m² of module**. -/
theorem lifeTrac_pvArea : areaFor (totalEnergy lifeTrac 1) = 1159550317/16425000 := by
  rw [lifeTrac_totalEnergy, areaFor]
  norm_num [peakSunHours]

theorem lifeTrac_pvArea_bounds :
    70 < areaFor (totalEnergy lifeTrac 1) ∧ areaFor (totalEnergy lifeTrac 1) < 71 := by
  rw [lifeTrac_pvArea]; constructor <;> norm_num

/-- **Sunlight is more than a hundred times as land-efficient as firewood.**
A year's tractor takes 8487 m² of coppice but only 70.6 m² of module — and the
module lasts twenty-five years, whereas the wood is gone. -/
theorem solar_land_beats_forest :
    100 * areaFor (totalEnergy lifeTrac 1) < forestArea lifeTracWood := by
  rw [lifeTrac_pvArea, forestArea_eq, lifeTracWood_eq]; norm_num

/-- **But the panels have to be paid for first.**  The array that would run
the shop cannot be built by the sun it has not yet caught: its embodied energy
has to come from the wood pile.  It is 21 179 kWh of embodied energy — more
than a machine's whole energy bill — and 25 213 kg of wood to supply it. -/
theorem woodToBuildArray :
    woodGasSet.fuelFor firewood ((shopArray (areaFor (totalEnergy lifeTrac 1))
      (by rw [lifeTrac_pvArea]; norm_num)).embodied) = 1159550317/45990 := by
  rw [PVArray.embodied, HeatEngine.fuelFor]
  simp only [shopArray, embodiedPerArea, woodGasSet, firewood, lifeTrac_pvArea]
  norm_num

end EnergySupply
end LifeTrac
