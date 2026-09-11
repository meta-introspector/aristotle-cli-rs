import RequestProject.Gvcs.Workshop
import RequestProject.Gvcs.Bounds
import RequestProject.Gvcs.SkillTree

set_option maxRecDepth 40000

/-!
# The fab: making a 3D printer and a computer out of the same ground

`RequestProject/Fabrication.lean` takes seven raw materials and a seed toolkit
and ends with a tractor.  This file starts in the same place and ends
somewhere else: with a **3D printer** and a **computer**.

The item universe is again in layers.

* **Raw materials** — silica sand, iron ore, copper ore, coal, limestone and
  crude oil.  Nothing makes these.
* **Seed tools** — the ore smelter, the oil refinery, the metal shop (lathe,
  mill and welder) and the wood-gas power plant.  This is the shop the
  LifeTrac era already left standing; the fab does not make it either.
* **Mill goods** — steel stock, copper wire, polymer pellet, photoresist,
  glass blank, metallurgical silicon, filament, printed-circuit board.
* **Tools the fab builds for itself** — the glass furnace, the arc furnace,
  the filament extruder, the etch line, the wire saw, the dicing saw, the
  clean room, the Siemens reactor, the crystal puller, the diffusion furnace,
  the wire bonder, the lithography stepper — and the 3D printer, which is the
  only tool that is also a product.
* **The silicon chain** — polysilicon, ingot, wafer, doped wafer, die, and the
  four packaged chips: logic, microcontroller, memory, processor.
* **The machines** — the printer, and then the computer, whose case is
  printed on it.

Everything below is forced by the workflows.  The printer is a *tool of* the
computer and never the other way round, which is the same ordering the skill
tree of `RequestProject/SkillTree.lean` records (`Skills.Skill.printer_before_computer`).

The numbers are illustrative of the technology, not quotations from a
particular fab; quantities of mill goods are kilograms, chips and machines are
counted in pieces, labour is hours.
-/

namespace LifeTrac
namespace Fab

open Workflow (Recipe Plant)

/-- Everything the fab knows about: raw materials, the seed shop, mill goods,
the tools the fab builds for itself, the silicon chain, and the two machines
at the end of it. -/
inductive Part where
  -- raw materials
  | silicaSand | ironOre | copperOre | coal | limestone | crudeOil
  -- the shop the tractor era left standing
  | oreSmelter | oilRefinery | metalShop | powerPlant
  -- mill goods
  | steelStock | copperWire | polymerPellet | photoresist | glassBlank | metSilicon
  | filament | pcb
  -- the tools the fab builds for itself
  | glassFurnace | arcFurnace | extruderTool | etchLine | electricMotor | wireSaw
  | dicingSaw | cleanRoom | siemensReactor | crystalPuller | diffusionFurnace
  | wireBonder | stepper | maskSet
  -- the silicon chain
  | polysilicon | siliconIngot | wafer | dopedWafer | die
  | logicChip | microcontrollerChip | memoryChip | cpuChip
  -- the machines
  | printerFrame | hotEnd | controlBoard | printer3D | printedCase | powerSupply
  | motherboard | computer
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Part

/-- What the fab digs out of the ground. -/
def rawParts : List Part := [silicaSand, ironOre, copperOre, coal, limestone, crudeOil]

/-- The shop the fab must already have: the equipment of the tractor era. -/
def seedTools : List Part := [oreSmelter, oilRefinery, metalShop, powerPlant]


/-- The tools the fab builds for itself before it can build a computer.  The
3D printer is one of them. -/
def fabTools : List Part :=
  [glassFurnace, arcFurnace, extruderTool, etchLine, wireSaw, dicingSaw, cleanRoom,
   siemensReactor, crystalPuller, diffusionFurnace, wireBonder, stepper, printer3D]

end Part

open Part

/-- The workflow that makes each part, if the fab makes it.  `none` marks the
base: the six raw materials and the four seed tools. -/
def recipe : Part → Option (Recipe Part)
  | silicaSand | ironOre | copperOre | coal | limestone | crudeOil
  | oreSmelter | oilRefinery | metalShop | powerPlant => none
  | steelStock => some ⟨1, [(ironOre, 2), (coal, 3/4), (limestone, 1/4)], [oreSmelter], 1/50⟩
  | copperWire => some ⟨1, [(copperOre, 8)], [oreSmelter, metalShop], 1/20⟩
  | polymerPellet => some ⟨1, [(crudeOil, 6/5)], [oilRefinery], 1/100⟩
  | photoresist => some ⟨1, [(crudeOil, 2)], [oilRefinery], 1/10⟩
  | glassFurnace => some ⟨1, [(steelStock, 400), (limestone, 50)], [metalShop], 40⟩
  | arcFurnace => some ⟨1, [(steelStock, 800), (copperWire, 60)], [metalShop], 60⟩
  | extruderTool => some ⟨1, [(steelStock, 60), (copperWire, 8)], [metalShop], 12⟩
  | etchLine =>
      some ⟨1, [(steelStock, 150), (polymerPellet, 20), (copperWire, 5)],
        [metalShop], 20⟩
  | electricMotor => some ⟨1, [(steelStock, 6), (copperWire, 2)], [metalShop], 3⟩
  | wireSaw => some ⟨1, [(steelStock, 120), (copperWire, 10)], [metalShop], 20⟩
  | printerFrame => some ⟨1, [(steelStock, 12)], [metalShop], 4⟩
  | hotEnd => some ⟨1, [(steelStock, 1/2), (copperWire, 1/10)], [metalShop], 2⟩
  | glassBlank => some ⟨1, [(silicaSand, 3/2)], [glassFurnace], 1/5⟩
  | metSilicon => some ⟨1, [(silicaSand, 5/2), (coal, 3/2)], [arcFurnace], 2⟩
  | filament => some ⟨1, [(polymerPellet, 21/20)], [extruderTool], 1/10⟩
  | pcb =>
      some ⟨1, [(polymerPellet, 1/2), (copperWire, 1/10), (photoresist, 1/20)],
        [etchLine], 1/2⟩
  | dicingSaw =>
      some ⟨1, [(steelStock, 90), (copperWire, 8), (electricMotor, 2)],
        [metalShop], 18⟩
  | cleanRoom =>
      some ⟨1, [(steelStock, 500), (polymerPellet, 200), (glassBlank, 40)],
        [metalShop], 200⟩
  | siemensReactor =>
      some ⟨1, [(steelStock, 300), (copperWire, 20), (glassBlank, 10)],
        [metalShop], 50⟩
  | crystalPuller =>
      some ⟨1, [(steelStock, 250), (copperWire, 30), (glassBlank, 5)],
        [metalShop], 45⟩
  | diffusionFurnace =>
      some ⟨1, [(steelStock, 180), (copperWire, 15), (glassBlank, 8)],
        [metalShop], 40⟩
  | wireBonder =>
      some ⟨1, [(steelStock, 70), (copperWire, 10), (electricMotor, 3), (pcb, 4)],
        [metalShop], 30⟩
  | stepper =>
      some ⟨1, [(steelStock, 200), (copperWire, 40), (glassBlank, 20), (electricMotor, 6), (pcb, 10)],
        [metalShop, cleanRoom], 300⟩
  | maskSet => some ⟨1, [(glassBlank, 2), (photoresist, 1/10)], [cleanRoom, etchLine], 20⟩
  | polysilicon => some ⟨1, [(metSilicon, 11/10)], [siemensReactor], 8⟩
  | powerSupply =>
      some ⟨1, [(steelStock, 2), (copperWire, 1), (pcb, 1)],
        [metalShop, wireBonder], 2⟩
  | siliconIngot => some ⟨1, [(polysilicon, 21/20)], [crystalPuller], 6⟩
  | wafer => some ⟨1, [(siliconIngot, 1/2)], [wireSaw], 1/10⟩
  | dopedWafer =>
      some ⟨1, [(wafer, 1), (photoresist, 1/50), (maskSet, 1/1000)],
        [stepper, diffusionFurnace, cleanRoom], 3⟩
  | die => some ⟨200, [(dopedWafer, 1)], [dicingSaw, cleanRoom], 1⟩
  | logicChip =>
      some ⟨1, [(die, 1), (copperWire, 1/500), (polymerPellet, 1/200)],
        [wireBonder], 1/20⟩
  | microcontrollerChip =>
      some ⟨1, [(die, 1), (copperWire, 1/500), (polymerPellet, 1/200)],
        [wireBonder], 1/20⟩
  | memoryChip =>
      some ⟨1, [(die, 2), (copperWire, 1/250), (polymerPellet, 1/100)],
        [wireBonder], 1/10⟩
  | cpuChip => some ⟨1, [(die, 4), (copperWire, 1/100), (polymerPellet, 1/50)], [wireBonder], 1/5⟩
  | controlBoard =>
      some ⟨1, [(pcb, 1), (microcontrollerChip, 1), (logicChip, 2), (copperWire, 1/20)],
        [wireBonder, metalShop], 1⟩
  | motherboard =>
      some ⟨1, [(pcb, 2), (cpuChip, 1), (memoryChip, 4), (logicChip, 6), (copperWire, 1/10)],
        [wireBonder, metalShop], 3⟩
  | printer3D =>
      some ⟨1, [(printerFrame, 1), (electricMotor, 4), (hotEnd, 1), (controlBoard, 1), (filament, 1)],
        [metalShop], 8⟩
  | printedCase => some ⟨1, [(filament, 3)], [printer3D], 6⟩
  | computer =>
      some ⟨1, [(motherboard, 1), (powerSupply, 1), (printedCase, 1)],
        [metalShop, printer3D], 2⟩

/-- How deep in the fab a part sits: the certificate that the system is not
circular. -/
def rank : Part → ℕ
  | silicaSand | ironOre | copperOre | coal | limestone
  | crudeOil | oreSmelter | oilRefinery | metalShop | powerPlant => 0
  | steelStock | copperWire | polymerPellet | photoresist => 1
  | glassFurnace | arcFurnace | extruderTool | etchLine
  | electricMotor | wireSaw | printerFrame | hotEnd => 2
  | glassBlank | metSilicon | filament | pcb | dicingSaw => 3
  | cleanRoom | siemensReactor | crystalPuller | diffusionFurnace | wireBonder => 4
  | stepper | maskSet | polysilicon | powerSupply => 5
  | siliconIngot => 6
  | wafer => 7
  | dopedWafer => 8
  | die => 9
  | logicChip | microcontrollerChip | memoryChip | cpuChip => 10
  | controlBoard | motherboard => 11
  | printer3D => 12
  | printedCase => 13
  | computer => 14

/-- **The fab.**  Every workflow of the silicon chain, together with the
certificate that nothing is needed in order to make itself. -/
def fab : Plant Part where
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

@[simp] theorem fab_recipe : fab.recipe = recipe := rfl

@[simp] theorem fab_rank : fab.rank = rank := rfl

/-! ## The base of the fab -/

/-- **The fab is based on six raw materials and the shop of the tractor era,
and on nothing else.** -/
theorem base_eq (i : Part) : fab.recipe i = none ↔ i ∈ rawParts ∨ i ∈ seedTools := by
  revert i; decide

theorem rawParts_base : ∀ i ∈ rawParts, fab.recipe i = none := by decide

theorem seedTools_base : ∀ i ∈ seedTools, fab.recipe i = none := by decide

/-- Everything that is neither a raw material nor part of the seed shop has a
workflow. -/
theorem has_recipe (i : Part) (h₁ : i ∉ rawParts) (h₂ : i ∉ seedTools) :
    (fab.recipe i).isSome := by
  revert i; decide

/-- **Everything can be built from the ground.**  Every part of the fab — the
clean room, the stepper, the wafer, the processor, the printer and the
computer — can be produced starting from the six raw materials and the seed
shop alone. -/
theorem producible (i : Part) : fab.Producible i := fab.producible i

/-! ## The fab builds its own instruments -/

theorem fabTools_made : ∀ t ∈ fabTools, (fab.recipe t).isSome := by decide

/-- Every tool called for anywhere in the fab is either part of the seed shop
or one the fab builds for itself. -/
theorem tools_seed_or_fab (i : Part) (r : Recipe Part) (h : fab.recipe i = some r) :
    ∀ t ∈ r.tools, t ∈ seedTools ∨ t ∈ fabTools := by
  revert i r h; decide

/-- No machine is needed in order to build itself, however indirectly. -/
theorem no_self_tooling (i : Part) : i ∉ fab.toolClosure i := fab.not_mem_toolClosure_self i

/-- Nothing in the fab is built with a computer: the computer is the end of
the line, not an instrument of it. -/
theorem computer_never_a_tool (j : Part) (r : Recipe Part) (h : fab.recipe j = some r) :
    computer ∉ r.tools := by
  revert j r h; decide

theorem computer_not_a_tool : ¬ fab.IsTool computer := by
  rintro ⟨j, r, hj, hr⟩
  exact computer_never_a_tool j r hj hr

/-- **The printer prints the computer's case.**  The 3D printer is a tool of
the case and of the final assembly, and the computer is a tool of nothing: the
ordering of the skill tree is the ordering of the shop floor. -/
theorem printer_builds_the_computer :
    (∀ r, fab.recipe printedCase = some r → printer3D ∈ r.tools) ∧
      (∀ r, fab.recipe computer = some r → printer3D ∈ r.tools) ∧
      ¬ fab.IsTool computer :=
  ⟨by decide, by decide, computer_not_a_tool⟩

/-- The printer needs one chip and the computer needs six: the printer is the
cheap machine, and it comes first. -/
theorem printer_is_the_simpler_machine : rank printer3D < rank computer := by decide

/-! ## A schedule for the whole fab -/

/-- A complete build order: raw materials and the seed shop first, then the
mill goods, the fab's own instruments, the silicon chain, the printer and
finally the computer. -/
def buildOrder : List Part :=
  [silicaSand, ironOre, copperOre, coal, limestone, crudeOil, oreSmelter, oilRefinery,
   metalShop, powerPlant, steelStock, copperWire, polymerPellet, photoresist, glassFurnace,
   arcFurnace, extruderTool, etchLine, electricMotor, wireSaw, printerFrame, hotEnd,
   glassBlank, metSilicon, filament, pcb, dicingSaw, cleanRoom, siemensReactor, crystalPuller,
   diffusionFurnace, wireBonder, stepper, maskSet, polysilicon, powerSupply, siliconIngot,
   wafer, dopedWafer, die, logicChip, microcontrollerChip, memoryChip, cpuChip, controlBoard,
   motherboard, printer3D, printedCase, computer]

theorem mem_buildOrder (i : Part) : i ∈ buildOrder := by revert i; decide

theorem buildOrder_nodup : buildOrder.Nodup := by decide

theorem buildOrder_length : buildOrder.length = 49 := by decide

/-- **The schedule is workable.**  By the time each workflow is reached,
everything it consumes has already been made. -/
theorem buildOrder_inputs_first (i : Part) (r : Recipe Part) (h : fab.recipe i = some r) :
    ∀ p ∈ r.inputs, buildOrder.idxOf p.1 < buildOrder.idxOf i := by
  revert i r h; decide

/-- … and every instrument it needs is already standing in the fab. -/
theorem buildOrder_tools_first (i : Part) (r : Recipe Part) (h : fab.recipe i = some r) :
    ∀ t ∈ r.tools, buildOrder.idxOf t < buildOrder.idxOf i := by
  revert i r h; decide

/-- The schedule starts on bare ground … -/
theorem buildOrder_take_base : buildOrder.take 10 = rawParts ++ seedTools := by decide

/-- … and ends with the computer. -/
theorem buildOrder_getLast : buildOrder.getLast? = some computer := by decide



/-! ## The fab runs

The same theory that ran the tractor shop in `RequestProject/Workshop.lean`
runs the fab: no workflow eats a tool, so a yard stocked with the
raw-material demand of one computer and one of each instrument works the
whole plan through to a finished machine. -/

/-- No workflow eats an instrument. -/
theorem no_tool_is_input (i : Part) (r : Recipe Part) (h : fab.recipe i = some r) :
    ∀ p ∈ r.inputs, p.1 ∉ seedTools ∧ p.1 ∉ fabTools := by
  revert i r h; decide

theorem isTool_seed_or_fab {t : Part} (ht : fab.IsTool t) : t ∈ seedTools ∨ t ∈ fabTools := by
  obtain ⟨j, r, hj, hr⟩ := ht
  exact tools_seed_or_fab j r hj t hr

/-- The fab satisfies the standing hypothesis of the plan theory: a stepper is
never melted down for its steel. -/
theorem fab_toolsNotConsumed : fab.ToolsNotConsumed := by
  intro t ht j r hj p hp
  rcases isTool_seed_or_fab ht with h | h
  · rintro rfl; exact (no_tool_is_input j r hj p hp).1 h
  · rintro rfl; exact (no_tool_is_input j r hj p hp).2 h

/-- One of each instrument the fab owns, and none of anything else. -/
def toolStock (x : Part) : ℚ := if x ∈ seedTools ∨ x ∈ fabTools then 1 else 0

theorem toolStock_nonneg (x : Part) : 0 ≤ toolStock x := by
  unfold toolStock; split <;> norm_num

theorem toolStock_of_mem {x : Part} (h : x ∈ seedTools ∨ x ∈ fabTools) : toolStock x = 1 :=
  if_pos h

theorem toolStock_computer : toolStock computer = 0 := by decide

/-- The stock the fab must have on hand before it starts: the raw-material
demand of one computer, plus one of each instrument. -/
noncomputable def startStock (x : Part) : ℚ := fab.rawDemand computer 1 x + toolStock x

theorem startStock_computer : startStock computer = fab.rawDemand computer 1 computer := by
  simp [startStock, toolStock_computer]

/-- **The fab runs.**  Starting from a yard holding exactly the raw-material
demand of one computer and one of each instrument, the production plan for one
computer is admissible at every step — every input it calls for is already on
the shelf, dug out of the ground or made earlier — and when the last step is
done there is a finished computer. -/
theorem computer_plan_works :
    fab.PlanOK (fab.plan computer 1) startStock ∧
      1 ≤ fab.runPlan (fab.plan computer 1) startStock computer := by
  have hs : ∀ x, fab.rawDemand computer 1 x ≤ startStock x := by
    intro x
    have := toolStock_nonneg x
    simp only [startStock]
    linarith
  have htool : ∀ t, fab.IsTool t → 1 ≤ startStock t := by
    intro t ht
    have h1 : toolStock t = 1 := toolStock_of_mem (isTool_seed_or_fab ht)
    have h2 : 0 ≤ fab.rawDemand computer 1 t := fab.rawDemand_nonneg zero_le_one t
    simp only [startStock, h1]
    linarith
  obtain ⟨h1, h2⟩ :=
    fab.plan_produces fab_toolsNotConsumed computer zero_le_one startStock hs htool
  refine ⟨h1, ?_⟩
  rw [startStock_computer] at h2
  linarith

/-- The plan ends with the final assembly of one computer. -/
theorem computer_plan_getLast : (fab.plan computer 1).getLast? = some (computer, 1) := by
  obtain ⟨r, hr⟩ := Option.isSome_iff_exists.1 (has_recipe computer (by decide) (by decide))
  rw [fab.plan_recipe hr]
  simp

/-! ## Nothing is created

Every step of the fab is a *rearrangement*.  `Plant.rawContent b s` measures
how much of the raw material `b` is embodied in a yard `s`, counting what is
inside every half-finished thing on the shelf.  A production run changes what the
yard looks like and leaves that number exactly where it was: the sand that
goes into the crystal puller is the sand that comes out inside the ingot. -/

/-- **A production run creates no matter and destroys none.** -/
theorem step_conserves_raw (b : Part) (i : Part) (q : ℚ) (s : Part → ℚ) :
    fab.rawContent b (fab.step i q s) = fab.rawContent b s :=
  fab.rawContent_step (i := i) (q := q) b s

/-- **And neither does the whole plan.**  From the first shovel to the
finished computer, the raw material embodied in the yard never changes: the
machine is the ground, rearranged. -/
theorem plan_conserves_raw (b : Part) (l : List (Part × ℚ)) (s : Part → ℚ) :
    fab.rawContent b (fab.runPlan l s) = fab.rawContent b s :=
  fab.rawContent_runPlan b l s

/-- In particular the raw content of the yard at the end of the computer plan
is the raw content of the yard it started with. -/
theorem computer_plan_conserves_raw (b : Part) :
    fab.rawContent b (fab.runPlan (fab.plan computer 1) startStock) =
      fab.rawContent b startStock :=
  plan_conserves_raw b _ _

/-! ## Every part of the fab is inside the skill tree -/

open Skills (Skill)

/-- The skill each part of the fab is made by. -/
def skillOf : Part → Skill
  | silicaSand | ironOre | copperOre | coal | limestone | crudeOil => Skill.mining
  | oreSmelter => Skill.ironSmelting
  | oilRefinery => Skill.oilRefining
  | metalShop => Skill.machining
  | powerPlant => Skill.woodGas
  | steelStock => Skill.steelMaking
  | copperWire => Skill.wireDrawing
  | polymerPellet | photoresist => Skill.oilRefining
  | glassBlank | glassFurnace => Skill.glassMaking
  | metSilicon | polysilicon | siliconIngot | wafer => Skill.siliconRefining
  | arcFurnace | siemensReactor | crystalPuller => Skill.siliconRefining
  | filament | extruderTool => Skill.polymerExtrusion
  | pcb | etchLine | stepper | maskSet => Skill.photolithography
  | electricMotor => Skill.electricMotors
  | wireSaw | dicingSaw | printerFrame | hotEnd => Skill.machining
  | cleanRoom | diffusionFurnace | dopedWafer => Skill.semiconductors
  | wireBonder | die | motherboard => Skill.integratedCircuits
  | logicChip => Skill.digitalLogic
  | microcontrollerChip | controlBoard => Skill.microcontrollers
  | memoryChip => Skill.memoryFabrication
  | cpuChip => Skill.microprocessor
  | printer3D | printedCase => Skill.printer3D
  | powerSupply => Skill.electricity
  | computer => Skill.computer

/-- **The whole fab fits inside the skill tree.**  Every one of the
forty-nine parts — ore at the pit, the clean room, the stepper, the wafer,
the processor, the printer and the computer — is made by a skill the fab
possesses. -/
theorem every_part_within_fabSkills : ∀ p : Part, skillOf p ∈ Skill.fabSkills := by decide

/-- **And none of it needs a tractor.**  No part of the fab is made by
hydraulics, by an internal combustion engine, by tractor building or by
photovoltaics: the computer is not downstream of the machine. -/
theorem fab_needs_no_tractor :
    ∀ p : Part, skillOf p ∉
      [Skill.hydraulics, Skill.internalCombustion, Skill.tractorBuilding, Skill.photovoltaics] := by
  decide

/-- **Proof checking builds nothing.**  It is the one skill of the fab that no
part is made by: it consumes energy and produces no matter at all.  What it
costs is counted in `RequestProject/Checker.lean`. -/
theorem no_part_is_made_by_proofChecking : ∀ p : Part, skillOf p ≠ Skill.proofChecking := by
  decide

end Fab
end LifeTrac

