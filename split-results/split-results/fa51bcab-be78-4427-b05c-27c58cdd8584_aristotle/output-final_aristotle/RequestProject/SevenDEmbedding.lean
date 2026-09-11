/-
SevenDEmbedding.lean — the 7D space as the primary ontology, and the embedding of the
term-relation graph into it.

The honest recalibration (`ShapeNarrative.SevenAct`, the empirical ℤ₇ resonance) is taken
here at face value: the **seven acts of a term's type-shape are its coordinates**.  We do not
project, we do not impose CRT constraints, we do not take Bott shadows.  Each term `t` carries
a canonical decomposition of its size word into seven consecutive *acts*, and the seven
*act-sizes*

  `t ↦ (a₁, a₂, a₃, a₄, a₅, a₆, a₇) ∈ ℕ⁷`

**are** its point in space.  This is the raw 7-act geometry, nothing else.

* **Vertices.** Each term `t` sits at `coord t : Fin 7 → ℕ`, the seven act-sizes of its size
  word (`coord`).
* **Arrows.** Each relation `t → u` is the 7D displacement vector `coord u − coord t`
  (`arrowVec`, valued in ℤ).
* **Clustering.** Terms are grouped by 7D proximity: the L¹ distance `dist7` is a genuine
  pseudometric (`dist7_self`, `dist7_comm`, `dist7_triangle`, `dist7_eq_zero_iff`), and
  "same cell" (identical coordinate) is an equivalence relation (`sameCell_equiv`).

Headline machine-checked facts about the embedding:

* `coord_sum` — *the embedding is faithful to total magnitude*: the seven act-sizes sum to the
  total size of the word; the partition into acts loses nothing.
* `arrow_telescope` — *the arrows compose*: the displacement along a path of relations is the
  difference of the endpoints' coordinates (a true 7D vector field, gradient of `coord`).
* `dist7_*` — the 7D L¹ geometry is a genuine pseudometric, so clustering by proximity is
  well-posed.
* `coord_of_sizeWord` / `coordShape` — the coordinate of a `ShapeAlgebra.Shape` is the
  coordinate of its size word, linking the geometry to the shape algebra.

This is the formal backbone of the `sevendfinder` executable, which assigns every Lean /
Mathlib declaration its 7D coordinate, embeds the dependency graph, clusters by 7D proximity,
and emits 2D slices for the map / periodic table.
-/
import Mathlib
import RequestProject.ShapeAlgebra
import RequestProject.ShapeNarrative

open Finset

namespace SevenD

/-! ## The canonical seven-act split of a size word

A word `l : List ℕ` (a term's pre-order list of subtree sizes) is split into seven consecutive
acts as evenly as possible.  The `i`-th boundary is `bdry L i = i·L / 7` (for `L = l.length`),
so the acts are the slices `[bdry L i, bdry L (i+1))`.  The `i`-th **act-size** is the sum of
the word over that slice — the magnitude of act `i`. -/

/-- The prefix sum of a word: the total size carried by its first `m` entries. -/
def psum (l : List Nat) (m : Nat) : Nat := (l.take m).sum

/-- The `i`-th of the seven even boundaries of a length-`L` word: `i·L / 7`. -/
def bdry (L i : Nat) : Nat := i * L / 7

/-- **The 7D coordinate of a term.** `coord l i` is the *act-size* of the `i`-th of the seven
consecutive acts of the word `l`: the total size carried by the slice `[bdry i, bdry (i+1))`.
This is the canonical point `t ↦ (a₁,…,a₇) ∈ ℕ⁷` the whole embedding is built on. -/
def coord (l : List Nat) (i : Fin 7) : Nat :=
  psum l (bdry l.length (i.val + 1)) - psum l (bdry l.length i.val)

theorem bdry_zero (L : Nat) : bdry L 0 = 0 := by simp [bdry]

theorem bdry_seven (L : Nat) : bdry L 7 = L := by simp [bdry]

theorem bdry_mono (L : Nat) : Monotone (bdry L) := fun _ _ hab =>
  Nat.div_le_div_right (Nat.mul_le_mul_right _ hab)

theorem psum_mono (l : List Nat) : Monotone (psum l) := by
  intro a b hab
  unfold psum
  have hpre : (l.take a) <+: (l.take b) := by
    have : (l.take b).take a = l.take a := by rw [List.take_take]; simp [Nat.min_eq_left hab]
    rw [← this]; exact List.take_prefix a (l.take b)
  exact List.Sublist.sum_le_sum hpre.sublist (fun x _ => Nat.zero_le x)

/-- **Faithfulness of the embedding to total magnitude.** The seven act-sizes sum to the total
size of the word: partitioning a term's size word into seven acts loses none of its mass. -/
theorem coord_sum (l : List Nat) : ∑ i : Fin 7, coord l i = l.sum := by
  set g : ℕ → ℕ := fun i => psum l (bdry l.length i) with hg
  have hgmono : Monotone g := (psum_mono l).comp (bdry_mono l.length)
  have hstep : (∑ i : Fin 7, coord l i) = ∑ i ∈ Finset.range 7, (g (i + 1) - g i) :=
    Fin.sum_univ_eq_sum_range (fun k : ℕ => g (k + 1) - g k) 7
  rw [hstep, Finset.sum_range_tsub hgmono]
  simp only [hg, bdry_seven, bdry_zero]
  simp [psum, List.take_length]

/-! ## Arrows: relations as 7D displacement vectors -/

/-- **The arrow of a relation `t → u`.** Its 7D displacement vector `coord u − coord t`,
valued in ℤ (coordinates can decrease as well as increase along an edge). -/
def arrowVec (t u : List Nat) (i : Fin 7) : ℤ := (coord u i : ℤ) - (coord t i : ℤ)

/-- An arrow run backwards is the negated arrow. -/
theorem arrowVec_swap (t u : List Nat) (i : Fin 7) :
    arrowVec u t i = - arrowVec t u i := by simp [arrowVec]

/-- A self-loop is the zero vector. -/
theorem arrowVec_self (t : List Nat) (i : Fin 7) : arrowVec t t i = 0 := by simp [arrowVec]

/-- **Arrows compose (telescoping).** Walking a path of relations `w 0 → w 1 → … → w n`, the
total 7D displacement is exactly the difference of the endpoints' coordinates: the arrow field
is the discrete gradient of `coord`. -/
theorem arrow_telescope (w : ℕ → List Nat) (n : ℕ) (i : Fin 7) :
    ∑ j ∈ Finset.range n, arrowVec (w j) (w (j + 1)) i
      = (coord (w n) i : ℤ) - (coord (w 0) i : ℤ) := by
  simpa [arrowVec] using Finset.sum_range_sub (fun j => (coord (w j) i : ℤ)) n

/-! ## Clustering: the 7D L¹ geometry -/

/-- **The 7D L¹ distance** between two terms: the sum over the seven acts of the absolute
coordinate differences.  This is the proximity used for clustering. -/
noncomputable def dist7 (t u : List Nat) : ℤ := ∑ i : Fin 7, |(coord t i : ℤ) - coord u i|

theorem dist7_self (t : List Nat) : dist7 t t = 0 := by simp [dist7]

theorem dist7_comm (t u : List Nat) : dist7 t u = dist7 u t := by
  simp only [dist7]; exact Finset.sum_congr rfl fun i _ => abs_sub_comm _ _

theorem dist7_nonneg (t u : List Nat) : 0 ≤ dist7 t u :=
  Finset.sum_nonneg fun _ _ => abs_nonneg _

theorem dist7_triangle (t u v : List Nat) : dist7 t v ≤ dist7 t u + dist7 u v := by
  simp only [dist7, ← Finset.sum_add_distrib]
  apply Finset.sum_le_sum; intro i _
  calc |(coord t i : ℤ) - coord v i|
      = |((coord t i : ℤ) - coord u i) + ((coord u i : ℤ) - coord v i)| := by ring_nf
    _ ≤ |(coord t i : ℤ) - coord u i| + |(coord u i : ℤ) - coord v i| := abs_add_le _ _

/-- The L¹ distance vanishes exactly when the two terms occupy the same 7D point. -/
theorem dist7_eq_zero_iff (t u : List Nat) :
    dist7 t u = 0 ↔ ∀ i : Fin 7, coord t i = coord u i := by
  rw [dist7, Finset.sum_eq_zero_iff_of_nonneg fun _ _ => abs_nonneg _]
  constructor
  · intro h i
    have hi : |(coord t i : ℤ) - coord u i| = 0 := h i (Finset.mem_univ i)
    have : (coord t i : ℤ) - coord u i = 0 := by simpa [abs_eq_zero] using hi
    omega
  · intro h i _; rw [h i]; simp

/-- **A 7D cell.** Two terms occupy the *same cell* when their seven act-sizes agree — they
land on the same point of the 7D lattice. -/
def SameCell (t u : List Nat) : Prop := ∀ i : Fin 7, coord t i = coord u i

/-- "Same 7D cell" is an equivalence relation, so the lattice clustering is well-defined. -/
theorem sameCell_equiv : Equivalence SameCell where
  refl _ _ := rfl
  symm h i := (h i).symm
  trans h1 h2 i := (h1 i).trans (h2 i)

/-- Zero distance is exactly occupying the same cell. -/
theorem dist7_eq_zero_iff_sameCell (t u : List Nat) : dist7 t u = 0 ↔ SameCell t u :=
  dist7_eq_zero_iff t u

/-! ## Link to the shape algebra: the coordinate of a `Shape`

The 7D coordinate of a `ShapeAlgebra.Shape` is the coordinate of its size word, so the geometry
sits directly on top of the shape algebra developed earlier. -/

/-- The 7D coordinate of a shape: the coordinate of its `sizeWord`. -/
def coordShape (s : SizeSignature.Shape) (i : Fin 7) : Nat :=
  coord (ShapeAlgebra.sizeWord s) i

theorem coord_of_sizeWord (s : SizeSignature.Shape) (i : Fin 7) :
    coordShape s i = coord (ShapeAlgebra.sizeWord s) i := rfl

/-- The seven act-sizes of a shape sum to the total mass of its size word. -/
theorem coordShape_sum (s : SizeSignature.Shape) :
    ∑ i : Fin 7, coordShape s i = (ShapeAlgebra.sizeWord s).sum :=
  coord_sum _

end SevenD
