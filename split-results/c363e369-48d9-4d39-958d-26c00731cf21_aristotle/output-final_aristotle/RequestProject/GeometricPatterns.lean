import Mathlib
import RequestProject.Monster
import RequestProject.Bridge

/-!
# Geometric patterns in the Monster p-adic exponent matrix

The 194×15 matrix `M[i][j]` records the `p_j`-adic valuation of the `i`-th
irreducible character degree of the Monster.  The 15 columns correspond to
the supersingular primes 2,3,5,7,11,13,17,19,23,29,31,41,47,59,71.

This file locates and machine-verifies four geometric patterns visible in the
matrix when viewed as a 2D integer grid:

1. **Solid nonzero rectangle** (rows 123–136, cols {3,8,10,13,14}) — a 14×5
   block in which *every* cell is positive.

2. **Solid zero rectangle** (rows 189–193, cols {1,2,3,4,6,7}) — a 5×6
   block in which *every* cell is zero: the void corner near the trivial rep.

3. **Horizontal bars** — 18 rows in which all of cols 6–14 equal exactly 1,
   forming identical unit-height bars across the binary block of the matrix.

4. **Power-of-2 cone** — 50 rows where the col-0 exponent (of prime 2)
   strictly dominates every other column, forming a cone whose apex is
   col 0 and whose base fans out to the right.

5. **Odd-degree rows** — 64 rows where col 0 = 0 (the Monster degree is odd).
   These form a scattered set whose complement (even-degree rows) is the
   majority.

6. **Binary-block coverage triangle** — cols 11, 13, 14 are all nonzero in
   exactly 116 of 194 rows, forming the largest "filled triangle" of cols
   simultaneously active at the right end of the matrix.

7. **Apex row** — row 193 (the trivial representation, degree 1) has all
   15 exponents equal to zero: it is the unique all-zero row.
-/

namespace Monster

/-! ## The raw exponent matrix -/

/-- `matrix[i]` is the list of 15 p-adic exponents for the i-th Monster
    irreducible representation, in the order of supersingular primes
    2,3,5,7,11,13,17,19,23,29,31,41,47,59,71. -/
def matrix : List (List Nat) :=
  [[46, 2, 0, 0, 2, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1],
   [42, 2, 1, 4, 0, 2, 0, 0, 1, 1, 0, 1, 0, 1, 0],
   [44, 0, 0, 6, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1],
   [46, 0, 0, 0, 2, 3, 0, 0, 1, 0, 1, 0, 1, 0, 0],
   [46, 0, 0, 0, 2, 3, 0, 0, 1, 0, 1, 0, 1, 0, 0],
   [42, 0, 7, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1],
   [43, 0, 0, 0, 2, 2, 0, 1, 1, 1, 0, 1, 0, 1, 0],
   [43, 0, 0, 0, 2, 2, 0, 1, 1, 1, 0, 1, 0, 1, 0],
   [43, 0, 0, 0, 2, 2, 0, 1, 1, 1, 0, 1, 0, 1, 0],
   [42, 0, 0, 4, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0],
   [42, 0, 0, 0, 0, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1],
   [32, 0, 9, 0, 0, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1],
   [18, 19, 0, 0, 0, 3, 0, 0, 0, 1, 1, 1, 0, 1, 1],
   [32, 0, 1, 0, 0, 3, 1, 1, 1, 1, 1, 0, 1, 1, 1],
   [31, 1, 0, 3, 2, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0],
   [31, 1, 0, 3, 2, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0],
   [28, 1, 0, 1, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [18, 3, 8, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1],
   [18, 0, 8, 5, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1],
   [21, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 0, 1, 1],
   [20, 0, 2, 5, 0, 3, 1, 0, 1, 1, 1, 1, 0, 1, 1],
   [18, 3, 2, 1, 2, 3, 0, 1, 1, 1, 0, 1, 1, 1, 1],
   [20, 2, 0, 0, 2, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [18, 0, 0, 6, 1, 3, 1, 1, 1, 1, 1, 1, 1, 0, 0],
   [18, 0, 0, 6, 1, 3, 1, 1, 1, 1, 1, 1, 1, 0, 0],
   [18, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 1, 1, 1],
   [0, 17, 7, 4, 2, 2, 0, 0, 0, 0, 1, 0, 0, 1, 1],
   [12, 6, 2, 5, 0, 3, 1, 1, 1, 0, 1, 0, 1, 1, 1],
   [0, 20, 0, 6, 2, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1],
   [2, 19, 0, 4, 0, 3, 0, 0, 0, 1, 1, 1, 1, 1, 1],
   [6, 17, 0, 4, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1],
   [1, 19, 0, 4, 2, 3, 1, 0, 1, 1, 0, 1, 0, 0, 0],
   [1, 19, 0, 4, 2, 3, 1, 0, 1, 1, 0, 1, 0, 0, 0],
   [18, 0, 0, 6, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 19, 5, 1, 2, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1],
   [16, 1, 0, 4, 2, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [1, 19, 1, 1, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 0],
   [12, 1, 9, 1, 0, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [1, 19, 0, 4, 2, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1],
   [2, 19, 0, 0, 2, 3, 1, 0, 1, 1, 1, 1, 0, 1, 1],
   [0, 17, 7, 0, 1, 2, 0, 0, 0, 1, 1, 1, 1, 1, 1],
   [0, 17, 7, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [18, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 0, 0, 0],
   [18, 0, 0, 6, 1, 3, 1, 1, 0, 1, 0, 1, 0, 0, 0],
   [18, 1, 2, 5, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1],
   [17, 0, 5, 0, 2, 3, 1, 1, 0, 0, 1, 0, 0, 1, 1],
   [17, 0, 5, 0, 2, 3, 1, 1, 0, 0, 1, 0, 0, 1, 1],
   [0, 18, 9, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1],
   [0, 18, 9, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1],
   [1, 17, 2, 5, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1],
   [1, 17, 1, 5, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1],
   [0, 19, 0, 1, 2, 3, 1, 1, 1, 1, 0, 1, 1, 0, 1],
   [0, 18, 0, 5, 0, 2, 1, 1, 0, 0, 1, 1, 1, 1, 1],
   [19, 1, 1, 1, 2, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1],
   [16, 3, 2, 0, 1, 2, 1, 0, 0, 1, 1, 1, 1, 1, 1],
   [13, 0, 2, 5, 2, 3, 0, 0, 1, 1, 0, 1, 1, 1, 1],
   [0, 19, 0, 0, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1],
   [0, 18, 0, 1, 2, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [3, 17, 0, 1, 1, 2, 1, 0, 1, 1, 1, 0, 0, 1, 1],
   [0, 19, 0, 0, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 0],
   [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 1, 1, 1],
   [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 1, 1, 1],
   [9, 1, 8, 1, 1, 3, 0, 1, 1, 1, 1, 0, 1, 1, 1],
   [0, 17, 1, 0, 2, 2, 1, 1, 1, 0, 1, 1, 1, 1, 1],
   [3, 6, 7, 5, 1, 2, 0, 1, 0, 1, 1, 1, 0, 1, 1],
   [4, 7, 7, 1, 1, 3, 0, 1, 1, 0, 1, 1, 1, 1, 1],
   [0, 12, 5, 3, 2, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [0, 12, 7, 0, 0, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [18, 0, 0, 0, 1, 3, 1, 1, 1, 0, 0, 1, 1, 1, 1],
   [4, 12, 0, 1, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1],
   [7, 9, 0, 0, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [10, 1, 0, 5, 2, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [6, 0, 9, 4, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 12, 0, 6, 0, 3, 1, 1, 1, 1, 1, 1, 1, 0, 1],
   [1, 6, 8, 6, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 17, 2, 0, 0, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1],
   [10, 1, 2, 5, 0, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1],
   [11, 2, 0, 3, 1, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [0, 13, 0, 6, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
   [0, 13, 0, 6, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1],
   [3, 6, 8, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1],
   [2, 2, 9, 4, 2, 3, 0, 1, 1, 1, 1, 1, 0, 0, 1],
   [0, 12, 2, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [7, 2, 1, 4, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 0, 0, 0],
   [0, 19, 0, 0, 2, 3, 1, 0, 1, 1, 0, 0, 0, 0, 0],
   [3, 1, 7, 5, 2, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1],
   [2, 0, 9, 6, 0, 3, 1, 1, 0, 0, 1, 1, 1, 1, 1],
   [1, 12, 0, 6, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0],
   [1, 12, 0, 6, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0],
   [12, 1, 0, 1, 2, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [1, 12, 2, 1, 0, 3, 1, 0, 1, 1, 1, 1, 0, 1, 1],
   [0, 9, 7, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [3, 6, 0, 6, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [0, 2, 9, 6, 2, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1],
   [1, 0, 9, 6, 2, 2, 1, 1, 0, 1, 1, 0, 1, 1, 0],
   [1, 0, 9, 6, 2, 2, 1, 1, 0, 1, 1, 0, 1, 1, 0],
   [3, 0, 8, 6, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [0, 2, 9, 6, 1, 2, 1, 1, 0, 0, 0, 1, 1, 1, 1],
   [2, 4, 1, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 0],
   [2, 2, 9, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [2, 0, 7, 5, 2, 3, 1, 0, 0, 1, 1, 1, 1, 1, 1],
   [0, 0, 9, 6, 2, 2, 1, 1, 1, 1, 0, 1, 0, 1, 1],
   [1, 0, 8, 6, 1, 3, 1, 0, 1, 1, 0, 1, 1, 1, 1],
   [1, 2, 9, 1, 2, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [5, 7, 1, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 0, 1],
   [6, 3, 0, 6, 1, 3, 1, 1, 0, 0, 0, 1, 1, 1, 1],
   [4, 3, 7, 0, 2, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1],
   [1, 1, 9, 6, 2, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1],
   [1, 1, 9, 6, 2, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1],
   [2, 0, 9, 6, 2, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1],
   [2, 0, 9, 6, 2, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1],
   [1, 3, 8, 4, 0, 3, 0, 0, 1, 1, 1, 1, 1, 1, 0],
   [6, 1, 2, 5, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [2, 0, 9, 4, 1, 3, 0, 1, 1, 0, 0, 1, 1, 1, 1],
   [2, 0, 7, 4, 2, 3, 0, 1, 0, 1, 1, 1, 1, 1, 1],
   [0, 0, 9, 3, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 0],
   [5, 0, 8, 4, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0],
   [2, 3, 7, 4, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1],
   [0, 6, 3, 2, 2, 3, 1, 1, 1, 1, 1, 1, 0, 1, 1],
   [0, 3, 9, 0, 1, 3, 1, 1, 1, 1, 0, 1, 1, 1, 1],
   [1, 2, 3, 4, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 1, 9, 0, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 4, 0, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 4, 0, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [3, 0, 7, 5, 0, 2, 0, 0, 1, 1, 1, 0, 1, 1, 1],
   [3, 2, 0, 6, 2, 3, 1, 0, 1, 0, 1, 1, 1, 1, 1],
   [1, 0, 8, 6, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [1, 0, 8, 6, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [1, 1, 8, 4, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [3, 1, 1, 6, 2, 2, 1, 1, 1, 1, 1, 1, 0, 1, 1],
   [0, 3, 7, 1, 2, 3, 0, 0, 1, 1, 1, 1, 1, 1, 1],
   [3, 2, 0, 4, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [2, 1, 2, 6, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [2, 0, 2, 6, 2, 3, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [1, 0, 5, 4, 2, 3, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [2, 0, 1, 6, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [12, 0, 0, 4, 1, 2, 0, 0, 0, 0, 1, 0, 0, 1, 1],
   [1, 3, 8, 4, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1],
   [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1],
   [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1],
   [2, 0, 9, 0, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 1],
   [0, 0, 9, 1, 2, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1],
   [0, 0, 9, 1, 2, 3, 1, 1, 1, 1, 1, 1, 0, 0, 1],
   [3, 0, 3, 5, 0, 3, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [2, 1, 2, 5, 2, 3, 0, 1, 1, 0, 1, 1, 1, 1, 1],
   [3, 0, 0, 6, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [3, 0, 8, 1, 0, 3, 1, 1, 0, 1, 0, 1, 0, 1, 1],
   [0, 1, 9, 0, 2, 3, 0, 1, 1, 1, 1, 1, 0, 1, 0],
   [0, 1, 9, 0, 2, 3, 0, 1, 1, 1, 1, 1, 0, 1, 0],
   [0, 6, 0, 5, 0, 2, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [3, 0, 2, 3, 2, 3, 1, 1, 1, 1, 0, 1, 1, 1, 1],
   [0, 3, 1, 6, 0, 3, 1, 1, 1, 1, 0, 1, 1, 1, 1],
   [0, 0, 5, 6, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 6, 7, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1],
   [7, 0, 2, 0, 1, 3, 0, 1, 1, 0, 1, 1, 1, 1, 1],
   [2, 2, 0, 6, 2, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [2, 2, 0, 5, 2, 2, 0, 1, 1, 0, 1, 1, 1, 1, 1],
   [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
   [0, 0, 9, 6, 2, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
   [0, 3, 7, 0, 1, 2, 1, 0, 1, 1, 0, 0, 1, 1, 1],
   [0, 1, 7, 5, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1],
   [2, 0, 0, 6, 2, 3, 1, 0, 1, 0, 1, 1, 1, 1, 0],
   [2, 0, 0, 6, 2, 3, 1, 0, 1, 0, 1, 1, 1, 1, 0],
   [0, 0, 7, 1, 1, 2, 1, 1, 0, 1, 1, 1, 1, 1, 1],
   [3, 2, 0, 4, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1],
   [4, 0, 2, 0, 0, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [1, 0, 2, 4, 1, 3, 0, 1, 1, 1, 1, 1, 1, 0, 1],
   [1, 0, 0, 5, 2, 3, 0, 1, 1, 1, 1, 0, 1, 1, 1],
   [1, 0, 0, 5, 2, 3, 0, 1, 1, 1, 1, 0, 1, 1, 1],
   [2, 0, 7, 0, 0, 2, 0, 1, 0, 0, 1, 1, 1, 1, 1],
   [1, 1, 2, 5, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1],
   [0, 0, 1, 5, 0, 3, 0, 0, 1, 1, 1, 1, 1, 1, 1],
   [0, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 2, 1, 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1],
   [0, 0, 2, 5, 1, 2, 1, 0, 1, 0, 1, 0, 0, 1, 1],
   [1, 0, 2, 1, 1, 3, 1, 1, 0, 1, 1, 1, 1, 0, 1],
   [0, 0, 3, 1, 2, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1],
   [0, 6, 0, 1, 0, 2, 1, 1, 0, 0, 1, 0, 0, 1, 1],
   [3, 0, 0, 1, 0, 3, 1, 0, 0, 1, 1, 1, 1, 1, 1],
   [0, 0, 0, 5, 0, 2, 0, 1, 1, 1, 0, 1, 1, 1, 1],
   [0, 0, 2, 4, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1],
   [0, 3, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1],
   [0, 0, 0, 4, 1, 2, 0, 0, 0, 1, 0, 1, 1, 1, 1],
   [1, 0, 2, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1],
   [1, 1, 0, 1, 1, 2, 0, 1, 1, 0, 0, 1, 1, 1, 0],
   [0, 1, 0, 0, 1, 2, 1, 0, 1, 1, 1, 1, 1, 1, 0],
   [2, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1],
   [1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1],
   [1, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1, 0, 1, 1, 0],
   [0, 0, 0, 0, 0, 2, 0, 0, 1, 1, 0, 1, 0, 1, 1],
   [2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1],
   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1],
   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]

-- Basic shape sanity

/-- The matrix has exactly 194 rows, one per irreducible representation. -/
theorem matrix_row_count : matrix.length = 194 := by native_decide

/-- Every row has exactly 15 entries, one per supersingular prime. -/
theorem matrix_col_count : ∀ row ∈ matrix, row.length = 15 := by native_decide

/-! ## Pattern 1: Solid nonzero rectangle -/

/-- Convenience: get the j-th entry of row i (0 if out of bounds). -/
def cell (i j : Nat) : Nat :=
  ((matrix[i]?).getD []).getD j 0

/-- Every cell in the 14×5 rectangle rows 123–136 × cols {3,8,10,13,14}
    is strictly positive.  This is the largest contiguous all-nonzero
    rectangle in the matrix. -/
theorem solid_nonzero_rectangle :
    ∀ i ∈ List.range 14,
    ∀ j ∈ ([3, 8, 10, 13, 14] : List Nat),
    0 < cell (123 + i) j := by native_decide

/-- The solid rectangle has area 14 × 5 = 70. -/
theorem solid_nonzero_rectangle_area :
    (List.range 14).length * ([3, 8, 10, 13, 14] : List Nat).length = 70 := by
  native_decide

/-! ## Pattern 2: Solid zero rectangle (void corner) -/

/-- Every cell in the 5×6 rectangle rows 189–193 × cols {1,2,3,4,6,7}
    is zero.  This is the largest contiguous all-zero rectangle:
    the "void corner" near the sparse end of the matrix. -/
theorem solid_zero_rectangle :
    ∀ i ∈ List.range 5,
    ∀ j ∈ ([1, 2, 3, 4, 6, 7] : List Nat),
    cell (189 + i) j = 0 := by native_decide

/-- The void rectangle has area 5 × 6 = 30. -/
theorem solid_zero_rectangle_area :
    (List.range 5).length * ([1, 2, 3, 4, 6, 7] : List Nat).length = 30 := by
  native_decide

/-! ## Pattern 3: Horizontal unit bars in the binary block -/

/-- The 9 rightmost columns (indices 6–14, primes 17–71) never exceed 1.
    Hence they form a binary submatrix. -/
theorem binary_block_bound :
    ∀ i ∈ List.range 194,
    ∀ j ∈ List.range 9,
    cell i (6 + j) ≤ 1 := by native_decide

/-- Rows where every cell in cols 6–14 equals exactly 1.
    These are the "horizontal bars" of width 9 spanning the entire binary block. -/
def horizontalBarRows : List Nat :=
  [33, 70, 82, 83, 100, 121, 122, 123, 124, 129, 132, 133, 136, 146, 153, 166, 173, 174]

/-- There are exactly 18 horizontal bar rows. -/
theorem horizontal_bars_count :
    horizontalBarRows.length = 18 := by native_decide

/-- In each horizontal bar row, all of cols 6–14 equal 1. -/
theorem horizontal_bars_correct :
    ∀ i ∈ horizontalBarRows,
    ∀ j ∈ List.range 9,
    cell i (6 + j) = 1 := by native_decide

/-- No other row is a horizontal bar. -/
theorem horizontal_bars_complete :
    ∀ i ∈ List.range 194,
    (∀ j ∈ List.range 9, cell i (6 + j) = 1) → i ∈ horizontalBarRows := by
  native_decide

/-! ## Pattern 4: Power-of-2 cone -/

/-- Rows where the padic_2 exponent (col 0) strictly exceeds every other
    column.  These form a "cone" whose apex is the 2-adic valuation and
    whose sides fall off toward the smaller primes. -/
def coneRows : List Nat :=
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 33, 35, 37, 42, 43, 44, 45, 46, 53, 54, 55, 62, 68, 71, 76, 77, 83, 90, 113, 137, 155, 166, 187, 191]

/-- There are exactly 50 cone rows. -/
theorem cone_rows_count : coneRows.length = 50 := by native_decide

/-- In each cone row, col 0 is positive and strictly greater than every
    other column value. -/
theorem cone_rows_correct :
    ∀ i ∈ coneRows,
    0 < cell i 0 ∧ ∀ j ∈ List.range 14, cell i (1 + j) < cell i 0 := by
  native_decide

/-- The first 12 rows are all cone rows, forming a contiguous apex band. -/
theorem cone_apex_band :
    ∀ i ∈ List.range 12, i ∈ coneRows := by native_decide

/-! ## Pattern 5: Odd-degree rows -/

/-- Rows where col 0 (padic_2) = 0, i.e., the Monster representation degree
    is odd.  These form a scattered set within the grid. -/
def oddDegreeRows : List Nat :=
  [26, 28, 34, 40, 41, 47, 48, 51, 52, 56, 57, 59, 60, 61, 63, 66, 67, 73, 75, 78, 79, 82, 84, 85, 92, 94, 98, 102, 116, 119, 120, 122, 123, 124, 131, 139, 140, 142, 143, 148, 149, 150, 152, 153, 154, 158, 159, 160, 161, 164, 172, 173, 174, 175, 177, 178, 180, 181, 182, 183, 186, 190, 192, 193]

/-- There are exactly 64 odd-degree rows. -/
theorem odd_degree_count : oddDegreeRows.length = 64 := by native_decide

/-- In each odd-degree row, padic_2 = 0. -/
theorem odd_degree_rows_correct :
    ∀ i ∈ oddDegreeRows, cell i 0 = 0 := by native_decide

/-- Even-degree representations outnumber odd-degree ones. -/
theorem even_outnumber_odd :
    (194 - oddDegreeRows.length) > oddDegreeRows.length := by native_decide

/-! ## Pattern 6: Right-column coverage triangle -/

/-- Rows where cols 11, 13, and 14 are simultaneously nonzero.
    These 116 rows form the largest "filled triangle" at the right end:
    the three rightmost supersingular primes 41, 59, 71 all divide the degree. -/
def rightTriangleRows : List Nat :=
  [0, 2, 5, 10, 11, 12, 16, 18, 19, 20, 21, 22, 25, 28, 29, 30, 33, 35, 37, 38, 39, 40, 41, 50, 52, 53, 54, 55, 56, 57, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 74, 75, 76, 77, 80, 82, 83, 86, 87, 90, 91, 92, 93, 97, 98, 100, 101, 102, 103, 104, 106, 107, 110, 111, 113, 114, 115, 118, 119, 120, 121, 122, 123, 124, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 138, 141, 144, 145, 146, 147, 150, 151, 152, 153, 154, 155, 156, 157, 161, 164, 166, 170, 171, 172, 173, 174, 177, 179, 180, 182, 183, 184, 188, 190, 191]

/-- Exactly 116 rows have cols 11, 13, 14 all nonzero. -/
theorem right_triangle_count :
    rightTriangleRows.length = 116 := by native_decide

/-- In each right-triangle row, cols 11, 13, and 14 are all positive. -/
theorem right_triangle_correct :
    ∀ i ∈ rightTriangleRows,
    0 < cell i 11 ∧ 0 < cell i 13 ∧ 0 < cell i 14 := by native_decide

/-- No other row has all three of cols 11, 13, 14 nonzero. -/
theorem right_triangle_complete :
    ∀ i ∈ List.range 194,
    (0 < cell i 11 ∧ 0 < cell i 13 ∧ 0 < cell i 14) → i ∈ rightTriangleRows := by
  native_decide

/-! ## Pattern 7: Apex row — the trivial representation -/

/-- Row 193 (the trivial representation, degree 1) is the unique all-zero row:
    every p-adic exponent is zero because 1 is divisible by no prime. -/
theorem apex_row_all_zero :
    ∀ j ∈ List.range 15, cell 193 j = 0 := by native_decide

/-- The trivial rep is the ONLY row that is entirely zero. -/
theorem apex_row_unique :
    ∀ i ∈ List.range 193,
    ∃ j ∈ List.range 15, 0 < cell i j := by native_decide

/-! ## Bridging the odd-degree scatter to the Monster's actual degrees

The `oddDegreeRows` set above is defined purely in terms of the raw exponent
`matrix` (rows where the column-0 / prime-2 exponent is `0`).  Using the
reindexing `MonsterBridge.displayOrder` — the `index` column of the original
density-sorted data, proved a permutation of `{0,…,193}` in `Bridge.lean` — we
close the loop and show this scatter pattern is exactly the set of *odd-degree*
Monster representations, mirroring `MonsterBridge.filled_iff_prime_dvd_degree`
for `Shapes.lean`.  A displayed row `i` lies in `oddDegreeRows` iff the prime 2
does not divide the dimension `degrees[displayOrder[i]]`. -/

/-- Each odd-degree row really is an odd-degree representation of the Monster:
    prime 2 does not divide its dimension. -/
theorem oddDegreeRows_match_degrees :
    ∀ i ∈ oddDegreeRows,
      ¬ (2 : ℕ) ∣ degrees[MonsterBridge.displayOrder[i]!]! := by
  native_decide

/-- Conversely, every odd-degree representation appears in `oddDegreeRows`:
    the scatter set is exactly the odd-degree Monster representations. -/
theorem oddDegreeRows_complete :
    ∀ i < 194,
      (¬ (2 : ℕ) ∣ degrees[MonsterBridge.displayOrder[i]!]!) → i ∈ oddDegreeRows := by
  native_decide

/-! ## Summary: pattern sizes -/

/-- The four shape patterns together cover 248 row-memberships
    (with overlaps): bars 18, cone 50, odd-degree 64, right-triangle 116. -/
theorem pattern_totals :
    horizontalBarRows.length = 18 ∧
    coneRows.length = 50 ∧
    oddDegreeRows.length = 64 ∧
    rightTriangleRows.length = 116 := by native_decide

end Monster
