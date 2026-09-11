import RequestProject.Gvcs.Printer.SelfPrint
import RequestProject.Gvcs.GVCSEcology

/-!
# Bootstrapping a fleet: how far self-replication actually goes

`RequestProject/Printer/SelfPrint.lean` has the printer print its own plastic
parts.  This file asks the next question: if a printer can print its own
plastic, can a printer make a printer, and how fast does a fleet grow?

Two things are modelled.

**The bill of materials** (`bill`).  A D3D-style printer, split into the pieces
that come off a printer's bed and the *vitamins* — motors, rods, bearings, hot
end, board, drivers, power supply, belts, pulleys, fasteners, wiring, heated
bed — that do not.  The masses and counts below are this file's own modelling
assumptions, not measurements: they are stated so the arithmetic that follows
is checkable, and every number reported about them is derived, not asserted.
Print time is taken at a deposition rate of 30 g per hour (`printMinutes`).

The two models here and in `SelfPrint.lean` are at different granularities and
are not meant to reproduce one another: the voxel plate of `SelfPrint.lean` is
a coarse 10 mm-cell picture of the parts, printed in 3835 ticks of machine
time, while the hours below come from the mass bill at 30 g an hour.  The
geometry says what the printer *does*; the bill says what a printer *is made
of*.

**The fleet** (`Fleet`, `gen`).  A generation is one round in which every
printer in the fleet prints one full set of plastic parts, and each set is
married to one vitamin kit to become a new printer.  `gen` executes a round.

The results:

* `printedMass_eq`, `vitaminMass_eq` — 1475 g of printed plastic against
  5885 g of vitamins, so `printed_between_fifth_and_quarter`: a printer is
  between a fifth and a quarter of itself by mass;
* `printHours_eq` — 49 hours 10 minutes of printing for one set of plastic;
* `fleet_doubles` — with kits on the shelf the fleet doubles every generation,
  `fleet_pow` gives 2ⁿ printers after n rounds and `fleet_fifty` reaches fifty
  in six;
* `gen_conserves` and `fleet_le_kits` — **and that is the hard limit**: the
  number of printers can never exceed the seed printers plus the vitamin kits
  supplied from outside.  Printing plastic does not make motors, so a printer
  is not a self-replicator; it is an amplifier of a supply of vitamins.
* `keystone_and_its_limit` puts that beside the result of
  `RequestProject/GVCSEcology.lean` that the printer is the machine which opens
  the whole Global Village Construction Set.
-/

namespace LifeTrac
namespace Printer

/-! ## The bill of materials -/

/-- One line of the bill: how many, how heavy each, and whether a printer can
make it. -/
structure Piece where
  /-- What the piece is. -/
  name : String
  /-- How many of them one printer needs. -/
  count : ℕ
  /-- The mass of one, in grams. -/
  grams : ℚ
  /-- Can a 3D printer make it? -/
  printable : Bool
  deriving DecidableEq, Repr

/-- The plastic parts, the ones a printer prints. -/
def printedPieces : List Piece :=
  [ ⟨"axis motor mount", 3, 90, true⟩,
    ⟨"axis idler end", 3, 75, true⟩,
    ⟨"carriage", 3, 60, true⟩,
    ⟨"belt clamp", 6, 10, true⟩,
    ⟨"extruder body", 1, 85, true⟩,
    ⟨"fan duct", 1, 25, true⟩,
    ⟨"spool holder", 1, 120, true⟩,
    ⟨"electronics case", 1, 150, true⟩,
    ⟨"corner bracket", 8, 45, true⟩ ]

/-- The vitamins: everything a printer cannot make. -/
def vitaminPieces : List Piece :=
  [ ⟨"NEMA 17 stepper motor", 5, 280, false⟩,
    ⟨"8 mm smooth rod", 6, 160, false⟩,
    ⟨"lead screw", 3, 200, false⟩,
    ⟨"linear bearing", 12, 25, false⟩,
    ⟨"hot end", 1, 100, false⟩,
    ⟨"controller board", 1, 90, false⟩,
    ⟨"stepper driver", 5, 10, false⟩,
    ⟨"power supply", 1, 700, false⟩,
    ⟨"belt, per metre", 3, 30, false⟩,
    ⟨"pulley", 3, 15, false⟩,
    ⟨"fasteners", 1, 400, false⟩,
    ⟨"wiring harness", 1, 250, false⟩,
    ⟨"heated bed", 1, 900, false⟩ ]

/-- The whole printer. -/
def bill : List Piece := printedPieces ++ vitaminPieces

/-- The mass of a list of lines, in grams. -/
def mass (l : List Piece) : ℚ := (l.map fun p => (p.count : ℚ) * p.grams).sum

/-- How many pieces a list of lines is. -/
def pieces (l : List Piece) : ℕ := (l.map Piece.count).sum

/-- Printing runs at 30 g an hour, so two minutes a gram. -/
def printMinutes (l : List Piece) : ℚ := 2 * mass l

/-! ### What the bill says -/

/-- The plastic in one printer masses 1475 g. -/
theorem printedMass_eq : mass printedPieces = 1475 := by
  simp [mass, printedPieces]; norm_num

/-- The vitamins mass 5885 g. -/
theorem vitaminMass_eq : mass vitaminPieces = 5885 := by
  simp [mass, vitaminPieces]; norm_num

/-- A printer masses 7360 g. -/
theorem billMass_eq : mass bill = 7360 := by
  simp [mass, bill, printedPieces, vitaminPieces]; norm_num

/-- Twenty-seven printed pieces … -/
theorem printedPieces_count : pieces printedPieces = 27 := by decide

/-- … and forty-three vitamins. -/
theorem vitaminPieces_count : pieces vitaminPieces = 43 := by decide

/-- **A printer is between a fifth and a quarter of itself.**  Four times the
printed plastic is less than a whole printer, five times is more. -/
theorem printed_between_fifth_and_quarter :
    4 * mass printedPieces < mass bill ∧ mass bill < 5 * mass printedPieces := by
  rw [printedMass_eq, billMass_eq]
  constructor <;> norm_num

/-- The vitamins outweigh the plastic three to one. -/
theorem vitamins_outweigh_plastic : 3 * mass printedPieces < mass vitaminPieces := by
  rw [printedMass_eq, vitaminMass_eq]; norm_num

/-- **One set of plastic is 49 hours 10 minutes of printing.** -/
theorem printHours_eq : printMinutes printedPieces / 60 = 295 / 6 := by
  rw [printMinutes, printedMass_eq]; norm_num

theorem printHours_bounds :
    49 < printMinutes printedPieces / 60 ∧ printMinutes printedPieces / 60 < 50 := by
  rw [printHours_eq]; constructor <;> norm_num

/-- **The printer cannot make all of itself.**  Some line of the bill — the
stepper motors, for one — is not printable. -/
theorem bill_not_all_printable : ∃ p ∈ bill, p.printable = false := by
  refine ⟨⟨"NEMA 17 stepper motor", 5, 280, false⟩, ?_, rfl⟩
  simp [bill, vitaminPieces]

/-! ## A fleet of printers over the generations -/

/-- Hours of printing in one generation: one full set of plastic parts. -/
def setHours : ℚ := printMinutes printedPieces / 60

/-- A fleet: printers in service, vitamin kits on the shelf, hours elapsed. -/
structure Fleet where
  /-- Printers in service. -/
  printers : ℕ
  /-- Vitamin kits in stock, each enough for one new printer. -/
  kits : ℕ
  /-- Hours elapsed. -/
  hours : ℚ
  deriving DecidableEq, Repr

/-- One generation: every printer prints a set of plastic parts, and every set
that finds a vitamin kit becomes a printer. -/
def gen (f : Fleet) : Fleet :=
  { printers := f.printers + min f.printers f.kits,
    kits := f.kits - min f.printers f.kits,
    hours := f.hours + setHours }

/-- With a kit for every printer, the fleet doubles. -/
theorem gen_doubles {f : Fleet} (h : f.printers ≤ f.kits) :
    (gen f).printers = 2 * f.printers := by
  simp [gen, min_eq_left h]; omega

/-- **Printers plus kits is constant.**  A generation turns kits into printers
one for one; it creates neither. -/
theorem gen_conserves (f : Fleet) : (gen f).printers + (gen f).kits = f.printers + f.kits := by
  have h : min f.printers f.kits ≤ f.kits := min_le_right _ _
  simp only [gen]
  omega

/-- **The hard limit on a fleet.**  However many generations are run, the
number of printers never exceeds the printers you started with plus the vitamin
kits you brought in.  A 3D printer is not a self-replicator: it is an amplifier
of a supply of motors, rods and electronics. -/
theorem fleet_le_kits (f : Fleet) (n : ℕ) :
    (gen^[n] f).printers ≤ f.printers + f.kits := by
  have key : ∀ n : ℕ, (gen^[n] f).printers + (gen^[n] f).kits = f.printers + f.kits := by
    intro n
    induction n with
    | zero => rfl
    | succ n ih => rw [Function.iterate_succ_apply', gen_conserves]; exact ih
  have := key n
  omega

/-- The state of a fleet that starts as one printer and `k` kits, after `n`
generations, as long as the kits hold out. -/
theorem fleet_pow (k n : ℕ) (h : 2 ^ n ≤ k + 1) :
    gen^[n] ⟨1, k, 0⟩ = ⟨2 ^ n, k + 1 - 2 ^ n, n * setHours⟩ := by
  induction n with
  | zero => simp
  | succ n ih =>
      have hmono : 2 ^ n ≤ 2 ^ (n + 1) := Nat.pow_le_pow_right (by norm_num) (by omega)
      have hn : 2 ^ n ≤ k + 1 := le_trans hmono h
      rw [Function.iterate_succ_apply', ih hn]
      have hpow : 2 ^ (n + 1) = 2 ^ n + 2 ^ n := by ring
      have hmin : min (2 ^ n) (k + 1 - 2 ^ n) = 2 ^ n := by omega
      simp only [gen, hmin, Fleet.mk.injEq]
      refine ⟨by omega, by omega, ?_⟩
      push_cast
      ring

/-- **Six generations make fifty printers** — sixty-four, in fact — out of one
printer and sixty-three vitamin kits, in 295 hours of printing. -/
theorem fleet_fifty :
    (gen^[6] ⟨1, 63, 0⟩).printers = 64 ∧ 50 ≤ (gen^[6] ⟨1, 63, 0⟩).printers ∧
      (gen^[6] ⟨1, 63, 0⟩).hours = 295 := by
  rw [fleet_pow 63 6 (by norm_num)]
  refine ⟨by norm_num, by norm_num, ?_⟩
  simp only [setHours, printMinutes, printedMass_eq]
  norm_num

/-- And those sixty-three kits are 370.7 kg of motors, rods and electronics
that no printer made. -/
theorem fleet_fifty_vitamin_mass : 63 * mass vitaminPieces = 370755 := by
  rw [vitaminMass_eq]; norm_num

/-! ## Plate after plate, on the machine itself

The fleet above counts generations; this counts what the interpreter of
`RequestProject/Printer/SelfPrint.lean` actually does, plate after plate. -/

/-- The machine time to print `k` plates of the printer's own parts, each from
a fresh bed. -/
def batchTicks : ℕ → ℕ
  | 0 => 0
  | k + 1 => batchTicks k + (run d3d (job d3d 205 printerParts) (State.init 20)).clock

/-- **Every plate costs the same.**  Printing `k` plates of parts takes
`k × 3835` ticks on the machine — the figure the interpreter produces for one
plate, `k` times over. -/
theorem batchTicks_eq (k : ℕ) : batchTicks k = k * 3835 := by
  induction k with
  | zero => rfl
  | succ k ih =>
      rw [batchTicks, ih, selfPrint.2.2.2.2]
      ring

/-- The sixty-three plates that turn one printer into sixty-four are 241605
ticks of machine time in all — but only six plates deep, so six plate-times of
waiting if the fleet prints in parallel. -/
theorem batchTicks_sixtyThree : batchTicks 63 = 241605 ∧ batchTicks 6 = 23010 := by
  rw [batchTicks_eq, batchTicks_eq]
  exact ⟨by norm_num, by norm_num⟩

/-! ## The keystone and its limit -/

/-- **What the printer is, and what it is not.**  It is the machine that opens
the Global Village Construction Set: given the twenty-six machines the wiki
leaves undocumented and one 3D printer, four rounds of building produce all
fifty (`GVCS.printer_seed_completes`).  And it prints under a quarter of itself
by mass, so a fleet of printers can never outnumber the vitamin kits carried in
from outside. -/
theorem keystone_and_its_limit :
    (∀ m : GVCS.Machine, m ∈ GVCS.buildClosure (GVCS.Machine.printer3D :: GVCS.undocumentedSeed) 4) ∧
    4 * mass printedPieces < mass bill ∧
    (∀ (f : Fleet) (n : ℕ), (gen^[n] f).printers ≤ f.printers + f.kits) :=
  ⟨GVCS.printer_seed_completes, printed_between_fifth_and_quarter.1, fleet_le_kits⟩

end Printer
end LifeTrac
