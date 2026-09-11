import RequestProject.Gvcs.Process
import RequestProject.Gvcs.Materials

set_option maxRecDepth 40000

/-!
# The LifeTrac production system, from ore upwards

`RequestProject/Materials.lean` explodes the tractor into a catalogue of stock
material — tube, plate, hose, an engine — and stops there, because that is
where a builder's purchase order stops.  This file does not stop there: it
gives a **workflow for every one of those items**, and for the mill goods they
are made of, and for the shop tools used to make them, all the way down to
what comes out of the ground.

The item universe is in five layers.

* **Raw materials** — iron ore, coal, limestone, silica sand, crude oil,
  natural latex, copper ore.  Nothing makes these; they are dug or grown.
* **Seed tools** — the coke oven, blast furnace, induction furnace, rolling
  mill, tube mill, foundry, refinery, copper smelter, rubber mill, engine
  lathe, milling machine, MIG welder and hand tools.  The model does not make
  these either: they are the plant one must already have (or buy) before the
  first LifeTrac can be built.  Together with the raw materials they are the
  entire *base* of the system (`base_eq`).
* **Mill goods** — coke, pig iron, steel, hot-rolled strip, bar, wire rod,
  cast iron, welded tube, and the oil, plastic, rubber and copper streams.
* **Shop-built tools** — the welding table, cut-off saw, drill press, CNC
  torch table, press brake, arbor press, ironworker, wire-drawing bench and
  blending tank.  These are *made by the plant*, out of mill goods, using only
  the seed tools (`shopTools_use_only_seed`): this is the bootstrap step.
* **Stock and assemblies** — the twenty-four catalogue items of
  `Materials.lean` and the six subassemblies of the machine.  The
  subassemblies' input lists are not written out again here: they are read off
  the bill of materials of `Materials.lean` (`bomInputs`), so the two
  descriptions of the machine cannot drift apart.

Quantities of mill goods are kilograms; quantities of catalogue stock are in
the units of `Build.Material.unitName`; assemblies are counted in pieces.
Yields are deliberately less than one — 1.6 kg of ore per kilogram of pig
iron, 5 % scrap when rolling — so the ore demand of the finished machine is
strictly larger than its mass.

The numbers are illustrative of the machine class and of standard practice,
not quotations from a particular mill.
-/

namespace LifeTrac
namespace Workflow

open Build (Material Assembly)

/-- Everything the production system knows about: raw materials, seed tools,
mill goods, shop-built tools, catalogue stock and the assemblies of the
machine. -/
inductive Item where
  -- raw materials
  | ironOre | coal | limestone | silicaSand | crudeOil | latex | copperOre
  -- seed tools: the plant one must start with
  | cokeOven | blastFurnace | inductionFurnace | rollingMill | tubeMill | foundry
  | refinery | copperSmelter | rubberMill | machineLathe | millingMachine | migWelder
  | handTools
  -- mill goods
  | coke | pigIron | steel | hotStrip | barStock | wireRod | castIron | tubeStock
  | plasticStock | oilStock | rubberStock | copperStock
  -- tools the shop builds for itself
  | weldingTable | cutoffSaw | drillPress | torchTable | pressBrake | arborPress
  | ironworker | wireDrawBench | blendingTank
  -- the catalogue of `Materials.lean`
  | steelTube4 | steelTube3 | steelTube2 | steelPlate6 | steelPlate12 | roundBar50
  | boltM12 | nutM12 | weldWire | hose | fitting | fluid | gearPump | wheelMotor
  | cylinder | controlValve | engine | fuelTank | hydraulicTank | wheelHub | tire
  | seat | paint | electricalKit
  -- the machine
  | frame | wheelModule | powerUnit | controlStation | loader | finishing | lifeTrac
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Item

/-- The catalogue item of `Materials.lean` as an item of the production
system. -/
def ofMaterial : Material → Item
  | .steelTube4 => steelTube4
  | .steelTube3 => steelTube3
  | .steelTube2 => steelTube2
  | .steelPlate6 => steelPlate6
  | .steelPlate12 => steelPlate12
  | .roundBar50 => roundBar50
  | .boltM12 => boltM12
  | .nutM12 => nutM12
  | .weldWire => weldWire
  | .hose => hose
  | .fitting => fitting
  | .fluid => fluid
  | .gearPump => gearPump
  | .wheelMotor => wheelMotor
  | .cylinder => cylinder
  | .controlValve => controlValve
  | .engine => engine
  | .fuelTank => fuelTank
  | .hydraulicTank => hydraulicTank
  | .wheelHub => wheelHub
  | .tire => tire
  | .seat => seat
  | .paint => paint
  | .electricalKit => electricalKit

theorem ofMaterial_injective : Function.Injective ofMaterial := by decide

/-- The raw materials: what the system takes out of the ground. -/
def rawMaterials : List Item :=
  [ironOre, coal, limestone, silicaSand, crudeOil, latex, copperOre]

/-- The seed toolkit: the equipment the system does not make and must be
started with. -/
def seedToolkit : List Item :=
  [cokeOven, blastFurnace, inductionFurnace, rollingMill, tubeMill, foundry, refinery,
   copperSmelter, rubberMill, machineLathe, millingMachine, migWelder, handTools]

/-- The tools the shop builds for itself before it builds the tractor. -/
def shopTools : List Item :=
  [weldingTable, cutoffSaw, drillPress, torchTable, pressBrake, arborPress, ironworker,
   wireDrawBench, blendingTank]

end Item

open Item

/-! ## The assembly stage, read off the bill of materials

The subassemblies of the machine are not described again here.  `bomInputs`
turns a bill of materials from `Materials.lean` into an input list, and
`bomLabor` reads off its own fabrication time, so the workflows below are the
bills of materials of that file by construction. -/

/-- The stock items a bill of materials draws, as an input list. -/
def bomInputs : Assembly → List (Item × ℚ)
  | .stock m q => [(ofMaterial m, q)]
  | .part _ _ cs => (cs.map bomInputs).flatten

/-- The fabrication time of a bill of materials' own step, excluding its
children. -/
def bomLabor : Assembly → ℚ
  | .stock _ _ => 0
  | .part _ l _ => l

/-! ## The workflows -/

/-- The workflow that makes each item, if the system makes it.  `none` marks
the base of the system: raw materials and the seed toolkit. -/
def recipe : Item → Option (Recipe Item)
  -- raw materials and seed tools: the base
  | ironOre | coal | limestone | silicaSand | crudeOil | latex | copperOre => none
  | cokeOven | blastFurnace | inductionFurnace | rollingMill | tubeMill | foundry
  | refinery | copperSmelter | rubberMill | machineLathe | millingMachine | migWelder
  | handTools => none
  -- mill goods (quantities in kilograms)
  | coke => some ⟨1, [(coal, 3/2)], [cokeOven], 1/50⟩
  | pigIron => some ⟨1, [(ironOre, 8/5), (coke, 1/2), (limestone, 3/10)], [blastFurnace], 1/50⟩
  | steel => some ⟨1, [(pigIron, 11/10), (coke, 1/20)], [inductionFurnace], 1/50⟩
  | hotStrip => some ⟨1, [(steel, 21/20)], [rollingMill], 1/100⟩
  | barStock => some ⟨1, [(steel, 21/20)], [rollingMill], 1/100⟩
  | wireRod => some ⟨1, [(steel, 103/100)], [rollingMill], 1/100⟩
  | castIron => some ⟨1, [(pigIron, 21/20), (silicaSand, 1/5)], [foundry], 1/20⟩
  | tubeStock => some ⟨1, [(hotStrip, 51/50)], [tubeMill], 1/100⟩
  | plasticStock => some ⟨1, [(crudeOil, 6/5)], [refinery], 1/100⟩
  | oilStock => some ⟨1, [(crudeOil, 13/10)], [refinery], 1/100⟩
  | rubberStock => some ⟨1, [(latex, 9/10), (coal, 1/20)], [rubberMill], 1/50⟩
  | copperStock => some ⟨1, [(copperOre, 8)], [copperSmelter], 1/20⟩
  -- the tools the shop builds for itself, out of mill goods, with seed tools only
  | weldingTable => some ⟨1, [(hotStrip, 60), (tubeStock, 25)], [migWelder, handTools], 8⟩
  | cutoffSaw =>
      some ⟨1, [(hotStrip, 20), (barStock, 15), (castIron, 10)],
        [migWelder, machineLathe, handTools], 10⟩
  | drillPress =>
      some ⟨1, [(castIron, 40), (barStock, 20)], [machineLathe, millingMachine, handTools], 12⟩
  | torchTable =>
      some ⟨1, [(hotStrip, 80), (tubeStock, 40), (barStock, 10), (copperStock, 2),
        (plasticStock, 3)], [migWelder, machineLathe, handTools], 30⟩
  | pressBrake =>
      some ⟨1, [(hotStrip, 120), (barStock, 40)], [migWelder, machineLathe, handTools], 20⟩
  | arborPress =>
      some ⟨1, [(hotStrip, 100), (barStock, 25), (castIron, 30)],
        [migWelder, machineLathe, handTools], 24⟩
  | ironworker =>
      some ⟨1, [(hotStrip, 90), (barStock, 35), (castIron, 20)],
        [migWelder, machineLathe, millingMachine, handTools], 26⟩
  | wireDrawBench =>
      some ⟨1, [(hotStrip, 40), (barStock, 20), (castIron, 15)],
        [migWelder, machineLathe, handTools], 14⟩
  | blendingTank => some ⟨1, [(hotStrip, 25)], [migWelder, handTools], 4⟩
  -- the catalogue stock, per unit of `Build.Material.unitName`
  | steelTube4 => some ⟨1, [(tubeStock, 47/2)], [cutoffSaw], 1/10⟩
  | steelTube3 => some ⟨1, [(tubeStock, 87/5)], [cutoffSaw], 1/10⟩
  | steelTube2 => some ⟨1, [(tubeStock, 46/5)], [cutoffSaw], 1/10⟩
  | steelPlate6 => some ⟨1, [(hotStrip, 48)], [torchTable], 1/5⟩
  | steelPlate12 => some ⟨1, [(hotStrip, 96)], [torchTable, ironworker], 1/4⟩
  | roundBar50 => some ⟨1, [(barStock, 157/10)], [cutoffSaw, ironworker], 1/10⟩
  | boltM12 => some ⟨100, [(barStock, 12)], [machineLathe], 1⟩
  | nutM12 => some ⟨100, [(barStock, 4)], [machineLathe], 1/2⟩
  | weldWire => some ⟨1, [(wireRod, 21/20)], [wireDrawBench], 1/20⟩
  | hose => some ⟨1, [(rubberStock, 3/4), (wireRod, 1/5)], [rubberMill], 1/20⟩
  | fitting => some ⟨1, [(barStock, 9/50)], [machineLathe], 1/10⟩
  | fluid => some ⟨1, [(oilStock, 9/10)], [blendingTank], 1/100⟩
  | paint => some ⟨1, [(oilStock, 4/5), (plasticStock, 2/5), (limestone, 1/10)],
      [blendingTank], 1/100⟩
  | wheelHub => some ⟨1, [(castIron, 10), (barStock, 3)], [machineLathe, drillPress], 3/2⟩
  | tire => some ⟨1, [(rubberStock, 30), (wireRod, 3), (hotStrip, 14)],
      [arborPress, migWelder, weldingTable], 2⟩
  | seat => some ⟨1, [(hotStrip, 5), (plasticStock, 2), (rubberStock, 2)],
      [pressBrake, migWelder], 3/2⟩
  | fuelTank => some ⟨1, [(hotStrip, 9)], [pressBrake, migWelder, weldingTable], 2⟩
  | hydraulicTank => some ⟨1, [(hotStrip, 33/2)], [pressBrake, migWelder, weldingTable], 3⟩
  | gearPump => some ⟨1, [(castIron, 8), (barStock, 4), (rubberStock, 3/10)],
      [machineLathe, millingMachine, drillPress], 6⟩
  | wheelMotor => some ⟨1, [(castIron, 20), (barStock, 9), (rubberStock, 1/2)],
      [machineLathe, millingMachine, drillPress], 10⟩
  | cylinder => some ⟨1, [(tubeStock, 10), (barStock, 9), (rubberStock, 2/5)],
      [machineLathe, migWelder, weldingTable], 5⟩
  | controlValve => some ⟨1, [(castIron, 9), (barStock, 5), (rubberStock, 1/5)],
      [machineLathe, millingMachine, drillPress], 8⟩
  | electricalKit => some ⟨1, [(copperStock, 2), (plasticStock, 3/2), (hotStrip, 3)],
      [handTools], 3⟩
  | engine => some ⟨1, [(castIron, 90), (barStock, 40), (hotStrip, 15), (copperStock, 5),
      (plasticStock, 4), (rubberStock, 2)],
      [machineLathe, millingMachine, drillPress, arborPress], 60⟩
  -- the assemblies; these input lists are exactly the bills of materials of
  -- `Materials.lean` (see `frame_recipe_eq_bom` and its companions below)
  | frame => some ⟨1, [(steelTube4, 12), (steelTube3, 8), (steelPlate6, 3/2), (weldWire, 6),
      (boltM12, 40), (nutM12, 40)],
      [torchTable, weldingTable, cutoffSaw, drillPress, ironworker, migWelder, handTools], 24⟩
  | wheelModule => some ⟨1, [(wheelHub, 1), (tire, 1), (wheelMotor, 1), (steelPlate12, 1/5),
      (hose, 4), (fitting, 4), (boltM12, 8), (nutM12, 8)],
      [torchTable, drillPress, handTools], 4⟩
  | powerUnit => some ⟨1, [(engine, 1), (gearPump, 1), (hydraulicTank, 1), (fuelTank, 1),
      (fluid, 40), (steelPlate6, 1/2), (hose, 6), (fitting, 8), (boltM12, 16), (nutM12, 16)],
      [weldingTable, drillPress, migWelder, handTools], 12⟩
  | controlStation => some ⟨1, [(controlValve, 2), (seat, 1), (electricalKit, 1),
      (steelTube2, 6), (hose, 10), (fitting, 12), (boltM12, 12), (nutM12, 12)],
      [cutoffSaw, weldingTable, drillPress, handTools], 8⟩
  | loader => some ⟨1, [(steelTube3, 6), (steelPlate12, 6/5), (roundBar50, 3/2), (cylinder, 2),
      (hose, 8), (fitting, 8), (weldWire, 3)],
      [torchTable, weldingTable, cutoffSaw, migWelder, handTools], 16⟩
  | finishing => some ⟨1, [(paint, 8), (boltM12, 20), (nutM12, 20)], [handTools], 6⟩
  | lifeTrac => some ⟨1, [(frame, 1), (wheelModule, 4), (powerUnit, 1), (controlStation, 1),
      (loader, 1), (finishing, 1)], [weldingTable, handTools], 10⟩

/-- How deep in the production system an item sits.  Every workflow consumes
and uses only strictly shallower items, which is what makes the system
buildable at all. -/
def rank : Item → ℕ
  | ironOre | coal | limestone | silicaSand | crudeOil | latex | copperOre => 0
  | cokeOven | blastFurnace | inductionFurnace | rollingMill | tubeMill | foundry
  | refinery | copperSmelter | rubberMill | machineLathe | millingMachine | migWelder
  | handTools => 0
  | coke | plasticStock | oilStock | rubberStock | copperStock => 1
  | pigIron => 2
  | steel => 3
  | hotStrip | barStock | wireRod | castIron => 4
  | tubeStock => 5
  | weldingTable | cutoffSaw | drillPress | torchTable | pressBrake | arborPress
  | ironworker | wireDrawBench | blendingTank => 6
  | steelTube4 | steelTube3 | steelTube2 | steelPlate6 | steelPlate12 | roundBar50
  | boltM12 | nutM12 | weldWire | hose | fitting | fluid | paint => 7
  | gearPump | wheelMotor | cylinder | controlValve | fuelTank | hydraulicTank
  | wheelHub | tire | seat | electricalKit => 8
  | engine => 9
  | frame | wheelModule | powerUnit | controlStation | loader | finishing => 10
  | lifeTrac => 11

/-- **The LifeTrac production system.**  The whole catalogue of workflows,
together with the certificate that it is not circular: everything consumed,
and every tool used, is strictly shallower than what it makes. -/
def plant : Plant Item where
  recipe := recipe
  rank := rank
  batch_pos := by
    intro i r h
    cases i <;> simp only [recipe] at h <;>
      first
        | (injection h with h'; subst h'; norm_num)
        | exact absurd h (by simp)
  qty_nonneg := by
    intro i r h
    cases i <;> simp only [recipe] at h <;>
      first
        | (injection h with h'; subst h'; norm_num)
        | exact absurd h (by simp)
  labor_nonneg := by
    intro i r h
    cases i <;> simp only [recipe] at h <;>
      first
        | (injection h with h'; subst h'; norm_num)
        | exact absurd h (by simp)
  rank_input := by decide
  rank_tool := by decide

@[simp] theorem plant_recipe : plant.recipe = recipe := rfl

@[simp] theorem plant_rank : plant.rank = rank := rfl

/-! ## The assembly workflows are the bill of materials of `Materials.lean`

Each subassembly's input list, and the hours booked against it, are exactly
what the bill-of-materials tree of `Materials.lean` says; the two files
describe the same machine. -/

theorem frame_recipe_eq_bom :
    recipe frame = some ⟨1, bomInputs Build.frame,
      [torchTable, weldingTable, cutoffSaw, drillPress, ironworker, migWelder, handTools],
      bomLabor Build.frame⟩ := by
  simp [recipe, bomInputs, bomLabor, Build.frame, ofMaterial]

theorem wheelModule_recipe_eq_bom :
    recipe wheelModule = some ⟨1, bomInputs Build.wheelModule,
      [torchTable, drillPress, handTools], bomLabor Build.wheelModule⟩ := by
  simp [recipe, bomInputs, bomLabor, Build.wheelModule, ofMaterial]

theorem powerUnit_recipe_eq_bom :
    recipe powerUnit = some ⟨1, bomInputs Build.powerUnit,
      [weldingTable, drillPress, migWelder, handTools], bomLabor Build.powerUnit⟩ := by
  simp [recipe, bomInputs, bomLabor, Build.powerUnit, ofMaterial]

theorem controlStation_recipe_eq_bom :
    recipe controlStation = some ⟨1, bomInputs Build.controlStation,
      [cutoffSaw, weldingTable, drillPress, handTools], bomLabor Build.controlStation⟩ := by
  simp [recipe, bomInputs, bomLabor, Build.controlStation, ofMaterial]

theorem loader_recipe_eq_bom :
    recipe loader = some ⟨1, bomInputs Build.loader,
      [torchTable, weldingTable, cutoffSaw, migWelder, handTools], bomLabor Build.loader⟩ := by
  simp [recipe, bomInputs, bomLabor, Build.loader, ofMaterial]

theorem finishing_recipe_eq_bom :
    recipe finishing = some ⟨1, bomInputs Build.finishing, [handTools],
      bomLabor Build.finishing⟩ := by
  simp [recipe, bomInputs, bomLabor, Build.finishing, ofMaterial]

/-- The final assembly step books the same ten hours as the bill of
materials. -/
theorem lifeTrac_labor_eq_bom :
    ∀ r, recipe lifeTrac = some r → r.labor = bomLabor Build.lifeTrac := by
  simp [recipe, bomLabor, Build.lifeTrac]

/-! ## The base of the system -/

/-- **The system is based on raw materials and a seed toolkit, and on nothing
else.**  An item has no workflow exactly when it is one of the seven raw
materials or one of the thirteen seed tools. -/
theorem base_eq (i : Item) :
    plant.recipe i = none ↔ i ∈ rawMaterials ∨ i ∈ seedToolkit := by
  revert i; decide

/-- No raw material is made by the system. -/
theorem rawMaterials_base : ∀ i ∈ rawMaterials, plant.recipe i = none := by decide

/-- No seed tool is made by the system. -/
theorem seedToolkit_base : ∀ i ∈ seedToolkit, plant.recipe i = none := by decide

/-- **Everything else the system makes itself.**  Every item that is neither a
raw material nor a seed tool has a workflow. -/
theorem has_recipe (i : Item) (h₁ : i ∉ rawMaterials) (h₂ : i ∉ seedToolkit) :
    (plant.recipe i).isSome := by
  revert i; decide

/-- **Everything can be built from the base.**  Every item of the system — every
piece of the tractor, every piece of stock, and every tool the shop builds for
itself — can be produced starting from raw materials and the seed toolkit
alone. -/
theorem producible (i : Item) : plant.Producible i := plant.producible i

/-! ## The bootstrap: the shop builds its own tools -/

/-- Every shop-built tool really is built by the system. -/
theorem shopTools_made : ∀ t ∈ shopTools, (plant.recipe t).isSome := by decide

/-- **The bootstrap step.**  Each tool the shop builds for itself is made
using nothing but the seed toolkit: no shop-built tool is needed to build
another. -/
theorem shopTools_use_only_seed :
    ∀ t ∈ shopTools, ∀ r, plant.recipe t = some r → ∀ u ∈ r.tools, u ∈ seedToolkit := by
  decide

/-- Each shop-built tool is made out of mill goods only — nothing from the
catalogue of finished stock is needed to equip the shop. -/
theorem shopTools_from_mill_goods :
    ∀ t ∈ shopTools, ∀ r, plant.recipe t = some r → ∀ p ∈ r.inputs, rank p.1 ≤ 5 := by
  decide

/-- Every tool called for by any workflow is either a seed tool or one the
shop builds for itself: the tool list of the system is closed. -/
theorem tools_seed_or_shop (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    ∀ t ∈ r.tools, t ∈ seedToolkit ∨ t ∈ shopTools := by
  revert i r h; decide

/-- No machine is needed in order to build itself, however indirectly. -/
theorem no_self_tooling (i : Item) : i ∉ plant.toolClosure i :=
  plant.not_mem_toolClosure_self i

/-! ## A build order for the whole system

`buildOrder` lists every item of the system in an order in which it can
actually be worked through: when a workflow is reached, everything it consumes
and every tool it needs has already been made. -/

/-- A complete schedule for the production system: raw materials and seed
tools first, then the mill goods, then the tools the shop builds for itself,
then the catalogue stock, then the assemblies. -/
def buildOrder : List Item :=
  rawMaterials ++ seedToolkit ++
  [coke, plasticStock, oilStock, rubberStock, copperStock, pigIron, steel,
   hotStrip, barStock, wireRod, castIron, tubeStock] ++
  shopTools ++
  [steelTube4, steelTube3, steelTube2, steelPlate6, steelPlate12, roundBar50, boltM12,
   nutM12, weldWire, hose, fitting, fluid, paint, gearPump, wheelMotor, cylinder,
   controlValve, fuelTank, hydraulicTank, wheelHub, tire, seat, electricalKit, engine] ++
  [frame, wheelModule, powerUnit, controlStation, loader, finishing, lifeTrac]

/-- The schedule leaves nothing out. -/
theorem mem_buildOrder (i : Item) : i ∈ buildOrder := by revert i; decide

/-- The schedule repeats nothing. -/
theorem buildOrder_nodup : buildOrder.Nodup := by decide

/-- **The schedule is workable.**  By the time each workflow is reached,
everything it consumes has already been produced. -/
theorem buildOrder_inputs_first (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    ∀ p ∈ r.inputs, buildOrder.idxOf p.1 < buildOrder.idxOf i := by
  revert i r h; decide

/-- … and every tool it needs is already standing in the shop. -/
theorem buildOrder_tools_first (i : Item) (r : Recipe Item) (h : plant.recipe i = some r) :
    ∀ t ∈ r.tools, buildOrder.idxOf t < buildOrder.idxOf i := by
  revert i r h; decide

/-- The schedule starts with the base of the system: the first twenty entries
are the raw materials and the seed toolkit, and they need no work. -/
theorem buildOrder_take_base : buildOrder.take 20 = rawMaterials ++ seedToolkit := by decide

/-- … and ends with the tractor. -/
theorem buildOrder_getLast : buildOrder.getLast? = some lifeTrac := by decide

end Workflow
end LifeTrac
