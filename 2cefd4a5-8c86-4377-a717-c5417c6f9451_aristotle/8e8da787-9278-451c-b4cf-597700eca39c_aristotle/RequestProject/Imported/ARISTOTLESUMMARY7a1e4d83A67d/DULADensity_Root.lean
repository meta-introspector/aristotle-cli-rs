import Mathlib
import Mathlib.Analysis.LocallyConvex.Separation
import RequestProject.Imported.ARISTOTLESUMMARY7a1e4d83A67d.CEWeilTransfer_Root

namespace DULA

open MeasureTheory Topology Filter Set ContinuousLinearMap

variable (Φ : CohnElkiesFunction 24 → SchwartzMap ℝ ℝ)

/-- We refine SchwartzImageIsDense to target the Linear Span, 
    as Hahn-Banach separates vector subspaces, not arbitrary sets. -/
def SchwartzSpanIsDense {S : Type*} (Φ : S → SchwartzMap ℝ ℝ) : Prop :=
  Dense (Submodule.span ℝ (Set.range Φ) : Set (SchwartzMap ℝ ℝ))

/-- A map Φ has a trivial annihilator if every continuous 
    linear functional vanishing on the image of Φ is zero. -/
def AnnihilatorIsTrivial {S : Type*} (Φ : S → SchwartzMap ℝ ℝ) : Prop :=
  ∀ T : SchwartzMap ℝ ℝ →L[ℝ] ℝ, (∀ f : S, T (Φ f) = 0) → T = 0

/-- 
  THE GEOMETRIC HAHN-BANACH KILL
  By Geometric Hahn-Banach, a trivial annihilator implies the linear span 
  is topologically dense in the Fréchet space. 
  STATUS: PROVED (Zero Sorries)
-/
/-
NOTE (import repair): the proof below was re-done for this Lean/Mathlib version.  The
original script used `Set.ne_univ_iff_exists_not_mem` (now `Set.ne_univ_iff_exists_notMem`)
and a lemma `Submodule.exists_continuousLinearMap_of_not_mem_closure`, which does not exist
in Mathlib.  The separation step is now carried out with `geometric_hahn_banach_closed_point`
applied to the topological closure of the span, plus the standard argument that a continuous
linear functional which is bounded above on a subspace vanishes on it.  The statement is
unchanged.
-/
theorem annihilator_trivial_implies_span_dense {S : Type*} (Φ : S → SchwartzMap ℝ ℝ)
    (h_trivial : AnnihilatorIsTrivial Φ) : SchwartzSpanIsDense Φ := by
  -- Step 1: Proof by contradiction: assume the closure of the span is not the whole space.
  rw [SchwartzSpanIsDense, dense_iff_closure_eq]
  by_contra h_not_dense
  -- Step 2: The ghost point: some `x₀` lies outside the closure of the span.
  obtain ⟨x₀, hx₀⟩ : ∃ x₀ : SchwartzMap ℝ ℝ,
      x₀ ∉ closure (Submodule.span ℝ (Set.range Φ) : Set (SchwartzMap ℝ ℝ)) := by
    rw [← Set.ne_univ_iff_exists_notMem]
    exact h_not_dense
  -- The closure of the span, as a submodule; it is closed and convex.
  set K : Submodule ℝ (SchwartzMap ℝ ℝ) :=
    (Submodule.span ℝ (Set.range Φ)).topologicalClosure with hK
  have hKclosed : IsClosed (K : Set (SchwartzMap ℝ ℝ)) :=
    (Submodule.span ℝ (Set.range Φ)).isClosed_topologicalClosure
  have hx₀K : x₀ ∉ (K : Set (SchwartzMap ℝ ℝ)) := hx₀
  -- Step 3: geometric Hahn-Banach separation of the point from the closed subspace.
  obtain ⟨f, u, hfa, hfx⟩ :=
    geometric_hahn_banach_closed_point
      (K : Submodule ℝ (SchwartzMap ℝ ℝ)).convex hKclosed hx₀K
  -- A continuous functional bounded above on a subspace vanishes on it.
  have hzero : ∀ a ∈ K, f a = 0 := by
    intro a ha
    by_contra h
    rcases lt_or_gt_of_ne h with hneg | hpos
    · have := hfa ((u / f a - 1) • a) (K.smul_mem _ ha)
      rw [map_smul] at this
      simp only [smul_eq_mul] at this
      rw [sub_mul, div_mul_cancel₀ _ (ne_of_lt hneg), one_mul] at this
      linarith
    · have := hfa ((u / f a + 1) • a) (K.smul_mem _ ha)
      rw [map_smul] at this
      simp only [smul_eq_mul] at this
      rw [add_mul, div_mul_cancel₀ _ (ne_of_gt hpos), one_mul] at this
      linarith
  -- Step 4/5: `f` annihilates the image of `Φ`, hence is the zero functional.
  have hTzero : f = 0 := by
    apply h_trivial
    intro s
    exact hzero (Φ s) (Submodule.le_topologicalClosure _ (Submodule.subset_span ⟨s, rfl⟩))
  -- Step 6: the contradiction `0 < u < f x₀ = 0`.
  rw [hTzero] at hfx hfa
  have h0 : (0 : ℝ) < u := by simpa using hfa 0 K.zero_mem
  simp at hfx
  linarith

end DULA
