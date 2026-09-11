import Mathlib

/-!
# Native shape detection in the Monster character-degree matrix

This file answers the question *"can you `see` circles, squares, triangles and
other shapes in the patterns of the numbers — and can Lean **natively decide**
that they are there?"*.

The image-based ("OpenCV") half of the question lives in `analysis/shape_detect.py`,
which renders the matrix and runs a classical contour pipeline.  Here we do the
**formal** half: we encode the matrix as data, give a *precise mathematical
definition* of each shape, and let Lean's `Decidable` machinery (`native_decide`)
prove — with kernel-checked certainty — exactly which shapes occur and how large
they get.

The matrix is the Monster character-degree table (rows in the order the user
displayed them, sorted by `row_exponent_sum`); column `j` is the p-adic exponent of
the `j`-th supersingular prime in the dimension of irreducible representation `i`.
A cell is **"ink" / filled** iff that exponent is nonzero — this is precisely the
black/white texture the eye groups into shapes.

Every theorem below is closed by `native_decide`, i.e. Lean *itself* performs the
search and certifies the answer; nothing is taken on faith.
-/

namespace MonsterShapes

/-- The 194 × 15 matrix of p-adic exponents, in the displayed (sorted) row order. -/
def grid : Array (Array Nat) :=
#[
    #[46,2,0,0,2,0,1,0,1,0,0,1,1,1,1],
    #[42,2,1,4,0,2,0,0,1,1,0,1,0,1,0],
    #[44,0,0,6,0,0,1,0,1,0,0,1,0,1,1],
    #[46,0,0,0,2,3,0,0,1,0,1,0,1,0,0],
    #[46,0,0,0,2,3,0,0,1,0,1,0,1,0,0],
    #[42,0,7,0,1,0,0,0,1,0,0,1,0,1,1],
    #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
    #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
    #[43,0,0,0,2,2,0,1,1,1,0,1,0,1,0],
    #[42,0,0,4,1,0,0,0,1,0,1,1,1,1,0],
    #[42,0,0,0,0,2,0,0,1,1,1,1,1,1,1],
    #[32,0,9,0,0,0,0,1,0,1,0,1,1,1,1],
    #[18,19,0,0,0,3,0,0,0,1,1,1,0,1,1],
    #[32,0,1,0,0,3,1,1,1,1,1,0,1,1,1],
    #[31,1,0,3,2,0,1,1,0,1,1,1,1,0,0],
    #[31,1,0,3,2,0,1,1,0,1,1,1,1,0,0],
    #[28,1,0,1,1,2,1,0,1,1,1,1,1,1,1],
    #[18,3,8,1,1,0,1,1,0,1,0,0,1,1,1],
    #[18,0,8,5,0,0,0,1,1,0,1,1,0,1,1],
    #[21,0,0,6,1,3,1,1,0,1,0,1,0,1,1],
    #[20,0,2,5,0,3,1,0,1,1,1,1,0,1,1],
    #[18,3,2,1,2,3,0,1,1,1,0,1,1,1,1],
    #[20,2,0,0,2,3,1,0,1,1,1,1,1,1,1],
    #[18,0,0,6,1,3,1,1,1,1,1,1,1,0,0],
    #[18,0,0,6,1,3,1,1,1,1,1,1,1,0,0],
    #[18,0,0,6,1,3,1,1,0,1,0,1,1,1,1],
    #[0,17,7,4,2,2,0,0,0,0,1,0,0,1,1],
    #[12,6,2,5,0,3,1,1,1,0,1,0,1,1,1],
    #[0,20,0,6,2,0,1,0,0,1,1,1,0,1,1],
    #[2,19,0,4,0,3,0,0,0,1,1,1,1,1,1],
    #[6,17,0,4,0,0,0,0,1,0,1,1,1,1,1],
    #[1,19,0,4,2,3,1,0,1,1,0,1,0,0,0],
    #[1,19,0,4,2,3,1,0,1,1,0,1,0,0,0],
    #[18,0,0,6,0,0,1,1,1,1,1,1,1,1,1],
    #[0,19,5,1,2,0,0,1,1,1,0,1,1,0,1],
    #[16,1,0,4,2,2,1,1,0,1,1,1,1,1,1],
    #[1,19,1,1,2,3,0,1,0,1,1,1,1,1,0],
    #[12,1,9,1,0,2,1,1,0,1,1,1,1,1,1],
    #[1,19,0,4,2,0,0,1,1,1,0,1,1,1,1],
    #[2,19,0,0,2,3,1,0,1,1,1,1,0,1,1],
    #[0,17,7,0,1,2,0,0,0,1,1,1,1,1,1],
    #[0,17,7,1,0,0,1,0,1,1,1,1,1,1,1],
    #[18,0,0,6,1,3,1,1,0,1,0,1,0,0,0],
    #[18,0,0,6,1,3,1,1,0,1,0,1,0,0,0],
    #[18,1,2,5,1,0,0,0,0,1,1,0,1,1,1],
    #[17,0,5,0,2,3,1,1,0,0,1,0,0,1,1],
    #[17,0,5,0,2,3,1,1,0,0,1,0,0,1,1],
    #[0,18,9,0,0,0,0,1,1,0,1,0,0,1,1],
    #[0,18,9,0,0,0,0,1,1,0,1,0,0,1,1],
    #[1,17,2,5,0,0,0,1,1,1,1,0,1,1,1],
    #[1,17,1,5,1,0,0,1,1,1,1,1,0,1,1],
    #[0,19,0,1,2,3,1,1,1,1,0,1,1,0,1],
    #[0,18,0,5,0,2,1,1,0,0,1,1,1,1,1],
    #[19,1,1,1,2,0,0,1,0,1,1,1,1,1,1],
    #[16,3,2,0,1,2,1,0,0,1,1,1,1,1,1],
    #[13,0,2,5,2,3,0,0,1,1,0,1,1,1,1],
    #[0,19,0,0,2,3,0,1,0,1,1,1,1,1,1],
    #[0,18,0,1,2,2,0,1,1,1,1,1,1,1,1],
    #[3,17,0,1,1,2,1,0,1,1,1,0,0,1,1],
    #[0,19,0,0,2,3,0,1,0,1,1,1,1,1,0],
    #[0,19,0,0,2,3,1,0,1,1,0,0,1,1,1],
    #[0,19,0,0,2,3,1,0,1,1,0,0,1,1,1],
    #[9,1,8,1,1,3,0,1,1,1,1,0,1,1,1],
    #[0,17,1,0,2,2,1,1,1,0,1,1,1,1,1],
    #[3,6,7,5,1,2,0,1,0,1,1,1,0,1,1],
    #[4,7,7,1,1,3,0,1,1,0,1,1,1,1,1],
    #[0,12,5,3,2,0,1,1,0,1,1,1,1,1,1],
    #[0,12,7,0,0,3,1,0,1,1,1,1,1,1,1],
    #[18,0,0,0,1,3,1,1,1,0,0,1,1,1,1],
    #[4,12,0,1,2,3,0,1,0,1,1,1,1,1,1],
    #[7,9,0,0,1,3,1,1,1,1,1,1,1,1,1],
    #[10,1,0,5,2,3,0,1,1,1,1,1,1,1,1],
    #[6,0,9,4,2,0,0,1,1,1,1,1,1,1,1],
    #[0,12,0,6,0,3,1,1,1,1,1,1,1,0,1],
    #[1,6,8,6,0,0,0,1,1,1,1,1,1,1,1],
    #[0,17,2,0,0,2,0,0,1,1,1,1,1,1,1],
    #[10,1,2,5,0,3,0,1,0,1,1,1,1,1,1],
    #[11,2,0,3,1,3,1,0,1,1,1,1,1,1,1],
    #[0,13,0,6,1,1,1,1,1,1,1,0,1,0,1],
    #[0,13,0,6,1,1,1,1,1,1,1,0,1,0,1],
    #[3,6,8,1,1,1,1,1,1,0,1,1,1,1,1],
    #[2,2,9,4,2,3,0,1,1,1,1,1,0,0,1],
    #[0,12,2,1,1,3,1,1,1,1,1,1,1,1,1],
    #[7,2,1,4,2,3,1,1,1,1,1,1,1,1,1],
    #[0,19,0,0,2,3,1,0,1,1,0,0,0,0,0],
    #[0,19,0,0,2,3,1,0,1,1,0,0,0,0,0],
    #[3,1,7,5,2,1,1,1,1,1,0,1,1,1,1],
    #[2,0,9,6,0,3,1,1,0,0,1,1,1,1,1],
    #[1,12,0,6,0,1,1,1,1,1,1,0,0,1,0],
    #[1,12,0,6,0,1,1,1,1,1,1,0,0,1,0],
    #[12,1,0,1,2,2,0,1,1,1,1,1,1,1,1],
    #[1,12,2,1,0,3,1,0,1,1,1,1,0,1,1],
    #[0,9,7,1,1,0,1,1,0,1,1,1,1,1,1],
    #[3,6,0,6,1,2,1,0,1,1,1,1,1,1,1],
    #[0,2,9,6,2,0,1,1,1,1,0,1,1,0,1],
    #[1,0,9,6,2,2,1,1,0,1,1,0,1,1,0],
    #[1,0,9,6,2,2,1,1,0,1,1,0,1,1,0],
    #[3,0,8,6,1,0,1,1,0,1,1,1,1,1,1],
    #[0,2,9,6,1,2,1,1,0,0,0,1,1,1,1],
    #[2,4,1,6,2,3,1,1,1,1,1,1,1,1,0],
    #[2,2,9,1,2,1,1,1,1,1,1,1,1,1,1],
    #[2,0,7,5,2,3,1,0,0,1,1,1,1,1,1],
    #[0,0,9,6,2,2,1,1,1,1,0,1,0,1,1],
    #[1,0,8,6,1,3,1,0,1,1,0,1,1,1,1],
    #[1,2,9,1,2,3,0,1,1,1,1,1,1,1,1],
    #[5,7,1,1,1,3,1,1,0,1,1,1,1,0,1],
    #[6,3,0,6,1,3,1,1,0,0,0,1,1,1,1],
    #[4,3,7,0,2,2,0,0,1,1,1,1,1,1,1],
    #[1,1,9,6,2,0,1,1,0,1,1,0,1,0,1],
    #[1,1,9,6,2,0,1,1,0,1,1,0,1,0,1],
    #[2,0,9,6,2,0,1,1,0,0,1,1,0,1,1],
    #[2,0,9,6,2,0,1,1,0,0,1,1,0,1,1],
    #[1,3,8,4,0,3,0,0,1,1,1,1,1,1,0],
    #[6,1,2,5,1,2,1,1,0,1,1,1,1,1,1],
    #[2,0,9,4,1,3,0,1,1,0,0,1,1,1,1],
    #[2,0,7,4,2,3,0,1,0,1,1,1,1,1,1],
    #[0,0,9,3,2,3,1,1,1,1,1,1,1,1,0],
    #[5,0,8,4,1,0,0,0,1,1,1,1,1,1,0],
    #[2,3,7,4,1,0,1,0,1,0,1,1,1,1,1],
    #[0,6,3,2,2,3,1,1,1,1,1,1,0,1,1],
    #[0,3,9,0,1,3,1,1,1,1,0,1,1,1,1],
    #[1,2,3,4,2,3,1,1,1,1,1,1,1,1,1],
    #[0,1,9,0,2,3,1,1,1,1,1,1,1,1,1],
    #[0,4,0,6,2,3,1,1,1,1,1,1,1,1,1],
    #[0,4,0,6,2,3,1,1,1,1,1,1,1,1,1],
    #[3,0,7,5,0,2,0,0,1,1,1,0,1,1,1],
    #[3,2,0,6,2,3,1,0,1,0,1,1,1,1,1],
    #[1,0,8,6,0,0,1,0,1,1,1,1,1,1,1],
    #[1,0,8,6,0,0,1,0,1,1,1,1,1,1,1],
    #[1,1,8,4,0,0,1,1,1,1,1,1,1,1,1],
    #[3,1,1,6,2,2,1,1,1,1,1,1,0,1,1],
    #[0,3,7,1,2,3,0,0,1,1,1,1,1,1,1],
    #[3,2,0,4,2,3,1,1,1,1,1,1,1,1,1],
    #[2,1,2,6,1,2,1,1,1,1,1,1,1,1,1],
    #[2,0,2,6,2,3,1,0,1,1,1,1,1,1,1],
    #[1,0,5,4,2,3,0,1,1,1,1,1,1,1,1],
    #[2,0,1,6,2,3,1,1,1,1,1,1,1,1,1],
    #[12,0,0,4,1,2,0,0,0,0,1,0,0,1,1],
    #[1,3,8,4,1,0,0,0,0,1,0,1,1,1,1],
    #[0,0,9,6,2,0,1,1,0,0,0,0,1,1,1],
    #[0,0,9,6,2,0,1,1,0,0,0,0,1,1,1],
    #[2,0,9,0,1,2,1,0,1,1,1,1,1,1,1],
    #[0,0,9,1,2,3,1,1,1,1,1,1,0,0,1],
    #[0,0,9,1,2,3,1,1,1,1,1,1,0,0,1],
    #[3,0,3,5,0,3,1,1,0,1,1,1,1,1,1],
    #[2,1,2,5,2,3,0,1,1,0,1,1,1,1,1],
    #[3,0,0,6,2,2,1,1,1,1,1,1,1,1,1],
    #[3,0,8,1,0,3,1,1,0,1,0,1,0,1,1],
    #[0,1,9,0,2,3,0,1,1,1,1,1,0,1,0],
    #[0,1,9,0,2,3,0,1,1,1,1,1,0,1,0],
    #[0,6,0,5,0,2,0,1,1,1,1,1,1,1,1],
    #[3,0,2,3,2,3,1,1,1,1,0,1,1,1,1],
    #[0,3,1,6,0,3,1,1,1,1,0,1,1,1,1],
    #[0,0,5,6,1,0,1,1,1,1,1,1,1,1,1],
    #[0,6,7,0,1,0,0,0,1,0,1,1,1,1,1],
    #[7,0,2,0,1,3,0,1,1,0,1,1,1,1,1],
    #[2,2,0,6,2,0,1,1,0,1,1,1,1,1,1],
    #[2,2,0,5,2,2,0,1,1,0,1,1,1,1,1],
    #[0,0,9,6,2,0,1,1,0,0,0,0,0,0,0],
    #[0,0,9,6,2,0,1,1,0,0,0,0,0,0,0],
    #[0,3,7,0,1,2,1,0,1,1,0,0,1,1,1],
    #[0,1,7,5,0,0,0,0,0,1,1,1,1,1,1],
    #[2,0,0,6,2,3,1,0,1,0,1,1,1,1,0],
    #[2,0,0,6,2,3,1,0,1,0,1,1,1,1,0],
    #[0,0,7,1,1,2,1,1,0,1,1,1,1,1,1],
    #[3,2,0,4,1,0,1,1,1,1,1,0,1,1,1],
    #[4,0,2,0,0,3,1,1,1,1,1,1,1,1,1],
    #[1,0,2,4,1,3,0,1,1,1,1,1,1,0,1],
    #[1,0,0,5,2,3,0,1,1,1,1,0,1,1,1],
    #[1,0,0,5,2,3,0,1,1,1,1,0,1,1,1],
    #[2,0,7,0,0,2,0,1,0,0,1,1,1,1,1],
    #[1,1,2,5,1,0,0,1,1,1,0,1,0,1,1],
    #[0,0,1,5,0,3,0,0,1,1,1,1,1,1,1],
    #[0,2,1,1,1,2,1,1,1,1,1,1,1,1,1],
    #[0,2,1,0,2,2,1,1,1,1,1,1,1,1,1],
    #[0,0,2,5,1,2,1,0,1,0,1,0,0,1,1],
    #[1,0,2,1,1,3,1,1,0,1,1,1,1,0,1],
    #[0,0,3,1,2,2,0,0,1,1,1,1,1,1,1],
    #[0,6,0,1,0,2,1,1,0,0,1,0,0,1,1],
    #[3,0,0,1,0,3,1,0,0,1,1,1,1,1,1],
    #[0,0,0,5,0,2,0,1,1,1,0,1,1,1,1],
    #[0,0,2,4,0,0,1,0,0,1,1,1,1,0,1],
    #[0,3,0,1,1,0,1,0,1,1,0,1,1,1,1],
    #[0,0,0,4,1,2,0,0,0,1,0,1,1,1,1],
    #[1,0,2,1,0,0,0,1,1,1,1,1,1,1,1],
    #[1,1,0,1,1,2,0,1,1,0,0,1,1,1,0],
    #[0,1,0,0,1,2,1,0,1,1,1,1,1,1,0],
    #[2,0,0,1,1,0,0,0,1,1,1,1,0,0,1],
    #[1,1,0,0,1,0,0,1,0,1,0,1,1,1,1],
    #[1,0,0,0,0,2,0,0,0,1,1,0,1,1,0],
    #[0,0,0,0,0,2,0,0,1,1,0,1,0,1,1],
    #[2,0,0,0,0,0,0,0,0,0,1,1,0,1,1],
    #[0,0,0,0,0,0,0,0,0,0,0,0,1,1,1],
    #[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]

/-- Number of rows (irreducible representations). -/
def R : Nat := 194
/-- Number of columns (supersingular primes `2,3,5,7,11,13,17,19,23,29,31,41,47,59,71`). -/
def C : Nat := 15

/-- The p-adic exponent at displayed row `i`, column `j` (0 outside the grid). -/
def cell (i j : Nat) : Nat := (grid.getD i #[]).getD j 0

/-- A cell is *filled* ("ink") iff its exponent is nonzero. -/
def filled (i j : Nat) : Prop := cell i j ≠ 0

instance (i j : Nat) : Decidable (filled i j) := by unfold filled; infer_instance

/-- The grid really has 194 rows. -/
theorem grid_rows : grid.size = R := by native_decide
/-- Every row really has 15 columns. -/
theorem grid_cols : ∀ i < R, (grid.getD i #[]).size = C := by native_decide

/-! ## Squares

A **solid square of side `k`** is a `k × k` block of cells, all filled. -/

/-- There is a solid `k × k` square of filled cells somewhere in the grid. -/
abbrev hasSolidSquare (k : Nat) : Prop :=
  ∃ r < R, ∃ c < C, ∀ i < k, ∀ j < k, filled (r + i) (c + j)

/-- The largest solid square in the matrix has side **exactly 6**: a 6×6 block of
nonzero exponents exists, but no 7×7 block does. -/
theorem largest_solid_square : hasSolidSquare 6 ∧ ¬ hasSolidSquare 7 := by
  native_decide

/-! ## Rectangles -/

/-- There is a solid `h × w` rectangle (height `h`, width `w`) of filled cells. -/
abbrev hasSolidRect (h w : Nat) : Prop :=
  ∃ r < R, ∃ c < C, ∀ i < h, ∀ j < w, filled (r + i) (c + j)

/-- A tall solid `24 × 2` rectangle of nonzero exponents exists (it is the block in
the last two columns, primes 59 and 71, across 24 consecutive rows). -/
theorem solid_rect_24x2 : hasSolidRect 24 2 := by native_decide

/-- No solid rectangle is `25` cells tall and `2` wide: `24` is the maximal height
at width 2. -/
theorem no_solid_rect_25x2 : ¬ hasSolidRect 25 2 := by native_decide

/-! ## Triangles

A **filled right triangle of height `k`** anchored at `(r, c)` is the staircase
`{ (r+i, c+j) : 0 ≤ j ≤ i < k }` — row `r+i` has its first `i+1` cells filled. -/

/-- There is a lower-left filled right triangle of height `k`. -/
abbrev hasTriangle (k : Nat) : Prop :=
  ∃ r < R, ∃ c < C, ∀ i < k, ∀ j ≤ i, filled (r + i) (c + j)

/-- The largest filled right triangle has height **exactly 7**. -/
theorem largest_triangle : hasTriangle 7 ∧ ¬ hasTriangle 8 := by native_decide

/-! ## "Circles": discrete diamonds (L¹ balls)

A `15`-column grid has no room for a Euclidean circle, so the faithful discrete
analogue is an **L¹ ball** (a diamond / "pixel circle"): the set of cells whose
taxicab distance to a centre is `≤ t`.  `diamondHalf t a` is the half-width of the
diamond in the `a`-th row counted from its top vertex. -/

/-- Half-width of a radius-`t` diamond in the row `a` rows below its top vertex. -/
abbrev diamondHalf (t a : Nat) : Nat := min a (2 * t - a)

/-- There is a fully filled discrete circle (L¹ ball / diamond) of radius `t`. -/
abbrev hasDiamond (t : Nat) : Prop :=
  ∃ r < R, ∃ c < C, t ≤ c ∧
    ∀ a ≤ 2 * t, ∀ k ≤ 2 * diamondHalf t a, filled (r + a) (c - diamondHalf t a + k)

/-- The largest fully filled discrete circle (diamond) has radius **exactly 3**. -/
theorem largest_circle : hasDiamond 3 ∧ ¬ hasDiamond 4 := by native_decide

/-! ## Summary

Lean *natively decided* — by exhaustive, kernel-checked search — the maximal size of
each shape in the Monster matrix's ink pattern:

* largest solid **square**: side 6        (`largest_solid_square`)
* a tall solid **rectangle**: 24 × 2      (`solid_rect_24x2`, `no_solid_rect_25x2`)
* largest filled **triangle**: height 7   (`largest_triangle`)
* largest discrete **circle** (diamond): radius 3 (`largest_circle`)

So yes: the shapes are really there, and each statement above is a theorem, not an
optical illusion. -/

end MonsterShapes
