import RequestProject.Gvcs.Water.Cards

/-!
# The market stall: modules, priced

What is actually for sale is not a machine, it is a **kit of modules** and a
**stack of cards**: a tray of sixteen water gates, a bank of latches, a siphon
clock, a head tank, a solar lift, a card punch, a loom reader — and the chain
of pasteboard that tells them what to build.  This file is the price list, and
the arithmetic on it.

* `Module`, `price`, `pitch` — the eleven things on the stall, each with a
  price in millionths and a one-line pitch.
* `gateTrays` — 1 200 gates at a hundred to a rack is 12 racks
  (`gateTrays_eq`), which is what makes the kit's price what it is.
* `kitPrice` — the whole water-and-sun controller, 4 309.21, against 1 000.00
  for a silicon board plus 5 500.00 of grid connection and inverter it needs
  (`kit_beats_grid`).
* `resale`, `resale_le_price`, `kit_resale_margin` — the stall buys modules
  back at three fifths, so a kit can be flipped, and the flipper's loss is
  bounded.
-/

namespace LifeTrac
namespace Water

open Steampunk (Part)

/-! ## The stall -/

/-- A thing on the stall. -/
inductive Module where
  /-- A rack of a hundred water NAND gates, plumbed and tested. -/
  | gateTray
  /-- A bank of eight tipping-bucket latch cells. -/
  | latchBank
  /-- The siphon clock that beats the whole deck. -/
  | siphonClock
  /-- The head tank and its two-metre stand. -/
  | headTank
  /-- The glazed solar collector and thermosiphon pump. -/
  | solarLift
  /-- The pond, lined and screened. -/
  | pond
  /-- The Jacquard card reader: needles, comber board, cylinder. -/
  | loomReader
  /-- The hand punch that makes cards. -/
  | cardPunchPress
  /-- A hundred blank cards. -/
  | cardBox
  /-- The printer's own program, laced: 910 cards. -/
  | printerCardStack
  /-- The aiming mirror and its wooden heliostat frame. -/
  | heliostat
  deriving DecidableEq, Repr

namespace Module

/-- Everything on the stall, in catalogue order. -/
def all : List Module :=
  [gateTray, latchBank, siphonClock, headTank, solarLift, pond, loomReader,
   cardPunchPress, cardBox, printerCardStack, heliostat]

/-- The stall's short key for a module — also the key it has in the game. -/
def key : Module → String
  | gateTray => "gatetray"
  | latchBank => "latchbank"
  | siphonClock => "siphonclock"
  | headTank => "headtank"
  | solarLift => "solarlift"
  | pond => "pond"
  | loomReader => "loomreader"
  | cardPunchPress => "cardpunch"
  | cardBox => "cardbox"
  | printerCardStack => "cardstack"
  | heliostat => "heliostat"

/-- What the stall calls it. -/
def name : Module → String
  | gateTray => "rack of 100 water NAND gates"
  | latchBank => "bank of 8 tipping-bucket latches"
  | siphonClock => "siphon clock"
  | headTank => "head tank on a two metre stand"
  | solarLift => "solar collector and thermosiphon pump"
  | pond => "lined pond and screen"
  | loomReader => "Jacquard card reader"
  | cardPunchPress => "hand card punch"
  | cardBox => "box of 100 blank cards"
  | printerCardStack => "the printer's program, 910 cards laced"
  | heliostat => "aiming mirror on a heliostat frame"

/-- The pitch that goes on the card pinned to it. -/
def pitch : Module → String
  | gateTray => "a hundred gates, no fab, runs on a puddle"
  | latchBank => "it remembers, and it is made of buckets"
  | siphonClock => "the only oscillator you can drink from"
  | headTank => "two metres of gravity is your power supply"
  | solarLift => "the sun does the pumping, you do nothing"
  | pond => "your ground plane, with frogs in it"
  | loomReader => "1804 called, it brought your program counter"
  | cardPunchPress => "compile by hand, ship by post"
  | cardBox => "blank media, still readable in 200 years"
  | printerCardStack => "the printer prints itself, off pasteboard"
  | heliostat => "aim it once a season, it aims itself all day"

/-- The price, in millionths of a unit of account. -/
def price : Module → Int
  | gateTray => 175000000
  | latchBank => 34000000
  | siphonClock => 55000000
  | headTank => 240000000
  | solarLift => 620000000
  | pond => 180000000
  | loomReader => 310000000
  | cardPunchPress => 145000000
  | cardBox => 12000000
  | printerCardStack => printerStackPrice
  | heliostat => 95000000

/-- What the stall pays to take one back: three fifths. -/
def resale (m : Module) : Int := 3 * m.price / 5

/-- Nothing on the stall is worth more second hand than new. -/
theorem resale_le_price : ∀ m ∈ all, resale m ≤ price m := by decide

/-- And nothing is worthless: every module has a buy-back bid. -/
theorem resale_pos : ∀ m ∈ all, 0 < resale m := by decide

end Module

/-! ## The kit -/

/-- Gates to a rack. -/
def gatesPerTray : ℕ := 100

/-- Racks needed for the controller's 1 200 gates, rounding up. -/
def gateTrays : ℕ := (controllerValves + gatesPerTray - 1) / gatesPerTray

theorem gateTrays_eq : gateTrays = 12 := by decide

/-- The kit that makes one water-and-sun controller: the trays, the latch
banks, the clock, the water works, the reader and the program. -/
def kit : List (Module × ℕ) :=
  [ (.gateTray, gateTrays)
  , (.latchBank, 4)
  , (.siphonClock, 1)
  , (.headTank, 1)
  , (.solarLift, 1)
  , (.pond, 1)
  , (.loomReader, 1)
  , (.cardPunchPress, 1)
  , (.cardBox, 10)
  , (.printerCardStack, 1)
  , (.heliostat, 2) ]

/-- The price of a list of modules with quantities. -/
def bundlePrice (b : List (Module × ℕ)) : Int :=
  (b.map (fun mq => mq.1.price * (mq.2 : Int))).sum

/-- The price of the whole kit. -/
def kitPrice : Int := bundlePrice kit

/-- **4 309.21 for a controller that has never seen a fab.** -/
theorem kitPrice_eq : kitPrice = 4309210000 := by decide

/-- What the silicon route really costs the same shop: the board, plus the grid
connection, the inverter and the surge protection it cannot run without. -/
def gridRoutePrice : Int := boughtControllerPrice + 5500000000

/-- **The kit is cheaper than the wire from the road.** -/
theorem kit_beats_grid : kitPrice < gridRoutePrice := by decide

/-- The stall's buy-back on the whole kit. -/
def kitResale : Int := (kit.map (fun mq => mq.1.resale * (mq.2 : Int))).sum

/-- A kit can be sold back, and the flip costs under two fifths of what it cost
to buy: this is a market for memes, but not a market for suckers. -/
theorem kit_resale_margin : 5 * kitResale ≥ 2 * kitPrice := by decide

theorem kitResale_le_kitPrice : kitResale ≤ kitPrice := by decide

/-! ## The stall in text -/

/-- One line of the price list. -/
def listingLine (m : Module) : String :=
  m.key ++ " | " ++ m.name ++ " | " ++ toString (m.price / 1000000) ++ " | " ++ m.pitch

/-- The price list. -/
def listing : List String := Module.all.map listingLine

theorem listing_length : listing.length = 11 := by decide

end Water
end LifeTrac
