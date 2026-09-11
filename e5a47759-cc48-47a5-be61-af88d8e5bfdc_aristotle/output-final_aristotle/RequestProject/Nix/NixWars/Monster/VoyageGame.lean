import RequestProject.Nix.NixWars.Monster.Voyage
import RequestProject.Nix.NixWars.Monster.Projected

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

/-!
# Flying to the things in the game

`Projected.lean` puts the 3529 cans of `Cans.nixwarsWorld` into the first irrep
world — atom `i` sits in the cell `Irrep.atomCell i` of `71 × 59 × 47`, and no two of
them share a cell.  `Voyage.lean` puts a player into that world.  This file is
the two together: the player can fly to any atom of the game, knows which atom
it is sitting on when it gets there, and carries it along the game's own path to
the world next door.
-/

namespace NixWars

namespace Monster

namespace Voyage

open Moonshine

/-- The ship parked on the atom numbered `i` of the game. -/
def atomShip (i : Nat) : Ship := shipOfCan Irrep.irrep3 i

/-- Its address is a real address of the first world. -/
theorem atomShip_aboard (i : Nat) : (atomShip i).Aboard :=
  shipOfCan_aboard Irrep.irrep3_legit.pos i

/-- The cell it is parked on is the cell `Projected.lean` puts that atom in. -/
theorem atomShip_cell (i : Nat) : (atomShip i).cell = Irrep.atomCell i := rfl

/-- Every atom of the game is inside the world. -/
theorem atomShip_cell_lt (i : Nat) : (atomShip i).cell < Irrep.irrep3.size :=
  Irrep.atomCell_lt i

/-- **The player can fly to any atom of the game**, from wherever it is. -/
theorem route_to_atom {S : Ship} (hS : S.Aboard) (i : Nat) :
    run (route S (atomShip i)) S = atomShip i :=
  route_flies hS (atomShip_aboard i)

/-- **And knows what it has arrived at**: the can under the ship is the atom it
was sent to. -/
theorem atom_at_ship {i : Nat} (hi : i < 196883) : canAt (atomShip i) = i :=
  can_at_ship Irrep.irrep3_legit (by simpa [Irrep.irrep3_size] using hi)

/-- **No two atoms of the game are the same destination.** -/
theorem atomShip_inj {i j : Nat} (hi : i < Irrep.gameCans.length) (hj : j < Irrep.gameCans.length)
    (h : atomShip i = atomShip j) : i = j := by
  have : Irrep.atomCell i = Irrep.atomCell j := by
    rw [← atomShip_cell, ← atomShip_cell, h]
  exact Irrep.atomCell_inj hi hj this

/-- Carrying an atom along the game's own path: the two axes the path keeps are
the two residues the atom keeps, and the three axes it multiplies in are entered
at their origin. -/
theorem atomShip_travel_ladder (i : Nat) :
    travel ladder (atomShip i) = ⟨irrepNext, [0, 0, 0, i % 71, i % 59]⟩ := rfl

/-- A worked one: atom 1234 of the game, whose cell in the first world is
`77421`, flown to the world next door. -/
theorem atom_1234_ship : atomShip 1234 = ⟨Irrep.irrep3, [27, 54, 12]⟩ := by decide

theorem atom_1234_ship_cell : (atomShip 1234).cell = 77421 := by decide

theorem atom_1234_travelled :
    travel ladder (atomShip 1234) = ⟨irrepNext, [0, 0, 0, 27, 54]⟩ := by decide

/-- The flight plan from the origin of the first world to atom 1234: three axes
stripped, three built, and one cell of flying for each unit of its address. -/
theorem route_to_atom_1234_length : (route start3 (atomShip 1234)).length = 3 + 3 + 93 := by
  decide

theorem route_to_atom_1234 : run (route start3 (atomShip 1234)) start3 = atomShip 1234 :=
  route_to_atom start3_aboard 1234

end Voyage

end Monster

end NixWars
