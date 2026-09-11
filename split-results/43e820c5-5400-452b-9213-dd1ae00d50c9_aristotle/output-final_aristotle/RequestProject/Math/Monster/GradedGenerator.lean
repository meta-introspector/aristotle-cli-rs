import RequestProject.Math.UnivalentCore

/-!
# Graded generators: monstrous moonshine head characters

This module formalizes the genuinely checkable arithmetic kernel of the
"graded Monster generator / Griess representation" component: the *McKay–Thompson*
relations that opened **monstrous moonshine**.

The graded dimensions of the moonshine module `V♮` are the coefficients of the
normalized modular `j`-invariant `J(q) = q⁻¹ + 196884 q + 21493760 q² + …`, and
each coefficient decomposes as a non-negative integer combination of the
dimensions of the irreducible representations of the Monster group `𝕄`. We record
the first irreducible dimensions and `j`-coefficients as data and prove the
celebrated head-character relations.
-/

namespace RequestProject.Math.Monster

/-- Dimensions of the first irreducible representations of the Monster group
`𝕄` (the "graded generators"): the trivial rep, the `196883`-dimensional Griess
rep, and the next two irreducibles. -/
def monsterIrrep : ℕ → ℕ
  | 0 => 1
  | 1 => 196883
  | 2 => 21296876
  | 3 => 842609326
  | _ => 0

/-- Coefficients of the normalized modular `j`-invariant
`J(q) = q⁻¹ + 196884 q + 21493760 q² + 864299970 q³ + …`, indexed by the power of
`q` (so `jCoeff 1 = 196884`). These are the graded dimensions of the moonshine
module. -/
def jCoeff : ℕ → ℕ
  | 1 => 196884
  | 2 => 21493760
  | 3 => 864299970
  | _ => 0

/-- **First moonshine relation.** The first nontrivial `j`-coefficient is the
sum of the two smallest Monster irreducible dimensions. -/
theorem moonshine_head₁ :
    jCoeff 1 = monsterIrrep 0 + monsterIrrep 1 := by decide

/-- **Second moonshine relation.** -/
theorem moonshine_head₂ :
    jCoeff 2 = monsterIrrep 0 + monsterIrrep 1 + monsterIrrep 2 := by decide

/-- **Third moonshine relation.** -/
theorem moonshine_head₃ :
    jCoeff 3 = 2 * monsterIrrep 0 + 2 * monsterIrrep 1
      + monsterIrrep 2 + monsterIrrep 3 := by decide

/-- The Griess representation dimension, the defining generator of the Monster's
linear action, is `196883`. -/
theorem griess_dim : monsterIrrep 1 = 196883 := rfl

end RequestProject.Math.Monster
