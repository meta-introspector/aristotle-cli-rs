import RequestProject.Gvcs.SalvageBill

/-!
# The teardown manual, written out

`RequestProject/Salvage.lean` holds the teardown data and the theorems about
it; this file turns the very same data into the printable guide in
`docs/salvage-guide.md`.  The document is not written by hand: every hazard
line, every tool list, every step and every number in it is read out of the
definitions that the theorems are about, so the page on the wall and the page
that was proved correct cannot drift apart.

`lake exe salvage [file]` writes the guide; the default is
`docs/salvage-guide.md`.
-/

namespace LifeTrac
namespace Salvage

open Fab (fab)
open Fab.Part
open Device

/-! ## Names -/

/-- The name of a device. -/
def Device.name : Device → String
  | inkjetPrinter => "Inkjet printer"
  | laserPrinter => "Laser printer"
  | flatbedScanner => "Flatbed scanner"
  | wifiRouter => "Wifi router"
  | desktopPC => "Desktop computer"
  | laptop => "Laptop"
  | smartphone => "Smartphone"
  | lcdMonitor => "Flat monitor"
  | opticalDrive => "Optical drive"
  | microwaveOven => "Microwave oven"
  | crtTelevision => "CRT television"
  | cordlessDrill => "Cordless drill"

/-- What a hazard is, and what to do about it. -/
def Hazard.line : Hazard → String
  | .mainsCapacitor =>
      "**Mains capacitor.**  The supply holds a charge after the plug is out. \
Wait, then short it through a resistor with the discharge probe and confirm \
zero volts on the meter before your hands go in."
  | .highVoltageAnode =>
      "**Picture-tube anode.**  Kilovolts, held for weeks, behind the rubber \
cap. Do not open a tube you have not been trained to open."
  | .lithiumCell =>
      "**Lithium cell.**  Take it out first, whole and unbent.  Never pry, cut \
or puncture a cell; a swollen one goes straight to the fire bucket, not the \
bench."
  | .inkAndToner =>
      "**Ink and toner.**  Fine powder that hangs in the air.  Mask on, work \
outside or over a damp cloth, and do not use a household vacuum on toner."
  | .laserDiode =>
      "**Laser diode.**  Invisible and collimated.  Cut its supply before the \
lid comes off and never look into the aperture."
  | .mercuryLamp =>
      "**Backlight lamp.**  A cold-cathode tube holds mercury.  Slide it out \
whole and store it padded; a broken one is a hazardous-waste problem, not a \
sweeping-up problem."
  | .leadedGlass =>
      "**Leaded glass.**  The funnel glass of a tube is loaded with lead.  It \
never goes in the glass furnace and never goes in the ground."

/-- The short name of a hazard. -/
def Hazard.name : Hazard → String
  | .mainsCapacitor => "mains capacitor"
  | .highVoltageAnode => "picture-tube anode"
  | .lithiumCell => "lithium cell"
  | .inkAndToner => "ink and toner"
  | .laserDiode => "laser diode"
  | .mercuryLamp => "mercury backlight lamp"
  | .leadedGlass => "leaded glass"

/-- The name of a tool. -/
def Tool.name : Tool → String
  | .screwdriverSet => "screwdriver set"
  | .torxBits => "torx and security bits"
  | .pryTool => "plastic pry tool"
  | .sideCutters => "side cutters"
  | .solderingIron => "soldering iron"
  | .hotAirStation => "hot-air station"
  | .multimeter => "multimeter"
  | .dischargeProbe => "discharge probe (resistor on a lead)"
  | .shredder => "plastics shredder"
  | .dustMask => "dust mask"
  | .gloves => "gloves"
  | .safetyGlasses => "safety glasses"

/-- What a step of the teardown says to do. -/
def Step.line : Step → String
  | .unplugAndRest =>
      "Unplug it and leave it to sit.  Nothing is opened while it is on a lead."
  | .dischargeCapacitors =>
      "Discharge the supply through the probe and check it with the meter."
  | .removeCells => "Take the cells out whole and set them aside."
  | .openCase => "Take the fasteners out and open the case."
  | .separateBoards => "Unplug the looms and lift the boards out."
  | .pullMotors => "Unbolt the motors, with their pinions and their leads."
  | .pullOptics => "Slide the glass, mirrors and lenses out and pad them."
  | .desolderComponents => "Lift the chips off the board with hot air."
  | .shredPlastics => "Cut the shells up and run them through the shredder."
  | .sortMetals => "Sort the steel and the copper into their bins."
  | .logAndStore => "Weigh it, label it and put it on the shelf."

/-- The short name of a step. -/
def Step.name : Step → String
  | .unplugAndRest => "unplug and rest"
  | .dischargeCapacitors => "discharge"
  | .removeCells => "cells out"
  | .openCase => "open"
  | .separateBoards => "boards out"
  | .pullMotors => "motors out"
  | .pullOptics => "optics out"
  | .desolderComponents => "chips off"
  | .shredPlastics => "shred"
  | .sortMetals => "sort metal"
  | .logAndStore => "log and store"

/-- The name of a salvaged part, in the vocabulary of the fab. -/
def partName : Fab.Part → String
  | steelStock => "steel"
  | copperWire => "copper wire"
  | polymerPellet => "shreddable polymer"
  | glassBlank => "optical glass"
  | pcb => "bare board"
  | electricMotor => "motor"
  | controlBoard => "control board"
  | powerSupply => "power supply"
  | motherboard => "motherboard"
  | logicChip => "logic chip"
  | memoryChip => "memory chip"
  | microcontrollerChip => "microcontroller"
  | cpuChip => "processor"
  | printerFrame => "printer frame"
  | hotEnd => "hot end"
  | filament => "filament"
  | printedCase => "printed case"
  | printer3D => "3D printer"
  | computer => "computer"
  | extruderTool => "filament extruder"
  | metalShop => "metal shop"
  | p => toString (repr p)

/-- The unit a salvaged part is counted in. -/
def partUnit : Fab.Part → String
  | steelStock | copperWire | polymerPellet => "kg"
  | _ => "off"

/-! ## Rendering -/

/-- A rational written as a decimal to two places, rounding down, for the
printed page. -/
def showQ (q : ℚ) : String :=
  let n := (q * 100).floor
  let whole := n / 100
  let freq := (n % 100).toNat
  let frac := if freq < 10 then "0" ++ toString freq else toString freq
  toString whole ++ "." ++ frac

def bullets (l : List String) : String := String.intercalate "\n" (l.map (fun s => "- " ++ s))

/-- One numbered line of a teardown. -/
def stepLines (l : List Step) : String :=
  String.intercalate "\n"
    ((l.zipIdx.map (fun (s, i) => toString (i + 1) ++ ". " ++ s.line)))

/-- The yield table of a device. -/
def yieldLines (d : Device) : String :=
  bullets ((yield d).map (fun e => showQ e.2 ++ " " ++ partUnit e.1 ++ " — " ++ partName e.1))

/-- The whole entry for one device. -/
def deviceSection (d : Device) : String :=
  "### " ++ d.name ++ "\n\n" ++
  "**Hazards.**\n\n" ++ bullets ((hazards d).map Hazard.line) ++ "\n\n" ++
  "**On the bench.** " ++ String.intercalate ", " ((kit d).map Tool.name) ++ ".\n\n" ++
  "**Steps.**\n\n" ++ stepLines (procedure d) ++ "\n\n" ++
  "**Yield, per unit.**\n\n" ++ yieldLines d ++ "\n\n" ++
  "**Time.** " ++ showQ (teardown d) ++ " h on the bench, against " ++
    showQ (avoided d) ++ " h of shop work saved" ++
  (if d = crtTelevision then " — *this one does not pay: leave it alone.*" else ".") ++ "\n"

/-- The heading and the rules that hold of every teardown. -/
def preamble : String :=
"# Salvaging the pile

*Generated from `RequestProject/Salvage.lean` and `RequestProject/SalvageBill.lean`;
every number below is read out of the definitions those files prove theorems about.*

A heap of dead printers, routers, computers and phones is a shortcut past most
of the fab.  A stepper motor pulled out of a scrap printer is a motor the shop
does not have to wind; a motherboard out of a dead desktop is a processor the
shop does not have to grow, dice, bond and package — and, far more to the
point, a clean room the shop does not have to build.

## The rules

1. **The plug comes out first, on everything.**
2. **Anything with a mains-side capacitor is discharged second**, before
   another screw is turned.
3. **Cells come out before boards** — never work around a lithium cell.
4. **Every job ends the same way:** weighed, labelled and on a shelf.  A part
   you cannot find is a part you did not salvage.
5. **Open everything except picture tubes.**  Every other machine on this list
   returns at least five hours of shop work for each hour on the bench; a CRT
   returns less than it costs and can kill you while it does it.

## The machines
"

/-- The worked example: what six machines are worth. -/
def worked : String :=
"## A worked pile

Two inkjet printers, one laser printer, one desktop and two microwaves — six
machines, " ++ showQ pileHours ++ " hours of teardown — hold everything needed to build a
3D printer *and* a computer:

" ++ bullets (salvaged.map (fun p =>
        showQ (harvest pile p) ++ " " ++ partUnit p ++ " " ++ partName p)) ++ "

What is left to make is the printer's frame, its hot end, a spool of filament
off the shredded shells, the printed case, and the two assemblies:

- 3D printer: " ++ showQ (fab.laborGiven onHand printer3D 1) ++ " h
- computer: " ++ showQ (fab.laborGiven onHand computer 1) ++ " h
- teardown: " ++ showQ pileHours ++ " h
- **total: " ++ showQ (pileHours + fab.laborGiven onHand printer3D 1
        + fab.laborGiven onHand computer 1) ++ " h**

The same two machines built from ore come to " ++
  showQ (fab.laborFor printer3D 1 + fab.laborFor computer 1) ++ " h of shop work — and that
figure counts only the machines, not the twelve tonnes of instruments that
have to be standing before the first wafer is cut.  Out of the pile, the whole
job needs a metal shop, a filament extruder and the 3D printer it builds
first.  No clean room, no stepper, no crystal puller, no furnace.

*Not everything in a machine is worth pulling, and nothing here says what to
do with what is left: cells, tubes, lamps and toner are hazardous waste and go
to a proper facility, not in the ground.*
"

/-- The whole guide. -/
def guideText : String :=
  preamble ++ "\n" ++
  String.intercalate "\n" (Device.all.map deviceSection) ++ "\n" ++ worked

end Salvage
end LifeTrac
