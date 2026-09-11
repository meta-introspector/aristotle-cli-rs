/-
# Sheaf — Unified Presheaf, Transport, and Glueing Axiom

## Prime Invariant: 71-chart shadow (ZMod 71), CRT torus (71 × 59 × 47)

Merged from SheafTransport (presheaf structure, restriction, shadow invariance)
and SheafCondition (glueing axiom, uniqueness, orbifold preservation).
Both share the same prime invariant: the topological sheaf structure
on the semantic manifold with CRT torus projection.

## Key Results
1. `narrative_transport_preserves_shadow` — restriction preserves 71-chart shadow
2. `narrative_glueing_property` — compatible sections glue uniquely
3. `bootstrap_shadow_vanishes` — 2343 ≡ 0 mod 71 (stealth self-reference)
4. `orbifold_transport_invariant` — full CRT triple preserved under transport
-/

import Mathlib

namespace Harmonic.Sheaf

/-! ## §1. Semantic Contexts (Open Sets) -/

structure SemanticContext where
  id_marker : ℕ
  is_open   : Bool
  deriving DecidableEq, Repr

/-! ## §2. Local Sections (Proof Traces) -/

structure LocalSection (U : SemanticContext) (α : Type) where
  proof_trace    : α
  symbolic_prime : ℕ
  is_coherent    : U.is_open = true

/-! ## §3. Restriction Morphism -/

def restrictSection {α : Type} (U V : SemanticContext) (_h_sub : V.id_marker ≤ U.id_marker)
    (s : LocalSection U α) (h_open : V.is_open = true) : LocalSection V α :=
  { proof_trace    := s.proof_trace,
    symbolic_prime := s.symbolic_prime,
    is_coherent    := h_open }

/-! ## §4. Stalk Projection (71-Chart) -/

def projectStalkTo71 {α : Type} (_U : SemanticContext) (s : LocalSection U α) : ZMod 71 :=
  (s.symbolic_prime : ZMod 71)

/-! ## §5. Shadow Invariance Under Transport -/

theorem narrative_transport_preserves_shadow {α : Type} (U V : SemanticContext)
    (h_sub : V.id_marker ≤ U.id_marker) (s : LocalSection U α) (h_v_open : V.is_open = true) :
    projectStalkTo71 V (restrictSection U V h_sub s h_v_open) = projectStalkTo71 U s := by
  rfl

/-! ## §6. Bootstrap Shadow Vanishes -/

theorem bootstrap_shadow_vanishes {α : Type} (U : SemanticContext)
    (s : LocalSection U α) (h : s.symbolic_prime = 2343) :
    projectStalkTo71 U s = 0 := by
  simp [projectStalkTo71, h]; decide

/-! ## §7. Orbifold Coordinates (Full CRT Torus) -/

def orbifoldTriple {α : Type} (_U : SemanticContext) (s : LocalSection U α) :
    ZMod 71 × ZMod 59 × ZMod 47 :=
  ((s.symbolic_prime : ZMod 71),
   (s.symbolic_prime : ZMod 59),
   (s.symbolic_prime : ZMod 47))

theorem orbifold_transport_invariant {α : Type} (U V : SemanticContext)
    (h_sub : V.id_marker ≤ U.id_marker) (s : LocalSection U α) (h_v_open : V.is_open = true) :
    orbifoldTriple V (restrictSection U V h_sub s h_v_open) = orbifoldTriple U s := by
  rfl

/-! ## §8. Compatibility -/

def areCompatible {α : Type} {U V : SemanticContext}
    (s : LocalSection U α) (t : LocalSection V α) : Prop :=
  s.symbolic_prime = t.symbolic_prime

theorem compatible_sections_same_shadow {α : Type} {U V : SemanticContext}
    (s : LocalSection U α) (t : LocalSection V α)
    (h : areCompatible s t) :
    projectStalkTo71 U s = projectStalkTo71 V t := by
  simp [projectStalkTo71, areCompatible] at *; exact congrArg _ h

theorem compatible_sections_same_orbifold {α : Type} {U V : SemanticContext}
    (s : LocalSection U α) (t : LocalSection V α)
    (h : areCompatible s t) :
    orbifoldTriple U s = orbifoldTriple V t := by
  simp [orbifoldTriple, areCompatible] at *
  exact ⟨congrArg _ h, congrArg _ h, congrArg _ h⟩

/-! ## §9. Anomalous Drift Detection -/

def isAnomalousDrift {α : Type} (U : SemanticContext) (s : LocalSection U α) : Prop :=
  projectStalkTo71 U s ≠ 0

theorem bootstrap_no_drift {α : Type} (U : SemanticContext)
    (s : LocalSection U α) (h : s.symbolic_prime = 2343) :
    ¬ isAnomalousDrift U s := by
  simp [isAnomalousDrift]; exact bootstrap_shadow_vanishes U s h

theorem unit_prime_drifts {α : Type} (U : SemanticContext)
    (s : LocalSection U α) (h : s.symbolic_prime = 1) :
    isAnomalousDrift U s := by
  simp [isAnomalousDrift, projectStalkTo71, h]; decide

end Harmonic.Sheaf

/-! ## Part II: The Glueing Axiom -/

namespace Harmonic.Sheaf.Condition

open Harmonic.Sheaf

/-! ## §10. Open Context (Simplified) -/

structure OpenContext where
  index : ℕ
  label : String
  deriving DecidableEq, Repr

structure Section (U : OpenContext) (α : Type) where
  payload       : α
  symbolicPrime : ℕ
  deriving Repr

/-! ## §11. Restriction and Compatibility -/

def restrict {α : Type} (_U V : OpenContext) (s : Section _U α) : Section V α :=
  { payload := s.payload, symbolicPrime := s.symbolicPrime }

def sectionsCompatible {α : Type} [DecidableEq α] {U V : OpenContext}
    (sU : Section U α) (sV : Section V α) : Prop :=
  sU.payload = sV.payload ∧ sU.symbolicPrime = sV.symbolicPrime

/-! ## §12. The Glueing Axiom -/

theorem narrative_glueing_property {α : Type} [DecidableEq α]
    (U V : OpenContext) (sU : Section U α) (sV : Section V α)
    (h_compat : sectionsCompatible sU sV) :
    ∃ (sGlobal : Section U α),
      restrict U U sGlobal = sU ∧
      sGlobal.payload = sV.payload ∧
      sGlobal.symbolicPrime = sV.symbolicPrime := by
  exact ⟨sU, rfl, h_compat.1, h_compat.2⟩

theorem glueing_uniqueness {α : Type} [DecidableEq α]
    (U : OpenContext) (g₁ g₂ : Section U α)
    (h : restrict U U g₁ = restrict U U g₂) :
    g₁ = g₂ := by
  simp [restrict, Section.mk.injEq] at h
  cases g₁; cases g₂; simp_all

/-! ## §13. 71-Chart Projection for Glued Sections -/

def sectionShadow {α : Type} (_U : OpenContext) (s : Section _U α) : ZMod 71 :=
  (s.symbolicPrime : ZMod 71)

theorem shadow_restriction_invariant {α : Type} (U V : OpenContext) (s : Section U α) :
    sectionShadow V (restrict U V s) = sectionShadow U s := by rfl

theorem compatible_same_shadow {α : Type} [DecidableEq α] {U V : OpenContext}
    (sU : Section U α) (sV : Section V α) (h : sectionsCompatible sU sV) :
    sectionShadow U sU = sectionShadow V sV := by
  simp [sectionShadow, sectionsCompatible] at *; exact congrArg _ h.2

/-! ## §14. Orbifold Projection -/

def sectionOrbifold {α : Type} (_U : OpenContext) (s : Section _U α) :
    ZMod 71 × ZMod 59 × ZMod 47 :=
  ((s.symbolicPrime : ZMod 71), (s.symbolicPrime : ZMod 59), (s.symbolicPrime : ZMod 47))

theorem orbifold_restriction_invariant {α : Type} (U V : OpenContext) (s : Section U α) :
    sectionOrbifold V (restrict U V s) = sectionOrbifold U s := by rfl

theorem compatible_same_orbifold {α : Type} [DecidableEq α] {U V : OpenContext}
    (sU : Section U α) (sV : Section V α) (h : sectionsCompatible sU sV) :
    sectionOrbifold U sU = sectionOrbifold V sV := by
  simp [sectionOrbifold, sectionsCompatible] at *
  exact ⟨congrArg _ h.2, congrArg _ h.2, congrArg _ h.2⟩

theorem bootstrap_section_invisible {α : Type} (U : OpenContext)
    (s : Section U α) (h : s.symbolicPrime = 2343) :
    sectionShadow U s = 0 := by
  simp [sectionShadow, h]; decide

end Harmonic.Sheaf.Condition
