import RequestProject.Gvcs.Given
import RequestProject.Gvcs.FabBill

set_option maxRecDepth 40000

/-!
# The scrap pile: stripping e-waste for parts

The fab of `RequestProject/FabLab.lean` starts at the pit: to get a stepper
motor it digs iron ore, and to get a processor it builds a clean room.  A pile
of dead printers, routers, computers and phones is a shortcut past both.  This
file is the teardown manual, written as data so that statements can be proved
about it.

* `Device` — twelve things that turn up in the pile: an inkjet and a laser
  printer, a flatbed scanner, a wifi router, a desktop and a laptop, a phone,
  a flat monitor, an optical drive, a microwave, a CRT television and a
  cordless drill.
* `yield d` — what one unit of `d` gives up, in the *same* part vocabulary the
  fab uses (`LifeTrac.Fab.Part`): kilograms of steel, copper and shreddable
  polymer, and pieces of motor, board, supply and glass.
* `hazards d` — what can hurt you: mains capacitors, the anode of a CRT,
  lithium cells, toner, laser diodes, backlight lamps, leaded glass.
* `procedure d` — the order of work, *generated* from the hazards and the
  yield rather than written out by hand, so that the safety rules below are
  properties of the recipe and not of a list someone typed.
* `kit d` — the tools the job needs, likewise generated.

The results:

* `procedure_starts_unplugged`, `procedure_ends_logged`, `procedure_nodup` —
  every teardown begins with the plug out, ends with the parts labelled on a
  shelf, and does no step twice.
* `discharge_immediately` — anything with a mains capacitor is discharged
  *second*, before anything is opened further.
* `cells_before_boards` — anything with a lithium cell has the cell out before
  a board is touched.
* `kit_probe_iff_capacitor`, `kit_shredder_iff_polymer`,
  `kit_hotAir_iff_chips` — the tool list matches the job exactly.
* `salvage_pays` — every device except one returns at least **five hours** of
  fab work for each hour spent tearing it down.
* `crt_does_not_pay` — the exception is the CRT television: it takes longer to
  strip than the parts are worth, and its glass is leaded.  Leave it alone.

`RequestProject/SalvageBill.lean` then takes a specific pile apart and builds a
3D printer and a computer out of it.
-/

namespace LifeTrac
namespace Salvage

open Fab (Part fab)
open Fab.Part

/-! ## The pile -/

/-- Twelve kinds of dead equipment worth opening. -/
inductive Device where
  | inkjetPrinter | laserPrinter | flatbedScanner | wifiRouter | desktopPC | laptop
  | smartphone | lcdMonitor | opticalDrive | microwaveOven | crtTelevision | cordlessDrill
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Device

/-- Every kind of device in the manual. -/
def all : List Device :=
  [inkjetPrinter, laserPrinter, flatbedScanner, wifiRouter, desktopPC, laptop,
   smartphone, lcdMonitor, opticalDrive, microwaveOven, crtTelevision, cordlessDrill]

theorem mem_all (d : Device) : d ∈ all := by revert d; decide

theorem all_nodup : all.Nodup := by decide

theorem all_length : all.length = 12 := by decide

end Device

open Device

/-- What can hurt you inside a dead machine. -/
inductive Hazard where
  /-- A charged mains-side capacitor: a switching supply, a monitor, a
  microwave. -/
  | mainsCapacitor
  /-- The anode of a picture tube, which holds kilovolts for weeks. -/
  | highVoltageAnode
  /-- A lithium cell, which burns when punctured. -/
  | lithiumCell
  /-- Ink and toner: fine powder, do not breathe it. -/
  | inkAndToner
  /-- A laser diode, invisible and collimated. -/
  | laserDiode
  /-- A cold-cathode backlight lamp: mercury inside. -/
  | mercuryLamp
  /-- Leaded glass, which must not go in the furnace. -/
  | leadedGlass
  deriving DecidableEq, Repr, Fintype, Inhabited

/-- The tools of the teardown bench. -/
inductive Tool where
  | screwdriverSet | torxBits | pryTool | sideCutters | solderingIron | hotAirStation
  | multimeter | dischargeProbe | shredder | dustMask | gloves | safetyGlasses
  deriving DecidableEq, Repr, Fintype, Inhabited

/-- The steps a teardown can be made of. -/
inductive Step where
  | unplugAndRest | dischargeCapacitors | removeCells | openCase | separateBoards
  | pullMotors | pullOptics | desolderComponents | shredPlastics | sortMetals | logAndStore
  deriving DecidableEq, Repr, Fintype, Inhabited

/-! ## What comes out of each machine

Quantities are in the fab's own units: kilograms for steel, copper and
polymer, pieces for everything else.  A board is listed as the assembly it is
— a desktop gives up a motherboard, chips and all, so its processor and its
memory are not counted twice. -/

/-- What one unit of a device gives up on the bench. -/
def yield : Device → List (Part × ℚ)
  | inkjetPrinter =>
      [(electricMotor, 2), (steelStock, 3/5), (polymerPellet, 3/2), (controlBoard, 1),
       (powerSupply, 1)]
  | laserPrinter =>
      [(electricMotor, 3), (steelStock, 5/2), (polymerPellet, 2), (glassBlank, 1/5),
       (controlBoard, 1), (powerSupply, 1)]
  | flatbedScanner =>
      [(electricMotor, 1), (glassBlank, 1/2), (steelStock, 2/5), (polymerPellet, 1), (pcb, 1)]
  | wifiRouter =>
      [(pcb, 1), (logicChip, 2), (memoryChip, 1), (microcontrollerChip, 1), (copperWire, 1/20),
       (polymerPellet, 3/10), (powerSupply, 1)]
  | desktopPC =>
      [(motherboard, 1), (powerSupply, 1), (steelStock, 4), (copperWire, 1/5),
       (electricMotor, 2), (polymerPellet, 1/2)]
  | laptop =>
      [(motherboard, 1), (glassBlank, 1/10), (copperWire, 1/20), (polymerPellet, 2/5),
       (electricMotor, 1), (steelStock, 3/10)]
  | smartphone =>
      [(cpuChip, 1), (memoryChip, 2), (pcb, 1), (glassBlank, 1/20), (copperWire, 1/100),
       (electricMotor, 1), (steelStock, 1/20)]
  | lcdMonitor =>
      [(pcb, 2), (glassBlank, 1), (steelStock, 1), (polymerPellet, 6/5), (powerSupply, 1),
       (copperWire, 1/10)]
  | opticalDrive =>
      [(electricMotor, 2), (steelStock, 1/5), (pcb, 1), (polymerPellet, 1/5)]
  | microwaveOven =>
      [(steelStock, 6), (copperWire, 3/2), (electricMotor, 2), (pcb, 1), (glassBlank, 1/5)]
  | crtTelevision =>
      [(steelStock, 2), (copperWire, 4/5), (pcb, 2), (polymerPellet, 2)]
  | cordlessDrill =>
      [(electricMotor, 1), (steelStock, 4/5), (pcb, 1), (polymerPellet, 2/5)]

/-- Does this device give up that part at all? -/
def has (d : Device) (p : Part) : Bool := (yield d).any (fun e => e.1 == p)

/-- The parts a device gives up, without their quantities. -/
def parts (d : Device) : List Part := (yield d).map Prod.fst

theorem has_iff (d : Device) (p : Part) : has d p = true ↔ p ∈ parts d := by
  simp [has, parts, List.any_eq_true, List.mem_map]

/-- Nothing is listed twice in a yield. -/
theorem parts_nodup (d : Device) : (parts d).Nodup := by revert d; decide

/-- Every quantity in every yield is positive: nothing is listed that does not
come out. -/
theorem yield_pos (d : Device) : ∀ e ∈ yield d, 0 < e.2 := by
  intro e he
  revert he
  cases d <;> simp only [yield, List.mem_cons, List.not_mem_nil, or_false] <;>
    rintro (rfl | rfl | rfl | rfl | rfl | rfl | rfl) <;> norm_num

/-! ## What the pile cannot give you

Salvage yields *components*, and only components.  It never yields ore — you
cannot un-smelt a chassis — and, more to the point, it never yields an
*instrument*: no pile of dead printers contains a clean room, a lithography
stepper or a crystal puller.  The shop still has to exist. -/

/-- Nothing salvaged is a raw material or part of the seed shop: everything
that comes off the bench is something the fab would otherwise have had to
manufacture. -/
theorem yield_is_manufactured (d : Device) :
    ∀ p ∈ parts d, p ∉ Fab.Part.rawParts ∧ p ∉ Fab.Part.seedTools ∧ (fab.recipe p).isSome := by
  revert d; decide

/-- **The pile is not a fab.**  No device gives up any of the instruments the
fab builds for itself — no clean room, no stepper, no crystal puller, not even
a 3D printer. -/
theorem yield_no_instruments (d : Device) : ∀ p ∈ parts d, p ∉ Fab.Part.fabTools := by
  revert d; decide

/-- In particular the pile never hands you a finished machine. -/
theorem yield_no_machines (d : Device) :
    printer3D ∉ parts d ∧ computer ∉ parts d := by
  revert d; decide

/-! ## What can hurt you -/

/-- The hazards of each device. -/
def hazards : Device → List Hazard
  | inkjetPrinter => [.mainsCapacitor, .inkAndToner]
  | laserPrinter => [.mainsCapacitor, .inkAndToner, .laserDiode]
  | flatbedScanner => [.mercuryLamp]
  | wifiRouter => [.mainsCapacitor]
  | desktopPC => [.mainsCapacitor, .lithiumCell]
  | laptop => [.lithiumCell]
  | smartphone => [.lithiumCell]
  | lcdMonitor => [.mainsCapacitor, .mercuryLamp]
  | opticalDrive => [.laserDiode]
  | microwaveOven => [.mainsCapacitor]
  | crtTelevision => [.mainsCapacitor, .highVoltageAnode, .leadedGlass]
  | cordlessDrill => [.lithiumCell]

/-- Is this hazard present in this device? -/
def hasHazard (d : Device) (h : Hazard) : Bool := h ∈ hazards d

/-- **Nothing in the pile is harmless.**  Every device on the list carries at
least one hazard; there is no machine you may open without thinking. -/
theorem every_device_is_hazardous (d : Device) : hazards d ≠ [] := by revert d; decide

/-- Anything with a mains plug and a switching supply holds a charge. -/
theorem mains_devices_hold_charge :
    ∀ d ∈ [inkjetPrinter, laserPrinter, desktopPC, lcdMonitor, microwaveOven, crtTelevision],
      hasHazard d .mainsCapacitor := by decide

/-- Anything with a battery in it is on the lithium list. -/
theorem battery_devices_flagged :
    ∀ d ∈ [laptop, smartphone, cordlessDrill, desktopPC], hasHazard d .lithiumCell := by decide

/-! ## The order of work

The procedure is not typed out device by device: it is *computed* from the
hazards and the yield.  The plug comes out first, then the charge, then the
cells; only then is the case opened, and only then are boards, motors, optics,
components, plastics and metals taken in that order; the job ends with the
parts labelled and put away. -/

open Step in
/-- The teardown of a device, in order. -/
def procedure (d : Device) : List Step :=
  [unplugAndRest]
    ++ (if hasHazard d .mainsCapacitor then [dischargeCapacitors] else [])
    ++ (if hasHazard d .lithiumCell then [removeCells] else [])
    ++ [openCase]
    ++ (if has d pcb || has d controlBoard || has d motherboard || has d powerSupply
          then [separateBoards] else [])
    ++ (if has d electricMotor then [pullMotors] else [])
    ++ (if has d glassBlank then [pullOptics] else [])
    ++ (if has d logicChip || has d memoryChip || has d microcontrollerChip || has d cpuChip
          then [desolderComponents] else [])
    ++ (if has d polymerPellet then [shredPlastics] else [])
    ++ (if has d steelStock || has d copperWire then [sortMetals] else [])
    ++ [logAndStore]

/-- **The plug comes out first**, on every device without exception. -/
theorem procedure_starts_unplugged (d : Device) :
    (procedure d).head? = some .unplugAndRest := by revert d; decide

/-- **The job ends with the parts labelled and on a shelf.** -/
theorem procedure_ends_logged (d : Device) :
    (procedure d).getLast? = some .logAndStore := by revert d; decide

/-- No step is done twice. -/
theorem procedure_nodup (d : Device) : (procedure d).Nodup := by revert d; decide

/-- Every teardown is at least three steps and at most all eleven. -/
theorem procedure_length (d : Device) : 3 ≤ (procedure d).length ∧ (procedure d).length ≤ 11 := by
  revert d; decide

/-- **Discharge second.**  Anything holding a mains-side charge is discharged
immediately after the plug comes out, before anything else at all. -/
theorem discharge_immediately (d : Device) (h : hasHazard d .mainsCapacitor) :
    (procedure d).take 2 = [.unplugAndRest, .dischargeCapacitors] := by
  revert h; revert d; decide

/-- And a device that holds no charge is not discharged: the step is there
exactly when it is needed. -/
theorem discharge_iff_capacitor (d : Device) :
    Step.dischargeCapacitors ∈ procedure d ↔ hasHazard d .mainsCapacitor := by
  revert d; decide

/-- **Cells out before boards.**  On anything with a lithium cell, the cell is
removed before a board is separated, before a motor is pulled and before an
iron is put anywhere near it. -/
theorem cells_before_boards (d : Device) (h : hasHazard d .lithiumCell) :
    (procedure d).idxOf .removeCells < (procedure d).idxOf .openCase ∧
      (procedure d).idxOf .removeCells < (procedure d).idxOf .separateBoards ∧
      (procedure d).idxOf .removeCells < (procedure d).idxOf .desolderComponents := by
  revert h; revert d; decide

/-- The case is opened before anything is taken out of it, and the shredder
runs after the boards and motors are out. -/
theorem case_before_contents (d : Device) :
    (procedure d).idxOf .openCase < (procedure d).idxOf .shredPlastics ∧
      (procedure d).idxOf .openCase < (procedure d).idxOf .sortMetals := by
  revert d; decide

/-- Each harvesting step appears exactly when the device actually gives up
that class of part. -/
theorem steps_match_yield (d : Device) :
    (Step.pullMotors ∈ procedure d ↔ has d electricMotor) ∧
      (Step.pullOptics ∈ procedure d ↔ has d glassBlank) ∧
      (Step.shredPlastics ∈ procedure d ↔ has d polymerPellet) := by
  revert d; decide

/-! ## The bench -/

open Tool in
/-- The tools a given teardown calls for.  Eyes, hands and lungs are protected
on every job; the rest follows the hazards and the yield. -/
def kit (d : Device) : List Tool :=
  [safetyGlasses, gloves, screwdriverSet, torxBits, pryTool, sideCutters, multimeter]
    ++ (if hasHazard d .mainsCapacitor then [dischargeProbe] else [])
    ++ (if hasHazard d .inkAndToner || hasHazard d .leadedGlass then [dustMask] else [])
    ++ (if has d logicChip || has d memoryChip || has d microcontrollerChip || has d cpuChip
          then [solderingIron, hotAirStation] else [])
    ++ (if has d polymerPellet then [shredder] else [])

/-- The safety kit is on the bench for every job. -/
theorem kit_always_protects (d : Device) :
    Tool.safetyGlasses ∈ kit d ∧ Tool.gloves ∈ kit d ∧ Tool.multimeter ∈ kit d := by
  revert d; decide

/-- The discharge probe is called for exactly when there is a charge to
discharge. -/
theorem kit_probe_iff_capacitor (d : Device) :
    Tool.dischargeProbe ∈ kit d ↔ hasHazard d .mainsCapacitor := by revert d; decide

/-- The shredder is called for exactly when there is plastic to shred. -/
theorem kit_shredder_iff_polymer (d : Device) :
    Tool.shredder ∈ kit d ↔ has d polymerPellet := by revert d; decide

/-- Hot air is called for exactly when chips are to come off a board. -/
theorem kit_hotAir_iff_chips (d : Device) :
    Tool.hotAirStation ∈ kit d ↔
      (has d logicChip || has d memoryChip || has d microcontrollerChip || has d cpuChip) := by
  revert d; decide

/-- A dust mask whenever there is toner or leaded glass. -/
theorem kit_mask_iff_dust (d : Device) :
    Tool.dustMask ∈ kit d ↔ (hasHazard d .inkAndToner || hasHazard d .leadedGlass) := by
  revert d; decide

theorem kit_nodup (d : Device) : (kit d).Nodup := by revert d; decide

/-- No teardown needs more than eleven tools, and none needs fewer than
seven. -/
theorem kit_size (d : Device) : 7 ≤ (kit d).length ∧ (kit d).length ≤ 11 := by revert d; decide

/-! ## Does it pay?

Every part on the bench is an hour the fab does not have to work.  Set the
hours a teardown takes against the hours the parts would have cost to make,
and the answer for eleven of the twelve devices is: strip it. -/

/-- Hours of bench work to strip one device. -/
def teardown : Device → ℚ
  | inkjetPrinter => 3/4
  | laserPrinter => 3/2
  | flatbedScanner => 1/2
  | wifiRouter => 1/3
  | desktopPC => 1
  | laptop => 5/4
  | smartphone => 1/2
  | lcdMonitor => 3/4
  | opticalDrive => 1/4
  | microwaveOven => 1
  | crtTelevision => 3/2
  | cordlessDrill => 1/3

theorem teardown_pos (d : Device) : 0 < teardown d := by
  cases d <;> norm_num [teardown]

/-- The fab hours a teardown saves: what it would have cost to make everything
the device gives up, starting from ore. -/
def avoided (d : Device) : ℚ := ((yield d).map (fun e => fab.laborFor e.1 e.2)).sum

/-- **Stripping the pile pays, and pays well.**  Every device but one returns
at least five hours of fab work for every hour spent on the bench. -/
theorem salvage_pays (d : Device) (h : d ≠ crtTelevision) : 5 * teardown d ≤ avoided d := by
  cases d <;> first
    | exact absurd rfl h
    | · simp only [avoided, yield, teardown, List.map_cons, List.map_nil, List.sum_cons,
          List.sum_nil, Fab.lf_electricMotor, Fab.lf_steelStock, Fab.lf_polymerPellet,
          Fab.lf_controlBoard, Fab.lf_powerSupply, Fab.lf_glassBlank, Fab.lf_pcb,
          Fab.lf_logicChip, Fab.lf_memoryChip, Fab.lf_microcontrollerChip, Fab.lf_cpuChip,
          Fab.lf_copperWire, Fab.lf_motherboard]
        norm_num

/-- In particular every device but one pays for itself outright. -/
theorem salvage_pays_outright (d : Device) (h : d ≠ crtTelevision) : teardown d < avoided d := by
  have h5 := salvage_pays d h
  have hp := teardown_pos d
  linarith

/-- **The exception: leave the picture tubes alone.**  A CRT television takes
an hour and a half to strip safely, holds kilovolts on its anode long after it
is unplugged, and gives back barely an hour of work in steel, copper and bare
board — its glass is leaded and no use to the furnace at all. -/
theorem crt_does_not_pay : avoided crtTelevision < teardown crtTelevision := by
  simp only [avoided, yield, teardown, List.map_cons, List.map_nil, List.sum_cons, List.sum_nil,
    Fab.lf_steelStock, Fab.lf_copperWire, Fab.lf_pcb, Fab.lf_polymerPellet]
  norm_num

/-- … and it is the only device on the list that carries the anode and the
leaded glass. -/
theorem crt_is_the_dangerous_one (d : Device) :
    (hasHazard d .highVoltageAnode ∨ hasHazard d .leadedGlass) ↔ d = crtTelevision := by
  revert d; decide

/-- The devices worth opening: everything but the picture tube. -/
def worthStripping : List Device := Device.all.filter (fun d => d ≠ crtTelevision)

theorem worthStripping_length : worthStripping.length = 11 := by decide

theorem mem_worthStripping (d : Device) : d ∈ worthStripping ↔ d ≠ crtTelevision := by
  revert d; decide

/-- **The rule for the pile**, in one statement: open everything except the
picture tubes, and every hour on the bench is worth five in the shop. -/
theorem the_rule : ∀ d ∈ worthStripping, 5 * teardown d ≤ avoided d := by
  intro d hd
  exact salvage_pays d ((mem_worthStripping d).1 hd)

end Salvage
end LifeTrac
