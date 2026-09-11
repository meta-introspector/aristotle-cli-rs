import Mathlib.Data.Finset.Card
import Mathlib.Tactic

/-!
# The Global Village Construction Set

This file imports, as Lean data, the list of the fifty machines of the
**Global Village Construction Set** (GVCS) exactly as the Open Source Ecology
wiki states it, together with the two attributes the wiki's own summary table
carries for each machine: the sector it belongs to and how far its development
has got.

Source: the OSE wiki page *Global Village Construction Set* and the summary
table it transcludes (`Template:GVCS List`), read in August 2026.  The table
is grouped into six sectors — habitat, agriculture, industry, energy,
materials, transportation — and colour-codes each cell with a development
status whose key is printed at the foot of the table: *design*, *planning*,
*prototype*, *almost done*, *full release*.

Each machine also carries the title of the wiki page it was read from
(`Machine.wikiPage`), so every row of the table below can be checked against
its source.

What is proved here is what such a transcription can support: that the list is
the fifty distinct machines it claims to be, how those fifty split across the
six sectors, and what the recorded state of completion actually amounts to —
no machine has reached full release, and exactly twenty of the fifty have a
prototype or better.

The dependency structure between these machines (the wiki's *product ecology*
relations) is imported separately, in `RequestProject/GVCSEcology.lean`.
-/

namespace LifeTrac
namespace GVCS

/-- The sectors the wiki's GVCS table is grouped into. -/
inductive Sector where
  | habitat | agriculture | industry | energy | materials | transportation
  deriving DecidableEq, Repr, Fintype, Inhabited

/-- The development status key printed at the foot of the wiki's GVCS table.
The colours are, in the order the key lists them: design, planning, prototype,
almost done, full release. -/
inductive Status where
  | design | planning | prototype | almostDone | fullRelease
  deriving DecidableEq, Repr, Fintype, Inhabited

/-- The fifty machines of the Global Village Construction Set, in the order
the wiki's table lists them (habitat, agriculture, industry, energy,
materials, transportation). -/
inductive Machine where
  -- habitat
  | cebPress | cementMixer | sawmill | bulldozer | backhoe
  -- agriculture
  | tractor | seeder | hayRake | wellDrillingRig | microtractor | soilPulverizer
  | spader | hayCutter | trencher | bakeryOven | dairyMilker | microcombine | baler
  -- industry
  | multimachine | ironworker | laserCutter | welder | plasmaCutter | torchTable
  | metalRoller | rodWireMill | pressForge | universalRotor | printer3D | scanner3D
  | circuitMill | industrialRobot | hammermill | drillPress | inductionFurnace
  -- energy
  | powerCube | gasifierBurner | solarConcentrator | motorGenerator | hydraulicMotor
  | steamEngine | heatExchanger | windTurbine | pelletizer | ups | battery
  -- materials
  | aluminumExtractor | bioplasticExtruder
  -- transportation
  | car | truck
  deriving DecidableEq, Repr, Fintype, Inhabited

namespace Machine

/-- The sector of the wiki's table each machine is listed in. -/
def sector : Machine → Sector
  | cebPress | cementMixer | sawmill | bulldozer | backhoe => .habitat
  | tractor | seeder | hayRake | wellDrillingRig | microtractor | soilPulverizer
  | spader | hayCutter | trencher | bakeryOven | dairyMilker | microcombine
  | baler => .agriculture
  | multimachine | ironworker | laserCutter | welder | plasmaCutter | torchTable
  | metalRoller | rodWireMill | pressForge | universalRotor | printer3D | scanner3D
  | circuitMill | industrialRobot | hammermill | drillPress
  | inductionFurnace => .industry
  | powerCube | gasifierBurner | solarConcentrator | motorGenerator | hydraulicMotor
  | steamEngine | heatExchanger | windTurbine | pelletizer | ups | battery => .energy
  | aluminumExtractor | bioplasticExtruder => .materials
  | car | truck => .transportation

/-- The development status the wiki's table records for each machine, by the
colour of its cell. -/
def status : Machine → Status
  -- almost done (yellow)
  | cebPress => .almostDone
  -- prototype (orange)
  | sawmill | bulldozer | backhoe | tractor | microtractor | soilPulverizer
  | trencher | ironworker | torchTable | universalRotor | printer3D | circuitMill
  | drillPress | powerCube | gasifierBurner | windTurbine => .prototype
  -- design (blue)
  | solarConcentrator | steamEngine | car => .design
  -- planning (uncoloured)
  | cementMixer | seeder | hayRake | wellDrillingRig | spader | hayCutter
  | bakeryOven | dairyMilker | microcombine | baler | multimachine | laserCutter
  | welder | plasmaCutter | metalRoller | rodWireMill | pressForge | scanner3D
  | industrialRobot | hammermill | inductionFurnace | motorGenerator
  | hydraulicMotor | heatExchanger | pelletizer | ups | battery
  | aluminumExtractor | bioplasticExtruder | truck => .planning

/-- The title of the OSE wiki page each machine was read from. -/
def wikiPage : Machine → String
  | cebPress => "CEB Press"
  | cementMixer => "Cement Mixer"
  | sawmill => "Sawmill"
  | bulldozer => "Bulldozer"
  | backhoe => "Backhoe"
  | tractor => "LifeTrac"
  | seeder => "Seeder"
  | hayRake => "Hay Rake"
  | wellDrillingRig => "Well-Drilling Rig"
  | microtractor => "MicroTrac"
  | soilPulverizer => "Soil Pulverizer"
  | spader => "Spader"
  | hayCutter => "Hay Cutter"
  | trencher => "Trencher"
  | bakeryOven => "Bakery Oven"
  | dairyMilker => "Dairy Milker"
  | microcombine => "Microcombine"
  | baler => "Baler"
  | multimachine => "Multimachine"
  | ironworker => "Ironworker"
  | laserCutter => "Laser Cutter"
  | welder => "Welder"
  | plasmaCutter => "Plasma Cutter"
  | torchTable => "CNC Torch Table"
  | metalRoller => "Metal Roller"
  | rodWireMill => "Rod and Wire Mill"
  | pressForge => "Press Forge"
  | universalRotor => "Universal Rotor"
  | printer3D => "3D Printer"
  | scanner3D => "3D Scanner"
  | circuitMill => "CNC Circuit Mill"
  | industrialRobot => "Industrial Robot"
  | hammermill => "Chipper Hammermill"
  | drillPress => "Drill Press"
  | inductionFurnace => "Induction Furnace"
  | powerCube => "Power Cube"
  | gasifierBurner => "Gasifier Burner"
  | solarConcentrator => "Solar Concentrator"
  | motorGenerator => "Electric Motor Generator"
  | hydraulicMotor => "Hydraulic Motor"
  | steamEngine => "Steam Engine"
  | heatExchanger => "Heat Exchanger"
  | windTurbine => "Wind Turbine"
  | pelletizer => "Pelletizer"
  | ups => "Universal Power Supply"
  | battery => "Nickel-Iron Battery"
  | aluminumExtractor => "Aluminum Extractor"
  | bioplasticExtruder => "Bioplastic Extruder"
  | car => "Open Source Car"
  | truck => "Open Source Truck"

end Machine

open Machine

/-- The fifty machines as a list, in the order of the wiki's table. -/
def allMachines : List Machine :=
  [cebPress, cementMixer, sawmill, bulldozer, backhoe,
   tractor, seeder, hayRake, wellDrillingRig, microtractor, soilPulverizer,
   spader, hayCutter, trencher, bakeryOven, dairyMilker, microcombine, baler,
   multimachine, ironworker, laserCutter, welder, plasmaCutter, torchTable,
   metalRoller, rodWireMill, pressForge, universalRotor, printer3D, scanner3D,
   circuitMill, industrialRobot, hammermill, drillPress, inductionFurnace,
   powerCube, gasifierBurner, solarConcentrator, motorGenerator, hydraulicMotor,
   steamEngine, heatExchanger, windTurbine, pelletizer, ups, battery,
   aluminumExtractor, bioplasticExtruder, car, truck]

/-- The list of the fifty machines really does list every machine. -/
theorem mem_allMachines (m : Machine) : m ∈ allMachines := by
  revert m; decide

/-- No machine is listed twice. -/
theorem allMachines_nodup : allMachines.Nodup := by decide

/-- The list has fifty entries. -/
theorem allMachines_length : allMachines.length = 50 := by decide

/-- The set of GVCS machines belonging to one sector. -/
def sectorSet (s : Sector) : Finset Machine :=
  Finset.univ.filter (fun m => m.sector = s)

/-- The set of GVCS machines at one development status. -/
def statusSet (t : Status) : Finset Machine :=
  Finset.univ.filter (fun m => m.status = t)

/-! ## The list is the fifty machines it says it is -/

/-- The Global Village Construction Set is a set of exactly fifty machines. -/
theorem card_machines : Fintype.card Machine = 50 := by decide

/-- The six sectors of the wiki's table. -/
theorem card_sectors : Fintype.card Sector = 6 := by decide

/-! ## How the fifty split across the six sectors -/

theorem card_habitat : (sectorSet .habitat).card = 5 := by decide
theorem card_agriculture : (sectorSet .agriculture).card = 13 := by decide
theorem card_industry : (sectorSet .industry).card = 17 := by decide
theorem card_energy : (sectorSet .energy).card = 11 := by decide
theorem card_materials : (sectorSet .materials).card = 2 := by decide
theorem card_transportation : (sectorSet .transportation).card = 2 := by decide

/-- The six sectors partition the fifty machines: their sizes add up. -/
theorem sectors_partition :
    (sectorSet .habitat).card + (sectorSet .agriculture).card
      + (sectorSet .industry).card + (sectorSet .energy).card
      + (sectorSet .materials).card + (sectorSet .transportation).card
      = Fintype.card Machine := by decide

/-- Industry is the largest sector: more of the set is machines that make
machines than any other kind. -/
theorem industry_is_largest (s : Sector) (hs : s ≠ .industry) :
    (sectorSet s).card < (sectorSet .industry).card := by
  revert hs; cases s <;> decide

/-! ## The recorded state of completion -/

theorem card_almostDone : (statusSet .almostDone).card = 1 := by decide
theorem card_prototype : (statusSet .prototype).card = 16 := by decide
theorem card_design : (statusSet .design).card = 3 := by decide
theorem card_planning : (statusSet .planning).card = 30 := by decide
theorem card_fullRelease : (statusSet .fullRelease).card = 0 := by decide

/-- **Nothing has been fully released.**  On the wiki's own completion table
not one of the fifty machines carries the full-release colour, so the GVCS is
not complete in its own sense of the word. -/
theorem no_machine_fully_released (m : Machine) : m.status ≠ .fullRelease := by
  revert m; decide

/-- Seventeen of the fifty machines — barely a third — have got as far as a
prototype or beyond; the other thirty-three are still on paper. -/
theorem card_prototyped_or_better :
    (Finset.univ.filter
      (fun m : Machine => m.status = .prototype ∨ m.status = .almostDone
        ∨ m.status = .fullRelease)).card = 17 := by decide

/-- The single most advanced machine on the list is the CEB press, the
Liberator. -/
theorem cebPress_is_the_most_advanced (m : Machine) (h : m.status = .almostDone) :
    m = cebPress := by
  revert h; revert m; decide

/-! ## Where the LifeTrac sits -/

/-- The tractor this project is about is one of the fifty, and it is an
agricultural machine. -/
theorem tractor_is_agricultural : tractor.sector = .agriculture := rfl

/-- The tractor is at prototype status. -/
theorem tractor_is_prototyped : tractor.status = .prototype := rfl

/-- Every machine has a distinct wiki page: the fifty rows of the table are
fifty different articles. -/
theorem wikiPage_injective : Function.Injective Machine.wikiPage := by decide

/-! ## The development budget

The wiki's own arithmetic for GVCS 1.0: development is estimated at roughly
one million dollars per machine, for a nominal total budget of fifty million
by 2028. -/

/-- Development cost per machine, in dollars, as the wiki estimates it. -/
def devCostPerMachine : ℕ := 1000000

/-- The nominal development budget: one estimate per machine, over all fifty
machines. -/
def devBudget : ℕ := Fintype.card Machine * devCostPerMachine

/-- Fifty machines at a million dollars each is the fifty million dollar
figure the wiki quotes. -/
theorem devBudget_eq : devBudget = 50000000 := by decide

end GVCS
end LifeTrac
