/-
PeriodicTable.lean — feeding the collected Lean size-data into the crystal map.

The earlier layers of this project did two complementary things:

* They **collected data** from Lean 4 core + Mathlib: every declaration was given a
  numeric *size signature* (the leaf count of its type, `SizeFinder` / `SizeSignature`),
  and a *shape* of subtree sizes (`ShapeFinder` / `ShapeAlgebra`).

* They built a **crystal mapping system**: the genuine Altland–Zirnbauer "tenfold way"
  periodic table of topological insulators and superconductors (`AZ/TenfoldWay.lean`,
  `AZ/CliffordK.lean`), with its two Bott clocks `ℤ₂` (complex / `KU`) and `ℤ₈`
  (real / `KO`), and the section `ShapeBott.realClassOfResidue : ZMod 8 → AZ.Class`
  that sends a clock residue to the symmetry class sitting at that position.

This file **wires the two together**: it sends each declaration's size signature `N`
through the real Bott clock and reads off the Altland–Zirnbauer symmetry class (the
"crystal" / periodic-table cell) it lands in, and the classifying K-group of that cell in
every spatial dimension.  This is exactly the assignment the `periodictable` executable
performs over the whole environment to produce the *periodic table of Lean 4 corelib +
Mathlib*; here we prove its mathematical backbone is faithful and genuinely periodic.

Headline results:

* `crystalCell N` — the AZ symmetry class a declaration of size `N` lands in.
* `crystalCell_realIndex` — *faithfulness*: the cell's Bott-clock position is exactly
  `N mod 8`, so the map loses nothing the clock can see.
* `crystalCell_isComplex_false`, `crystalCell_surjOnReals` — the cells are exactly the
  eight real classes, and **every** real class is populated by some size (the table is
  fully covered).
* `crystalCell_mod8` / `crystalCell_periodic8` — a whole period of size is invisible.
* `crystalCell_table` — the explicit eight-cell key (residue ↦ Cartan label).
* `crystalKGroup` and its periodicities `crystalKGroup_periodic8_dim` /
  `crystalKGroup_periodic8_size` — the topological invariant attached to each cell.
* `five_nontrivial_cells_per_dimension` — the tenfold-way headline transported to the
  table: in every dimension exactly five of the ten classes are topologically nontrivial.
* `dominant_sizes_cells` — the most common collected sizes (`1,2,3,4,5`) named as cells.
-/
import Mathlib
import RequestProject.SizeSignature
import RequestProject.ShapeBott

namespace PeriodicTable

open AZ ShapeBott

/-! ## The crystal cell of a declaration size -/

/-- The **crystal cell** of a declaration of size signature `N`: read `N` on the real
Bott clock `ℤ₈` and return the Altland–Zirnbauer real symmetry class sitting at that
residue.  This is the periodic-table cell the `periodictable` tool assigns to each
declaration. -/
def crystalCell (N : ℕ) : AZ.Class :=
  ShapeBott.realClassOfResidue (N : ZMod 8)

/-- The **complex shadow** of a declaration size on the period-`2` clock (`A`/`AIII`). -/
def crystalCellComplex (N : ℕ) : AZ.Class :=
  ShapeBott.complexClassOfResidue (N : ZMod 2)

/-! ## Faithfulness and coverage -/

/-- *Faithfulness.* The Bott-clock position (`realIndex`) of the cell assigned to a size
`N` is exactly `N mod 8`: the crystal map records precisely the residue the clock sees. -/
theorem crystalCell_realIndex (N : ℕ) :
    (crystalCell N).realIndex = (N : ZMod 8) := by
  unfold crystalCell
  exact ShapeBott.realIndex_realClassOfResidue _

/-- Every cell is one of the eight *real* Altland–Zirnbauer classes (never the two complex
classes `A`, `AIII`). -/
theorem crystalCell_isComplex_false (N : ℕ) :
    (crystalCell N).isComplex = false := by
  unfold crystalCell
  exact ShapeBott.realClassOfResidue_isComplex_false _

/-- *Coverage.* Every real Altland–Zirnbauer class is the crystal cell of some size: the
periodic table of Lean is fully populated in principle (take `N = c.realIndex.val`). -/
theorem crystalCell_surjOnReals (c : AZ.Class) (hc : c.isComplex = false) :
    crystalCell c.realIndex.val = c := by
  unfold crystalCell
  have : ((c.realIndex.val : ℕ) : ZMod 8) = c.realIndex := by
    simp [ZMod.natCast_val, ZMod.cast_id]
  rw [this]
  exact ShapeBott.realClassOfResidue_surjective_on_reals c hc

/-! ## Periodicity: a whole period of size is invisible -/

/-- The crystal cell depends on the size only through `N mod 8`. -/
theorem crystalCell_mod8 (N : ℕ) : crystalCell N = crystalCell (N % 8) := by
  unfold crystalCell
  have : ((N : ℕ) : ZMod 8) = ((N % 8 : ℕ) : ZMod 8) := by
    conv_lhs => rw [← Nat.div_add_mod N 8]
    push_cast
    rw [show (8 : ZMod 8) = 0 from by decide]; ring
  rw [this]

/-- **Period-8 invariance of the cells.** Adding a whole real period to a declaration's
size leaves its crystal cell unchanged. -/
theorem crystalCell_periodic8 (N : ℕ) : crystalCell (N + 8) = crystalCell N := by
  rw [crystalCell_mod8 (N + 8), crystalCell_mod8 N, Nat.add_mod_right]

/-! ## The explicit eight-cell key -/

/-- The explicit periodic-table key: the eight residues `0,…,7` name the eight real
classes in Bott-clock order. -/
theorem crystalCell_table :
    crystalCell 0 = .AI ∧ crystalCell 1 = .BDI ∧ crystalCell 2 = .D ∧
    crystalCell 3 = .DIII ∧ crystalCell 4 = .AII ∧ crystalCell 5 = .CII ∧
    crystalCell 6 = .C ∧ crystalCell 7 = .CI := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;> decide

/-! ## The classifying K-group of a cell -/

/-- The classifying K-group (topological invariant group) attached to a declaration of
size `N` in spatial dimension `d`: the periodic-table entry `classify` of its crystal
cell. -/
def crystalKGroup (N d : ℕ) : KGroup :=
  AZ.classify (crystalCell N) d

/-- The K-group depends on the dimension only through `d mod 8`. -/
theorem crystalKGroup_mod8_dim (N d : ℕ) :
    crystalKGroup N d = crystalKGroup N (d % 8) := by
  unfold crystalKGroup
  exact AZ.classify_mod8 _ d

/-- **Period-8 Bott periodicity in the dimension.** -/
theorem crystalKGroup_periodic8_dim (N d : ℕ) :
    crystalKGroup N (d + 8) = crystalKGroup N d := by
  unfold crystalKGroup
  exact AZ.classify_periodic8 _ d

/-- **Period-8 invariance in the size.** -/
theorem crystalKGroup_periodic8_size (N d : ℕ) :
    crystalKGroup (N + 8) d = crystalKGroup N d := by
  unfold crystalKGroup
  rw [crystalCell_periodic8]

/-! ## The tenfold-way headline, transported to the Lean periodic table -/

/-- **Five nontrivial cells in every dimension.** In every spatial dimension exactly five
of the ten Altland–Zirnbauer classes — equivalently, exactly five of the columns of the
Lean periodic table — carry a nontrivial topological invariant.  (Re-exported from
`AZ.five_nontrivial_per_dimension`.) -/
theorem five_nontrivial_cells_per_dimension (d : ℕ) :
    (Finset.univ.filter (fun c : AZ.Class => AZ.classify c d ≠ KGroup.null)).card = 5 :=
  AZ.five_nontrivial_per_dimension d

/-! ## The dominant collected sizes, named as cells

The size-data collected over Mathlib is dominated by the small sizes `2, 1, 4, 3, 5`
(in descending population order; see `size-out/sizes.txt`).  Here is what crystal cell
each of these dominant sizes lands in. -/

/-- The five most common collected sizes named as periodic-table cells:
`1 ↦ BDI`, `2 ↦ D`, `3 ↦ DIII`, `4 ↦ AII`, `5 ↦ CII`. -/
theorem dominant_sizes_cells :
    crystalCell 1 = .BDI ∧ crystalCell 2 = .D ∧ crystalCell 3 = .DIII ∧
    crystalCell 4 = .AII ∧ crystalCell 5 = .CII := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;> decide

end PeriodicTable
