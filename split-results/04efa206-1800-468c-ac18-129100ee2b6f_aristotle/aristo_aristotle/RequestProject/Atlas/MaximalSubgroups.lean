/-
# Maximal Subgroups
This file formalizes the concept of maximal subgroups as used in the ATLAS.
For each simple group G, the ATLAS lists all maximal subgroups of G
(and often of Aut(G)). The maximal subgroups are crucial for:
- Understanding the internal structure of G
- Determining what groups certain elements generate
- Computing character tables via induction/restriction
-/
import Mathlib
set_option maxHeartbeats 800000
open scoped BigOperators Classical
noncomputable section
/-- An entry recording a maximal subgroup as it appears in the ATLAS. -/
structure MaximalSubgroupEntry (G : Type*) [Group G] where
  /-- The maximal subgroup. -/
  subgroup : Subgroup G
  /-- The index [G : H]. -/
  index : ℕ
  /-- Description of the structure of H. -/
  structureDescription : String
/-- The ATLAS records that the maximal subgroups of A₅ are:
    - A₄ (index 5)
    - S₃ = D₆ (index 10)
    - D₁₀ = 5:2 (index 6) -/
def maximalSubgroupsA5_description : List String :=
  ["A4 (index 5)",
   "S3 (index 10)",
   "D10 = 5:2 (index 6)"]
/-- For M₁₁, the ATLAS records 5 conjugacy classes of maximal subgroups. -/
def maximalSubgroupsM11_description : List (String × ℕ) :=
  [("M10 = A6.2", 11),
   ("L2(11)", 12),
   ("3^2:QD16", 55),
   ("S5", 66),
   ("2.S4 = GL2(3)", 165)]
/-- The indices of maximal subgroups of M₁₁ all divide |M₁₁| = 7920. -/
theorem M11_indices_valid :
    let indices := [11, 12, 55, 66, 165]
    ∀ i ∈ indices, i ∣ 7920 := by
  decide
end -- noncomputable section
