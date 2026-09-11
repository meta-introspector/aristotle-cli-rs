import RequestProject.Craft.RigKernelSpec

/-!
# `setup` totals up the design grid

`setup` is the one function of the kernel that reads the 16 × 16 design grid.  It
has no loop: the pass over the 256 cells is unrolled, and for each cell it looks
the cell's byte up in five constant tables and adds the five entries into five
running totals.  This file gives that pass a meaning — a plain sum over the cells —
and then matches the sum against `Rig.Params.of` of the design the grid holds.

The bridge between the two is `sumCells_valAt`: summing a per-kind quantity over
all 256 cells of a grid that holds the design `d` gives the same answer as summing
it over the blocks of `d`, provided no two blocks share a cell and every block is
inside the grid.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace RigKernel

open RigVM Rig

/-! ## Sums over the cells of the grid -/

/-- `sumCells g n` is `g 0 + g 1 + ⋯ + g (n-1)`, associated the way the unrolled
pass over the grid accumulates it. -/
def sumCells (g : Nat → Nat) : Nat → Nat
  | 0 => 0
  | n + 1 => sumCells g n + g n

theorem sumCells_congr {g h : Nat → Nat} :
    ∀ (n : Nat), (∀ c, c < n → g c = h c) → sumCells g n = sumCells h n
  | 0, _ => rfl
  | n + 1, e => by
      rw [sumCells, sumCells, sumCells_congr n (fun c hc => e c (by omega)), e n (by omega)]

theorem sumCells_zero (n : Nat) : sumCells (fun _ => 0) n = 0 := by
  induction n with
  | zero => rfl
  | succ n ih => rw [sumCells, ih]

theorem sumCells_le {g : Nat → Nat} (hb : ∀ c, g c ≤ 255) :
    ∀ n : Nat, sumCells g n ≤ 255 * n
  | 0 => by simp [sumCells]
  | n + 1 => by
      have := sumCells_le hb n
      have := hb n
      rw [sumCells]
      omega

/-- Two functions that agree away from one cell, where the second is zero: the sums
differ by exactly the value at that cell. -/
theorem sumCells_update {g h : Nat → Nat} {c₀ : Nat} (e : ∀ c, c ≠ c₀ → g c = h c)
    (hz : h c₀ = 0) : ∀ (n : Nat), c₀ < n → sumCells g n = sumCells h n + g c₀
  | 0, hlt => absurd hlt (by omega)
  | n + 1, hlt => by
      rcases Nat.lt_or_ge c₀ n with hc | hc
      · rw [sumCells, sumCells, sumCells_update e hz n hc, e n (by omega)]
        omega
      · have hc0 : c₀ = n := by omega
        subst hc0
        rw [sumCells, sumCells, hz, sumCells_congr c₀ (fun c hcn => e c (by omega))]
        omega

/-! ## What the grid holds -/

/-- The kind sitting in a cell of the grid, if any. -/
def kindAt (d : Design) (c : Nat) : Option Kind :=
  (d.find? (fun b => b.pos == c)).map Block.kind

/-- A per-kind quantity read off a cell; an empty cell contributes nothing. -/
def valAt (f : Kind → Nat) (d : Design) (c : Nat) : Nat := (kindAt d c).elim 0 f

@[simp] theorem kindAt_nil (c : Nat) : kindAt [] c = none := rfl

theorem kindAt_cons (b : Block) (d : Design) (c : Nat) :
    kindAt (b :: d) c = if b.pos = c then some b.kind else kindAt d c := by
  unfold kindAt
  by_cases h : b.pos = c <;> simp [h]

theorem kindAt_eq_none {d : Design} {p : Nat} (h : p ∉ d.cells) : kindAt d p = none := by
  unfold kindAt
  have : d.find? (fun b => b.pos == p) = none := by
    rw [List.find?_eq_none]
    intro x hx
    simp only [beq_iff_eq]
    intro hxp
    exact h (by simpa [Design.cells, ← hxp] using List.mem_map_of_mem (f := Block.pos) hx)
  rw [this, Option.map_none]

/-- Summing a per-kind quantity over the 256 cells of the grid is summing it over
the blocks of the design. -/
theorem sumCells_valAt (f : Kind → Nat) :
    ∀ (d : Design), (∀ b ∈ d, b.inBounds = true) → d.cells.Nodup →
      sumCells (valAt f d) 256 = (d.map (fun b => f b.kind)).sum
  | [], _, _ => by
      simpa [valAt] using sumCells_zero 256
  | b :: d, hin, hnd => by
      have hcells : Design.cells (b :: d) = b.pos :: Design.cells d := rfl
      rw [hcells, List.nodup_cons] at hnd
      have hrest : sumCells (valAt f d) 256 = (d.map (fun x => f x.kind)).sum :=
        sumCells_valAt f d (fun x hx => hin x (List.mem_cons_of_mem _ hx)) hnd.2
      have hpos : b.pos < 256 := by
        have := Block.pos_lt (hin b (by simp))
        simpa [gridW] using this
      have hz : valAt f d b.pos = 0 := by
        simp [valAt, kindAt_eq_none hnd.1]
      have hg : valAt f (b :: d) b.pos = f b.kind := by
        simp [valAt, kindAt_cons]
      have he : ∀ c, c ≠ b.pos → valAt f (b :: d) c = valAt f d c := by
        intro c hc
        simp only [valAt, kindAt_cons, if_neg (fun h : b.pos = c => hc h.symm)]
      rw [sumCells_update he hz 256 hpos, hg, hrest, List.map_cons, List.sum_cons]
      omega

/-! ## What memory holds -/

/-- One of the five per-kind constant tables sits at `base`, with a zero in the slot
for "no block". -/
structure TableAt (m : Mem) (base : Nat) (f : Kind → Nat) : Prop where
  zero : m.byte base = 0
  val : ∀ k : Kind, m.byte (base + k.code) = f k

/-- All five constant tables are in place. -/
structure TablesAt (m : Mem) : Prop where
  mass : TableAt m tblMass Kind.mass
  thrust : TableAt m tblThrust Kind.thrust
  lift : TableAt m tblLift Kind.lift
  fuel : TableAt m tblFuel Kind.fuelUnits
  payload : TableAt m tblPayload Kind.payload

/-- The design grid holds the design `d`. -/
structure GridAt (m : Mem) (d : Design) : Prop where
  cell : ∀ c, c < 256 → m.byte (gridAddr + c) = valAt Kind.code d c

/-- Looking a grid cell up in a constant table gives that cell's contribution. -/
theorem byte_tbl_grid {m : Mem} {base : Nat} {f : Kind → Nat} (ht : TableAt m base f)
    {d : Design} (hg : GridAt m d) {c : Nat} (hc : c < 256) :
    m.byte (base + m.byte (gridAddr + c)) = valAt f d c := by
  rw [hg.cell c hc]
  unfold valAt
  cases h : kindAt d c with
  | none => simpa using ht.zero
  | some k => simpa using ht.val k

end RigKernel
