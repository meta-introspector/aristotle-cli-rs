import Mathlib

/-!
# Micro-voxel parts for the factory tycoon

A tycoon factory is built out of **parts**, and every part is a small rigid
cluster of *micro voxels*: unit cubes on an integer grid, sixteen to a side.  A
`Part` is a `Kind` (which fixes its shape, its colour and its price) together
with the grid position of its origin, and a `Scene` is the list of parts placed
so far — the thing the renderer draws and the thing the economy reads.

The invariant a scene must keep is `Scene.WF`: every micro voxel of every part
lies inside the grid, no two parts share a micro voxel, and the factory has not
grown past `maxParts` parts.  The two building moves — placing a part and
removing one — are proved to preserve it.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-! ## The micro-voxel grid -/

/-- A micro-voxel coordinate. -/
structure V3 where
  x : Nat
  y : Nat
  z : Nat
deriving DecidableEq, Repr, Inhabited

namespace V3

/-- Componentwise addition: translating a local part offset by a part origin. -/
def add (a b : V3) : V3 := ⟨a.x + b.x, a.y + b.y, a.z + b.z⟩

/-- The side length of the build grid, in micro voxels. -/
def gridSize : Nat := 16

/-- Is a micro voxel inside the build grid? -/
def inGrid (v : V3) : Bool := v.x < gridSize && v.y < gridSize && v.z < gridSize

theorem add_right_injective (p : V3) : Function.Injective (fun o => p.add o) := by
  rintro ⟨a1, a2, a3⟩ ⟨b1, b2, b3⟩ h
  simp only [add, V3.mk.injEq] at h
  simp_all

end V3

/-! ## Parts -/

/-- The kinds of part a player can build. -/
inductive Kind where
  /-- Extracts ore each world tick. -/
  | miner
  /-- Turns one ore into one ingot each world tick. -/
  | smelter
  /-- Lets the player sell ingots. -/
  | seller
  /-- Decoration: a single micro voxel. -/
  | belt
  /-- Decoration: a two-voxel column. -/
  | pillar
deriving DecidableEq, Repr, Inhabited

namespace Kind

/-- The micro voxels a part of this kind occupies, as offsets from its origin. -/
def shape : Kind → List V3
  | .miner   => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨0,0,1⟩, ⟨1,0,1⟩, ⟨0,1,0⟩, ⟨1,1,0⟩, ⟨0,1,1⟩, ⟨1,1,1⟩]
  | .smelter => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨0,1,0⟩, ⟨1,1,0⟩, ⟨0,0,1⟩, ⟨1,0,1⟩]
  | .seller  => [⟨0,0,0⟩, ⟨1,0,0⟩, ⟨0,0,1⟩, ⟨1,0,1⟩]
  | .belt    => [⟨0,0,0⟩]
  | .pillar  => [⟨0,0,0⟩, ⟨0,1,0⟩]

/-- The price of a part, in cash. -/
def cost : Kind → Nat
  | .miner => 20
  | .smelter => 35
  | .seller => 50
  | .belt => 1
  | .pillar => 1

/-- The fill colour the renderer uses, as a `0xRRGGBB` value. -/
def color : Kind → Nat
  | .miner => 0x4f9de0
  | .smelter => 0xe08a3c
  | .seller => 0x54c07a
  | .belt => 0x9aa3ad
  | .pillar => 0x6b7480

/-- Every kind's shape lists distinct micro voxels. -/
theorem shape_nodup (k : Kind) : k.shape.Nodup := by
  cases k <;> decide

/-- Every kind's shape is non-empty. -/
theorem shape_ne_nil (k : Kind) : k.shape ≠ [] := by
  cases k <;> simp [shape]

end Kind

/-- A placed part: a kind and the grid position of its origin. -/
structure Part where
  kind : Kind
  pos : V3
deriving DecidableEq, Repr, Inhabited

namespace Part

/-- The micro voxels a placed part occupies. -/
def cells (p : Part) : List V3 := p.kind.shape.map (fun o => p.pos.add o)

/-- Do all of a part's micro voxels lie inside the grid? -/
def fits (p : Part) : Bool := p.cells.all V3.inGrid

theorem cells_nodup (p : Part) : p.cells.Nodup :=
  (List.nodup_map_iff_inj_on (Kind.shape_nodup p.kind)).2
    (fun _ _ _ _ h => V3.add_right_injective p.pos h)

theorem cells_ne_nil (p : Part) : p.cells ≠ [] := by
  simpa [cells] using Kind.shape_ne_nil p.kind

end Part

/-! ## Scenes -/

/-- A factory: the parts built so far, most recent first. -/
abbrev Scene := List Part

namespace Scene

/-- Every micro voxel occupied in the scene, part by part. -/
def cells (s : Scene) : List V3 := s.flatMap Part.cells

@[simp] theorem cells_nil : cells [] = [] := rfl

@[simp] theorem cells_cons (p : Part) (s : Scene) :
    cells (p :: s) = p.cells ++ cells s := rfl

/-- The largest number of parts a factory may contain. -/
def maxParts : Nat := 64

/-- Is the space a part would occupy still free? -/
def free (s : Scene) (p : Part) : Bool := p.cells.all (fun c => !((cells s).contains c))

/-- The scene invariant: everything is inside the grid, nothing overlaps, and
the factory has not outgrown the build limit. -/
structure WF (s : Scene) : Prop where
  /-- Every occupied micro voxel is inside the grid. -/
  inGrid : ∀ c ∈ cells s, c.inGrid
  /-- No micro voxel is occupied twice. -/
  nodup : (cells s).Nodup
  /-- The factory is within the part limit. -/
  bounded : s.length ≤ maxParts

theorem wf_nil : WF [] := ⟨by simp, by simp, by simp [maxParts]⟩

/-- Placing a part: it goes on the front of the scene. -/
def place (s : Scene) (p : Part) : Scene := p :: s

/-- May a part be placed here? -/
def canPlace (s : Scene) (p : Part) : Bool :=
  p.fits && s.free p && decide (s.length < maxParts)

theorem free_iff (s : Scene) (p : Part) :
    s.free p = true ↔ ∀ c ∈ p.cells, c ∉ cells s := by
  simp [free]

/-- **Placing a legal part keeps the scene well formed.** -/
theorem place_wf {s : Scene} {p : Part} (hs : WF s) (h : s.canPlace p = true) :
    WF (s.place p) := by
  simp only [canPlace, Bool.and_eq_true, decide_eq_true_eq] at h
  obtain ⟨⟨hfit, hfree⟩, hlen⟩ := h
  refine ⟨?_, ?_, ?_⟩
  · intro c hc
    rw [place, cells_cons, List.mem_append] at hc
    rcases hc with hc | hc
    · exact (List.all_eq_true.mp hfit) c hc
    · exact hs.inGrid c hc
  · rw [place, cells_cons, List.nodup_append]
    refine ⟨p.cells_nodup, hs.nodup, ?_⟩
    intro a ha b hb
    rintro rfl
    exact (free_iff s p).1 hfree a ha hb
  · simpa [place] using hlen

/-- Removing the part at index `i`. -/
def remove (s : Scene) (i : Nat) : Scene := s.eraseIdx i

theorem cells_eraseIdx_sublist (s : Scene) (i : Nat) :
    (cells (s.eraseIdx i)).Sublist (cells s) := by
  induction s generalizing i with
  | nil => simp [cells]
  | cons p t ih =>
      cases i with
      | zero =>
          simp only [List.eraseIdx_cons_zero, cells_cons]
          exact List.sublist_append_right _ _
      | succ n =>
          simp only [List.eraseIdx_cons_succ, cells_cons]
          exact (ih n).append_left _

/-- **Removing a part keeps the scene well formed.** -/
theorem remove_wf {s : Scene} (hs : WF s) (i : Nat) : WF (s.remove i) := by
  have hsub := cells_eraseIdx_sublist s i
  refine ⟨?_, ?_, ?_⟩
  · exact fun c hc => hs.inGrid c (hsub.mem hc)
  · exact hs.nodup.sublist hsub
  · exact le_trans (List.length_eraseIdx_le s i) hs.bounded

/-- Placing a part and then removing it again returns the original factory. -/
@[simp] theorem remove_place (s : Scene) (p : Part) : (s.place p).remove 0 = s := rfl

/-- Placing adds exactly the part's own micro voxels. -/
@[simp] theorem cells_place (s : Scene) (p : Part) :
    cells (s.place p) = p.cells ++ cells s := rfl

/-- How many parts of a given kind the factory contains. -/
def countKind (k : Kind) (s : Scene) : Nat := (s.filter (fun p => p.kind == k)).length

theorem countKind_le_length (k : Kind) (s : Scene) : countKind k s ≤ s.length :=
  List.length_filter_le _ _

theorem countKind_le_maxParts {s : Scene} (hs : WF s) (k : Kind) :
    countKind k s ≤ maxParts :=
  le_trans (countKind_le_length k s) hs.bounded

end Scene

end Tycoon
