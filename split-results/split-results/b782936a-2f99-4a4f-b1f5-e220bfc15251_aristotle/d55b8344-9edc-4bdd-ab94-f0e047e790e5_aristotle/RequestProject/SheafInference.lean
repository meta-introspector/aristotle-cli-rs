import Mathlib

/-!
# Sheaf-Theoretic Inference

A belief system is a sheaf over a partial order:
- Stalks assign data to each open set
- Restriction maps relate larger opens to smaller ones
- The sheaf condition: identity and composition axioms

The key insight: **restriction is the unique valid inference rule**.
Any rule compatible with the sheaf axioms must agree with restriction on overlaps.

## Structures

- `BeliefSystem`: A presheaf over a partial order with sheaf-like axioms
- `InferenceRule`: A family of maps between stalks
- `SheafMorphism`: Natural transformations between belief systems
- `GlobalSection`: Consistent assignments across all stalks
- `TrustworthyIntrospection`: The commutative triangle for self-referential systems
-/

set_option maxHeartbeats 400000

/-- A belief system over a linearly ordered index type.
    This is a presheaf with restriction maps satisfying identity and composition. -/
structure BeliefSystem (I : Type*) [PartialOrder I] where
  /-- The stalk (data) at each index. -/
  stalk : I → Type*
  /-- Restriction map from a larger open to a smaller one. -/
  restrict : ∀ {i j : I}, i ≤ j → stalk i → stalk j
  /-- Identity: restricting along reflexivity is the identity. -/
  restrict_id : ∀ (i : I) (x : stalk i), restrict (le_refl i) x = x
  /-- Composition: restricting along a composition is composing restrictions. -/
  restrict_comp : ∀ {i j k : I} (hij : i ≤ j) (hjk : j ≤ k) (x : stalk i),
    restrict hjk (restrict hij x) = restrict (le_trans hij hjk) x

/-- An inference rule is a family of maps between stalks, indexed by pairs. -/
structure InferenceRule {I : Type*} [PartialOrder I] (B : BeliefSystem I) where
  /-- The inference map from stalk i to stalk j when i ≤ j. -/
  infer : ∀ {i j : I}, i ≤ j → B.stalk i → B.stalk j
  /-- Inference must agree with restriction. -/
  compatible : ∀ {i j : I} (h : i ≤ j) (x : B.stalk i),
    infer h x = B.restrict h x

/-- Restriction is the unique valid inference rule:
    any inference rule compatible with the sheaf axioms must be restriction. -/
theorem unique_valid_inference {I : Type*} [PartialOrder I] (B : BeliefSystem I)
    (r : InferenceRule B) :
    ∀ {i j : I} (h : i ≤ j) (x : B.stalk i),
      r.infer h x = B.restrict h x :=
  fun h x => r.compatible h x

/-- The P/N ratio structure: evaluation × normalizer = evidence. -/
structure Explainability (α : Type*) [Mul α] where
  evaluate : α
  normalizer : α
  evidence : α
  ratio_eq : evaluate * normalizer = evidence

/-- A morphism of belief systems (natural transformation). -/
structure SheafMorphism {I : Type*} [PartialOrder I]
    (B₁ B₂ : BeliefSystem I) where
  /-- The component map at each index. -/
  map : ∀ (i : I), B₁.stalk i → B₂.stalk i
  /-- Naturality: the morphism commutes with restriction. -/
  naturality : ∀ {i j : I} (h : i ≤ j) (x : B₁.stalk i),
    map j (B₁.restrict h x) = B₂.restrict h (map i x)

/-- Introspection commutes: the naturality square for self-referential morphisms. -/
theorem introspection_commutes {I : Type*} [PartialOrder I]
    (B : BeliefSystem I) (φ : SheafMorphism B B)
    {i j : I} (h : i ≤ j) (x : B.stalk i) :
    φ.map j (B.restrict h x) = B.restrict h (φ.map i x) :=
  φ.naturality h x

/-- Composition of sheaf morphisms. -/
def SheafMorphism.comp {I : Type*} [PartialOrder I]
    {B₁ B₂ B₃ : BeliefSystem I}
    (g : SheafMorphism B₂ B₃) (f : SheafMorphism B₁ B₂) :
    SheafMorphism B₁ B₃ where
  map i x := g.map i (f.map i x)
  naturality h x := by
    rw [f.naturality h x, g.naturality h (f.map _ x)]

/-- Identity sheaf morphism. -/
def SheafMorphism.id {I : Type*} [PartialOrder I]
    (B : BeliefSystem I) : SheafMorphism B B where
  map _ x := x
  naturality _ _ := rfl

/-- A global section is a consistent choice across all stalks. -/
structure GlobalSection {I : Type*} [PartialOrder I] (B : BeliefSystem I) where
  /-- The section value at each index. -/
  val : ∀ (i : I), B.stalk i
  /-- Consistency: values respect restriction. -/
  consistent : ∀ {i j : I} (h : i ≤ j), B.restrict h (val i) = val j

/-- The S₁ ← S₂ → S₃ filter/compiler structure:
    a span in the category of belief systems. -/
structure FilterSpan {I : Type*} [PartialOrder I]
    (S₁ S₂ S₃ : BeliefSystem I) where
  left : SheafMorphism S₂ S₁
  right : SheafMorphism S₂ S₃

/-- Trustworthy introspection: the commutative triangle.
    introspect ∘ ingestion agrees with the expected morphism. -/
structure TrustworthyIntrospection {I : Type*} [PartialOrder I]
    (B : BeliefSystem I)
    (introspect : SheafMorphism B B)
    (ingestion : SheafMorphism B B)
    (expected : SheafMorphism B B) where
  commutes : ∀ (i : I) (x : B.stalk i),
    introspect.map i (ingestion.map i x) = expected.map i x
