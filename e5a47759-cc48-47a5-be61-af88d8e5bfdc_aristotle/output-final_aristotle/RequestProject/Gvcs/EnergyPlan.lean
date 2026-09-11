import RequestProject.Gvcs.SkillTree
import RequestProject.Gvcs.Pit
import RequestProject.Gvcs.Field

/-!
# The whole energy answer: mine it, make it, and where the power comes from

This is the capstone of the energy side of the project.  It puts together

* the pit (`RequestProject/Pit.lean`): 7.66 hours of machine time at the face
  for one tractor's raw material,
* the shop (`RequestProject/Energy.lean`): 2467.61 kWh of process energy and
  11 446.99 kWh of fuel dug as coal and oil,
* the supply (`RequestProject/Sources.lean`): wood, charcoal, heat engines and
  photovoltaics,
* and the tree (`RequestProject/SkillTree.lean`): what the shop is allowed to
  know when.

and answers, in one place: **how much energy does a LifeTrac take, where can
it come from, and in what order can those sources be had?**

The headline figures, all derived from the workflows rather than assumed:

| | |
|---|---|
| digging | 137.80 kWh |
| shop processes | 2467.61 kWh |
| fuel dug as coal and oil | 11 446.99 kWh |
| **total** | **14 052.40 kWh** |
| as wood | 8651.74 kg |
| as coppice | 0.87 hectare-years |
| as photovoltaics | 71.30 m² running for a year |

and the sequencing result (`first_machine_burns_wood`): every energy source a
workshop with the bootstrap skills can operate is a wood-burning one.  The
solar array is not a way of building the first tractor; it is something the
first tractor's workshop can go on to build.
-/

namespace LifeTrac
namespace EnergyPlan

open Workflow Workflow.Item EnergySupply Skills Skills.Skill

/-! ## The energy of the digging -/

/-- The shaft power of the machine at the face, in kilowatts. -/
def machinePower : ℚ := 18

/-- The energy the LifeTrac spends winning its own successor's raw material:
`machinePower` for the 7.655 hours of `Mining.tractorHours`. -/
def pitEnergy : ℚ := machinePower * Mining.tractorHours

/-- **137.80 kWh at the face.** -/
theorem pitEnergy_eq : pitEnergy = 34449528897/250000000 := by
  rw [pitEnergy, Mining.tractorHours_eq, machinePower]; norm_num

/-- **Digging is the small part.**  Seventeen times the energy spent at the
face is still less than the shop spends turning what it digs into a
machine. -/
theorem pit_energy_small :
    17 * pitEnergy < plant.chainEnergy procEnergy lifeTrac 1 := by
  rw [pitEnergy_eq, lifeTrac_processEnergy]; norm_num

/-! ## The whole bill -/

/-- Everything one machine costs in energy: the digging, the shop processes,
and the chemical energy of the fuel that goes into it as material. -/
def wholeEnergy : ℚ := pitEnergy + totalEnergy lifeTrac 1

/-- **One LifeTrac, from untouched ground to finished machine: 14 052.40
kWh.** -/
theorem wholeEnergy_eq : wholeEnergy = 3513100479897/250000000 := by
  rw [wholeEnergy, pitEnergy_eq, lifeTrac_totalEnergy]; norm_num

theorem wholeEnergy_bounds : 14052 < wholeEnergy ∧ wholeEnergy < 14053 := by
  rw [wholeEnergy_eq]; constructor <;> norm_num

/-- **Nine kilowatt-hours per kilogram of tractor**, the machine massing
1539.7 kg. -/
theorem wholeEnergy_per_kg : 9 * (15397/10 : ℚ) < wholeEnergy := by
  rw [wholeEnergy_eq]; norm_num

/-! ## Paying for it with wood -/

/-- The wood the pit burns, as producer gas in the machine's own engine. -/
def pitWood : ℚ := woodGasSet.fuelFor firewood pitEnergy

theorem pitWood_eq : pitWood = 1640453757/10000000 := by
  rw [pitWood, HeatEngine.fuelFor, pitEnergy_eq]
  norm_num [woodGasSet, firewood]

/-- All the wood one machine takes: charcoal for the furnaces, producer gas
for the shop, and producer gas for the digging. -/
def wholeWood : ℚ := lifeTracWood + pitWood

/-- **8651.74 kg of wood for one tractor.** -/
theorem wholeWood_eq : wholeWood = 19985509362067/2310000000 := by
  rw [wholeWood, lifeTracWood_eq, pitWood_eq]; norm_num

theorem wholeWood_bounds : 8651 < wholeWood ∧ wholeWood < 8652 := by
  rw [wholeWood_eq]; constructor <;> norm_num

/-- **A hectare of coppice builds a tractor a year, with wood to spare.**  The
ten tonnes a hectare yields exceed the 8.65 tonnes a machine burns. -/
theorem one_hectare_one_tractor : hectareYears wholeWood < 1 := by
  rw [hectareYears, wholeWood_eq, coppiceYield]; norm_num

/-- The whole undertaking is renewable in a strong sense: the wood grows back
every year, and the same hectare will go on building machines indefinitely. -/
theorem coppice_covers_a_machine_a_year : wholeWood < coppiceYield := by
  rw [wholeWood_eq, coppiceYield]; norm_num

/-! ## Paying for it with sunlight instead -/

/-- **71.30 m² of module, running for a year, is the same energy.** -/
theorem wholeEnergy_pvArea : areaFor wholeEnergy = 1171033493299/16425000000 := by
  rw [areaFor, wholeEnergy_eq]; norm_num [peakSunHours]

theorem wholeEnergy_pvArea_bounds : 71 < areaFor wholeEnergy ∧ areaFor wholeEnergy < 72 := by
  rw [wholeEnergy_pvArea]; constructor <;> norm_num

/-- **Sunlight uses a hundred and twenty times less land than firewood** — but
only once the shop can make a cell at all. -/
theorem solar_land_beats_coppice :
    120 * areaFor wholeEnergy < forestArea wholeWood := by
  rw [wholeEnergy_pvArea, forestArea_eq, wholeWood_eq]; norm_num

/-- The array that would run the whole undertaking pays back the energy that
went into making it in 1.52 years, and lives twenty-five. -/
theorem array_pays_back :
    (shopArray (areaFor wholeEnergy) (by rw [wholeEnergy_pvArea]; norm_num)).paybackYears
      = 1000/657 ∧
    (shopArray (areaFor wholeEnergy) (by rw [wholeEnergy_pvArea]; norm_num)).paybackYears < 25 := by
  refine ⟨shopArray_payback _, ?_⟩
  rw [shopArray_payback]
  norm_num

/-! ## Working the finished machine on wood gas

`RequestProject/Field.lean` shows that the work at the drawbar is the draft
times the area divided by the working width, whatever speed is chosen.  Here
that work is valued in kilowatt-hours and paid for in wood. -/

/-- The drawbar work of pulling an implement of draft `F` newtons and working
width `w` metres over `A` square metres, in kilowatt-hours (a kilowatt-hour is
3.6 MJ). -/
def tillageWork (F w A : ℚ) : ℚ := F * A / w / 3600000

/-- The same quantity as the drawbar energy of `RequestProject/Field.lean`,
converted from joules to kilowatt-hours. -/
theorem tillageWork_eq_draftEnergy (F w A : ℚ) (p : Plot) (hA : p.area = (A : ℝ)) :
    (F : ℝ) * p.pathLength (w : ℝ) = 3600000 * (tillageWork F w A : ℝ) := by
  rw [Plot.pathLength_eq, hA, tillageWork]
  push_cast
  field_simp

/-- Tractive efficiency: the fraction of engine shaft work that reaches the
drawbar. -/
def tractiveEff : ℚ := 7/10

/-- The wood a hectare of tillage burns: 10 kN of draft over a 1.5 m implement,
through the transmission and a producer-gas engine. -/
def woodPerHectare : ℚ :=
  woodGasSet.fuelFor firewood (tillageWork 10000 (3/2) 10000 / tractiveEff)

/-- **18.52 kWh at the drawbar, and 31.49 kg of wood, per hectare tilled.** -/
theorem tillage_figures :
    tillageWork 10000 (3/2) 10000 = 500/27 ∧ woodPerHectare = 125000/3969 := by
  constructor
  · norm_num [tillageWork]
  · rw [woodPerHectare, HeatEngine.fuelFor, tillageWork, tractiveEff]
    norm_num [woodGasSet, firewood]

/-- **The wood that builds the machine would till 274 hectares with it.**  The
tractor pays back the forest that made it in a season or two of work. -/
theorem wood_to_build_tills_274_hectares :
    274 * woodPerHectare < wholeWood ∧ wholeWood < 275 * woodPerHectare := by
  rw [wholeWood_eq, (tillage_figures).2]
  constructor <;> norm_num

/-! ## Which source can be had when -/

/-- **The first machine is built on wood.**  Whatever energy source a workshop
with the bootstrap skills can operate — open fire, charcoal retort, wood gas
engine, steam set — burns wood; the solar array is out of reach until four
more skills are learned. -/
theorem first_machine_burns_wood :
    ∀ src : Source, src.available bootstrapSkills → src ∈ woodSources := by decide

/-- And the wood-burning sources really are all available: the shop is not
merely barred from solar, it is equipped for wood. -/
theorem all_wood_sources_ready : ∀ src ∈ woodSources, src.available bootstrapSkills :=
  wood_sources_available

/-- **Solar is a second-generation technology here.**  Photovoltaics rests on
electricity, electricity on steam, and steam on wood: the shop must burn a
forest before it can catch a photon. -/
theorem solar_is_downstream_of_wood :
    Source.solarArray.skill ∉ bootstrapSkills ∧
      steamPower ∈ needs Source.solarArray.skill ∧
      charcoalBurning ∈ needs Source.solarArray.skill := by decide

end EnergyPlan
end LifeTrac
