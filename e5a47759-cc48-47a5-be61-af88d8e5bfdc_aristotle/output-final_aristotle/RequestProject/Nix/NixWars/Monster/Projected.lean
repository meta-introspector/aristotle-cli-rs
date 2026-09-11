import RequestProject.Nix.NixWars.Monster.Project

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

/-!
# The game, projected into the irrep we start in

`Project.lean` says what projecting is; this file does it to the actual
development.  Everything in NixWars is a can (`Cans.parts Cans.nixwarsWorld` —
3529 of them, the board's cabinets and their fields, the 194 rows of the
Monster's table with their exponents, the opening position of the galaxy), and
each can is projected into `irrep3 = [71, 59, 47]` by taking a number modulo
each axis.

Two numbers to project by, and they behave very differently:

* **By atom number** (`atomCell`): the can's place in the enumeration of the
  world.  There are fewer cans than cells, so the projection separates them —
  `atomCell_inj` — and the world is populated with one can per occupied cell
  (`contents_atom`).  This is the projection the world is built from.
* **By what is written in the can** (`valueCell`): the numbers themselves.  These
  are mostly divisors of the order of the Monster, and `71`, `59` and `47` divide
  a great many of them, so the values pile up in the corners of the box — the
  3529 cans carry 227 distinct values but land in only 76 distinct cells
  (`valueCells_distinct_count`).  That collapse is the same phenomenon
  `Place.lean` records for the rows of the table.

The three counts — 3529 cans, 227 distinct values, 76 distinct value cells —
are settled by compiled evaluation (`native_decide`), because `Cans.parts` does
not reduce in the kernel; everything else here is a kernel proof.

Then the world moves: `shift` translates every can at once, and `transfer`
carries the whole population into another irrep — `[47, 71, 59]`, the same three
primes in another order and so the same `196883` cells differently addressed, or
`[71, 59, 47, 41]`, one dimension up, where `cell_of_refine` says a can's old
address is its new one divided by `41`.
-/

namespace NixWars

namespace Monster

namespace Irrep

/-! ## Everything in the game -/

/-- Everything in the game, as cans: the world can and everything anywhere
inside it. -/
def gameCans : List Cans.Can := Cans.parts Cans.nixwarsWorld

/-- How many cans there are in the game. -/
theorem gameCans_length : gameCans.length = 3529 := by native_decide

/-- The atoms of the game: every can, numbered by where it comes in the
enumeration of the world. -/
def gameAtoms : List (Nat × Cans.Can) := gameCans.zipIdx.map (fun p => (p.2, p.1))

theorem gameAtoms_length : gameAtoms.length = 3529 := by
  simp [gameAtoms, gameCans_length]

/-- The cell of the atom numbered `i`: its number modulo `71`, `59` and `47`. -/
def atomCell (i : Nat) : Nat := irrep3.cell i

/-- The cell the number written in a can projects to. -/
def valueCell (c : Cans.Can) : Nat := irrep3.cell c.value

/-! ## The world the atoms populate -/

/-- There is room for every atom of the game in the three-dimensional irrep. -/
theorem gameCans_length_lt : gameCans.length < irrep3.size := by
  rw [gameCans_length, irrep3_size]
  norm_num

/-- **Each cell is a different can.**  Distinct atoms of the game land in
distinct cells of `71 × 59 × 47`. -/
theorem atomCell_inj {i j : Nat} (hi : i < gameCans.length) (hj : j < gameCans.length)
    (h : atomCell i = atomCell j) : i = j :=
  cell_injOn irrep3_legit (lt_trans hi gameCans_length_lt) (lt_trans hj gameCans_length_lt) h

theorem atomCell_lt (i : Nat) : atomCell i < irrep3.size := cell_lt irrep3_legit.pos i

/-- The content array of the world: one slot per cell of `71 × 59 × 47`, holding
the atom projected into it. -/
def gameWorld : List (Option (Nat × Cans.Can)) := irrep3.contents Prod.fst gameAtoms

theorem gameWorld_length : gameWorld.length = irrep3.size :=
  contents_length irrep3 Prod.fst gameAtoms

/-- **What is written in the cans does not separate them.**  The 3529 cans carry
227 distinct numbers, but those numbers are mostly divisors of the order of the
Monster, so `71`, `59` and `47` divide many of them and the values land in only
76 distinct cells: projecting by value piles the world into the corners of the
box, which is why the world is built from the atom numbers instead. -/
theorem valueCells_distinct_count :
    ((gameCans.map valueCell).eraseDups.length,
      (gameCans.map Cans.Can.value).eraseDups.length) = (76, 227) := by
  native_decide

/-! ## Worked addresses -/

/-- The world can itself is the atom numbered `0`, and it sits in the corner. -/
theorem atom_zero : irrep3.coords 0 = [0, 0, 0] := by decide

/-- The last cell of the box is the far corner, and it belongs to the number
`196882`. -/
theorem atom_last : irrep3.coords 196882 = [70, 58, 46] := by decide

theorem cell_last : irrep3.cell 196882 = 196882 := by decide

/-- The three-dimensional grid wraps: the can numbered `196883` is back at the
origin, on top of the can numbered `0`. -/
theorem cell_wraps : irrep3.cell 196883 = irrep3.cell 0 := by decide

/-- A worked atom: number `1234` has residues `27`, `54`, `12`. -/
theorem atom_1234_coords : irrep3.coords 1234 = [27, 54, 12] := by decide

theorem atom_1234_cell : atomCell 1234 = 77421 := by decide

/-! ## Moving the world -/

/-- Moving atom `1234` five along adds five to each residue and wraps: the
second axis comes back round to `0`, which is the componentwise translation of
`coords_add`. -/
theorem atom_1234_moved : irrep3.coords (1234 + 5) = [32, 0, 17] := by decide

theorem shift_atom_1234 : irrep3.shift 5 (atomCell 1234) = atomCell 1239 :=
  shift_cell irrep3_legit 1234 5

/-- Moving one object on its own: slide atom `1234` one along the first axis,
two along the second and three along the third. -/
theorem slide_atom_1234 : irrep3.slide [1, 2, 3] (irrep3.coords 1234) = [28, 56, 15] := by
  decide

/-- Sliding an atom by the address of `5` is moving that atom on by `5`. -/
theorem slide_atom_1234_by_five :
    irrep3.slide (irrep3.coords 5) (irrep3.coords 1234) = irrep3.coords 1239 :=
  slide_coords irrep3 1234 5

/-- Moving the whole world by a full turn of the box puts everything back. -/
theorem shift_full_turn {c : Nat} (hc : c < irrep3.size) : irrep3.shift 196883 c = c := by
  have h : irrep3.shift 196883 c = irrep3.cell (irrep3.lift c + 196883) := rfl
  rw [h, cell_congr (m := irrep3.lift c + 196883) (n := irrep3.lift c) (by
        rw [irrep3_size] at *
        omega),
    cell_lift irrep3_legit hc]

/-! ## Changing irrep -/

/-- The same three primes in another order: the same `196883` cells, the same
cans, different addresses. -/
theorem irrep3'_same_size : irrep3.size = irrep3'.size := by decide

theorem atom_1234_in_irrep3' : irrep3'.coords 1234 = [12, 27, 54] := by decide

/-- Changing irrep and changing back is doing nothing. -/
theorem round_trip {c : Nat} (hc : c < irrep3.size) :
    irrep3'.transfer irrep3 (irrep3.transfer irrep3' c) = c :=
  transfer_transfer irrep3_legit irrep3'_legit irrep3'_same_size hc

/-- One dimension up: `71 × 59 × 47 × 41`, and a can's old address is its new
one divided by `41`. -/
theorem atom_cell_in_irrep4 (n : Nat) : irrep4.cell n / 41 = irrep3.cell n := by
  simpa using cell_of_refine (I := irrep3) (J := irrep4) (E := [41]) irrep4_refines (by decide) n

theorem atom_1234_in_irrep4 : irrep4.coords 1234 = [27, 54, 12, 4] := by decide

/-- Going up in dimension multiplies the number of cells by the new axis. -/
theorem irrep4_size_eq : irrep4.size = irrep3.size * 41 := by decide

end Irrep

end Monster

end NixWars
