import Mathlib
import RequestProject.Gvcs.Voxel.Core

/-!
# Rigs: machines made of blocks

This is the *construction* half of the pocket game in `web/rigs.html`.  A player
builds a machine by tapping blocks into an eight-by-four-by-two grid; the
machine's behaviour on the course is decided entirely by what is in that grid.

* `Kind` — the seven things a cell can hold, as the small numbers the
  WebAssembly module keeps them as (`kEmpty` … `kScoop`).
* `Design` — a grid: a function from a cell index to a kind.  `cellIdx` numbers
  the cells, `place` writes one.
* `statOf` — how a machine's figures are read off its grid: every one of them
  is a *sum over the cells* of a per-kind table, so `statOf_place` gives the
  incremental update (subtract the old block's contribution, add the new one's)
  that the module performs, and that is the only fact the compiled code needs.
* `Rig` — the five figures the driving model uses, and `rigOf` reads them off a
  design.
* `Valid` — the rules of the workshop: two wheels, an engine, a tank, and a
  bill under budget.
* `solidOf` — the bridge to `RequestProject/Voxel/Core.lean`: a design is also a
  *solid*, the union of unit boxes at its filled cells, and two different cells
  of a grid never interpenetrate (`solidOf_cells_apart`).
-/

namespace LifeTrac
namespace Rig

/-! ## The grid -/

/-- Cells across the machine (its length). -/
def gridW : Nat := 8
/-- Cells up. -/
def gridH : Nat := 4
/-- Cells across the machine's width. -/
def gridD : Nat := 2

/-- The number of cells in the build grid. -/
def gridN : Nat := gridW * gridH * gridD

theorem gridN_eq : gridN = 64 := rfl

/-- The cell index of a coordinate. -/
def cellIdx (x y z : Nat) : Nat := x + 8 * y + 32 * z

theorem cellIdx_lt {x y z : Nat} (hx : x < gridW) (hy : y < gridH) (hz : z < gridD) :
    cellIdx x y z < gridN := by
  simp only [cellIdx, gridN, gridW, gridH, gridD] at *
  omega

theorem cellIdx_inj {x y z x' y' z' : Nat} (hx : x < gridW) (hy : y < gridH)
    (hx' : x' < gridW) (hy' : y' < gridH)
    (h : cellIdx x y z = cellIdx x' y' z') : x = x' ∧ y = y' ∧ z = z' := by
  simp only [cellIdx, gridW, gridH] at *
  omega

/-! ## The blocks -/

/-- An empty cell. -/
def kEmpty : Nat := 0
/-- Frame: structure, cheap and light, and nothing else. -/
def kFrame : Nat := 1
/-- Wheel: grip, which is what turns speed into a change of line. -/
def kWheel : Nat := 2
/-- Engine: the power that drives the machine. -/
def kEngine : Nat := 3
/-- Tank: the fuel the engine burns. -/
def kTank : Nat := 4
/-- Ballast: mass, a little grip, and almost no money. -/
def kBallast : Nat := 5
/-- Scoop: the capacity to carry a load. -/
def kScoop : Nat := 6

/-- The number of kinds of block, the empty cell included. -/
def kindN : Nat := 7

/-- A number that names a block. -/
def KindOk (k : Nat) : Prop := k < kindN

instance (k : Nat) : Decidable (KindOk k) := by unfold KindOk; infer_instance

/-- Mass of a block, in kilogrammes. -/
def massTbl : Nat → Int
  | 1 => 40 | 2 => 60 | 3 => 120 | 4 => 30 | 5 => 200 | 6 => 70 | _ => 0

/-- Power of a block, in the game's units of thrust. -/
def powerTbl : Nat → Int
  | 3 => 240000 | _ => 0

/-- Grip of a block: how many millimetres of line it can buy in one tick. -/
def gripTbl : Nat → Int
  | 2 => 120 | 5 => 40 | _ => 0

/-- Carrying capacity of a block, in kilogrammes. -/
def capTbl : Nat → Int
  | 6 => 200 | _ => 0

/-- What a block costs to bolt on. -/
def costTbl : Nat → Int
  | 1 => 30 | 2 => 80 | 3 => 250 | 4 => 60 | 5 => 20 | 6 => 90 | _ => 0

/-- How much fuel a block holds, in millilitres. -/
def fuelTbl : Nat → Int
  | 4 => 4000 | _ => 0

/-- One if the block is a wheel. -/
def wheelTbl : Nat → Int
  | 2 => 1 | _ => 0

/-- One if the block is an engine. -/
def engineTbl : Nat → Int
  | 3 => 1 | _ => 0

/-- One if the block is a tank. -/
def tankTbl : Nat → Int
  | 4 => 1 | _ => 0

/-- The nine tables, in the order the module keeps them. -/
def tables : List (Nat → Int) :=
  [massTbl, powerTbl, gripTbl, capTbl, costTbl, fuelTbl, wheelTbl, engineTbl, tankTbl]

theorem tables_length : tables.length = 9 := rfl

/-- Every table is non-negative, and no entry is large. -/
theorem tables_bounds (f : Nat → Int) (hf : f ∈ tables) (k : Nat) : 0 ≤ f k ∧ f k ≤ 240000 := by
  fin_cases hf <;>
    · match k with
      | 0 | 1 | 2 | 3 | 4 | 5 | 6 => exact ⟨by decide, by decide⟩
      | (n+7) =>
          refine ⟨by rfl, ?_⟩
          calc _ = (0 : Int) := rfl
            _ ≤ 240000 := by norm_num

/-- An empty cell contributes nothing to anything. -/
theorem tables_empty (f : Nat → Int) (hf : f ∈ tables) : f kEmpty = 0 := by
  fin_cases hf <;> rfl

/-! ## Designs -/

/-- A design: what is in each cell of the grid.  Only the cells below `gridN`
are ever read. -/
abbrev Design := Nat → Nat

/-- The empty grid. -/
def emptyDesign : Design := fun _ => kEmpty

/-- A design given cell by cell. -/
def ofList (l : List Nat) : Design := fun i => l.getD i kEmpty

/-- Every cell of a design names a block. -/
def DesignOk (d : Design) : Prop := ∀ i < gridN, KindOk (d i)

instance (d : Design) : Decidable (DesignOk d) := by unfold DesignOk; infer_instance

/-- Putting a block in a cell. -/
def place (d : Design) (i k : Nat) : Design := fun j => if j = i then k else d j

@[simp] theorem place_same (d : Design) (i k : Nat) : place d i k i = k := by simp [place]

@[simp] theorem place_other {d : Design} {i k j : Nat} (h : j ≠ i) : place d i k j = d j := by
  simp [place, h]

theorem designOk_place {d : Design} (hd : DesignOk d) {i k : Nat} (hk : KindOk k) :
    DesignOk (place d i k) := by
  intro j hj
  by_cases h : j = i
  · subst h; simpa using hk
  · simpa [place, h] using hd j hj

/-! ## Reading a machine off its grid -/

/-- A figure of a machine: a per-kind table summed over the cells. -/
def statOf (f : Nat → Int) (d : Design) : Int := ∑ i ∈ Finset.range gridN, f (d i)

/-- The empty grid has every figure zero. -/
theorem statOf_empty (f : Nat → Int) (hf : f ∈ tables) : statOf f emptyDesign = 0 := by
  simp [statOf, emptyDesign, tables_empty f hf]

/-- **The incremental update.**  Changing one cell changes every figure by the
difference of the two blocks' table entries — which is exactly what the
compiled `place` does to the accumulators, in constant time. -/
theorem statOf_place (f : Nat → Int) (d : Design) {i : Nat} (hi : i < gridN) (k : Nat) :
    statOf f (place d i k) = statOf f d - f (d i) + f k := by
  have hmem : i ∈ Finset.range gridN := Finset.mem_range.2 hi
  have h1 : ∑ j ∈ Finset.range gridN, f (place d i k j)
      = f k + ∑ j ∈ (Finset.range gridN).erase i, f (d j) := by
    rw [← Finset.add_sum_erase _ _ hmem, place_same]
    exact congrArg _ (Finset.sum_congr rfl fun j hj =>
      congrArg f (place_other (Finset.mem_erase.1 hj).1))
  have h2 : ∑ j ∈ Finset.range gridN, f (d j)
      = f (d i) + ∑ j ∈ (Finset.range gridN).erase i, f (d j) :=
    (Finset.add_sum_erase _ _ hmem).symm
  simp only [statOf, h1, h2]
  ring

/-- A figure is non-negative. -/
theorem statOf_nonneg {f : Nat → Int} (hf : f ∈ tables) (d : Design) : 0 ≤ statOf f d :=
  Finset.sum_nonneg fun i _ => (tables_bounds f hf (d i)).1

/-- The mass of a machine, in kilogrammes. -/
def mass (d : Design) : Int := statOf massTbl d
/-- The power of a machine. -/
def power (d : Design) : Int := statOf powerTbl d
/-- The grip of a machine. -/
def grip (d : Design) : Int := statOf gripTbl d
/-- What a machine can carry. -/
def cap (d : Design) : Int := statOf capTbl d
/-- What a machine costs to build. -/
def cost (d : Design) : Int := statOf costTbl d
/-- How much fuel a machine holds. -/
def fuelCap (d : Design) : Int := statOf fuelTbl d
/-- How many wheels a machine has. -/
def wheels (d : Design) : Int := statOf wheelTbl d
/-- How many engines. -/
def engines (d : Design) : Int := statOf engineTbl d
/-- How many tanks. -/
def tanks (d : Design) : Int := statOf tankTbl d

/-- The nine figures in table order, as the module numbers them. -/
def statAt (d : Design) : Nat → Int
  | 0 => mass d | 1 => power d | 2 => grip d | 3 => cap d | 4 => cost d
  | 5 => fuelCap d | 6 => wheels d | 7 => engines d | _ => tanks d

theorem statAt_eq {j : Nat} (hj : j < 9) (d : Design) :
    statAt d j = statOf (tables.getD j massTbl) d := by
  interval_cases j <;> rfl

/-! ## The workshop rules -/

/-- What a machine may cost. -/
def budget : Int := 1000

/-- A machine that may be taken to the course: two wheels, an engine, a tank,
and a bill inside the budget. -/
def Valid (d : Design) : Prop :=
  2 ≤ wheels d ∧ 1 ≤ engines d ∧ 1 ≤ tanks d ∧ cost d ≤ budget

instance (d : Design) : Decidable (Valid d) := by unfold Valid; infer_instance

/-- A legal machine has mass, so nothing ever divides by zero when it is
driven. -/
theorem mass_pos {d : Design} (h : Valid d) : 0 < mass d := by
  obtain ⟨hw, -, -, -⟩ := h
  have hsplit : ∀ i, (60 : Int) * wheelTbl (d i) ≤ massTbl (d i) := by
    intro i
    match hk : d i with
    | 0 | 1 | 2 | 3 | 4 | 5 | 6 => decide
    | (n+7) => simp [massTbl, wheelTbl]
  calc (0 : Int) < 60 * 2 := by norm_num
    _ ≤ 60 * wheels d := by
        have := mul_le_mul_of_nonneg_left hw (by norm_num : (0:Int) ≤ 60)
        linarith
    _ = ∑ i ∈ Finset.range gridN, 60 * wheelTbl (d i) := by
        simp [wheels, statOf, Finset.mul_sum]
    _ ≤ mass d := Finset.sum_le_sum fun i _ => hsplit i

/-- A legal machine holds fuel. -/
theorem fuelCap_pos {d : Design} (h : Valid d) : 0 < fuelCap d := by
  obtain ⟨-, -, ht, -⟩ := h
  have hsplit : ∀ i, (4000 : Int) * tankTbl (d i) ≤ fuelTbl (d i) := by
    intro i
    match hk : d i with
    | 0 | 1 | 2 | 3 | 4 | 5 | 6 => decide
    | (n+7) => simp [fuelTbl, tankTbl]
  calc (0 : Int) < 4000 * 1 := by norm_num
    _ ≤ 4000 * tanks d := by
        have := mul_le_mul_of_nonneg_left ht (by norm_num : (0:Int) ≤ 4000)
        linarith
    _ = ∑ i ∈ Finset.range gridN, 4000 * tankTbl (d i) := by
        simp [tanks, statOf, Finset.mul_sum]
    _ ≤ fuelCap d := Finset.sum_le_sum fun i _ => hsplit i

/-- A legal machine has power. -/
theorem power_pos {d : Design} (h : Valid d) : 0 < power d := by
  obtain ⟨-, he, -, -⟩ := h
  have hsplit : ∀ i, (240000 : Int) * engineTbl (d i) ≤ powerTbl (d i) := by
    intro i
    match hk : d i with
    | 0 | 1 | 2 | 3 | 4 | 5 | 6 => decide
    | (n+7) => simp [powerTbl, engineTbl]
  calc (0 : Int) < 240000 * 1 := by norm_num
    _ ≤ 240000 * engines d := by
        have := mul_le_mul_of_nonneg_left he (by norm_num : (0:Int) ≤ 240000)
        linarith
    _ = ∑ i ∈ Finset.range gridN, 240000 * engineTbl (d i) := by
        simp [engines, statOf, Finset.mul_sum]
    _ ≤ power d := Finset.sum_le_sum fun i _ => hsplit i

/-! ## The figures the driving model uses -/

/-- What the course sees of a machine. -/
structure Machine where
  /-- Mass, in kilogrammes. -/
  mass : Int
  /-- Thrust at full throttle. -/
  power : Int
  /-- Millimetres of line a tick of full lock can buy. -/
  grip : Int
  /-- Carrying capacity, in kilogrammes. -/
  cap : Int
  /-- Fuel capacity, in millilitres. -/
  fuelCap : Int
  deriving Repr, DecidableEq

/-- The machine a design makes. -/
def rigOf (d : Design) : Machine :=
  ⟨mass d, power d, grip d, cap d, fuelCap d⟩

/-- A legal design makes a machine with positive mass, power and fuel. -/
theorem rigOf_pos {d : Design} (h : Valid d) :
    0 < (rigOf d).mass ∧ 0 < (rigOf d).power ∧ 0 < (rigOf d).fuelCap :=
  ⟨mass_pos h, power_pos h, fuelCap_pos h⟩

/-! ## A design is a solid

The blocks are voxels, so a design is also an object in the algebra of
`RequestProject/Voxel/Core.lean`: the union of unit boxes at the filled cells.
-/

open Voxel

/-- The unit box at a cell. -/
def cellBox (x y z : Nat) : Solid :=
  Solid.box ((x : ℤ), (y : ℤ), (z : ℤ)) ((x : ℤ), (y : ℤ), (z : ℤ))

/-- The coordinates of the grid, in cell-index order. -/
def coords : List (Nat × Nat × Nat) :=
  (List.range gridD).flatMap fun z =>
    (List.range gridH).flatMap fun y =>
      (List.range gridW).map fun x => (x, y, z)

theorem coords_length : coords.length = gridN := by decide

/-- The solid a design occupies: the union of the boxes of its filled cells. -/
def solidOf (d : Design) : Solid :=
  Solid.unions (coords.map fun c => if d (cellIdx c.1 c.2.1 c.2.2) = kEmpty
    then Solid.empty else cellBox c.1 c.2.1 c.2.2)

/-- A cell's box holds exactly its own lattice point. -/
theorem cellBox_eq_true {x y z : Nat} {v : Vox} :
    cellBox x y z v = true ↔ v = ((x : ℤ), (y : ℤ), (z : ℤ)) := by
  simp [cellBox, Solid.box, Prod.ext_iff, Vox.x, Vox.y, Vox.z]
  omega

/-- The empty design occupies nothing. -/
theorem solidOf_empty : solidOf emptyDesign = Solid.empty := by
  have h : ∀ l : List (Nat × Nat × Nat),
      Solid.unions (l.map fun c => if emptyDesign (cellIdx c.1 c.2.1 c.2.2) = kEmpty
        then Solid.empty else cellBox c.1 c.2.1 c.2.2) = Solid.empty := by
    intro l
    induction l with
    | nil => rfl
    | cons c t ih => funext v; simp [Solid.unions, emptyDesign] at ih ⊢; exact congrFun ih v
  exact h coords

/-- Two different cells of the grid never interpenetrate: the blocks of a
design are pairwise apart. -/
theorem solidOf_cells_apart {x y z x' y' z' : Nat}
    (h : cellIdx x y z ≠ cellIdx x' y' z') :
    Solid.Apart (cellBox x y z) (cellBox x' y' z') := by
  intro v
  by_contra hc
  push_neg at hc
  obtain ⟨h1, h2⟩ := hc
  simp only [ne_eq, Bool.not_eq_false, cellBox_eq_true] at h1 h2
  have he : ((x : ℤ), (y : ℤ), (z : ℤ)) = ((x' : ℤ), (y' : ℤ), (z' : ℤ)) := h1.symm.trans h2
  simp only [Prod.mk.injEq, Nat.cast_inj] at he
  exact h (by rw [he.1, he.2.1, he.2.2])

end Rig
end LifeTrac
