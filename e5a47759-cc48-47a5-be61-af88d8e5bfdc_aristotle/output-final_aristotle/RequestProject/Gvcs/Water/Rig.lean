import RequestProject.Gvcs.Water.Teams
import RequestProject.Gvcs.Steampunk.Rig

/-!
# The capstone: a printer run by water and sun, with no silicon in it

Everything the rest of `RequestProject/Water/` establishes, in one statement.

`water_sun_printer_without_silicon` bundles:

1. **The logic.**  Every finite-state control law is a bounded network of water
   NAND gates and tipping-bucket latches (`water_computes_any_controller`).
2. **The program.**  The printer's own self-print job is 910 punched cards, and
   the chain survives punch → weave → re-punch on a plain loom, so a shop can
   copy its program instead of buying one.
3. **The print.**  That job runs faultless in 3 835 ticks and lays down exactly
   908 cells — the result the printer model already gives.
4. **The energy.**  One sunny day on four square metres lifts fifty-seven
   prints' worth of head, and the pond loses under ten litres a print.
5. **The bill.**  Not one part of the gate deck, the power station, the reader
   or the card stack is a semiconductor, and nothing is burned.
6. **The price.**  The kit is 4 309.21 against 6 500.00 for the silicon route
   with its grid connection.
7. **The search.**  And this design is the optimum of the space the four teams
   of `Water/Teams.lean` search.

`statedAssumptions` lists what is *not* proved: eight items, all of them about
physics, weather and mechanics rather than about logic or arithmetic.
-/

namespace LifeTrac
namespace Water

open Steampunk
open LifeTrac.Printer
open Voxel

/-! ## The bill of the rig -/

/-- The card reader: needles, comber board, cylinder, and the griffe. -/
def loomReaderParts : List Part :=
  [ ⟨"needle", .bronze, 71⟩
  , ⟨"comber board", .hardwood, 1⟩
  , ⟨"card cylinder", .hardwood, 1⟩
  , ⟨"griffe bar", .bronze, 2⟩
  , ⟨"return spring", .steel, 71⟩ ]

/-- The card stack itself: pasteboard, laced. -/
def cardStackParts : List Part :=
  [ ⟨"punched card", .pasteboard, 910⟩
  , ⟨"lacing cord", .leather, 2⟩
  , ⟨"end board", .hardwood, 2⟩ ]

/-- Everything in the water-and-sun controller: the gate deck, the power
station, the reader and the program. -/
def waterRigParts : List Part :=
  waterGateParts ++ solarLiftParts ++ loomReaderParts ++ cardStackParts

/-- **No semiconductor anywhere in the rig.** -/
theorem waterRigParts_semiconductor_free :
    ∀ p ∈ waterRigParts, p.mat.semiconductor = false := by decide

/-- The rig's part count, per gate deck: 1 091 pieces, of which 910 are
cards. -/
theorem waterRigParts_qty : (waterRigParts.map Part.qty).sum = 1091 := by decide

/-- The unmodified printer's own bill of materials, by contrast, does need a
fab: that is `Steampunk.bill_needs_semiconductors`. -/
theorem printer_bill_needs_fab : ∃ p ∈ bill, electronic p = true :=
  bill_needs_semiconductors

/-! ## The capstone -/

/-- **A 3D printer computed by water and powered by the sun, with no silicon
in it.**  Logic, program store, the print itself, the energy budget, the bill
of materials, the price and the design search, in one statement. -/
theorem water_sun_printer_without_silicon :
    -- 1. every control law is water plumbing, of bounded size
    (∀ (n s : ℕ) (f : (Fin n → Bool) → (Fin s → Bool) → (Fin s → Bool))
        (q0 : Fin s → Bool), ∃ M : WMachine n s,
        M.valves ≤ s * (4 * 2 ^ (n + s)) ∧ ∀ xs, M.run xs = iterate f q0 xs) ∧
    -- 2. the program is 910 cards, and the chain survives the loom
    (printerStack.length = 910 ∧
      jobOf ((Loom.mk cardWidth cardWidth id).punch plainLoom_surjective
          ((Loom.mk cardWidth cardWidth id).weave printerStack)) =
        some (job d3d 205 printerParts)) ∧
    -- 3. the print runs, faultless, in 3835 ticks, laying 908 cells
    ((run d3d (job d3d 205 printerParts) (State.init 20)).fault = none ∧
      (run d3d (job d3d 205 printerParts) (State.init 20)).filament = 908 ∧
      (run d3d (job d3d 205 printerParts) (State.init 20)).clock = 3835) ∧
    -- 4. the sun pays for the thinking, and the water comes back
    (57 * computeEnergy ≤ villageLift.energy ∧ makeupPerPrint ≤ 10) ∧
    -- 5. no semiconductor in the rig, and nothing burned
    ((∀ p ∈ waterRigParts, p.mat.semiconductor = false) ∧
      Consumable.fuel ∉ waterComputerConsumes) ∧
    -- 6. and it is cheaper than the silicon route
    (kitPrice < gridRoutePrice) ∧
    -- 7. and it is the best design in the space the teams searched
    (∀ d : Design, Design.fitness d ≤ Design.fitness waterSun) := by
  obtain ⟨hf, _, hfil, _, hclock⟩ := selfPrint
  exact ⟨fun n s f q0 => water_computes_any_controller n s f q0,
    ⟨printerStack_length, printerStack_roundtrip id plainLoom_surjective⟩,
    ⟨hf, hfil, hclock⟩,
    ⟨prints_per_sunny_day, pond_makeup_small⟩,
    ⟨waterRigParts_semiconductor_free, waterComputer_no_fuel⟩,
    kit_beats_grid,
    waterSun_is_optimal⟩

/-! ## What is taken on trust -/

/-- The assumptions the water-and-sun answer rests on.  None of these is
proved anywhere in this project. -/
def statedAssumptions : List String :=
  [ "water gates switch fast enough to keep four beats to a toolpath tick"
  , "capillary bores do not clog, and surface tension does not hold a gate shut"
  , "the pond does not freeze, and the shop does not run the deck in winter"
  , "the water is kept clean enough that algae do not foul the seats"
  , "the gantry, hot end, rods, bearings and screws are sourced or steam driven, not water logic"
  , "process heat for the hot end comes from the mirrors of Steampunk/Heat.lean, not from the lift"
  , "the collector sees 800 W/m2 for six hours on the day the plate is printed"
  , "filament stock is available; this project does not make plastic" ]

theorem statedAssumptions_count : statedAssumptions.length = 8 := by decide

end Water
end LifeTrac
