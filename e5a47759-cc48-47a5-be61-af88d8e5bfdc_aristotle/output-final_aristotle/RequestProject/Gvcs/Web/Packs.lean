import RequestProject.Gvcs.Web.Engine
import RequestProject.Gvcs.Runtime
import RequestProject.Gvcs.Water.Market

/-!
# The packs the game ships with

Four packs of increasing size, all built here out of the Lean tables the rest
of the development is about, so a price on a screen and a price in a proof
cannot drift apart:

* `corePack` — the homestead: the material catalogue and prices of
  `RequestProject/Runtime.lean`, its seven assemblies with their bills of
  materials and labour, diesel, seed, and wheat.  Goal: a LifeTrac in the yard
  and 18 000 in hand.
* `workshopPack` — the power cube, the CEB press and brickmaking.
* `farmPack` — a seed drill, oats and hay.
* `homesteadPack` — the sawmill, lumber and the microhouse, which is the goal
  of the big game.

`bigPacks` is all four at once; `worldOf bigPacks` is the catalogue of the
large build of the page.

Everything a page needs to trust about a pack is checked here by evaluation:
`Pack.Safe` (so the share code round-trips, by `decodeShare_encodeShare`),
`Consistent` (unique keys, and every bill of materials resolves) and `Priced`
(so `cash_nonneg` and `day_le` apply).  `core_demo_wins` and
`big_demo_wins` then play the two games to their goals, so neither is
merely well formed: both are winnable.
-/

namespace LifeTrac
namespace Modular

open Build (Material)
open Runtime (RPart RCrop costM salvageM fuelPriceM)

/-! ## Helpers -/

/-- A material: something the dealer sells and buys back. -/
def mkMat (id name unit : String) (price salvage : Int) : Item :=
  { id := id, name := name, kind := .material, unit := unit, price := price,
    salvage := salvage, days := 0, revenue := 0, inputs := [] }

/-- An assembly: something the workbench builds from a bill of materials. -/
def mkPart (id name : String) (price days : Int) (inputs : List (String × Int)) : Item :=
  { id := id, name := name, kind := .part, unit := "each", price := price,
    salvage := 0, days := days, revenue := 0, inputs := inputs }

/-- An activity: something the land, or a machine, yields when it is worked. -/
def mkCrop (id name unit : String) (days revenue : Int)
    (inputs : List (String × Int)) : Item :=
  { id := id, name := name, kind := .crop, unit := unit, price := 0, salvage := 0,
    days := days, revenue := revenue, inputs := inputs }

/-! ## The core pack, out of the runtime tables -/

/-- The materials of `Runtime.lean`, in catalogue order. -/
def runtimeMaterials : List Material :=
  [.steelTube4, .steelTube3, .steelTube2, .steelPlate6, .steelPlate12, .roundBar50,
   .boltM12, .nutM12, .weldWire, .hose, .fitting, .fluid, .gearPump, .wheelMotor,
   .cylinder, .controlValve, .engine, .fuelTank, .hydraulicTank, .wheelHub, .tire,
   .seat, .paint, .electricalKit]

/-- The key a material is known by in a pack. -/
def matKey : Material → String
  | .steelTube4 => "tube4"
  | .steelTube3 => "tube3"
  | .steelTube2 => "tube2"
  | .steelPlate6 => "plate6"
  | .steelPlate12 => "plate12"
  | .roundBar50 => "bar50"
  | .boltM12 => "bolt"
  | .nutM12 => "nut"
  | .weldWire => "wire"
  | .hose => "hose"
  | .fitting => "fitting"
  | .fluid => "fluid"
  | .gearPump => "pump"
  | .wheelMotor => "motor"
  | .cylinder => "cylinder"
  | .controlValve => "valve"
  | .engine => "engine"
  | .fuelTank => "fueltank"
  | .hydraulicTank => "hydtank"
  | .wheelHub => "hub"
  | .tire => "tire"
  | .seat => "seat"
  | .paint => "paint"
  | .electricalKit => "electrical"

/-- What the market calls it (plain ASCII, so that it survives a share code). -/
def matName : Material → String
  | .steelTube4 => "4 in. square steel tube"
  | .steelTube3 => "3 in. square steel tube"
  | .steelTube2 => "2 in. square steel tube"
  | .steelPlate6 => "6 mm steel plate"
  | .steelPlate12 => "12 mm steel plate"
  | .roundBar50 => "50 mm round bar"
  | .boltM12 => "M12 bolt"
  | .nutM12 => "M12 nut"
  | .weldWire => "MIG welding wire"
  | .hose => "hydraulic hose"
  | .fitting => "hose end fitting"
  | .fluid => "hydraulic fluid"
  | .gearPump => "gear pump"
  | .wheelMotor => "hydraulic wheel motor"
  | .cylinder => "hydraulic cylinder"
  | .controlValve => "spool control valve"
  | .engine => "engine"
  | .fuelTank => "fuel tank"
  | .hydraulicTank => "hydraulic reservoir"
  | .wheelHub => "wheel hub"
  | .tire => "tire on rim"
  | .seat => "operator seat"
  | .paint => "paint"
  | .electricalKit => "electrical kit"

/-- A material as a pack item, priced from the runtime tables. -/
def matItem (m : Material) : Item :=
  mkMat (matKey m) (matName m) m.unitName (costM m) (salvageM m)

/-- The assemblies of `Runtime.lean`. -/
def runtimeParts : List RPart :=
  [.frame, .wheelModule, .powerUnit, .controlStation, .loader, .finishing, .lifeTrac]

/-- The key an assembly is known by. -/
def partKey : RPart → String
  | .frame => "frame"
  | .wheelModule => "wheelmodule"
  | .powerUnit => "powerunit"
  | .controlStation => "controlstation"
  | .loader => "loader"
  | .finishing => "finishing"
  | .lifeTrac => "lifetrac"

/-- What the workbench calls it. -/
def partName : RPart → String
  | .frame => "frame"
  | .wheelModule => "wheel module"
  | .powerUnit => "power unit"
  | .controlStation => "control station"
  | .loader => "loader"
  | .finishing => "finishing"
  | .lifeTrac => "LifeTrac (whole machine)"

/-- The bill of materials of an assembly, as pack inputs. -/
def partInputs (a : RPart) : List (String × Int) :=
  (runtimeMaterials.filter (fun m => a.req m ≠ 0)).map (fun m => (matKey m, a.req m))

/-- An assembly as a pack item. -/
def partItem (a : RPart) : Item :=
  mkPart (partKey a) (partName a) a.cost a.days (partInputs a)

/-- Diesel, priced from `Runtime.fuelPriceM`. -/
def fuelItem : Item := mkMat "fuel" "diesel" "L" fuelPriceM (fuelPriceM * 3 / 5)

/-- A hectare's seed and fertiliser, priced from `Runtime.RCrop.seed`. -/
def seedItem : Item :=
  mkMat "seed" "seed and fertiliser" "ha dose" (RCrop.seed .wheat) (RCrop.seed .wheat * 3 / 5)

/-- Wheat, from the agronomy of `Runtime.lean`: one dose of seed and eighteen
litres of diesel a hectare, and the machine is needed to work it. -/
def wheatItem : Item :=
  mkCrop "wheat" "wheat" "ha" (RCrop.daysHa .wheat) (RCrop.revenue .wheat)
    [("seed", 1000000), ("fuel", RCrop.fuelHa .wheat), ("lifetrac", -1000000)]

/-- **The core pack**: the game of `Runtime.lean`, as a pack. -/
def corePack : Pack :=
  { id := "core"
    title := "LifeTrac: the homestead"
    version := 1
    goalItem := "lifetrac"
    goalCash := 18000000000
    items := runtimeMaterials.map matItem ++ [fuelItem, seedItem] ++
      runtimeParts.map partItem ++ [wheatItem] }

/-! ## The workshop pack -/

/-- **The workshop pack**: a power cube to drive things off the tractor, a
compressed-earth-brick press, and brickmaking as an activity. -/
def workshopPack : Pack :=
  { id := "workshop"
    title := "Workshop: power cube and CEB press"
    version := 1
    goalItem := "cebpress"
    goalCash := 20000000000
    items :=
      [ mkPart "powercube" "power cube" 2450000000 2000000
          [("engine", 1000000), ("pump", 1000000), ("hydtank", 1000000),
           ("tube3", 4000000), ("bolt", 24000000), ("nut", 24000000),
           ("hose", 4000000), ("fitting", 6000000), ("wire", 2000000)],
        mkPart "cebpress" "compressed earth brick press" 1830000000 4000000
          [("plate12", 3000000), ("tube4", 6000000), ("cylinder", 2000000),
           ("valve", 1000000), ("hose", 6000000), ("fitting", 8000000),
           ("bar50", 1000000), ("wire", 3000000), ("powercube", -1000000)],
        mkCrop "brick" "a run of compressed earth bricks" "run" 500000 340000000
          [("fuel", 6000000), ("cebpress", -1000000)] ] }

/-! ## The farm pack -/

/-- **The farm pack**: a seed drill, and two more things to grow. -/
def farmPack : Pack :=
  { id := "farm"
    title := "Farm: drill, oats and hay"
    version := 1
    goalItem := "seeddrill"
    goalCash := 20000000000
    items :=
      [ mkPart "seeddrill" "three metre seed drill" 940000000 1500000
          [("tube3", 5000000), ("plate6", 2000000), ("bar50", 1000000),
           ("bolt", 30000000), ("nut", 30000000), ("wire", 2000000),
           ("lifetrac", -1000000)],
        mkCrop "oats" "oats" "ha" 250000 620000000
          [("seed", 1000000), ("fuel", 15000000), ("lifetrac", -1000000),
           ("seeddrill", -1000000)],
        mkCrop "hay" "hay" "ha" 187500 410000000
          [("fuel", 11000000), ("lifetrac", -1000000)] ] }

/-! ## The homestead pack -/

/-- **The homestead pack**: a sawmill, lumber, and the microhouse the big game
is played for. -/
def homesteadPack : Pack :=
  { id := "homestead"
    title := "Homestead: sawmill, lumber and the microhouse"
    version := 1
    goalItem := "microhouse"
    goalCash := 5000000000
    items :=
      [ mkPart "sawmill" "band sawmill" 1620000000 3000000
          [("tube4", 8000000), ("plate6", 3000000), ("motor", 1000000),
           ("hose", 4000000), ("fitting", 4000000), ("bolt", 40000000),
           ("nut", 40000000), ("wire", 3000000), ("powercube", -1000000)],
        mkCrop "lumber" "a run of milled lumber" "run" 375000 260000000
          [("fuel", 5000000), ("sawmill", -1000000)],
        mkPart "microhouse" "the microhouse" 24000000000 30000000
          [("brick", 40000000), ("lumber", 6000000), ("plate6", 4000000),
           ("bolt", 60000000), ("nut", 60000000), ("paint", 12000000),
           ("electrical", 2000000), ("lifetrac", -1000000)] ] }

/-- Every pack, in load order: the big game. -/
def bigPacks : List Pack := [corePack, workshopPack, farmPack, homesteadPack]

/-- The pack the big build plays for: the whole catalogue under the
microhouse's goal. -/
def bigPack : Pack :=
  { id := "big"
    title := "The whole homestead"
    version := 1
    goalItem := "microhouse"
    goalCash := 5000000000
    items := (worldOf bigPacks) }

/-! ## The tiny pack -/

/-- **The tiny pack**: three items, a pottery. It exists so that the share
code of a whole game fits on one short line, which is what makes it the pack
to paste at somebody when showing them how packs travel. -/
def tinyPack : Pack :=
  { id := "tiny"
    title := "Tiny: a pottery"
    version := 1
    goalItem := "kiln"
    goalCash := 15000000000
    items :=
      [ mkMat "clay" "clay" "t" 40000000 10000000,
        mkPart "kiln" "a small kiln" 300000000 1000000 [("clay", 4000000)],
        mkCrop "pot" "a batch of pots" "batch" 250000 90000000
          [("clay", 1000000), ("kiln", -1000000)] ] }


/-! ## The water pack -/

/-- A module of the water-and-sun stall, as a pack item: the price is the one
`RequestProject/Water/Market.lean` proves things about, so the number on the
screen and the number in the proof are the same number. -/
def modPart (m : Water.Module) (days : Int) (inputs : List (String × Int)) : Item :=
  mkPart m.key m.name m.price days inputs

/-- **The water pack**: the pure water-and-sun computer, module by module.
Glass, hardwood, leather, mirror and pasteboard go in; a rack of a hundred
water NAND gates, a bank of latches, a siphon clock, the head tank, the solar
lift, the pond, the card reader, the punch, the program stack and two
heliostats come out; and the thing they add up to is a controller with no
silicon in it, which then prints plates — or weaves stacks of cards to sell on
the stall — for a living. -/
def waterPack : Pack :=
  { id := "water"
    title := "Water and sun: a computer with no silicon in it"
    version := 1
    goalItem := "watercomputer"
    goalCash := 13000000000
    items :=
      [ mkMat "water" "pond water" "m3" 2000000 500000,
        mkMat "glasstube" "drawn glass tube" "each" 6000000 2000000,
        mkMat "timber" "seasoned hardwood board" "each" 9000000 3000000,
        mkMat "leathersheet" "leather sheet" "each" 5000000 1500000,
        mkMat "mirrorglass" "silvered mirror" "each" 25000000 8000000,
        mkMat Water.Module.cardBox.key Water.Module.cardBox.name "box"
          Water.Module.cardBox.price 4000000,
        modPart Water.Module.gateTray 500000
          [("glasstube", 8000000), ("timber", 3000000), ("leathersheet", 4000000)],
        modPart Water.Module.latchBank 250000
          [("timber", 2000000), ("leathersheet", 2000000)],
        modPart Water.Module.siphonClock 500000
          [("glasstube", 4000000), ("timber", 2000000)],
        modPart Water.Module.headTank 1000000
          [("timber", 20000000), ("leathersheet", 4000000)],
        modPart Water.Module.solarLift 2000000
          [("mirrorglass", 8000000), ("glasstube", 30000000), ("timber", 20000000)],
        modPart Water.Module.pond 1000000
          [("timber", 8000000), ("leathersheet", 10000000), ("water", 20000000)],
        modPart Water.Module.loomReader 1500000
          [("timber", 12000000), ("leathersheet", 8000000), ("glasstube", 10000000)],
        modPart Water.Module.cardPunchPress 750000
          [("timber", 6000000), ("glasstube", 2000000)],
        modPart Water.Module.printerCardStack 2000000
          [("cardbox", 10000000), ("cardpunch", -1000000)],
        modPart Water.Module.heliostat 500000
          [("mirrorglass", 2000000), ("timber", 2000000)],
        mkPart "watercomputer" "the water and sun controller" Water.kitPrice 4000000
          [("gatetray", 12000000), ("latchbank", 4000000), ("siphonclock", 1000000),
           ("headtank", 1000000), ("solarlift", 1000000), ("pond", 1000000),
           ("loomreader", 1000000), ("cardstack", 1000000), ("heliostat", 2000000),
           ("cardpunch", -1000000)],
        mkCrop "printplate" "a plate of printed parts" "plate" 250000 120000000
          [("water", 100000), ("watercomputer", -1000000)],
        mkCrop "memestall" "a market day selling card stacks" "day" 500000 320000000
          [("cardbox", 10000000), ("cardpunch", -1000000)] ] }

/-! ## What is checked of them -/

/-- A world is consistent when its keys are distinct and every bill of
materials names an item that exists. -/
def Consistent (w : World) : Bool :=
  decide ((w.map Item.id).Nodup) &&
    w.all (fun i => !i.id.isEmpty && i.inputs.all (fun q => (findItem w q.1).isSome))

/-- The catalogue of the paste demo. -/
def tinyWorld : World := worldOf [tinyPack]

/-- The catalogue of the small build. -/
def coreWorld : World := worldOf [corePack]

/-- The catalogue of the large build. -/
def bigWorld : World := worldOf bigPacks

theorem tinyPack_safe : tinyPack.Safe = true := by decide

theorem corePack_safe : corePack.Safe = true := by decide

theorem workshopPack_safe : workshopPack.Safe = true := by decide

theorem farmPack_safe : farmPack.Safe = true := by decide

theorem homesteadPack_safe : homesteadPack.Safe = true := by decide

theorem bigPack_safe : bigPack.Safe = true := by decide

/-- **Every pack the game ships survives being shared.** -/
theorem corePack_share : decodeShare (encodeShare corePack) = some corePack :=
  decodeShare_encodeShare corePack_safe

theorem bigPack_share : decodeShare (encodeShare bigPack) = some bigPack :=
  decodeShare_encodeShare bigPack_safe

theorem tinyPack_share : decodeShare (encodeShare tinyPack) = some tinyPack :=
  decodeShare_encodeShare tinyPack_safe

theorem tinyWorld_consistent : Consistent tinyWorld = true := by decide

theorem tinyWorld_priced : Priced tinyWorld = true := by decide

theorem coreWorld_consistent : Consistent coreWorld = true := by decide

theorem bigWorld_consistent : Consistent bigWorld = true := by decide

theorem coreWorld_priced : Priced coreWorld = true := by decide

theorem bigWorld_priced : Priced bigWorld = true := by decide


/-! ## The water pack is checked too -/

/-- The catalogue of the water build: the homestead's core plus the stall. -/
def waterWorld : World := worldOf [corePack, waterPack]

theorem waterPack_safe : waterPack.Safe = true := by decide

/-- **The water pack survives being shared.** -/
theorem waterPack_share : decodeShare (encodeShare waterPack) = some waterPack :=
  decodeShare_encodeShare waterPack_safe

theorem waterWorld_consistent : Consistent waterWorld = true := by decide

theorem waterWorld_priced : Priced waterWorld = true := by decide

/-- **The screen and the proof quote the same prices.**  Every module of the
stall in `RequestProject/Water/Market.lean` is in the pack at exactly the price
that file prices it at. -/
theorem waterPack_prices_match_stall :
    ∀ m ∈ Water.Module.all,
      (findItem waterWorld m.key).map Item.price = some m.price := by decide

/-! ## The games are winnable -/

/-- The position a new game starts from: fifteen thousand in the bank, an empty
shed. -/
def start : St := { cash := 15000000000, day := 0, stock := [] }

/-- The bill of materials of the whole machine, as a shopping list of whole
units (rounding up). -/
def coreShopping : List Act :=
  [.buy "tube4" 12, .buy "tube3" 14, .buy "tube2" 6, .buy "plate6" 2,
   .buy "plate12" 2, .buy "bar50" 2, .buy "bolt" 120, .buy "nut" 120,
   .buy "wire" 9, .buy "hose" 40, .buy "fitting" 44, .buy "fluid" 40,
   .buy "pump" 1, .buy "motor" 4, .buy "cylinder" 2, .buy "valve" 2,
   .buy "engine" 1, .buy "fueltank" 1, .buy "hydtank" 1, .buy "hub" 4,
   .buy "tire" 4, .buy "seat" 1, .buy "paint" 8, .buy "electrical" 1]

/-- A playthrough of the core game: buy the machine's bill of materials, build
it, and put twenty hectares into wheat. -/
def coreDemo : List Act :=
  coreShopping ++ [.make "lifetrac", .buy "seed" 20, .buy "fuel" 360, .work "wheat" 20]

/-- Where the core playthrough ends. -/
def coreDemoEnd : Option St := run coreWorld start coreDemo

/-- **The core game is winnable**, and this is a winning line. -/
theorem core_demo_wins : coreDemoEnd.map (won corePack) = some true := by decide

/-- What the core playthrough ends with: 18 494 in hand on day 17.125. -/
theorem core_demo_end : coreDemoEnd.map (fun s => (s.cash, s.day)) =
    some (18494000000, 17125000) := by decide

/-- A playthrough of the whole game: the machine, then wheat for the money,
then the power cube and the press, forty runs of brick, the sawmill and six
runs of lumber, and the microhouse. -/
def bigDemo : List Act :=
  coreShopping ++ [.make "lifetrac", .buy "seed" 20, .buy "fuel" 400, .work "wheat" 20] ++
  [.buy "engine" 1, .buy "pump" 1, .buy "hydtank" 1, .buy "tube3" 4, .buy "bolt" 24,
   .buy "nut" 24, .buy "hose" 4, .buy "fitting" 6, .buy "wire" 2, .make "powercube"] ++
  [.buy "plate12" 3, .buy "tube4" 6, .buy "cylinder" 2, .buy "valve" 1, .buy "hose" 6,
   .buy "fitting" 8, .buy "bar50" 1, .buy "wire" 3, .make "cebpress"] ++
  [.buy "fuel" 300, .work "brick" 40] ++
  [.buy "tube4" 8, .buy "plate6" 3, .buy "motor" 1, .buy "hose" 4, .buy "fitting" 4,
   .buy "bolt" 40, .buy "nut" 40, .buy "wire" 3, .make "sawmill"] ++
  [.work "lumber" 6] ++
  [.buy "plate6" 4, .buy "bolt" 60, .buy "nut" 60, .buy "paint" 12, .buy "electrical" 2,
   .make "microhouse"]

/-- Where the whole game's playthrough ends. -/
def bigDemoEnd : Option St := run bigWorld start bigDemo

/-- **The big game is winnable too**: sixty-five moves put the microhouse in
the yard with 26 423.20 in hand, on day 78.375. -/
theorem big_demo_wins : bigDemoEnd.map (won homesteadPack) = some true := by decide

theorem big_demo_end : bigDemoEnd.map (fun s => (s.cash, s.day)) =
    some (26423200000, 78375000) := by decide

/-- A playthrough of the paste demo: ten tonnes of clay, a kiln, five batches
of pots. -/
def tinyDemo : List Act :=
  [.buy "clay" 10, .make "kiln", .work "pot" 5]

/-- Where the paste demo's playthrough ends. -/
def tinyDemoEnd : Option St := run tinyWorld start tinyDemo

/-- **The tiny pack is winnable too**, in three moves. -/
theorem tiny_demo_wins : tinyDemoEnd.map (won tinyPack) = some true := by decide

theorem tiny_demo_end : tinyDemoEnd.map (fun s => (s.cash, s.day)) =
    some (15050000000, 2250000) := by decide

/-- A playthrough of the water pack: buy the glass, wood, leather, mirror and
pasteboard, build the eleven modules, assemble the controller, print ten plates
with it, and take two market days weaving card stacks to sell. -/
def waterDemo : List Act :=
  [.buy "glasstube" 142, .buy "timber" 116, .buy "leathersheet" 78,
   .buy "mirrorglass" 12, .buy "water" 21, .buy "cardbox" 10] ++
  List.replicate 12 (.make "gatetray") ++
  List.replicate 4 (.make "latchbank") ++
  [.make "siphonclock", .make "headtank", .make "solarlift", .make "pond",
   .make "loomreader", .make "cardpunch", .make "cardstack",
   .make "heliostat", .make "heliostat", .make "watercomputer"] ++
  [.work "printplate" 10] ++
  [.buy "cardbox" 20, .work "memestall" 2]

/-- Where the water playthrough ends. -/
def waterDemoEnd : Option St := run waterWorld start waterDemo

/-- **The water game is winnable**, and this is a winning line. -/
theorem water_demo_wins : waterDemoEnd.map (won waterPack) = some true := by decide

/-- What the water playthrough ends with: 13 852 in hand on day 24.25, after
thirty-five moves. -/
theorem water_demo_end : waterDemoEnd.map (fun s => (s.cash, s.day)) =
    some (13852000000, 24250000) := by decide

/-! ## The stall in the big game -/

/-- Every pack of the big build, with the water stall in it: the stall is
loaded before the homestead, so the microhouse is still what the big game is
played for. -/
def maxPacks : List Pack := [corePack, workshopPack, farmPack, waterPack, homesteadPack]

/-- The catalogue of the biggest build. -/
def maxWorld : World := worldOf maxPacks

theorem maxWorld_consistent : Consistent maxWorld = true := by decide

theorem maxWorld_priced : Priced maxWorld = true := by decide

/-- Where the homestead playthrough ends when the stall is on the market too. -/
def maxDemoEnd : Option St := run maxWorld start bigDemo

/-- **Adding the stall does not break the big game**: the sixty-five move line
still wins it. -/
theorem max_demo_wins : maxDemoEnd.map (won homesteadPack) = some true := by decide

end Modular
end LifeTrac
