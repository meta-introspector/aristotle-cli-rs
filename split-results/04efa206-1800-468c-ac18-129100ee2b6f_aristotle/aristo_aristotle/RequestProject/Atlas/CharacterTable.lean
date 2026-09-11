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
  /-- The character table entries (numConjClasses × numConjClasses matrix over ℂ). -/
  charTable : Fin numConjClasses → Fin numConjClasses → ℂ
  /-- Names/descriptions of the maximal subgroups. -/
  maximalSubgroups : List String
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
  maximalSubgroups := ["A4", "S3", "D10"]
/-- ATLAS entry for the Mathieu group M₁₁. -/
def atlasM11 : ATLASEntry where
  name := "M11"
  order := 7920
  schurMultiplierOrder := 1
  outerAutOrder := 1
  numConjClasses := 10
  charTable := fun _ _ => 0  -- placeholder; the full table has algebraic integers
  maximalSubgroups := [
    "M10 = A6.2",
    "L2(11)",
    "M9.S3 = 3^2:QD16",
    "S5",
    "2.S4 = GL2(3)"
  ]
/-- ATLAS entry for M₁₂. -/
def atlasM12 : ATLASEntry where
  name := "M12"
  order := 95040
  schurMultiplierOrder := 2
  outerAutOrder := 2
  numConjClasses := 15
  charTable := fun _ _ => 0  -- placeholder
  maximalSubgroups := [
    "M11",
    "M11",
    "A6.2^2 = M10.2",
    "L2(11)",
    "3^2:2.S4",
    "S5 x 2",
    "2 x S5",
    "A4 x S3",
    "2^1+4:S3",
    "4^2:D12"
  ]
/-- ATLAS entry for M₂₄. -/
def atlasM24 : ATLASEntry where
  name := "M24"
  order := 244823040
  schurMultiplierOrder := 1
  outerAutOrder := 1
  numConjClasses := 26
  charTable := fun _ _ => 0  -- placeholder
  maximalSubgroups := [
    "M23",
    "M22:2",
    "2^4:A8",
    "M12:2",
    "2^6:3.S6",
    "2^6:(L3(2) x S3)",
    "L2(23)",
    "L2(7)"
  ]
end -- noncomputable section
