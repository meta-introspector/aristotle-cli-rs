/-
# ZOS 8×8 Grid and Narrative Vector

Formalization of the 8×8 eigenspace grid, the cell-to-position mapping,
and the R⁴ narrative vector structure from the Zero Ontology System.
-/
import Mathlib

open Finset

/-! ## 8×8 Grid Structure -/

/-- A cell in the 8×8 ZOS grid, using 0-indexed rows and columns. -/
structure GridCell where
  row : Fin 8
  col : Fin 8
  deriving DecidableEq, Fintype

/-- Convert a grid cell to its linear position (1-indexed).
    Cell (r, c) maps to position (r * 8 + c + 1). -/
def GridCell.linearPos (cell : GridCell) : ℕ :=
  cell.row.val * 8 + cell.col.val + 1

/-
The grid has exactly 64 cells.
-/
theorem grid_card : Fintype.card GridCell = 64 := by
  decide +revert

/-- The "Neo node" anchor cell: row 4, column 5 (0-indexed: row 3, col 4).
    This is Cell (4,5) in the 1-indexed notation of the ZOS document. -/
def neoCell : GridCell := ⟨⟨3, by omega⟩, ⟨4, by omega⟩⟩

/-
The Neo cell maps to linear position 29.
-/
theorem neoCell_pos : neoCell.linearPos = 29 := by
  rfl

/-- Position 29 is in Quadrant 2 of the grid.
    Quadrant 2 consists of rows 0-3 and columns 4-7 (0-indexed). -/
def inQuadrant2 (cell : GridCell) : Prop :=
  cell.row.val < 4 ∧ cell.col.val ≥ 4

theorem neoCell_in_quadrant2 : inQuadrant2 neoCell := by
  exact ⟨ by decide, by decide ⟩

/-! ## Grid Sieve Properties -/

/-
Column 3 (0-indexed, i.e. 1-indexed column 4): all positions are even.
-/
theorem column4_all_even (row : Fin 8) :
    Even (GridCell.linearPos ⟨row, ⟨3, by omega⟩⟩) := by
  native_decide +revert

/-- All odd-positioned cells survive the Prime 2 sieve. -/
def survivesS2 (cell : GridCell) : Prop :=
  ¬ Even cell.linearPos

/-
The Neo cell at position 29 survives the sieve.
-/
theorem neoCell_survives : survivesS2 neoCell := by
  exact fun h => by have := neoCell_pos; exact absurd h ( by simp +decide [*] ) ;

/-! ## Lattice Structure

The ZOS rejects "rigid tree" ontologies in favor of a "lattice" model.
A ZOS knowledge structure is formalized as a bounded lattice, supporting
joins (fluid merging) and meets (consensus). -/

/-- In any bounded lattice, the bottom element (Gaia/Void/0) is below all elements. -/
theorem zos_void_le [Lattice α] [BoundedOrder α] (a : α) : (⊥ : α) ≤ a :=
  bot_le

/-- In any bounded lattice, the top element (UU/Uranus/1) is above all elements. -/
theorem zos_uu_ge [Lattice α] [BoundedOrder α] (a : α) : a ≤ (⊤ : α) :=
  le_top

/-- Any two elements in a lattice have a join (supporting fluid merging). -/
theorem zos_lattice_has_join [Lattice α] (a b : α) : ∃ c : α, c = a ⊔ b :=
  ⟨a ⊔ b, rfl⟩

/-- Any two elements in a lattice have a meet (supporting consensus). -/
theorem zos_lattice_has_meet [Lattice α] (a b : α) : ∃ c : α, c = a ⊓ b :=
  ⟨a ⊓ b, rfl⟩

/-! ## Narrative Vector in R⁴ -/

/-- A narrative vector in the 4D semiospace (Version 4, associated with Muse 4 / Prime 7).
    Components represent the four narrative dimensions. -/
structure NarrativeVector where
  v₁ : ℝ  -- First narrative dimension
  v₂ : ℝ  -- Second narrative dimension
  v₃ : ℝ  -- Third narrative dimension
  v₄ : ℝ  -- Fourth narrative dimension

/-- The zero narrative vector (the "Void" state). -/
def NarrativeVector.zero : NarrativeVector := ⟨0, 0, 0, 0⟩

/-- Addition of narrative vectors (consensus merging). -/
def NarrativeVector.add (u v : NarrativeVector) : NarrativeVector :=
  ⟨u.v₁ + v.v₁, u.v₂ + v.v₂, u.v₃ + v.v₃, u.v₄ + v.v₄⟩

/-- Scalar multiplication of narrative vectors (amplitude modulation). -/
def NarrativeVector.smul (r : ℝ) (v : NarrativeVector) : NarrativeVector :=
  ⟨r * v.v₁, r * v.v₂, r * v.v₃, r * v.v₄⟩

/-- The squared norm of a narrative vector (resonance intensity). -/
noncomputable def NarrativeVector.normSq (v : NarrativeVector) : ℝ :=
  v.v₁^2 + v.v₂^2 + v.v₃^2 + v.v₄^2

/-
The norm squared is always non-negative.
-/
theorem NarrativeVector.normSq_nonneg (v : NarrativeVector) : 0 ≤ v.normSq := by
  exact add_nonneg ( add_nonneg ( add_nonneg ( sq_nonneg _ ) ( sq_nonneg _ ) ) ( sq_nonneg _ ) ) ( sq_nonneg _ )

/-
The zero vector has zero norm squared.
-/
theorem NarrativeVector.normSq_zero : NarrativeVector.zero.normSq = 0 := by
  exact show ( 0 : ℝ ) ^ 2 + 0 ^ 2 + 0 ^ 2 + 0 ^ 2 = 0 by norm_num;

/-
A vector with zero norm squared is the zero vector.
-/
theorem NarrativeVector.eq_zero_of_normSq_eq_zero (v : NarrativeVector)
    (h : v.normSq = 0) : v = NarrativeVector.zero := by
  -- If the sum of squares is zero, then each square is zero, so each component is zero.
  have h_components : v.v₁ = 0 ∧ v.v₂ = 0 ∧ v.v₃ = 0 ∧ v.v₄ = 0 := by
    unfold NarrativeVector.normSq at h;
    exact ⟨ by contrapose! h; positivity, by contrapose! h; positivity, by contrapose! h; positivity, by contrapose! h; positivity ⟩;
  cases v ; aesop