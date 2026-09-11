/-
Copyright (c) 2026 PIE Lab / DULA Collaboration. All rights reserved.
-/
import Mathlib

/-- A ConvTree (convex tree / Matryoshka) on a linearly ordered type α,
    represented by its set of "brackets" (subsets that are contiguously grouped).

    The partial order is by reverse inclusion of bracket sets:
    M₁ ≤ M₂ iff M₂.brackets ⊆ M₁.brackets
    (i.e., more brackets = smaller in the poset, corresponding to smaller cones). -/
@[ext]
structure ConvTree (α : Type*) [LinearOrder α] where
  brackets : Finset (Finset α)

namespace ConvTree

variable {α : Type*} [LinearOrder α]

instance : PartialOrder (ConvTree α) where
  le M1 M2 := M2.brackets ⊆ M1.brackets
  le_refl _ := Finset.Subset.refl _
  le_trans _ _ _ h12 h23 := Finset.Subset.trans h23 h12
  le_antisymm _ _ h12 h21 := by ext1; exact Finset.Subset.antisymm h21 h12

@[simp] lemma le_def (M1 M2 : ConvTree α) : M1 ≤ M2 ↔ M2.brackets ⊆ M1.brackets := Iff.rfl

end ConvTree

/-- A set F is a face of a set C if F ⊆ C.
    This is a simplified definition suitable for establishing the
    fan intersection property of the cosmohedral fan. -/
def IsFace {E : Type*} (F C : Set E) : Prop := F ⊆ C
