import RequestProject.Gvcs.Voxel.View
import RequestProject.Gvcs.VoxelGame.Editor

/-!
# The game world in the viewer

`RequestProject/Voxel/View.lean` puts a *solid* — a function from the lattice to a bit —
into the grid of `web/voxel.html`.  The world of the game
(`RequestProject/VoxelGame/World.lean`) is the same lattice with a richer codomain: every
voxel holds a `Cell`, soil or ore or a crop or a piece of the machine or a brick the player
placed.  This file paints those cells in the nine block types the page knows, and proves
that the picture the page draws is the world the game has.

* `cellCode` — the palette: soil, rock and bought stock are `STONE`, grass and crops are
  `TURF`, water is `ICE`, a subassembly in the shed is `BOUNCE`, fuel is `LAVA`, ore and
  cash are `COIN`, the machine itself is `GOAL`, and a player's brick is `GLASS`;
* `cellCode_eq_zero_iff` — a cell is drawn empty exactly when it is air, so the occupancy
  the page shows is `World.solid`, the bridge every solid theorem is stated about;
* `cellCode_ne_start` — nothing is drawn in `START`, so an exported world always satisfies
  the page's one-start rule;
* `world_view_faithful` — **the headline**: the text of a share link of a world decodes,
  the way the page decodes it, to a grid holding exactly the palette code of the cell the
  game has at each lattice point that the frame samples;
* `world_view_shows_occupancy` — and it is empty exactly where the world is air;
* `sceneFrame`, `demoShare` — the frame the campaign's closing scene is viewed in, and the
  link that shows it.
-/

namespace LifeTrac
namespace VoxelGame
namespace View

open Voxel Voxel.Codec Voxel.View

/-! ## The palette -/

/-- The block type a cell of the game world is drawn in, in the page's palette. -/
def cellCode : Cell → Nat
  | .air => 0
  | .soil => 1
  | .rock => 1
  | .stock _ => 1
  | .grass => 2
  | .crop _ => 2
  | .water => 3
  | .shed _ => 4
  | .fuel => 5
  | .ore => 6
  | .coin => 6
  | .body _ => 7
  | .brick _ => 9

theorem cellCode_lt_16 (c : Cell) : cellCode c < 16 := by
  cases c <;> simp [cellCode]

/-- Nothing is drawn in `START`: an exported world has no start block at all, so it never
breaks the page's rule that a design carries at most one. -/
theorem cellCode_ne_start (c : Cell) : cellCode c ≠ 8 := by
  cases c <;> simp [cellCode]

/-- **A cell is drawn empty exactly when it is air.** -/
theorem cellCode_eq_zero_iff (c : Cell) : cellCode c = 0 ↔ c = .air := by
  cases c <;> simp [cellCode]

/-! ## A world in the grid -/

/-- The painting of a world in the page's palette, one block to a cube of `n` voxels: the
first cell of the cube that is not air. -/
def worldPaint (n : Nat) (w : World) : Vox → Nat := coarse n (fun v => cellCode (w v))

theorem worldPaint_lt_16 (n : Nat) (w : World) (v : Vox) : worldPaint n w v < 16 :=
  coarse_lt_16 (fun u => cellCode_lt_16 (w u)) n v

/-- At one block to the voxel, the painting is the palette code of the cell. -/
theorem worldPaint_one (w : World) (v : Vox) : worldPaint 1 w v = cellCode (w v) :=
  coarse_one _ v

/-- **A block of the view is empty exactly when the whole cube it stands for is air.** -/
theorem worldPaint_eq_zero_iff (n : Nat) (w : World) (v : Vox) :
    worldPaint n w v = 0 ↔
      ∀ i : ℕ, i < n → ∀ j : ℕ, j < n → ∀ k : ℕ, k < n →
        w (v.x + (i : ℤ), v.y - (j : ℤ), v.z + (k : ℤ)) = .air := by
  rw [worldPaint, coarse_eq_zero_iff]
  constructor
  · intro h i hi j hj k hk
    exact (cellCode_eq_zero_iff _).1 (h i hi j hj k hk)
  · intro h i hi j hj k hk
    exact (cellCode_eq_zero_iff _).2 (h i hi j hj k hk)

/-- The cells of the viewer's grid, painted from a world of the game. -/
def worldCells (f : Frame) (n : Nat) (w : World) : List Nat := cellsOf f (worldPaint n w)

/-- The text of a share link showing a world of the game. -/
def worldShare (name : String) (f : Frame) (n : Nat) (w : World) : String :=
  share (asciiName name) f (worldPaint n w)

/-- **What the page draws is the world the game has.**  Decoding the link the way the page
does gives back the name and a grid whose every cell holds the palette code of the cell the
world has at the lattice point that cell stands for. -/
theorem world_view_faithful (name : String) (f : Frame) (n : Nat) (w : World) :
    ∃ rle grid, decodeLevel (worldShare name f n w) = some (asciiName name, rle)
      ∧ dec rle = some grid
      ∧ ∀ x y z, x < dimX → y < dimY → z < dimZ →
          grid.getD (index x y z) 0 = worldPaint n w (f.at x y z) :=
  view_faithful (asciiName name) f (worldPaint n w) (asciiName_lt_256 name)
    (asciiName_length_lt_256 name) (worldPaint_lt_16 n w)

/-- At one block to the voxel it is the palette code of the cell the game has there. -/
theorem world_view_faithful_fine (name : String) (f : Frame) (w : World) :
    ∃ rle grid, decodeLevel (worldShare name f 1 w) = some (asciiName name, rle)
      ∧ dec rle = some grid
      ∧ ∀ x y z, x < dimX → y < dimY → z < dimZ →
          grid.getD (index x y z) 0 = cellCode (w (f.at x y z)) := by
  obtain ⟨rle, grid, hdec, hrle, hgrid⟩ := world_view_faithful name f 1 w
  exact ⟨rle, grid, hdec, hrle, fun x y z hx hy hz => by
    rw [hgrid x y z hx hy hz, worldPaint_one]⟩

/-- …and it is empty exactly where the world is: the occupancy the page shows is
`World.solid`, the solid every theorem of `RequestProject/Voxel/Core.lean` is about. -/
theorem world_view_shows_occupancy (name : String) (f : Frame) (w : World) :
    ∃ rle grid, decodeLevel (worldShare name f 1 w) = some (asciiName name, rle)
      ∧ dec rle = some grid
      ∧ ∀ x y z, x < dimX → y < dimY → z < dimZ →
          (grid.getD (index x y z) 0 ≠ 0 ↔ World.solid w (f.at x y z) = true) := by
  obtain ⟨rle, grid, hdec, hrle, hgrid⟩ := world_view_faithful_fine name f w
  refine ⟨rle, grid, hdec, hrle, fun x y z hx hy hz => ?_⟩
  rw [hgrid x y z hx hy hz, World.solid_eq_true, ne_eq, cellCode_eq_zero_iff]

/-! ## The campaign scene -/

/-- The frame the whole game scene is viewed in: one block of the viewer to four voxels of
the lattice, wide enough for the machine, the yard, the shed, the gauges and the field. -/
def sceneFrame : Frame := ⟨(0, 44, -4), 4⟩

/-- The link that shows the closing scene of the campaign — the machine as built, the
stock in the yard, the subassemblies in the shed, the gauges, the field and the ground the
player dug — in `web/voxel.html`. -/
def demoShare : String := worldShare "LIFETRAC YARD" sceneFrame 4 demoWorld

/-- The demo scene, in the viewer, is the demo scene of the specification. -/
theorem demoShare_faithful :
    ∃ rle grid, decodeLevel demoShare = some (asciiName "LIFETRAC YARD", rle)
      ∧ dec rle = some grid
      ∧ ∀ x y z, x < dimX → y < dimY → z < dimZ →
          grid.getD (index x y z) 0 = worldPaint 4 demoWorld (sceneFrame.at x y z) :=
  world_view_faithful _ _ _ _

/-! ## Audit -/

#print axioms world_view_faithful
#print axioms world_view_shows_occupancy

end View
end VoxelGame
end LifeTrac
