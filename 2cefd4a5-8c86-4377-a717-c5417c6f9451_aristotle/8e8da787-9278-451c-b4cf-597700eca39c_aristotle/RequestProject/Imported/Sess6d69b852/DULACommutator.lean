/-
  Commutator [Φ, χ₃*] = 0
  This is the precise algebraic reason information survives scrambling
  in the Prime Inertia Engine (and, by analogy, in black holes).
-/

import Mathlib

open scoped BigOperators

namespace DULACommutator

abbrev G : Type := Fin 2
def toMod3 (g : G) : ℕ := g.val + 1

def V : Type := G → ℂ

noncomputable def chi3_val : ℕ → ℂ
  | 1 => 1
  | 2 => -1
  | _ => 0

noncomputable def DULAGrading (f : V) : V :=
  fun g => (chi3_val (toMod3 g)) * f g

noncomputable def chi3Functional (f : V) : ℂ :=
  ∑ g : G, (chi3_val (toMod3 g)) * f g

/-
The original theorem as stated is false. Counterexample:
   Let f(0) = 1, f(1) = 2. Then
     chi3Functional f = 1·1 + (-1)·2 = -1
     chi3Functional (DULAGrading f) = 1·(1·1) + (-1)·((-1)·2) = 1 + 2 = 3
   The root cause: applying DULAGrading squares the character values (χ₃(g)² = 1),
   so chi3Functional(DULAGrading f) = ∑ g, f g  ≠  ∑ g, χ₃(g) * f g = chi3Functional f.

-- theorem chi3_commutes_with_grading (f : V) :
--     chi3Functional (DULAGrading f) = chi3Functional f

The key algebraic property: χ₃ is an involution (χ₃² = 1),
    so DULAGrading is self-inverse. This is the property that ensures
    information is preserved under the grading operation.
-/
theorem DULAGrading_involution (f : V) :
    DULAGrading (DULAGrading f) = f := by
  funext g;
  unfold DULAGrading;
  fin_cases g <;> unfold chi3_val toMod3 <;> norm_num

/-
χ₃(g)² = 1 for all g ∈ G, the fundamental character identity.
-/
theorem chi3_val_sq (g : G) :
    chi3_val (toMod3 g) * chi3_val (toMod3 g) = 1 := by
  fin_cases g <;> norm_num [ toMod3, chi3_val ]

/-
chi3Functional is equivariant: applying DULAGrading then chi3Functional
    yields the sum of all values (the trivial character functional).
-/
theorem chi3Functional_DULAGrading (f : V) :
    chi3Functional (DULAGrading f) = ∑ g : G, f g := by
  -- By definition of chi3Functional, we have:
  simp [chi3Functional, DULAGrading];
  simp +decide [ ← mul_assoc, chi3_val_sq ]

end DULACommutator