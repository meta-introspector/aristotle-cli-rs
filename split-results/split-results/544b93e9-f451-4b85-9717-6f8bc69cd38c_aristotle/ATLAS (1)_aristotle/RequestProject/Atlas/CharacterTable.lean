/-
# Character Tables

This file formalizes the notion of a character table for a finite group,
which is the central object tabulated in the ATLAS of Finite Groups.

A character table is a matrix indexed by (conjugacy classes) × (irreducible characters),
with entries in ℂ (or an algebraically closed field of characteristic 0).
The character table encodes an enormous amount of information about the group.
-/
import Mathlib

set_option maxHeartbeats 800000

open scoped BigOperators Classical

noncomputable section

/-- A character table for a finite group `G` over `ℂ`.

In the ATLAS, the character table is presented as a matrix whose rows are
indexed by irreducible characters and whose columns are indexed by
conjugacy classes of `G`. The entry χ(g) gives the value of the character
χ on the conjugacy class of g.

Key properties of the character table:
* It is a square matrix (the number of irreducible characters equals the
  number of conjugacy classes).
* The rows are orthogonal with respect to the class-function inner product.
* The columns are also orthogonal.
* The first row is the trivial character (all 1s).
* χ(1) divides |G| for every irreducible character χ.
-/
structure CharacterTable (G : Type*) [Group G] [Fintype G] where
  /-- The number of conjugacy classes (= number of irreducible characters). -/
  numClasses : ℕ
  /-- Representatives of the conjugacy classes. -/
  classReps : Fin numClasses → G
  /-- The class representatives are pairwise non-conjugate. -/
  classReps_nonConj : ∀ i j : Fin numClasses,
    IsConj (classReps i) (classReps j) → i = j
  /-- Every element is conjugate to some representative. -/
  classReps_surj : ∀ g : G, ∃ i, IsConj g (classReps i)
  /-- The character values: entry (i, j) = χᵢ(gⱼ). -/
  charValues : Fin numClasses → Fin numClasses → ℂ
  /-- numClasses is positive. -/
  numClasses_pos : 0 < numClasses
  /-- The first row is the trivial character. -/
  trivial_char : ∀ j, charValues ⟨0, numClasses_pos⟩ j = 1

/-- An entry in the ATLAS of Finite Groups, recording the key invariants
    and structural data for a finite simple group. -/
structure ATLASEntry where
  /-- The name of the group (e.g., "A5", "M11", "Co1"). -/
  name : String
  /-- The order of the group. -/
  order : ℕ
  /-- The order of the Schur multiplier. -/
  schurMultiplierOrder : ℕ
  /-- The order of the outer automorphism group. -/
  outerAutOrder : ℕ
  /-- The number of conjugacy classes. -/
  numConjClasses : ℕ
  /-- The sizes of each conjugacy class. -/
  classSizes : Fin numConjClasses → ℕ
  /-- The orders of elements in each conjugacy class. -/
  classOrders : Fin numConjClasses → ℕ
  /-- ATLAS names for conjugacy classes (e.g., "1A", "2A", "3A"). -/
  classNames : Fin numConjClasses → String
  /-- The character table entries (numConjClasses × numConjClasses matrix over ℂ). -/
  charTable : Fin numConjClasses → Fin numConjClasses → ℂ
  /-- Names/descriptions of the maximal subgroups. -/
  maximalSubgroups : List String

/-- Power map data as recorded in the ATLAS. For each prime p and each
    conjugacy class, the power map gives the class containing g^p. -/
structure PowerMap (n : ℕ) where
  /-- For each prime p (stored as its index), which class does g^p land in? -/
  powerImage : ℕ → Fin n → Fin n

/-! ## A₅ Character Table

The character table of A₅ has 5 conjugacy classes and 5 irreducible characters.
This is the simplest non-abelian simple group.
-/

/-- ATLAS entry for A₅ ≅ L₂(4) ≅ L₂(5).

The character table of A₅ has 5 conjugacy classes:
  1A, 2A, 3A, 5A, 5B
and 5 irreducible characters of degrees 1, 3, 3, 4, 5.

The golden ratio φ = (1 + √5)/2 appears in the character table.
-/
def atlasA5 : ATLASEntry where
  name := "A5"
  order := 60
  schurMultiplierOrder := 2
  outerAutOrder := 2
  numConjClasses := 5
  classSizes := ![1, 15, 20, 12, 12]
  classOrders := ![1, 2, 3, 5, 5]
  classNames := !["1A", "2A", "3A", "5A", "5B"]
  charTable := fun i j =>
    let φ : ℂ := (1 + Complex.ofReal (Real.sqrt 5)) / 2
    -- Rows: χ₁ (trivial), χ₂ (degree 3), χ₃ (degree 3), χ₄ (degree 4), χ₅ (degree 5)
    -- Columns: 1A, 2A, 3A, 5A, 5B
    let table : Fin 5 → Fin 5 → ℂ := ![
      ![1,  1,  1,  1,  1],     -- trivial character
      ![3, -1,  0,  φ,  1-φ],   -- degree 3, involves golden ratio
      ![3, -1,  0,  1-φ, φ],    -- degree 3, conjugate
      ![4,  0,  1, -1, -1],     -- degree 4
      ![5,  1, -1,  0,  0]      -- degree 5
    ]
    table i j
  maximalSubgroups := ["A4 (index 5)", "S3 (index 10)", "D10 (index 6)"]

/-! ## M₁₁ Character Table

The Mathieu group M₁₁ has order 7920, 10 conjugacy classes, and 10
irreducible characters. The character table involves √2 and the
algebraic number b₁₁ = (-1 + √(-11))/2.
-/

/-- ATLAS entry for the Mathieu group M₁₁.

M₁₁ is the smallest of the five Mathieu groups and the first
sporadic simple group to be discovered (by Émile Mathieu, 1861).
It acts 4-transitively on 11 points.

Character table of M₁₁:
  Classes:  1A   2A   3A   4A   5A   6A   8A   8B   11A   11B
  Sizes:     1  165  440  990 1584 1320  990  990   720   720

  χ₁:   1    1    1    1    1    1    1    1     1     1
  χ₂:  10    2    1    0    0   -1   √2  -√2    -1    -1
  χ₃:  10    2    1    0    0   -1  -√2   √2    -1    -1
  χ₄:  10   -2    1    0    0    1    0    0    -1    -1
  χ₅:  11    3   -1   -1    1    1   -1   -1     0     0
  χ₆:  16    0   -2    0    1    0    0    0    b₁₁  b̄₁₁
  χ₇:  16    0   -2    0    1    0    0    0   b̄₁₁   b₁₁
  χ₈:  44    4    2    0   -1    0    0    0     0     0
  χ₉:  45   -3    0    1    0    0   -1    1     1     1
  χ₁₀: 55   -1    1   -1    0   -1    1    1     0     0

where b₁₁ = (-1 + i√11)/2.
-/
def atlasM11 : ATLASEntry where
  name := "M11"
  order := 7920
  schurMultiplierOrder := 1
  outerAutOrder := 1
  numConjClasses := 10
  classSizes := ![1, 165, 440, 990, 1584, 1320, 990, 990, 720, 720]
  classOrders := ![1, 2, 3, 4, 5, 6, 8, 8, 11, 11]
  classNames := !["1A", "2A", "3A", "4A", "5A", "6A", "8A", "8B", "11A", "11B"]
  charTable := fun i j =>
    let sqrt2 : ℂ := Complex.ofReal (Real.sqrt 2)
    -- b₁₁ = (-1 + i√11)/2
    let b11 : ℂ := (-1 + Complex.I * Complex.ofReal (Real.sqrt 11)) / 2
    let b11bar : ℂ := (-1 - Complex.I * Complex.ofReal (Real.sqrt 11)) / 2
    let table : Fin 10 → Fin 10 → ℂ := ![
      ![1,   1,   1,   1,   1,   1,     1,      1,     1,     1],  -- χ₁ (trivial)
      ![10,  2,   1,   0,   0,  -1,  sqrt2, -sqrt2,    -1,    -1],  -- χ₂
      ![10,  2,   1,   0,   0,  -1, -sqrt2,  sqrt2,    -1,    -1],  -- χ₃
      ![10, -2,   1,   0,   0,   1,     0,      0,    -1,    -1],  -- χ₄
      ![11,  3,  -1,  -1,   1,   1,    -1,     -1,     0,     0],  -- χ₅
      ![16,  0,  -2,   0,   1,   0,     0,      0,   b11, b11bar],  -- χ₆
      ![16,  0,  -2,   0,   1,   0,     0,      0, b11bar,  b11],  -- χ₇
      ![44,  4,   2,   0,  -1,   0,     0,      0,     0,     0],  -- χ₈
      ![45, -3,   0,   1,   0,   0,    -1,      1,     1,     1],  -- χ₉
      ![55, -1,   1,  -1,   0,  -1,     1,      1,     0,     0]   -- χ₁₀
    ]
    table i j
  maximalSubgroups := [
    "M10 ≅ A6.2 (index 11)",
    "L2(11) (index 12)",
    "3²:QD16 (index 55)",
    "S5 (index 66)",
    "2.S4 ≅ GL(2,3) (index 165)"
  ]

/-! ## M₁₂ Character Table -/

/-- ATLAS entry for M₁₂.

M₁₂ has order 95040, 15 conjugacy classes, and acts 5-transitively
on 12 points. It is the largest of the multiply-transitive Mathieu groups
(in terms of transitivity degree).
-/
def atlasM12 : ATLASEntry where
  name := "M12"
  order := 95040
  schurMultiplierOrder := 2
  outerAutOrder := 2
  numConjClasses := 15
  classSizes := ![1, 396, 1485, 1980, 2640, 3960, 3960, 5940, 7920,
                  7920, 7920, 7920, 7920, 7920, 7920]
  classOrders := ![1, 2, 2, 3, 4, 3, 4, 4, 5, 6, 6, 8, 8, 10, 11]
  classNames := !["1A", "2A", "2B", "3A", "4A", "3B", "4B", "4C", "5A",
                   "6A", "6B", "8A", "8B", "10A", "11A"]
  -- Character values: degrees are 1, 11, 11, 16, 16, 45, 54, 55, 55, 55, 66, 99, 120, 144, 176
  charTable := fun _ _ => 0  -- Full table omitted (involves cube roots of unity and √2)
  maximalSubgroups := [
    "M11 (index 12)",
    "M11 (index 12)",
    "A6.2² ≅ M10.2 (index 66)",
    "L2(11) (index 144)",
    "3²:2.S4 (index 220)",
    "S5 × 2 (index 396)",
    "2 × S5 (index 396)",
    "A4 × S3 (index 1320)",
    "2¹⁺⁴:S3 (index 495)",
    "4²:D12 (index 495)"
  ]

/-! ## M₂₄ Character Table -/

/-- ATLAS entry for M₂₄.

M₂₄ has order 244823040, 26 conjugacy classes, and is the largest
Mathieu group. It acts 5-transitively on 24 points.

M₂₄ plays a central role in the construction of the Leech lattice
and thus indirectly in the construction of the Monster group.
-/
def atlasM24 : ATLASEntry where
  name := "M24"
  order := 244823040
  schurMultiplierOrder := 1
  outerAutOrder := 1
  numConjClasses := 26
  classSizes := fun _ => 0  -- 26 class sizes omitted for brevity
  classOrders := fun _ => 0  -- placeholder
  classNames := fun _ => ""  -- placeholder
  charTable := fun _ _ => 0  -- Full 26×26 table omitted
  maximalSubgroups := [
    "M23 (index 24)",
    "M22:2 (index 276)",
    "2⁴:A8 (index 759)",
    "M12:2 (index 1288)",
    "2⁶:3.S6 (index 1771)",
    "2⁶:(L3(2) × S3) (index 3795)",
    "L2(23) (index 40320)",
    "L2(7) (index 1457280)"
  ]

/-! ## A₆ Character Table -/

/-- ATLAS entry for A₆ ≅ L₂(9) ≅ Sp(4,2)'.

A₆ has order 360, 7 conjugacy classes. It is notable for having
the largest outer automorphism group of any alternating group:
|Out(A₆)| = 4 (the Klein four-group).
-/
def atlasA6 : ATLASEntry where
  name := "A6"
  order := 360
  schurMultiplierOrder := 6
  outerAutOrder := 4
  numConjClasses := 7
  classSizes := ![1, 45, 40, 40, 72, 90, 72]
  classOrders := ![1, 2, 3, 3, 5, 4, 5]
  classNames := !["1A", "2A", "3A", "3B", "5A", "4A", "5B"]
  charTable := fun i j =>
    let φ : ℂ := (1 + Complex.ofReal (Real.sqrt 5)) / 2
    let table : Fin 7 → Fin 7 → ℂ := ![
      ![1,   1,    1,     1,     1,    1,    1],     -- trivial
      ![5,   1,    2,    -1,    0,   -1,    0],      -- degree 5
      ![5,   1,   -1,     2,    0,   -1,    0],      -- degree 5
      ![8,   0,   -1,    -1,   φ-1,   0,   -φ],     -- degree 8
      ![8,   0,   -1,    -1,   -φ,    0,   φ-1],    -- degree 8
      ![9,   1,    0,     0,   -1,    1,   -1],      -- degree 9
      ![10, -2,    1,     1,    0,    0,    0]        -- degree 10
    ]
    table i j
  maximalSubgroups := [
    "A5 (index 6)",
    "A5 (index 6)",
    "3²:4 (index 10)",
    "S4 (index 15)",
    "S4 (index 15)"
  ]

end -- noncomputable section
