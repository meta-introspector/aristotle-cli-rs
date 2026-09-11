/-
  DashiAdmissibility.lean — Formalization of the dashiCORE Admissibility specification.

  Formalizes admissibility quotient semantics from MATH.md §5:
    • Admissibility transforms preserve physical content
    • Equivalence relation (reflexive, symmetric, transitive)
    • Kernel compatibility (equivariance)
    • MDL ordering

  Key results:
    • Admissibility defines an equivalence relation on carrier fields
    • Admissibility transforms compose and form a groupoid
    • MDL comparison is deterministic
-/
import Mathlib
import RequestProject.DashiCarrier
import RequestProject.DashiKernel

namespace DashiCORE

/-! ## §1. Admissibility Transform -/

/-- An admissibility transform is a structure-preserving map on carrier fields.
    It must be invertible (bijective on carrier fields). -/
structure AdmissibilityTransform (Ω : Type*) where
  /-- The forward transform. -/
  fwd : CarrierField Ω → CarrierField Ω
  /-- The inverse transform. -/
  inv : CarrierField Ω → CarrierField Ω
  /-- Round-trip: fwd ∘ inv = id. -/
  fwd_inv : ∀ s, fwd (inv s) = s
  /-- Round-trip: inv ∘ fwd = id. -/
  inv_fwd : ∀ s, inv (fwd s) = s

/-! ## §2. Admissibility Equivalence Relation -/

/-- Two carrier fields are admissibility-equivalent iff there exists
    an admissibility transform relating them. -/
def admissible_equiv {Ω : Type*} (s₁ s₂ : CarrierField Ω) : Prop :=
  ∃ g : AdmissibilityTransform Ω, g.fwd s₁ = s₂

/-- Admissibility equivalence is reflexive. -/
theorem admissible_equiv_refl {Ω : Type*} (s : CarrierField Ω) :
    admissible_equiv s s :=
  ⟨{ fwd := id, inv := id, fwd_inv := fun _ => rfl, inv_fwd := fun _ => rfl }, rfl⟩

/-- Admissibility equivalence is symmetric. -/
theorem admissible_equiv_symm {Ω : Type*} {s₁ s₂ : CarrierField Ω}
    (h : admissible_equiv s₁ s₂) : admissible_equiv s₂ s₁ := by
  obtain ⟨g, hg⟩ := h
  refine ⟨{ fwd := g.inv, inv := g.fwd, fwd_inv := g.inv_fwd, inv_fwd := g.fwd_inv }, ?_⟩
  subst hg; exact g.inv_fwd s₁

/-- Admissibility equivalence is transitive. -/
theorem admissible_equiv_trans {Ω : Type*} {s₁ s₂ s₃ : CarrierField Ω}
    (h₁₂ : admissible_equiv s₁ s₂) (h₂₃ : admissible_equiv s₂ s₃) :
    admissible_equiv s₁ s₃ := by
  obtain ⟨g₁, hg₁⟩ := h₁₂
  obtain ⟨g₂, hg₂⟩ := h₂₃
  refine ⟨{
    fwd := g₂.fwd ∘ g₁.fwd,
    inv := g₁.inv ∘ g₂.inv,
    fwd_inv := fun s => by simp [Function.comp, g₁.fwd_inv, g₂.fwd_inv],
    inv_fwd := fun s => by simp [Function.comp, g₂.inv_fwd, g₁.inv_fwd] }, ?_⟩
  simp [Function.comp, hg₁, hg₂]

/-- Admissibility equivalence is an equivalence relation. -/
theorem admissible_equiv_equivalence (Ω : Type*) :
    Equivalence (@admissible_equiv Ω) :=
  ⟨admissible_equiv_refl, fun h => admissible_equiv_symm h, fun h₁ h₂ => admissible_equiv_trans h₁ h₂⟩

/-! ## §3. Kernel Compatibility (Equivariance) -/

/-- A kernel is equivariant with respect to a transform iff
    K(g(s)) ~ g(K(s)). -/
def kernelEquivariant {Ω : Type*}
    (g : AdmissibilityTransform Ω) (k : Kernel Ω) : Prop :=
  ∀ s, admissible_equiv (k.K (g.fwd s)) (g.fwd (k.K s))

/-- Strict equivariance: K(g(s)) = g(K(s)). -/
def kernelStrictlyEquivariant {Ω : Type*}
    (g : AdmissibilityTransform Ω) (k : Kernel Ω) : Prop :=
  ∀ s, k.K (g.fwd s) = g.fwd (k.K s)

/-- Strict equivariance implies equivariance. -/
theorem strict_implies_equivariant {Ω : Type*}
    (g : AdmissibilityTransform Ω) (k : Kernel Ω)
    (h : kernelStrictlyEquivariant g k) :
    kernelEquivariant g k := by
  intro s; rw [h s]; exact admissible_equiv_refl _

/-- The identity kernel is strictly equivariant with all transforms. -/
theorem identityKernel_equivariant {Ω : Type*}
    (g : AdmissibilityTransform Ω) :
    kernelStrictlyEquivariant g (identityKernel Ω) :=
  fun _ => rfl

/-! ## §4. MDL Ordering -/

/-- An MDL scoring functional: maps representations to non-negative reals. -/
structure MDLScore (Ω : Type*) where
  score : CarrierField Ω → ℝ
  nonneg : ∀ s, 0 ≤ score s

/-- MDL invariance under admissibility. -/
def MDLScore.isAdmissibilityInvariant {Ω : Type*}
    (m : MDLScore Ω) (g : AdmissibilityTransform Ω) : Prop :=
  ∀ s, m.score (g.fwd s) = m.score s

/-- MDL comparison result. -/
inductive MDLComparison where
  | A_preferred : MDLComparison
  | B_preferred : MDLComparison
  | tie         : MDLComparison
  deriving DecidableEq, Repr

/-- Compare two representations by MDL score. -/
noncomputable def mdlCompare {Ω : Type*} (m : MDLScore Ω)
    (s₁ s₂ : CarrierField Ω) : MDLComparison :=
  if m.score s₁ < m.score s₂ then .A_preferred
  else if m.score s₂ < m.score s₁ then .B_preferred
  else .tie

/-- If MDL is admissibility-invariant, equivalent reps get `tie`. -/
theorem mdl_tie_on_equivalent {Ω : Type*} (m : MDLScore Ω)
    (g : AdmissibilityTransform Ω)
    (hinv : m.isAdmissibilityInvariant g)
    (s : CarrierField Ω) :
    mdlCompare m s (g.fwd s) = .tie := by
  simp [mdlCompare, hinv s]

end DashiCORE
