import RequestProject.Gvcs.Salvage

set_option maxRecDepth 40000

/-!
# A printer and a computer out of six dead machines

`RequestProject/Salvage.lean` says what comes out of each kind of e-waste.
This file takes a specific heap — **two inkjet printers, one laser printer,
one desktop, two microwaves** — strips it, and builds the two machines at the
top of the fab out of what falls out.

Everything is measured against `RequestProject/FabBill.lean`, which costs the
same two machines starting at the pit.

* `pile_covers_the_build` — the heap really is enough: every part the two
  builds draw on is on the bench in at least the quantity needed.
* `salvage_route_digs_nothing` — and no ore is dug at all.  The whole build
  runs on the pile.
* `salvage_hours` / `ore_hours` — six hours on the bench and twenty-two and a
  half in the shop, against forty-six hours of fab work from ore.
* `salvage_is_faster` — so the pile saves better than seventeen hours, and
  `salvage_beats_ore_even_counting_teardown` says that holds even after every
  minute of teardown is charged to the build.
* `computer_needs_no_fab` — the real prize.  Building the computer from ore
  requires a clean room, a lithography stepper, a crystal puller, a Siemens
  reactor, a diffusion furnace, a wire bonder, an arc furnace, a wire saw, a
  dicing saw, an etch line, a glass furnace, a smelter and a refinery.
  Building it out of the pile requires a metal shop, an extruder and the 3D
  printer — and nothing else whatsoever.

The moral is the one the pile suggests: the hours are worth saving, but the
*instruments* are what the scrap heap really replaces.
-/

namespace LifeTrac
namespace Salvage

open Fab (fab ind)
open Fab.Part
open Device
open Workflow.Plant (laborGiven_eq demandGiven_eq toolClosureGiven_eq)

/-! ## The heap, and what is on the bench when it has been stripped -/

/-- The heap: two inkjet printers, a laser printer, a desktop and two dead
microwaves. -/
def pile : List Device :=
  [inkjetPrinter, inkjetPrinter, laserPrinter, desktopPC, microwaveOven, microwaveOven]

theorem pile_length : pile.length = 6 := by decide

/-- Nothing in the heap is one of the machines that does not pay to open. -/
theorem pile_is_worth_stripping : ∀ d ∈ pile, d ∈ worthStripping := by decide

/-- How much of a part a single yield contains. -/
def qtyOf (l : List (Fab.Part × ℚ)) (x : Fab.Part) : ℚ :=
  (l.map (fun e => if e.1 = x then e.2 else 0)).sum

/-- What a list of devices gives up in total. -/
def harvest (ds : List Device) (x : Fab.Part) : ℚ := (ds.map (fun d => qtyOf (yield d) x)).sum

/-- Hours of bench work to strip the heap. -/
def pileHours : ℚ := (pile.map teardown).sum

theorem pileHours_eq : pileHours = 6 := by norm_num [pileHours, pile, teardown]

/-- The parts that are on the bench once the heap has been stripped. -/
def salvaged : List Fab.Part :=
  [steelStock, copperWire, polymerPellet, glassBlank, pcb, electricMotor, controlBoard,
   powerSupply, motherboard]

/-- The shop's shelf after the teardown: these parts do not have to be made. -/
def onHand (p : Fab.Part) : Bool := p ∈ salvaged

/-- **The shelf is exactly what fell out of the heap.**  A part counts as on
hand precisely when the pile actually yields some of it. -/
theorem onHand_iff_harvested (p : Fab.Part) : onHand p = true ↔ 0 < harvest pile p := by
  cases p <;> simp [onHand, salvaged, harvest, qtyOf, pile, yield] <;> norm_num

@[simp] theorem onHand_steelStock : onHand steelStock = true := by decide
@[simp] theorem onHand_copperWire : onHand copperWire = true := by decide
@[simp] theorem onHand_polymerPellet : onHand polymerPellet = true := by decide
@[simp] theorem onHand_glassBlank : onHand glassBlank = true := by decide
@[simp] theorem onHand_pcb : onHand pcb = true := by decide
@[simp] theorem onHand_electricMotor : onHand electricMotor = true := by decide
@[simp] theorem onHand_controlBoard : onHand controlBoard = true := by decide
@[simp] theorem onHand_powerSupply : onHand powerSupply = true := by decide
@[simp] theorem onHand_motherboard : onHand motherboard = true := by decide

@[simp] theorem onHand_printerFrame : onHand printerFrame = false := by decide
@[simp] theorem onHand_hotEnd : onHand hotEnd = false := by decide
@[simp] theorem onHand_filament : onHand filament = false := by decide
@[simp] theorem onHand_extruderTool : onHand extruderTool = false := by decide
@[simp] theorem onHand_printer3D : onHand printer3D = false := by decide
@[simp] theorem onHand_printedCase : onHand printedCase = false := by decide
@[simp] theorem onHand_computer : onHand computer = false := by decide

/-- Nothing on the shelf is a raw material, a seed tool or an instrument: the
heap supplies components and only components. -/
theorem salvaged_are_components :
    ∀ p ∈ salvaged, p ∉ Fab.Part.rawParts ∧ p ∉ Fab.Part.seedTools ∧ p ∉ Fab.Part.fabTools := by
  decide

/-! ## The hours still to be worked

Parts on the shelf are not made again: the chain behind them is not walked.
What is left is the frame, the hot end, a spool of filament, the printed case
and the two assemblies. -/

@[simp] theorem lg_onHand {p : Fab.Part} (h : onHand p = true) (q : ℚ) :
    fab.laborGiven onHand p q = 0 :=
  Workflow.Plant.laborGiven_of_onHand h q

@[simp] theorem lg_printerFrame (q : ℚ) : fab.laborGiven onHand printerFrame q = q * 4 := by
  rw [laborGiven_eq]
  simp only [onHand_printerFrame, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_steelStock, lg_onHand]
  ring

@[simp] theorem lg_hotEnd (q : ℚ) : fab.laborGiven onHand hotEnd q = q * 2 := by
  rw [laborGiven_eq]
  simp only [onHand_hotEnd, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_steelStock,
    onHand_copperWire, lg_onHand]
  ring

@[simp] theorem lg_filament (q : ℚ) : fab.laborGiven onHand filament q = q * (1/10) := by
  rw [laborGiven_eq]
  simp only [onHand_filament, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_polymerPellet, lg_onHand]
  ring

/-- **The 3D printer, out of the pile: fourteen hours and no ore.** -/
@[simp] theorem lg_printer3D (q : ℚ) : fab.laborGiven onHand printer3D q = q * (141/10) := by
  rw [laborGiven_eq]
  simp only [onHand_printer3D, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_electricMotor,
    onHand_controlBoard, lg_onHand, lg_printerFrame, lg_hotEnd, lg_filament]
  ring

@[simp] theorem lg_printedCase (q : ℚ) : fab.laborGiven onHand printedCase q = q * (63/10) := by
  rw [laborGiven_eq]
  simp only [onHand_printedCase, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, lg_filament]
  ring

/-- **The computer, out of the pile: eight hours and no ore.** -/
@[simp] theorem lg_computer (q : ℚ) : fab.laborGiven onHand computer q = q * (83/10) := by
  rw [laborGiven_eq]
  simp only [onHand_computer, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_motherboard,
    onHand_powerSupply, lg_onHand, lg_printedCase]
  ring

/-! ## What the two builds draw off the bench -/

@[simp] theorem dg_onHand {p : Fab.Part} (h : onHand p = true) (q : ℚ) (x : Fab.Part) :
    fab.demandGiven onHand p q x = q * ind p x := by
  rw [Workflow.Plant.demandGiven_of_onHand h]
  by_cases hx : x = p <;> simp [ind, hx]

@[simp] theorem dg_printerFrame (q : ℚ) (x : Fab.Part) :
    fab.demandGiven onHand printerFrame q x = q * (12 * ind steelStock x) := by
  rw [demandGiven_eq]
  simp only [onHand_printerFrame, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_steelStock, dg_onHand]
  ring

@[simp] theorem dg_hotEnd (q : ℚ) (x : Fab.Part) :
    fab.demandGiven onHand hotEnd q x = q * (1/2 * ind steelStock x + 1/10 * ind copperWire x) := by
  rw [demandGiven_eq]
  simp only [onHand_hotEnd, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_steelStock,
    onHand_copperWire, dg_onHand]
  ring

@[simp] theorem dg_filament (q : ℚ) (x : Fab.Part) :
    fab.demandGiven onHand filament q x = q * (21/20 * ind polymerPellet x) := by
  rw [demandGiven_eq]
  simp only [onHand_filament, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_polymerPellet, dg_onHand]
  ring

/-- The whole bill of the printer, in salvaged parts: twelve and a half kilos
of steel, a hundred grams of copper wire, a kilo of shredded polymer, four
motors and a control board. -/
@[simp] theorem dg_printer3D (q : ℚ) (x : Fab.Part) :
    fab.demandGiven onHand printer3D q x =
      q * (25/2 * ind steelStock x + 1/10 * ind copperWire x + 21/20 * ind polymerPellet x
        + 4 * ind electricMotor x + 1 * ind controlBoard x) := by
  rw [demandGiven_eq]
  simp only [onHand_printer3D, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_electricMotor,
    onHand_controlBoard, dg_onHand, dg_printerFrame, dg_hotEnd, dg_filament]
  ring

@[simp] theorem dg_printedCase (q : ℚ) (x : Fab.Part) :
    fab.demandGiven onHand printedCase q x = q * (63/20 * ind polymerPellet x) := by
  rw [demandGiven_eq]
  simp only [onHand_printedCase, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, dg_filament]
  ring

/-- The whole bill of the computer: a motherboard, a supply and three kilos of
polymer for the case. -/
@[simp] theorem dg_computer (q : ℚ) (x : Fab.Part) :
    fab.demandGiven onHand computer q x =
      q * (1 * ind motherboard x + 1 * ind powerSupply x + 63/20 * ind polymerPellet x) := by
  rw [demandGiven_eq]
  simp only [onHand_computer, Bool.false_eq_true, if_false, Fab.fab_recipe, Fab.recipe,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, onHand_motherboard,
    onHand_powerSupply, dg_onHand, dg_printedCase]
  ring

/-! ## The heap is enough -/

/-- **The pile covers the build.**  Every part the printer and the computer
between them draw on is on the bench in at least the quantity the two builds
call for. -/
theorem pile_covers_the_build (x : Fab.Part) :
    fab.demandGiven onHand printer3D 1 x + fab.demandGiven onHand computer 1 x ≤
      harvest pile x := by
  cases x <;>
    simp [dg_printer3D, dg_computer, harvest, qtyOf, pile, yield, ind] <;> norm_num

/-- **And nothing is dug.**  Neither build draws a gram of sand, ore, coal,
limestone or oil: the whole of it comes off the bench. -/
theorem salvage_route_digs_nothing (x : Fab.Part) (hx : x ∈ Fab.Part.rawParts) :
    fab.demandGiven onHand printer3D 1 x = 0 ∧ fab.demandGiven onHand computer 1 x = 0 := by
  revert hx
  cases x <;> intro hx <;>
    first
      | (exfalso; revert hx; decide)
      | (constructor <;> simp [dg_printer3D, dg_computer, ind])

/-! ## The hours -/

/-- Six hours of teardown, fourteen hours to build the printer, eight to build
the computer: twenty-eight and a half hours all told. -/
theorem salvage_hours :
    pileHours + fab.laborGiven onHand printer3D 1 + fab.laborGiven onHand computer 1 = 142/5 := by
  rw [pileHours_eq, lg_printer3D, lg_computer]
  norm_num

/-- Starting at the pit instead: forty-six hours, and that is only the labour
in the two machines, not the labour of building the fab that makes them. -/
theorem ore_hours :
    fab.laborFor printer3D 1 + fab.laborFor computer 1 = 921957561/20000000 := by
  rw [Fab.lf_printer3D, Fab.lf_computer]
  norm_num

/-- **The heap is faster**, by better than seventeen hours on the two
machines, counting every minute of the teardown against it. -/
theorem salvage_is_faster :
    pileHours + fab.laborGiven onHand printer3D 1 + fab.laborGiven onHand computer 1
      + 17 < fab.laborFor printer3D 1 + fab.laborFor computer 1 := by
  rw [salvage_hours, ore_hours]
  norm_num

/-- In general, and with no arithmetic at all: whatever is on the shelf, the
work left can never exceed the work of making the thing from ore. -/
theorem salvage_never_costs_more (i : Fab.Part) {q : ℚ} (hq : 0 ≤ q) :
    fab.laborGiven onHand i q ≤ fab.laborFor i q :=
  Workflow.Plant.laborGiven_le_laborFor onHand hq

/-! ## What the heap really replaces

The hours are worth having.  The instruments are the point.  From ore, a
computer needs a clean room and a lithography stepper standing in the yard
before the first wafer is cut.  From the pile it needs a metal shop, a
filament extruder and the printer. -/

@[simp] theorem tc_onHand {p : Fab.Part} (h : onHand p = true) :
    fab.toolClosureGiven onHand p = [] :=
  Workflow.Plant.toolClosureGiven_of_onHand h

@[simp] theorem tc_extruderTool : fab.toolClosureGiven onHand extruderTool = [metalShop] := by
  rw [toolClosureGiven_eq]
  simp [Fab.recipe, Workflow.Plant.toolClosureGiven_base]

@[simp] theorem tc_printerFrame : fab.toolClosureGiven onHand printerFrame = [metalShop] := by
  rw [toolClosureGiven_eq]
  simp [Fab.recipe, Workflow.Plant.toolClosureGiven_base]

@[simp] theorem tc_hotEnd : fab.toolClosureGiven onHand hotEnd = [metalShop] := by
  rw [toolClosureGiven_eq]
  simp [Fab.recipe, Workflow.Plant.toolClosureGiven_base]

@[simp] theorem tc_filament :
    fab.toolClosureGiven onHand filament = [extruderTool, metalShop] := by
  rw [toolClosureGiven_eq]
  simp [Fab.recipe]

@[simp] theorem tc_printer3D :
    fab.toolClosureGiven onHand printer3D =
      [metalShop, metalShop, metalShop, extruderTool, metalShop] := by
  rw [toolClosureGiven_eq]
  simp [Fab.recipe, Workflow.Plant.toolClosureGiven_base]

@[simp] theorem tc_printedCase :
    fab.toolClosureGiven onHand printedCase =
      [printer3D, metalShop, metalShop, metalShop, extruderTool, metalShop, extruderTool,
       metalShop] := by
  rw [toolClosureGiven_eq]
  simp [Fab.recipe]

@[simp] theorem tc_computer :
    fab.toolClosureGiven onHand computer =
      [metalShop, printer3D, metalShop, metalShop, metalShop, extruderTool, metalShop,
       printer3D, metalShop, metalShop, metalShop, extruderTool, metalShop, extruderTool,
       metalShop] := by
  rw [toolClosureGiven_eq]
  simp [Fab.recipe, Workflow.Plant.toolClosureGiven_base]

/-- **Three machines and no fab.**  Everything the salvaged build needs
standing in the yard is a metal shop, a filament extruder and the 3D printer
it builds first. -/
theorem computer_needs_no_fab :
    ∀ t ∈ fab.toolClosureGiven onHand computer, t = metalShop ∨ t = extruderTool ∨ t = printer3D := by
  rw [tc_computer]; decide

/-- In particular: no clean room, no stepper, no crystal puller, no Siemens
reactor, no diffusion furnace, no wire bonder, no arc furnace, no wire saw, no
dicing saw, no etch line, no glass furnace, no smelter, no refinery. -/
theorem no_semiconductor_plant_needed :
    ∀ t ∈ [cleanRoom, stepper, crystalPuller, siemensReactor, diffusionFurnace, wireBonder,
      arcFurnace, wireSaw, dicingSaw, etchLine, glassFurnace, oreSmelter, oilRefinery],
      t ∉ fab.toolClosureGiven onHand computer := by
  rw [tc_computer]; decide

/-! ### … whereas from ore, all of it is needed

The chain is: the computer is assembled from a motherboard, the motherboard
carries a processor, the processor is a packaged die, and a die is cut in a
clean room.  So the clean room stands behind the computer. -/

/-- **From ore, the clean room is unavoidable.**  It is in the tool closure of
the computer: no wafer, no die, no processor, no machine. -/
theorem cleanRoom_needed_from_ore : cleanRoom ∈ fab.toolClosure computer := by
  have hdie : cleanRoom ∈ fab.toolClosure die :=
    fab.tools_subset_toolClosure (r := ⟨200, [(dopedWafer, 1)], [dicingSaw, cleanRoom], 1⟩)
      rfl cleanRoom (by simp)
  have hcpu : cleanRoom ∈ fab.toolClosure cpuChip :=
    fab.toolClosure_input_subset
      (r := ⟨1, [(die, 4), (copperWire, 1/100), (polymerPellet, 1/50)], [wireBonder], 1/5⟩)
      rfl (q := 4) (by simp) cleanRoom hdie
  have hmb : cleanRoom ∈ fab.toolClosure motherboard :=
    fab.toolClosure_input_subset
      (r := ⟨1, [(pcb, 2), (cpuChip, 1), (memoryChip, 4), (logicChip, 6), (copperWire, 1/10)],
        [wireBonder, metalShop], 3⟩)
      rfl (q := 1) (by simp) cleanRoom hcpu
  exact fab.toolClosure_input_subset
    (r := ⟨1, [(motherboard, 1), (powerSupply, 1), (printedCase, 1)], [metalShop, printer3D], 2⟩)
    rfl (q := 1) (by simp) cleanRoom hmb

/-- **The scrap heap stands in for a semiconductor plant.**  The clean room is
needed to build a computer from ore, and is not needed to build one out of the
pile. -/
theorem the_pile_replaces_the_fab :
    cleanRoom ∈ fab.toolClosure computer ∧ cleanRoom ∉ fab.toolClosureGiven onHand computer :=
  ⟨cleanRoom_needed_from_ore, by rw [tc_computer]; decide⟩

end Salvage
end LifeTrac
