import Mathlib
import RequestProject.Monster
import RequestProject.Shapes

/-!
# Bridging the shape grid to the Monster degrees

`RequestProject/Shapes.lean` encodes the p-adic exponent matrix as a hardcoded
`Array (Array Nat)` and proves purely combinatorial facts about it (the largest
square, the 24×2 rectangle, …).  `RequestProject/Monster.lean` independently records
the 194 irreducible degrees of the Monster as `Monster.degrees`.

A natural objection is that those two halves are only *asserted* to describe the same
object — nothing in Lean ties the grid back to the degrees.  This file closes that
loop, turning the shape theorems into genuine statements about the Monster.

The subtlety is row order: `MonsterShapes.grid` is listed **sorted by row density**
`Ω(dᵢ)` (descending), whereas `Monster.degrees` is in **index order** `0,…,193`.
The reindexing is the `index` column of the original data, recorded here as
`displayOrder`.  We prove:

* `displayOrder` is a genuine permutation of `{0,…,193}`
  (`displayOrder_nodup`, `displayOrder_lt`, `displayOrder_surj`), so it loses no rows;
* **reconstruction** (`degree_eq_reconstruction`): for every displayed row `i`, raising
  the supersingular primes to the grid's exponents reproduces *exactly* the Monster
  degree `Monster.degrees[displayOrder[i]]` — i.e. the grid row really is the prime
  factorization of that representation's dimension;
* **ink = divisibility** (`filled_iff_prime_dvd_degree`): a cell is "ink"/filled iff
  the corresponding supersingular prime divides that representation's dimension.

With these, the shapes detected in `Shapes.lean` are patterns in the actual
divisibility structure of the Monster's character degrees, not in an unmoored array.
Every theorem is closed by `native_decide` (only standard axioms).
-/

namespace MonsterBridge

open MonsterShapes (cell filled)
open Monster (degrees supersingularPrimes)

/-- The `index` column of the original (density-sorted) data: `displayOrder[i]` is the
degree index `0,…,193` occupying displayed row `i` of `MonsterShapes.grid`.  In
particular `displayOrder[0] = 192` (the densest degree) and `displayOrder[193] = 0`
(the trivial representation). -/
def displayOrder : List Nat :=
  [192, 174, 180, 101, 102, 139, 122, 123, 124, 132, 171, 147, 168, 158, 80, 81, 144,
   96, 118, 136, 157, 145, 125, 134, 135, 156, 160, 172, 175, 186, 77, 104, 105, 111,
   121, 141, 151, 161, 162, 163, 177, 188, 40, 41, 45, 58, 59, 70, 71, 130, 140, 159,
   167, 49, 63, 120, 152, 185, 65, 100, 106, 107, 129, 142, 150, 154, 181, 193, 42,
   112, 115, 153, 169, 173, 191, 76, 95, 97, 98, 99, 119, 155, 170, 187, 25, 26, 166,
   182, 43, 44, 60, 67, 91, 117, 126, 127, 128, 133, 137, 148, 149, 183, 184, 189,
   190, 56, 64, 78, 82, 83, 84, 85, 90, 94, 110, 143, 176, 48, 66, 109, 113, 164, 165,
   178, 179, 62, 87, 88, 89, 92, 93, 103, 114, 116, 131, 138, 146, 14, 36, 54, 55, 69,
   73, 74, 75, 79, 108, 35, 52, 53, 61, 68, 72, 86, 27, 28, 50, 51, 15, 16, 29, 30,
   38, 39, 57, 23, 33, 37, 46, 47, 20, 19, 31, 32, 34, 18, 22, 24, 8, 17, 21, 9, 10,
   12, 13, 7, 11, 4, 6, 3, 5, 2, 1, 0]

/-! ## `displayOrder` is a permutation of `{0,…,193}` -/

/-- The reindexing has one entry per displayed row. -/
theorem displayOrder_length : displayOrder.length = 194 := by native_decide

/-- No degree index is listed twice. -/
theorem displayOrder_nodup : displayOrder.Nodup := by native_decide

/-- Every listed index is a valid degree index `< 194`. -/
theorem displayOrder_lt : ∀ k ∈ displayOrder, k < 194 := by native_decide

/-- Every degree index `< 194` actually appears, so no representation is dropped.
Together with `displayOrder_nodup` and `displayOrder_length` this makes `displayOrder`
a bijection `{displayed rows} ≃ {degree indices}`. -/
theorem displayOrder_surj : ∀ n < 194, n ∈ displayOrder := by native_decide

/-! ## Reconstruction: the grid row is the factorization of the degree -/

/-- **The grid is the Monster's factorization table.**  For every displayed row `i`,
multiplying each supersingular prime raised to the grid exponent reproduces exactly
the Monster degree at index `displayOrder[i]`:
`∏ⱼ pⱼ ^ grid[i][j] = degrees[displayOrder[i]]`.

This is the formal bridge: `MonsterShapes.grid` genuinely *is* the array of p-adic
valuations of `Monster.degrees`, merely permuted into density-sorted order. -/
theorem degree_eq_reconstruction :
    ∀ i < 194,
      ((List.range 15).map (fun j => supersingularPrimes[j]! ^ cell i j)).prod
        = degrees[displayOrder[i]!]! := by
  native_decide

/-! ## Ink = divisibility -/

/-- **A cell is "ink" iff the prime divides the dimension.**  The black/white texture
the eye (and OpenCV) groups into shapes is exactly the divisibility pattern of the
Monster's representation degrees: grid cell `(i,j)` is filled iff the `j`-th
supersingular prime divides the dimension of representation `displayOrder[i]`. -/
theorem filled_iff_prime_dvd_degree :
    ∀ i < 194, ∀ j < 15,
      (filled i j ↔ supersingularPrimes[j]! ∣ degrees[displayOrder[i]!]!) := by
  native_decide

/-- Restatement of `filled_iff_prime_dvd_degree` for the *empty* cells (the "holes"
OpenCV also outlines): a cell is blank iff the prime does **not** divide the
dimension. -/
theorem unfilled_iff_not_prime_dvd_degree :
    ∀ i < 194, ∀ j < 15,
      (¬ filled i j ↔ ¬ supersingularPrimes[j]! ∣ degrees[displayOrder[i]!]!) := by
  have h := filled_iff_prime_dvd_degree
  intro i hi j hj
  exact not_congr (h i hi j hj)

end MonsterBridge
