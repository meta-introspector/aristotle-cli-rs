/-
Copyright (c) 2026 PIE Lab / DULA Collaboration. All rights reserved.
-/
import Mathlib
import RequestProject.Imported.Sessfb8ef01a.DulaCosmohedron

open Set

namespace CosmohedralFan

-- Assume `Matryoshka` is your combinatorial indexing type (e.g., ConvTree)
variable {α : Type} [LinearOrder α]

/-- Step 1: Define the meet (intersection) operation on the Matryoshkas.
    The intersection of two nested bracketings is their greatest common sub-bracketing.
    Concretely, the meet takes the union of bracket sets, giving the most refined
    common lower bound (smallest cone = intersection of constraints). -/
instance : Min (ConvTree α) where
  min M1 M2 := ⟨M1.brackets ∪ M2.brackets⟩

@[simp] lemma inf_brackets (M1 M2 : ConvTree α) :
    (min M1 M2).brackets = M1.brackets ∪ M2.brackets := rfl

instance : SemilatticeInf (ConvTree α) where
  inf := min
  inf_le_left := fun _ _ => Finset.subset_union_left
  inf_le_right := fun _ _ => Finset.subset_union_right
  le_inf := fun _ _ _ hab hac => Finset.union_subset hab hac

/-- Step 2: The cone mapping.
    Maps a Matryoshka to its geometric cone defined by containment inequalities.
    Each bracket b ∈ M.brackets imposes the constraint that the function f
    is order-preserving on b: for all a, c ∈ b with a ≤ c, we have f(a) ≤ f(c). -/
def matryoshkaCone (M : ConvTree α) : Set (α → ℝ) :=
  {f | ∀ b ∈ M.brackets, ∀ a ∈ b, ∀ c ∈ b, a ≤ c → f a ≤ f c}

/-- Step 3: The Intersection Lemma.
    The geometric intersection of two cones is the cone of their combinatorial meet.
    This follows because the cone constraints are per-bracket, so the intersection
    of constraint sets equals the constraints for the union of bracket sets. -/
lemma matryoshkaCone_inter (M1 M2 : ConvTree α) :
    matryoshkaCone M1 ∩ matryoshkaCone M2 = matryoshkaCone (M1 ⊓ M2) := by
  ext f
  simp only [matryoshkaCone, Set.mem_inter_iff, Set.mem_setOf_eq]
  constructor
  · rintro ⟨h1, h2⟩ b hb a ha c hc hle
    have hb' : b ∈ M1.brackets ∪ M2.brackets := hb
    rw [Finset.mem_union] at hb'
    cases hb' with
    | inl h => exact h1 b h a ha c hc hle
    | inr h => exact h2 b h a ha c hc hle
  · intro h
    refine ⟨fun b hb => h b ?_, fun b hb => h b ?_⟩
    · exact Finset.mem_union_left _ hb
    · exact Finset.mem_union_right _ hb

/-- Step 4: The Face Lemma.
    If M_sub ≤ M_super in the poset, then cone(M_sub) is a face of cone(M_super).
    Since M_sub ≤ M_super means M_super.brackets ⊆ M_sub.brackets,
    every constraint of M_super is also a constraint of M_sub,
    so the cone of M_sub (with more constraints) is contained in the cone of M_super. -/
lemma matryoshkaCone_isFace_of_le {M_sub M_super : ConvTree α} (h : M_sub ≤ M_super) :
    IsFace (matryoshkaCone M_sub) (matryoshkaCone M_super) := by
  intro f hf b hb a ha c hc hle
  exact hf b (h hb) a ha c hc hle

/-- Step 5: Resolving the Fan Intersection Condition. -/
theorem conesIntersectProperly (M1 M2 : ConvTree α) :
    IsFace (matryoshkaCone M1 ∩ matryoshkaCone M2) (matryoshkaCone M1) ∧
    IsFace (matryoshkaCone M1 ∩ matryoshkaCone M2) (matryoshkaCone M2) := by
  -- The proof elegantly falls out from the lemmas above.
  rw [matryoshkaCone_inter]
  exact ⟨matryoshkaCone_isFace_of_le inf_le_left, matryoshkaCone_isFace_of_le inf_le_right⟩

end CosmohedralFan
