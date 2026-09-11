import RequestProject.Gvcs.FabLab

set_option maxRecDepth 20000

/-!
# What the printer and the computer take out of the ground

`RequestProject/FabLab.lean` gives a workflow for every part of the fab.  This
file follows every one of those workflows back to the pit and works out, for
each part, exactly how much of the six raw materials goes into it and how many
hours of work it takes.  Each statement has the form

  `fab.rawDemand i q x = q * (c₁ · [x = silica sand] + c₂ · [x = iron ore] + …)`,
  `fab.laborFor i q = q * L`,

so it gives the whole raw-material vector at once and shows that demand and
labour are proportional to the size of the order.  Nothing here is postulated:
every coefficient is forced by the workflows of `FabLab.lean`.

The headline numbers are at the bottom.  A computer is twenty-three and a
half kilograms of sand, ore, coal, limestone and oil, and seventeen hours of
work.  The 3D printer is a hundred and seventy-eight kilograms.  The
*instruments* — the clean room, the stepper, the crystal puller and the rest —
come to twelve tonnes, two and a half times the raw-material bill of the
tractor itself: the machine is cheap and the means of making it is not.
-/

namespace LifeTrac
namespace Fab

open Part

/-- `ind i x` is `1` when `x` is the part `i` and `0` otherwise: the unit
demand vector of `i`. -/
def ind (i x : Part) : ℚ := if x = i then 1 else 0

@[simp] theorem ind_self (i : Part) : ind i i = 1 := by simp [ind]

/-! ## The raw materials themselves -/

@[simp] theorem rd_silicaSand (q : ℚ) (x : Part) : fab.rawDemand silicaSand q x = q * ind silicaSand x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = silicaSand <;> simp [h]

@[simp] theorem lf_silicaSand (q : ℚ) : fab.laborFor silicaSand q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_ironOre (q : ℚ) (x : Part) : fab.rawDemand ironOre q x = q * ind ironOre x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = ironOre <;> simp [h]

@[simp] theorem lf_ironOre (q : ℚ) : fab.laborFor ironOre q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_copperOre (q : ℚ) (x : Part) : fab.rawDemand copperOre q x = q * ind copperOre x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = copperOre <;> simp [h]

@[simp] theorem lf_copperOre (q : ℚ) : fab.laborFor copperOre q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_coal (q : ℚ) (x : Part) : fab.rawDemand coal q x = q * ind coal x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = coal <;> simp [h]

@[simp] theorem lf_coal (q : ℚ) : fab.laborFor coal q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_limestone (q : ℚ) (x : Part) : fab.rawDemand limestone q x = q * ind limestone x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = limestone <;> simp [h]

@[simp] theorem lf_limestone (q : ℚ) : fab.laborFor limestone q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_crudeOil (q : ℚ) (x : Part) : fab.rawDemand crudeOil q x = q * ind crudeOil x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = crudeOil <;> simp [h]

@[simp] theorem lf_crudeOil (q : ℚ) : fab.laborFor crudeOil q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_oreSmelter (q : ℚ) (x : Part) : fab.rawDemand oreSmelter q x = q * ind oreSmelter x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = oreSmelter <;> simp [h]

@[simp] theorem lf_oreSmelter (q : ℚ) : fab.laborFor oreSmelter q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_oilRefinery (q : ℚ) (x : Part) : fab.rawDemand oilRefinery q x = q * ind oilRefinery x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = oilRefinery <;> simp [h]

@[simp] theorem lf_oilRefinery (q : ℚ) : fab.laborFor oilRefinery q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_metalShop (q : ℚ) (x : Part) : fab.rawDemand metalShop q x = q * ind metalShop x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = metalShop <;> simp [h]

@[simp] theorem lf_metalShop (q : ℚ) : fab.laborFor metalShop q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

@[simp] theorem rd_powerPlant (q : ℚ) (x : Part) : fab.rawDemand powerPlant q x = q * ind powerPlant x := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, ind]
  by_cases h : x = powerPlant <;> simp [h]

@[simp] theorem lf_powerPlant (q : ℚ) : fab.laborFor powerPlant q = 0 := by
  rw [Workflow.Plant.laborFor_eq]
  simp [fab_recipe, recipe]

/-! ## Everything the fab makes -/

@[simp] theorem rd_steelStock (q : ℚ) (x : Part) :
    fab.rawDemand steelStock q x = q * (2 * ind ironOre x + 3/4 * ind coal x + 1/4 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_ironOre, rd_coal, rd_limestone]
  ring
@[simp] theorem lf_steelStock (q : ℚ) : fab.laborFor steelStock q = q * (1/50) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_ironOre, lf_coal, lf_limestone]
  ring

@[simp] theorem rd_copperWire (q : ℚ) (x : Part) :
    fab.rawDemand copperWire q x = q * (8 * ind copperOre x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_copperOre]
  ring
@[simp] theorem lf_copperWire (q : ℚ) : fab.laborFor copperWire q = q * (1/20) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_copperOre]
  ring

@[simp] theorem rd_polymerPellet (q : ℚ) (x : Part) :
    fab.rawDemand polymerPellet q x = q * (6/5 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_crudeOil]
  ring
@[simp] theorem lf_polymerPellet (q : ℚ) : fab.laborFor polymerPellet q = q * (1/100) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_crudeOil]
  ring

@[simp] theorem rd_photoresist (q : ℚ) (x : Part) :
    fab.rawDemand photoresist q x = q * (2 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_crudeOil]
  ring
@[simp] theorem lf_photoresist (q : ℚ) : fab.laborFor photoresist q = q * (1/10) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_crudeOil]
  ring

@[simp] theorem rd_glassFurnace (q : ℚ) (x : Part) :
    fab.rawDemand glassFurnace q x = q * (800 * ind ironOre x + 300 * ind coal x + 150 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_limestone]
  ring
@[simp] theorem lf_glassFurnace (q : ℚ) : fab.laborFor glassFurnace q = q * (48) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_limestone]
  ring

@[simp] theorem rd_arcFurnace (q : ℚ) (x : Part) :
    fab.rawDemand arcFurnace q x = q * (1600 * ind ironOre x + 480 * ind copperOre x + 600 * ind coal x + 200 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire]
  ring
@[simp] theorem lf_arcFurnace (q : ℚ) : fab.laborFor arcFurnace q = q * (79) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire]
  ring

@[simp] theorem rd_extruderTool (q : ℚ) (x : Part) :
    fab.rawDemand extruderTool q x = q * (120 * ind ironOre x + 64 * ind copperOre x + 45 * ind coal x + 15 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire]
  ring
@[simp] theorem lf_extruderTool (q : ℚ) : fab.laborFor extruderTool q = q * (68/5) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire]
  ring

@[simp] theorem rd_etchLine (q : ℚ) (x : Part) :
    fab.rawDemand etchLine q x = q * (300 * ind ironOre x + 40 * ind copperOre x + 225/2 * ind coal x + 75/2 * ind limestone x + 24 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_polymerPellet, rd_copperWire]
  ring
@[simp] theorem lf_etchLine (q : ℚ) : fab.laborFor etchLine q = q * (469/20) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_polymerPellet, lf_copperWire]
  ring

@[simp] theorem rd_electricMotor (q : ℚ) (x : Part) :
    fab.rawDemand electricMotor q x = q * (12 * ind ironOre x + 16 * ind copperOre x + 9/2 * ind coal x + 3/2 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire]
  ring
@[simp] theorem lf_electricMotor (q : ℚ) : fab.laborFor electricMotor q = q * (161/50) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire]
  ring

@[simp] theorem rd_wireSaw (q : ℚ) (x : Part) :
    fab.rawDemand wireSaw q x = q * (240 * ind ironOre x + 80 * ind copperOre x + 90 * ind coal x + 30 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire]
  ring
@[simp] theorem lf_wireSaw (q : ℚ) : fab.laborFor wireSaw q = q * (229/10) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire]
  ring

@[simp] theorem rd_printerFrame (q : ℚ) (x : Part) :
    fab.rawDemand printerFrame q x = q * (24 * ind ironOre x + 9 * ind coal x + 3 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock]
  ring
@[simp] theorem lf_printerFrame (q : ℚ) : fab.laborFor printerFrame q = q * (106/25) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock]
  ring

@[simp] theorem rd_hotEnd (q : ℚ) (x : Part) :
    fab.rawDemand hotEnd q x = q * (1 * ind ironOre x + 4/5 * ind copperOre x + 3/8 * ind coal x + 1/8 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire]
  ring
@[simp] theorem lf_hotEnd (q : ℚ) : fab.laborFor hotEnd q = q * (403/200) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire]
  ring

@[simp] theorem rd_glassBlank (q : ℚ) (x : Part) :
    fab.rawDemand glassBlank q x = q * (3/2 * ind silicaSand x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_silicaSand]
  ring
@[simp] theorem lf_glassBlank (q : ℚ) : fab.laborFor glassBlank q = q * (1/5) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_silicaSand]
  ring

@[simp] theorem rd_metSilicon (q : ℚ) (x : Part) :
    fab.rawDemand metSilicon q x = q * (5/2 * ind silicaSand x + 3/2 * ind coal x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_silicaSand, rd_coal]
  ring
@[simp] theorem lf_metSilicon (q : ℚ) : fab.laborFor metSilicon q = q * (2) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_silicaSand, lf_coal]
  ring

@[simp] theorem rd_filament (q : ℚ) (x : Part) :
    fab.rawDemand filament q x = q * (63/50 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_polymerPellet]
  ring
@[simp] theorem lf_filament (q : ℚ) : fab.laborFor filament q = q * (221/2000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_polymerPellet]
  ring

@[simp] theorem rd_pcb (q : ℚ) (x : Part) :
    fab.rawDemand pcb q x = q * (4/5 * ind copperOre x + 7/10 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_polymerPellet, rd_copperWire, rd_photoresist]
  ring
@[simp] theorem lf_pcb (q : ℚ) : fab.laborFor pcb q = q * (103/200) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_polymerPellet, lf_copperWire, lf_photoresist]
  ring

@[simp] theorem rd_dicingSaw (q : ℚ) (x : Part) :
    fab.rawDemand dicingSaw q x = q * (204 * ind ironOre x + 96 * ind copperOre x + 153/2 * ind coal x + 51/2 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire, rd_electricMotor]
  ring
@[simp] theorem lf_dicingSaw (q : ℚ) : fab.laborFor dicingSaw q = q * (666/25) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire, lf_electricMotor]
  ring

@[simp] theorem rd_cleanRoom (q : ℚ) (x : Part) :
    fab.rawDemand cleanRoom q x = q * (60 * ind silicaSand x + 1000 * ind ironOre x + 375 * ind coal x + 125 * ind limestone x + 240 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_polymerPellet, rd_glassBlank]
  ring
@[simp] theorem lf_cleanRoom (q : ℚ) : fab.laborFor cleanRoom q = q * (220) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_polymerPellet, lf_glassBlank]
  ring

@[simp] theorem rd_siemensReactor (q : ℚ) (x : Part) :
    fab.rawDemand siemensReactor q x = q * (15 * ind silicaSand x + 600 * ind ironOre x + 160 * ind copperOre x + 225 * ind coal x + 75 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire, rd_glassBlank]
  ring
@[simp] theorem lf_siemensReactor (q : ℚ) : fab.laborFor siemensReactor q = q * (59) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire, lf_glassBlank]
  ring

@[simp] theorem rd_crystalPuller (q : ℚ) (x : Part) :
    fab.rawDemand crystalPuller q x = q * (15/2 * ind silicaSand x + 500 * ind ironOre x + 240 * ind copperOre x + 375/2 * ind coal x + 125/2 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire, rd_glassBlank]
  ring
@[simp] theorem lf_crystalPuller (q : ℚ) : fab.laborFor crystalPuller q = q * (105/2) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire, lf_glassBlank]
  ring

@[simp] theorem rd_diffusionFurnace (q : ℚ) (x : Part) :
    fab.rawDemand diffusionFurnace q x = q * (12 * ind silicaSand x + 360 * ind ironOre x + 120 * ind copperOre x + 135 * ind coal x + 45 * ind limestone x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire, rd_glassBlank]
  ring
@[simp] theorem lf_diffusionFurnace (q : ℚ) : fab.laborFor diffusionFurnace q = q * (919/20) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire, lf_glassBlank]
  ring

@[simp] theorem rd_wireBonder (q : ℚ) (x : Part) :
    fab.rawDemand wireBonder q x = q * (176 * ind ironOre x + 656/5 * ind copperOre x + 66 * ind coal x + 22 * ind limestone x + 14/5 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire, rd_electricMotor, rd_pcb]
  ring
@[simp] theorem lf_wireBonder (q : ℚ) : fab.laborFor wireBonder q = q * (2181/50) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire, lf_electricMotor, lf_pcb]
  ring

@[simp] theorem rd_stepper (q : ℚ) (x : Part) :
    fab.rawDemand stepper q x = q * (30 * ind silicaSand x + 472 * ind ironOre x + 424 * ind copperOre x + 177 * ind coal x + 59 * ind limestone x + 7 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire, rd_glassBlank, rd_electricMotor, rd_pcb]
  ring
@[simp] theorem lf_stepper (q : ℚ) : fab.laborFor stepper q = q * (33447/100) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire, lf_glassBlank, lf_electricMotor, lf_pcb]
  ring

@[simp] theorem rd_maskSet (q : ℚ) (x : Part) :
    fab.rawDemand maskSet q x = q * (3 * ind silicaSand x + 1/5 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_glassBlank, rd_photoresist]
  ring
@[simp] theorem lf_maskSet (q : ℚ) : fab.laborFor maskSet q = q * (2041/100) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_glassBlank, lf_photoresist]
  ring

@[simp] theorem rd_polysilicon (q : ℚ) (x : Part) :
    fab.rawDemand polysilicon q x = q * (11/4 * ind silicaSand x + 33/20 * ind coal x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_metSilicon]
  ring
@[simp] theorem lf_polysilicon (q : ℚ) : fab.laborFor polysilicon q = q * (51/5) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_metSilicon]
  ring

@[simp] theorem rd_powerSupply (q : ℚ) (x : Part) :
    fab.rawDemand powerSupply q x = q * (4 * ind ironOre x + 44/5 * ind copperOre x + 3/2 * ind coal x + 1/2 * ind limestone x + 7/10 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_steelStock, rd_copperWire, rd_pcb]
  ring
@[simp] theorem lf_powerSupply (q : ℚ) : fab.laborFor powerSupply q = q * (521/200) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_steelStock, lf_copperWire, lf_pcb]
  ring

@[simp] theorem rd_siliconIngot (q : ℚ) (x : Part) :
    fab.rawDemand siliconIngot q x = q * (231/80 * ind silicaSand x + 693/400 * ind coal x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_polysilicon]
  ring
@[simp] theorem lf_siliconIngot (q : ℚ) : fab.laborFor siliconIngot q = q * (1671/100) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_polysilicon]
  ring

@[simp] theorem rd_wafer (q : ℚ) (x : Part) :
    fab.rawDemand wafer q x = q * (231/160 * ind silicaSand x + 693/800 * ind coal x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_siliconIngot]
  ring
@[simp] theorem lf_wafer (q : ℚ) : fab.laborFor wafer q = q * (1691/200) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_siliconIngot]
  ring

@[simp] theorem rd_dopedWafer (q : ℚ) (x : Part) :
    fab.rawDemand dopedWafer q x = q * (5787/4000 * ind silicaSand x + 693/800 * ind coal x + 201/5000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_wafer, rd_photoresist, rd_maskSet]
  ring
@[simp] theorem lf_dopedWafer (q : ℚ) : fab.laborFor dopedWafer q = q * (1147741/100000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_wafer, lf_photoresist, lf_maskSet]
  ring

@[simp] theorem rd_die (q : ℚ) (x : Part) :
    fab.rawDemand die q x = q * (5787/800000 * ind silicaSand x + 693/160000 * ind coal x + 201/1000000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_dopedWafer]
  ring
@[simp] theorem lf_die (q : ℚ) : fab.laborFor die q = q * (1247741/20000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_dopedWafer]
  ring

@[simp] theorem rd_logicChip (q : ℚ) (x : Part) :
    fab.rawDemand logicChip q x = q * (5787/800000 * ind silicaSand x + 2/125 * ind copperOre x + 693/160000 * ind coal x + 6201/1000000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_die, rd_copperWire, rd_polymerPellet]
  ring
@[simp] theorem lf_logicChip (q : ℚ) : fab.laborFor logicChip q = q * (2250741/20000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_die, lf_copperWire, lf_polymerPellet]
  ring

@[simp] theorem rd_microcontrollerChip (q : ℚ) (x : Part) :
    fab.rawDemand microcontrollerChip q x = q * (5787/800000 * ind silicaSand x + 2/125 * ind copperOre x + 693/160000 * ind coal x + 6201/1000000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_die, rd_copperWire, rd_polymerPellet]
  ring
@[simp] theorem lf_microcontrollerChip (q : ℚ) : fab.laborFor microcontrollerChip q = q * (2250741/20000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_die, lf_copperWire, lf_polymerPellet]
  ring

@[simp] theorem rd_memoryChip (q : ℚ) (x : Part) :
    fab.rawDemand memoryChip q x = q * (5787/400000 * ind silicaSand x + 4/125 * ind copperOre x + 693/80000 * ind coal x + 6201/500000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_die, rd_copperWire, rd_polymerPellet]
  ring
@[simp] theorem lf_memoryChip (q : ℚ) : fab.laborFor memoryChip q = q * (2250741/10000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_die, lf_copperWire, lf_polymerPellet]
  ring

@[simp] theorem rd_cpuChip (q : ℚ) (x : Part) :
    fab.rawDemand cpuChip q x = q * (5787/200000 * ind silicaSand x + 2/25 * ind copperOre x + 693/40000 * ind coal x + 6201/250000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_die, rd_copperWire, rd_polymerPellet]
  ring
@[simp] theorem lf_cpuChip (q : ℚ) : fab.laborFor cpuChip q = q * (2251241/5000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_die, lf_copperWire, lf_polymerPellet]
  ring

@[simp] theorem rd_controlBoard (q : ℚ) (x : Part) :
    fab.rawDemand controlBoard q x = q * (17361/800000 * ind silicaSand x + 156/125 * ind copperOre x + 2079/160000 * ind coal x + 718603/1000000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_pcb, rd_microcontrollerChip, rd_logicChip, rd_copperWire]
  ring
@[simp] theorem lf_controlBoard (q : ℚ) : fab.laborFor controlBoard q = q * (37102223/20000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_pcb, lf_microcontrollerChip, lf_logicChip, lf_copperWire]
  ring

@[simp] theorem rd_motherboard (q : ℚ) (x : Part) :
    fab.rawDemand motherboard q x = q * (52083/400000 * ind silicaSand x + 338/125 * ind copperOre x + 6237/80000 * ind coal x + 755809/500000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_pcb, rd_cpuChip, rd_memoryChip, rd_logicChip, rd_copperWire]
  ring
@[simp] theorem lf_motherboard (q : ℚ) : fab.laborFor motherboard q = q * (60607669/10000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_pcb, lf_cpuChip, lf_memoryChip, lf_logicChip, lf_copperWire]
  ring

@[simp] theorem rd_printer3D (q : ℚ) (x : Part) :
    fab.rawDemand printer3D q x = q * (17361/800000 * ind silicaSand x + 73 * ind ironOre x + 8256/125 * ind copperOre x + 4382079/160000 * ind coal x + 73/8 * ind limestone x + 1978603/1000000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_printerFrame, rd_electricMotor, rd_hotEnd, rd_controlBoard, rd_filament]
  ring
@[simp] theorem lf_printer3D (q : ℚ) : fab.laborFor printer3D q = q * (582012223/20000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_printerFrame, lf_electricMotor, lf_hotEnd, lf_controlBoard, lf_filament]
  ring

@[simp] theorem rd_printedCase (q : ℚ) (x : Part) :
    fab.rawDemand printedCase q x = q * (189/50 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_filament]
  ring
@[simp] theorem lf_printedCase (q : ℚ) : fab.laborFor printedCase q = q * (12663/2000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_filament]
  ring

@[simp] theorem rd_computer (q : ℚ) (x : Part) :
    fab.rawDemand computer q x = q * (52083/400000 * ind silicaSand x + 4 * ind ironOre x + 1438/125 * ind copperOre x + 126237/80000 * ind coal x + 1/2 * ind limestone x + 2995809/500000 * ind crudeOil x) := by
  rw [Workflow.Plant.rawDemand_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    rd_motherboard, rd_powerSupply, rd_printedCase]
  ring
@[simp] theorem lf_computer (q : ℚ) : fab.laborFor computer q = q * (169972669/10000000) := by
  rw [Workflow.Plant.laborFor_eq]
  simp only [fab_recipe, recipe, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    lf_motherboard, lf_powerSupply, lf_printedCase]
  ring

/-! ## The headline numbers -/

/-- The total mass of raw material in a demand vector.  All six raw materials
are measured in kilograms, so they may simply be added up. -/
def rawTotal (d : Part → ℚ) : ℚ :=
  d silicaSand + d ironOre + d copperOre + d coal + d limestone + d crudeOil

/-- **The raw-material bill of one computer.**  Following every workflow back
to the ground: 0.13 kg of silica sand, 4 kg of iron ore, 11.5 kg of copper
ore, 1.58 kg of coal, 0.5 kg of limestone and 5.99 kg of crude oil. -/
theorem computer_rawDemand :
    fab.rawDemand computer 1 silicaSand = 52083/400000 ∧
    fab.rawDemand computer 1 ironOre = 4 ∧
    fab.rawDemand computer 1 copperOre = 1438/125 ∧
    fab.rawDemand computer 1 coal = 126237/80000 ∧
    fab.rawDemand computer 1 limestone = 1/2 ∧
    fab.rawDemand computer 1 crudeOil = 2995809/500000 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [ind]

/-- **The raw-material bill of one 3D printer.**  The printer is mostly steel
frame and copper winding: 73 kg of iron ore and 66 kg of copper ore. -/
theorem printer3D_rawDemand :
    fab.rawDemand printer3D 1 silicaSand = 17361/800000 ∧
    fab.rawDemand printer3D 1 ironOre = 73 ∧
    fab.rawDemand printer3D 1 copperOre = 8256/125 ∧
    fab.rawDemand printer3D 1 coal = 4382079/160000 ∧
    fab.rawDemand printer3D 1 limestone = 73/8 ∧
    fab.rawDemand printer3D 1 crudeOil = 1978603/1000000 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> simp [ind]

/-- One computer takes 23.70 kg of raw material out of the ground. -/
theorem computer_rawTotal : rawTotal (fab.rawDemand computer 1) = 5925947/250000 := by
  simp [rawTotal, ind]; norm_num

theorem computer_rawTotal_bounds :
    23 < rawTotal (fab.rawDemand computer 1) ∧ rawTotal (fab.rawDemand computer 1) < 24 := by
  rw [computer_rawTotal]; constructor <;> norm_num

/-- One 3D printer takes 177.56 kg. -/
theorem printer3D_rawTotal : rawTotal (fab.rawDemand printer3D 1) = 88780649/500000 := by
  simp [rawTotal, ind]; norm_num

/-- **The printer costs seven computers.**  The machine that prints the case
is much the heavier of the two: silicon is light, and steel is not. -/
theorem printer_heavier_than_computer :
    7 * rawTotal (fab.rawDemand computer 1) < rawTotal (fab.rawDemand printer3D 1) := by
  rw [computer_rawTotal, printer3D_rawTotal]; norm_num

/-- The hours of work in one computer, and in one printer. -/
theorem computer_labor : fab.laborFor computer 1 = 169972669/10000000 := by simp

theorem printer3D_labor : fab.laborFor printer3D 1 = 582012223/20000000 := by simp

theorem computer_labor_bounds : 16 < fab.laborFor computer 1 ∧ fab.laborFor computer 1 < 17 := by
  rw [computer_labor]; constructor <;> norm_num

/-! ## The instruments cost more than the machine -/

/-- The raw material in one of each instrument the fab builds for itself. -/
noncomputable def toolingDemand (x : Part) : ℚ :=
  (fabTools.map (fun t => fab.rawDemand t 1 x)).sum

/-- **Twelve tonnes of instruments.**  Equipping the fab — the glass furnace,
the arc furnace, the extruder, the etch line, the wire saw, the dicing saw,
the clean room, the Siemens reactor, the crystal puller, the diffusion
furnace, the wire bonder, the stepper and the printer — takes 12019 kg out
of the ground. -/
theorem tooling_rawTotal : rawTotal toolingDemand = 6009530649/500000 := by
  simp [rawTotal, toolingDemand, fabTools, ind]; norm_num

/-- **The means of production cost five hundred computers.** -/
theorem tooling_dwarfs_the_computer :
    500 * rawTotal (fab.rawDemand computer 1) < rawTotal toolingDemand := by
  rw [computer_rawTotal, tooling_rawTotal]; norm_num

/-- **And two and a half tractors.**  Equipping a fab takes more out of the
ground than building two LifeTracs, whose bill is 4760.96 kg
(`Workflow.lifeTrac_rawTotal`). -/
theorem tooling_exceeds_two_tractors :
    2 * Workflow.rawTotal (Workflow.plant.rawDemand Workflow.Item.lifeTrac 1) <
      rawTotal toolingDemand := by
  rw [Workflow.lifeTrac_rawTotal, tooling_rawTotal]; norm_num

/-- **A computer is a two-hundredth of a tractor.**  Measured in ore, the
thinking machine is the cheap one; it is the plant behind it that is dear. -/
theorem computer_lighter_than_tractor :
    200 * rawTotal (fab.rawDemand computer 1) <
      Workflow.rawTotal (Workflow.plant.rawDemand Workflow.Item.lifeTrac 1) := by
  rw [Workflow.lifeTrac_rawTotal, computer_rawTotal]; norm_num

/-! ## Nothing but the ground -/

/-- Nothing the fab makes appears in its own raw-material demand: the demand
is expressed purely in what comes out of the ground. -/
theorem computer_demand_raw (x : Part) (hx : fab.recipe x ≠ none) :
    fab.rawDemand computer 1 x = 0 :=
  fab.rawDemand_eq_zero_of_made hx computer 1

/-- The instruments are used, not used up: none of them appears in the bill
for the computer. -/
theorem computer_demand_seedTools (t : Part) (ht : t ∈ seedTools) :
    fab.rawDemand computer 1 t = 0 := by
  fin_cases ht <;> simp [ind]

end Fab
end LifeTrac

