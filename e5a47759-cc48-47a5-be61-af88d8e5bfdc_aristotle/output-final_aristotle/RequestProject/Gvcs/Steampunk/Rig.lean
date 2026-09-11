import RequestProject.Gvcs.Steampunk.Jacquard
import RequestProject.Gvcs.Steampunk.Heat
import RequestProject.Gvcs.Steampunk.Stonehenge
import RequestProject.Gvcs.Printer.SelfRep

/-!
# The answer: a steam-and-ice 3D printer with no silicon in it

This file puts the pieces together and states, as one theorem, what the rest of
`RequestProject/Steampunk/` adds up to.

**The question.**  Can the 3D printer of `RequestProject/Printer/` — the
machine that `RequestProject/GVCSEcology.lean` singles out as the one that
opens the whole Global Village Construction Set — be built and run without
semiconductors, on steam, ice, wood gas and sunlight?

**The obstruction.**  It cannot be built as specified: the bill of materials in
`RequestProject/Printer/SelfRep.lean` contains a controller board, five stepper
drivers and a switch-mode power supply, and `bill_needs_semiconductors` says so.

**The substitution.**  Take those lines out and put back a boiler and engine, a
fluidic valve gate array, a Jacquard card reader, an ice condenser and a
mirror field.  That is `steamBill`, and `steamBill_semiconductor_free` says
nothing left in it is a semiconductor.  It is heavier — `steam_is_heavier`
puts the machine at over forty times the mass of the electric one, most of it
boiler, ice chest and stone.

**The capstone.**  `steampunk_printer_without_silicon` collects, in one
statement, everything that has been proved about the substituted machine:

1. any control law the machine needs is a plumbing diagram (`fluidic_complete`);
2. its program — the *actual* 910-instruction self-print job — goes onto
   punched cards, through the loom and back unchanged;
3. the mechanics still print the printer's own six plastic parts, faultlessly,
   in 3835 ticks (this is the interpreter of `Printer/Machine.lean`, unchanged);
4. one plate costs between 1.1 and 1.2 kg of dry wood, or nine mirrors of
   sunlight, and melts between 32 and 33 kg of ice;
5. and no part of the bill is made of semiconductor.

**What is taken on trust** is listed explicitly in `statedAssumptions`, and it
is not a short list.  In particular: that fluidic gates switch fast enough for
the toolpath clock, that a steam-driven gantry holds the one-cell positional
tolerance the voxel model assumes, that a non-electronic thermostat holds the
hot end at 205 °C, and that ice is at hand.  None of that is proved here, and
the honest answer to the question is therefore *yes on the logic, the program
store, the energy budget and the bill of materials; not yet on the mechanics
and the control loop's dynamics*.
-/

namespace LifeTrac
namespace Steampunk

open LifeTrac.Printer

/-! ## The electric machine is not silicon-free -/

/-- Which lines of the printer's bill of materials need a semiconductor fab. -/
def electronic (p : Piece) : Bool :=
  p.name == "controller board" || p.name == "stepper driver" || p.name == "power supply"

/-- **The printer as specified needs silicon.** -/
theorem bill_needs_semiconductors : ∃ p ∈ bill, electronic p = true := by
  refine ⟨⟨"controller board", 1, 90, false⟩, ?_, by decide⟩
  decide

/-! ## The substitution -/

/-- What replaces what. -/
def steamSubstitutions : List (String × String) :=
  [ ("controller board", "fluidic valve gate array")
  , ("stepper driver", "pilot valve manifold")
  , ("power supply", "wood-gas boiler and steam engine")
  , ("wiring harness", "signal tubing loom")
  , ("heated bed", "steam-heated platen")
  , ("NEMA 17 stepper motor", "ratchet-and-cam axis drive off the engine") ]

theorem steamSubstitutions_count : steamSubstitutions.length = 6 := by decide

/-- The vitamins that survive the substitution: everything purely mechanical.
A stepper motor goes too — without its driver it is scrap — and its place is
taken by a ratchet drive off the engine shaft. -/
def keptVitamins : List Piece :=
  [ ⟨"8 mm smooth rod", 6, 160, false⟩,
    ⟨"lead screw", 3, 200, false⟩,
    ⟨"linear bearing", 12, 25, false⟩,
    ⟨"hot end", 1, 100, false⟩,
    ⟨"belt, per metre", 3, 30, false⟩,
    ⟨"pulley", 3, 15, false⟩,
    ⟨"fasteners", 1, 400, false⟩ ]

/-- And that list is exactly the bill's vitamins with the substituted lines
struck out. -/
theorem keptVitamins_eq_filter :
    keptVitamins = vitaminPieces.filter (fun p => !electronic p
      && p.name != "wiring harness" && p.name != "heated bed"
      && p.name != "NEMA 17 stepper motor") := by
  decide

/-- The new hardware: engine, condenser, controller, program store, mirrors and
a stone calendar to know when the sun will serve. -/
def steamPieces : List Piece :=
  [ ⟨"wood-gas gasifier", 1, 30000, false⟩,
    ⟨"boiler", 1, 60000, false⟩,
    ⟨"steam engine", 1, 25000, false⟩,
    ⟨"ice condenser", 1, 20000, false⟩,
    ⟨"ice, per plate printed", 33, 1000, false⟩,
    ⟨"heliostat mirror", 9, 4000, false⟩,
    ⟨"fluidic valve", 200, 120, false⟩,
    ⟨"signal tubing, per metre", 60, 40, false⟩,
    ⟨"Jacquard card reader", 1, 15000, false⟩,
    ⟨"punched card", 910, 3, false⟩,
    ⟨"steam-heated platen", 1, 4000, false⟩,
    ⟨"ratchet-and-cam axis drive", 3, 8000, false⟩,
    ⟨"stone calendar ring", 1, 50000, false⟩ ]

/-- The whole steam machine. -/
def steamBill : List Piece := printedPieces ++ keptVitamins ++ steamPieces

/-- **Nothing in the steam machine is a semiconductor.** -/
theorem steamBill_semiconductor_free : ∀ p ∈ steamBill, electronic p = false := by
  decide

/-- The steam machine keeps every mechanical vitamin the electric one had. -/
theorem keptVitamins_count : keptVitamins.length = 7 := by decide

/-- The plastic parts are unchanged: the printer still prints its own six. -/
theorem printedPieces_unchanged : steamBill.take printedPieces.length = printedPieces := by
  decide

/-- **It is a much heavier machine.**  Boiler, ice, mirrors and stone put the
steam printer at more than forty times the mass of the electric one. -/
theorem steam_is_heavier : 40 * mass bill < mass steamBill := by
  norm_num [mass, bill, steamBill, printedPieces, vitaminPieces, keptVitamins, steamPieces]

/-! ## The program store, concretely

The loom of `RequestProject/Steampunk/Jacquard.lean` needs an onto comber
board.  The simplest one — one warp thread per needle — is onto, so the
roundtrip theorem applies with no hypotheses left over. -/

/-- One warp thread per hole position. -/
def plainLoom : Loom := ⟨cardWidth, cardWidth, id⟩

theorem plainLoom_surjective : Function.Surjective (id : Fin cardWidth → Fin cardWidth) :=
  Function.surjective_id

/-- **The machine's own program, punched, woven and read back.** -/
theorem selfPrint_cards_roundtrip :
    jobOf ((Loom.mk cardWidth cardWidth id).punch plainLoom_surjective
        ((Loom.mk cardWidth cardWidth id).weave (chainOf (job d3d 205 printerParts)))) =
      some (job d3d 205 printerParts) :=
  selfPrint_jacquard_roundtrip id plainLoom_surjective

/-! ## The capstone -/

/-- **A steam-and-ice printer with no silicon in it.**  Everything proved about
the substituted machine, in one statement: a complete control substrate, the
actual self-print job on 910 punched cards surviving the loom, the print itself
running faultless in 3835 ticks and leaving exactly the six parts, a wood
budget, a mirror count and an ice budget for that run, and a bill of materials
with no semiconductor in it. -/
theorem steampunk_printer_without_silicon :
    (∀ (n : ℕ) (f : (Fin n → Bool) → Bool), ∃ c : FCirc n, ∀ x, c.eval x = f x) ∧
    (chainOf (job d3d 205 printerParts)).length = 910 ∧
    jobOf ((Loom.mk cardWidth cardWidth id).punch plainLoom_surjective
        ((Loom.mk cardWidth cardWidth id).weave (chainOf (job d3d 205 printerParts)))) =
      some (job d3d 205 printerParts) ∧
    ((run d3d (job d3d 205 printerParts) (State.init 20)).fault = none ∧
      (run d3d (job d3d 205 printerParts) (State.init 20)).filament = 908 ∧
      (run d3d (job d3d 205 printerParts) (State.init 20)).clock = 3835) ∧
    (1.1 < villageFuel.woodFor printEnergy ∧ villageFuel.woodFor printEnergy < 1.2) ∧
    (villageSun.shaftPower 8 < printerPower ∧ printerPower ≤ villageSun.shaftPower 9) ∧
    (32 < iceMelted (villageFuel.rejectedFor printEnergy) ∧
      iceMelted (villageFuel.rejectedFor printEnergy) < 33) ∧
    (∀ p ∈ steamBill, electronic p = false) := by
  obtain ⟨hf, _, hfil, _, hclock⟩ := selfPrint
  exact ⟨fluidic_complete, selfPrint_chain_length, selfPrint_cards_roundtrip,
    ⟨hf, hfil, hclock⟩, wood_for_print_bounds, mirrors_suffice, ice_for_print_bounds,
    steamBill_semiconductor_free⟩

/-! ## What is taken on trust -/

/-- The assumptions the answer rests on, named.  None of these is proved
anywhere in this project. -/
def statedAssumptions : List String :=
  [ "fluidic valves switch fast enough to keep up with the toolpath clock"
  , "a steam-driven gantry holds the one-cell positional tolerance the voxel model assumes"
  , "a non-electronic thermostat holds the hot end at 205 °C without overshoot"
  , "the hot end, rods, bearings and lead screws are sourced, not printed"
  , "ice, or a means of making it, is at hand in the quantities of ice_for_print_bounds"
  , "the wood is dry and the gasifier reaches its rated cold-gas efficiency"
  , "the mirrors track the sun, each satisfying the aiming law heliostat_aims"
  , "filament stock is available; this project does not make plastic" ]

theorem statedAssumptions_count : statedAssumptions.length = 8 := by decide

end Steampunk
end LifeTrac
