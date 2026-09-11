import RequestProject.Gvcs.Voxel.Core
import RequestProject.Gvcs.Materials

/-!
# The voxel world

`RequestProject/Voxel/Core.lean` says what a *solid* is: a function from the
integer lattice to a bit, "is there material here?".  That is enough to model
the machine, but a game needs to know *what kind* of material is there — soil,
ore, a crop, a pile of bought steel, a piece of the tractor, a brick a player
placed.  So the world of the game is the same lattice with a richer codomain:

> `World := Vox → Cell`

and everything the player can see is a value of that type.  This file is the
algebra of worlds, exactly parallel to the algebra of solids:

* `Cell`, what one voxel can hold, and `World`, a world;
* `World.solid`, the occupancy of a world — the bridge back to `Voxel.Core`,
  so every theorem about solids applies to worlds;
* `paint`, a solid painted with one kind of cell; `lay`, one world laid on top
  of another, and `stack`, a list of worlds laid down in order.  `lay` is
  associative with `empty` as its unit, and — the fact the scene builder needs
  — **two worlds that do not interpenetrate commute** (`lay_comm_of_apart`),
  so a scene assembled out of separated districts does not depend on the order
  they are assembled in;
* `set`, changing one voxel, which is what digging and building do;
* `region`, the solid of the cells of one kind, and `tally`, how many voxels of
  a kind a window holds — the counting that the gauges of
  `RequestProject/VoxelGame/Scene.lean` are read off.
-/

namespace LifeTrac
namespace VoxelGame

open Voxel
open Voxel.Solid

/-- What a single voxel of the world holds. -/
inductive Cell where
  /-- Nothing: empty space. -/
  | air : Cell
  /-- Subsoil. -/
  | soil : Cell
  /-- Topsoil, the surface the machine drives on. -/
  | grass : Cell
  /-- Bedrock. -/
  | rock : Cell
  /-- Iron ore in the ground: what the mine yields. -/
  | ore : Cell
  /-- Water. -/
  | water : Cell
  /-- A growing crop, at the given stage. -/
  | crop (stage : ℕ) : Cell
  /-- A pile of bought stock material in the yard. -/
  | stock (m : Build.Material) : Cell
  /-- A fabricated subassembly standing in the shed. -/
  | shed (name : String) : Cell
  /-- A piece of the machine itself. -/
  | body (name : String) : Cell
  /-- Fuel, in the gauge. -/
  | fuel : Cell
  /-- Money, in the cash column. -/
  | coin : Cell
  /-- A brick the player placed in creative mode. -/
  | brick (part : ℕ) : Cell
deriving DecidableEq, Repr, Inhabited

/-- The world of the game: every point of the lattice holds a cell. -/
abbrev World := Vox → Cell

namespace World

/-! ## Worlds and solids -/

/-- The empty world. -/
def empty : World := fun _ => .air

/-- The occupancy of a world: where it is not air.  This is the bridge from a
world to the solids of `Voxel.Core`, so every theorem there — containment,
non-interpenetration, counting, rigid motion — applies to worlds too. -/
def solid (w : World) : Solid := fun v => decide (w v ≠ .air)

@[simp] theorem empty_apply (v : Vox) : empty v = .air := rfl

@[simp] theorem solid_apply (w : World) (v : Vox) :
    solid w v = decide (w v ≠ .air) := rfl

theorem solid_eq_true {w : World} {v : Vox} : solid w v = true ↔ w v ≠ .air := by
  simp [solid]

theorem solid_eq_false {w : World} {v : Vox} : solid w v = false ↔ w v = .air := by
  simp [solid]

@[simp] theorem solid_empty : solid empty = Solid.empty := by
  funext v; simp [solid, Solid.empty]

/-- A solid painted all in one kind of cell. -/
def paint (s : Solid) (c : Cell) : World := fun v => if s v then c else .air

@[simp] theorem paint_apply (s : Solid) (c : Cell) (v : Vox) :
    paint s c v = if s v then c else .air := rfl

/-- Painting with a real material gives back exactly the solid one started
with. -/
@[simp] theorem solid_paint {c : Cell} (hc : c ≠ .air) (s : Solid) :
    solid (paint s c) = s := by
  funext v
  by_cases hv : s v = true <;> simp [solid, paint, hv, hc]

@[simp] theorem paint_air (s : Solid) : paint s .air = empty := by
  funext v; simp [paint, empty]

@[simp] theorem paint_empty (c : Cell) : paint Solid.empty c = empty := by
  funext v; simp [paint, Solid.empty, empty]

/-! ## Laying one world on top of another -/

/-- `lay w u` is `w` laid on top of `u`: where `w` has something, it wins. -/
def lay (w u : World) : World := fun v => if w v = .air then u v else w v

theorem lay_apply (w u : World) (v : Vox) :
    lay w u v = if w v = .air then u v else w v := rfl

@[simp] theorem lay_empty (w : World) : lay w empty = w := by
  funext v; by_cases h : w v = .air <;> simp [lay, empty, h]

@[simp] theorem empty_lay (w : World) : lay empty w = w := by
  funext v; simp [lay, empty]

theorem lay_assoc (w u t : World) : lay (lay w u) t = lay w (lay u t) := by
  funext v
  by_cases h : w v = .air <;> simp [lay, h]

@[simp] theorem lay_self (w : World) : lay w w = w := by
  funext v; by_cases h : w v = .air <;> simp [lay, h]

/-- The occupancy of a stack of two worlds is the union of their
occupancies. -/
@[simp] theorem solid_lay (w u : World) : solid (lay w u) = cup (solid w) (solid u) := by
  funext v
  by_cases h : w v = .air <;> simp [solid, lay, h]

/-- **Districts that do not interpenetrate commute.**  A scene built out of a
yard, a shed, a field and a machine that occupy disjoint ground looks the same
however its pieces are laid down. -/
theorem lay_comm_of_apart {w u : World} (h : Apart (solid w) (solid u)) :
    lay w u = lay u w := by
  funext v
  rcases h v with hv | hv <;> rw [solid_eq_false] at hv <;> simp [lay, hv]
  all_goals exact fun h' => h'.symm

/-- A list of worlds, laid down head first. -/
def stack (l : List World) : World := l.foldr lay empty

@[simp] theorem stack_nil : stack [] = empty := rfl

@[simp] theorem stack_cons (w : World) (l : List World) :
    stack (w :: l) = lay w (stack l) := rfl

theorem stack_append (l m : List World) : stack (l ++ m) = lay (stack l) (stack m) := by
  induction l with
  | nil => simp
  | cons w l ih => simp [ih, lay_assoc]

/-- The occupancy of a scene is the union of the occupancies of its parts. -/
theorem solid_stack (l : List World) : solid (stack l) = unions (l.map solid) := by
  induction l with
  | nil => simp
  | cons w l ih => simp [ih]

/-- Everything in a scene is somewhere in one of its parts. -/
theorem mem_stack {l : List World} {v : Vox} (h : stack l v ≠ .air) :
    ∃ w ∈ l, w v ≠ .air := by
  induction l with
  | nil => exact absurd rfl h
  | cons w l ih =>
      by_cases hw : w v = .air
      · rw [stack_cons, lay_apply, if_pos hw] at h
        obtain ⟨u, hu, hu'⟩ := ih h
        exact ⟨u, List.mem_cons_of_mem _ hu, hu'⟩
      · exact ⟨w, List.mem_cons_self .., hw⟩

/-! ## Changing one voxel -/

/-- The world with the single voxel `p` set to `c`: what digging, placing a
brick and planting a seed all do. -/
def set (w : World) (p : Vox) (c : Cell) : World := fun v => if v = p then c else w v

@[simp] theorem set_same (w : World) (p : Vox) (c : Cell) : set w p c p = c := by
  simp [set]

@[simp] theorem set_other {w : World} {p v : Vox} (h : v ≠ p) (c : Cell) :
    set w p c v = w v := by
  simp [set, h]

/-- Setting a voxel twice: the second write wins. -/
@[simp] theorem set_set (w : World) (p : Vox) (c d : Cell) :
    set (set w p c) p d = set w p d := by
  funext v; by_cases h : v = p <;> simp [set, h]

@[simp] theorem set_get (w : World) (p : Vox) : set w p (w p) = w := by
  funext v; by_cases h : v = p <;> simp [set, h]

/-- Writes to different voxels commute — the reason two players may dig in two
places at once without agreeing on an order. -/
theorem set_comm {p q : Vox} (h : p ≠ q) (w : World) (c d : Cell) :
    set (set w p c) q d = set (set w q d) p c := by
  funext v
  by_cases hp : v = p <;> by_cases hq : v = q <;>
    simp_all [set]

/-! ## Regions and counting -/

/-- The solid made of the cells of one kind. -/
def region (w : World) (c : Cell) : Solid := fun v => decide (w v = c)

@[simp] theorem region_apply (w : World) (c : Cell) (v : Vox) :
    region w c v = decide (w v = c) := rfl

theorem region_sub_solid {c : Cell} (hc : c ≠ .air) (w : World) :
    Sub (region w c) (solid w) := by
  intro v hv
  simp only [region_apply, decide_eq_true_eq] at hv
  simp [solid, hv, hc]

@[simp] theorem region_paint_self {c : Cell} (hc : c ≠ .air) (s : Solid) :
    region (paint s c) c = s := by
  funext v
  by_cases hv : s v = true
  · simp [region, paint, hv]
  · simp only [Bool.not_eq_true] at hv
    simp [region, paint, hv, Ne.symm hc]

/-- A different kind of cell is nowhere to be found in a world painted all one
colour. -/
theorem region_paint_other {c d : Cell} (hcd : d ≠ c) (hd : d ≠ .air) (s : Solid) :
    region (paint s c) d = Solid.empty := by
  funext v
  by_cases hv : s v = true
  · simp [region, paint, hv, Ne.symm hcd, Solid.empty]
  · simp only [Bool.not_eq_true] at hv
    simp [region, paint, hv, Ne.symm hd, Solid.empty]

/-- How many voxels of kind `c` the window `W` holds. -/
def tally (W : Finset Vox) (w : World) (c : Cell) : ℕ := Solid.count W (w.region c)

theorem tally_eq_card (W : Finset Vox) (w : World) (c : Cell) :
    tally W w c = (W.filter (fun v => w v = c)).card := by
  simp [tally, Solid.count, region]

@[simp] theorem tally_empty (W : Finset Vox) {c : Cell} (hc : c ≠ .air) :
    tally W empty c = 0 := by
  rw [tally_eq_card]
  simp only [empty_apply]
  rw [Finset.filter_eq_empty_iff.2 (fun _ _ => fun h => hc h.symm)]
  simp

/-- Digging out a voxel of kind `c` takes exactly one voxel of `c` out of the
world. -/
theorem tally_set_erase {W : Finset Vox} {w : World} {c d : Cell} {p : Vox}
    (hp : p ∈ W) (hw : w p = c) (hd : d ≠ c) :
    tally W (set w p d) c + 1 = tally W w c := by
  classical
  rw [tally_eq_card, tally_eq_card]
  have hfil : W.filter (fun v => w v = c) =
      insert p (W.filter (fun v => set w p d v = c)) := by
    ext v
    by_cases hv : v = p
    · subst hv; simp [set, hp, hw, hd]
    · simp [set, hv]
  rw [hfil, Finset.card_insert_of_notMem (by simp [set, hd])]

/-- Filling an empty voxel with `c` adds exactly one voxel of `c`. -/
theorem tally_set_add {W : Finset Vox} {w : World} {c : Cell} {p : Vox}
    (hp : p ∈ W) (hw : w p ≠ c) :
    tally W (set w p c) c = tally W w c + 1 := by
  classical
  rw [tally_eq_card, tally_eq_card]
  have hfil : W.filter (fun v => set w p c v = c) =
      insert p (W.filter (fun v => w v = c)) := by
    ext v
    by_cases hv : v = p
    · subst hv; simp [set, hp]
    · simp [set, hv]
  rw [hfil, Finset.card_insert_of_notMem (by simp [hw])]

/-- **Digging takes exactly one voxel out of the world.** -/
theorem count_solid_set_air {W : Finset Vox} {w : World} {p : Vox} (hp : p ∈ W)
    (h : w p ≠ .air) :
    Solid.count W (solid (set w p .air)) + 1 = Solid.count W (solid w) := by
  classical
  simp only [Solid.count]
  have hfil : W.filter (fun v => solid w v = true) =
      insert p (W.filter (fun v => solid (set w p .air) v = true)) := by
    ext v
    by_cases hv : v = p
    · subst hv; simp [solid, set, hp, h]
    · simp [solid, set, hv]
  rw [hfil, Finset.card_insert_of_notMem (by simp [solid, set])]

/-- **Building puts exactly one voxel into it.** -/
theorem count_solid_set_cell {W : Finset Vox} {w : World} {p : Vox} {c : Cell} (hp : p ∈ W)
    (hw : w p = .air) (hc : c ≠ .air) :
    Solid.count W (solid (set w p c)) = Solid.count W (solid w) + 1 := by
  classical
  simp only [Solid.count]
  have hfil : W.filter (fun v => solid (set w p c) v = true) =
      insert p (W.filter (fun v => solid w v = true)) := by
    ext v
    by_cases hv : v = p
    · subst hv; simp [solid, set, hp, hc]
    · simp [solid, set, hv]
  rw [hfil, Finset.card_insert_of_notMem (by simp [solid, hw])]

/-- A window counts every one of the voxels of a box that fills it. -/
theorem count_box_self (lo hi : Vox) :
    Solid.count (Finset.Icc lo hi) (box lo hi) = (Finset.Icc lo hi).card := by
  classical
  rw [Solid.count, Finset.filter_true_of_mem]
  intro v hv
  simp only [Finset.mem_Icc, Prod.le_def] at hv
  simp only [mem_box, Vox.x, Vox.y, Vox.z]
  exact ⟨hv.1.1, hv.2.1, hv.1.2.1, hv.2.2.1, hv.1.2.2, hv.2.2.2⟩

end World
end VoxelGame
end LifeTrac
