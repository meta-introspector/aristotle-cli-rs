/-
# Constructed Groups
This file provides concrete constructions of some groups appearing in the
ATLAS and proves properties about them using Lean's computational kernel.
The ATLAS primarily records *data* about groups (character tables, maximal
subgroups, etc.), but for a formalization it is natural to also construct
the groups themselves and verify the data matches.
-/
import Mathlib
set_option maxHeartbeats 4000000
open Equiv Equiv.Perm
/-! ## The Alternating Group A₅
A₅ is the smallest non-abelian simple group (order 60).
In the ATLAS it appears as the first entry and is isomorphic to
L₂(4) ≅ L₂(5).
-/
/-- A₅ has order 60. -/
theorem A5_card : Fintype.card (alternatingGroup (Fin 5)) = 60 := by native_decide
/-- A₅ is nontrivial. -/
instance : Nontrivial (alternatingGroup (Fin 5)) :=
  Fintype.one_lt_card_iff_nontrivial.mp (by native_decide)
/-
A₅ is simple. This is the base case for the theorem that
    alternating groups Aₙ are simple for n ≥ 5.
    Proof: A₅ has order 60 = 2² · 3 · 5. By checking all possible
    orders of normal subgroups (which must be unions of conjugacy classes
    containing the identity, with order dividing 60), one verifies that
    only {e} and A₅ itself qualify.
-/
instance A5_simple : IsSimpleGroup (alternatingGroup (Fin 5)) := by
  infer_instance
/-! ## The Alternating Group A₆
A₆ has order 360 and is notable for being the only alternating group
with |Out(Aₙ)| > 2 (it has |Out(A₆)| = 4).
-/
/-- A₆ has order 360. -/
theorem A6_card : Fintype.card (alternatingGroup (Fin 6)) = 360 := by native_decide
/-- A₆ is nontrivial. -/
instance : Nontrivial (alternatingGroup (Fin 6)) :=
  Fintype.one_lt_card_iff_nontrivial.mp (by native_decide)
/-! ## The Symmetric Groups
The symmetric groups Sₙ are the ambient groups in which alternating
groups sit as index-2 subgroups.
-/
/-- S₅ has order 120. -/
theorem S5_order : Fintype.card (Equiv.Perm (Fin 5)) = 120 := by native_decide
/-- S₆ has order 720. -/
theorem S6_order : Fintype.card (Equiv.Perm (Fin 6)) = 720 := by native_decide
/-! ## Small Linear Groups
The ATLAS records many groups of Lie type. The smallest is L₂(2) ≅ S₃
(order 6). The next interesting ones are L₂(4) ≅ L₂(5) ≅ A₅ (order 60)
and L₂(7) ≅ L₃(2) (order 168).
-/
/-- GL(2, 𝔽₃) ≅ 2.S₄ has order 48.
    This is a maximal subgroup of M₁₁. -/
theorem GL2_F3_order : Fintype.card (Matrix.GeneralLinearGroup (Fin 2) (ZMod 3)) = 48 := by
  native_decide
/-- GL(2, 𝔽₂) ≅ S₃ has order 6. -/
theorem GL2_F2_order : Fintype.card (Matrix.GeneralLinearGroup (Fin 2) (ZMod 2)) = 6 := by
  native_decide
/-- GL(3, 𝔽₂) has order 168 and GL(3,𝔽₂)/Z ≅ L₃(2) ≅ L₂(7), the smallest
    exceptional isomorphism among groups of Lie type. -/
theorem GL3_F2_order : Fintype.card (Matrix.GeneralLinearGroup (Fin 3) (ZMod 2)) = 168 := by
  native_decide
/-! ## Verification of GL(n,q) order formula
The order of GL(n,q) is ∏ᵢ₌₀ⁿ⁻¹ (qⁿ - qⁱ). We verify this for small cases.
-/
/-- GL(2, 𝔽₅) has order (5² - 1)(5² - 5) = 24 · 20 = 480. -/
theorem GL2_F5_order : Fintype.card (Matrix.GeneralLinearGroup (Fin 2) (ZMod 5)) = 480 := by
  native_decide
