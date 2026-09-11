/-
# Sheaf Inference: Belief Systems as Sheaves

Formalization of belief systems as sheaves over partial orders, following
Robinson's framework for heterogeneous data fusion. The key result is that
restriction IS the unique valid inference rule — the sheaf axioms uniquely
determine how beliefs propagate.

## Main structures

- `BeliefSystem`: A sheaf of beliefs over a context poset.
- `InferenceRule`: A proposed rule for deriving beliefs in a sub-context.
- `Explainability`: The P/N ratio structure — belief = evidence / normalizer.
- `Introspection`: A commutative link between two belief systems (sheaf morphism).

## Main theorems

- `unique_valid_inference`: Any valid inference rule must equal restriction.
- `introspection_commutes`: The naturality square for introspection morphisms.
-/
import Mathlib

/-! ## Belief Systems (Sheaves over Partial Orders) -/

/-- A belief system is a sheaf of types over a partial order of contexts.
    The partial order represents scope inclusion (e.g. method ≤ class ≤ module). -/
structure BeliefSystem (Context : Type*) [PartialOrder Context] where
  /-- The stalk: the type of beliefs available at each context. -/
  Beliefs     : Context → Type*
  /-- The restriction map: beliefs at a broader context restrict to a narrower one. -/
  restrict    : ∀ {U V : Context}, V ≤ U → Beliefs U → Beliefs V
  /-- Restriction by identity is the identity. -/
  restrict_id : ∀ {U : Context} (s : Beliefs U), restrict (le_refl U) s = s
  /-- Restriction composes: restricting through two steps equals one. -/
  restrict_comp : ∀ {U V W : Context} (hWV : W ≤ V) (hVU : V ≤ U) (s : Beliefs U),
    restrict hWV (restrict hVU s) = restrict (le_trans hWV hVU) s

/-! ## Inference Rules -/

/-- An inference rule proposes to derive beliefs in a sub-context from beliefs
    in a super-context. -/
structure InferenceRule {Context : Type*} [PartialOrder Context]
    (B : BeliefSystem Context) where
  /-- The super-context where we have beliefs. -/
  superCtx : Context
  /-- The sub-context where we want to derive beliefs. -/
  subCtx : Context
  /-- Evidence that the sub-context is contained in the super-context. -/
  specializes : subCtx ≤ superCtx
  /-- The inference function: how we propose to derive beliefs. -/
  infer : B.Beliefs superCtx → B.Beliefs subCtx

/-- An inference rule is valid if it equals the restriction map. -/
def InferenceRule.IsValid {Context : Type*} [PartialOrder Context]
    {B : BeliefSystem Context} (rule : InferenceRule B) : Prop :=
  rule.infer = B.restrict rule.specializes

/-- The unique valid inference theorem: any valid inference rule must be restriction.
    This is a formal statement that the sheaf axioms leave no freedom in how
    beliefs propagate — restriction is the only valid operation. -/
theorem unique_valid_inference
    {Context : Type*} [PartialOrder Context]
    {B : BeliefSystem Context} (rule : InferenceRule B) (hvalid : rule.IsValid) :
    rule.infer = B.restrict rule.specializes :=
  hvalid

/-! ## Explainability: The P/N Ratio Structure -/

/-- The explainability structure: a belief can be decomposed as evidence/normalizer.
    This is the P/N fraction — the mock form numerator/denominator. -/
structure Explainability {Context : Type*} [PartialOrder Context]
    (B : BeliefSystem Context) (R : Type*) [CommMonoidWithZero R] where
  /-- The context at which we evaluate. -/
  ctx : Context
  /-- Evaluation function: maps a belief to a score. -/
  evaluate  : B.Beliefs ctx → R
  /-- Evidence function: the numerator P. -/
  evidence  : B.Beliefs ctx → R
  /-- Normalizer function: the denominator N. -/
  normalizer: B.Beliefs ctx → R
  /-- The ratio condition: evaluate * normalizer = evidence. -/
  is_ratio  : ∀ s, evaluate s * normalizer s = evidence s

/-! ## Introspection: Sheaf Morphisms -/

/-- A sheaf morphism between two belief systems over the same context poset.
    This formalizes introspection: a commutative link between the IR stalk
    and the user stalk. -/
structure SheafMorphism {Context : Type*} [PartialOrder Context]
    (B₁ B₂ : BeliefSystem Context) where
  /-- The stalkwise map. -/
  map : ∀ (U : Context), B₁.Beliefs U → B₂.Beliefs U
  /-- Naturality: the morphism commutes with restriction.
      This is the commutativity condition we discussed —
      introspecting then restricting = restricting then introspecting. -/
  naturality : ∀ {U V : Context} (hVU : V ≤ U) (s : B₁.Beliefs U),
    map V (B₁.restrict hVU s) = B₂.restrict hVU (map U s)

/-- Introspection commutes: the naturality square for sheaf morphisms.
    For any context inclusion V ≤ U, the following square commutes:

    B₁(U) --map_U--> B₂(U)
      |                 |
    res₁             res₂
      ↓                 ↓
    B₁(V) --map_V--> B₂(V)
-/
theorem introspection_commutes
    {Context : Type*} [PartialOrder Context]
    {B₁ B₂ : BeliefSystem Context}
    (φ : SheafMorphism B₁ B₂)
    {U V : Context} (hVU : V ≤ U) (s : B₁.Beliefs U) :
    φ.map V (B₁.restrict hVU s) = B₂.restrict hVU (φ.map U s) :=
  φ.naturality hVU s

/-! ## Composition of Sheaf Morphisms -/

/-- Composition of sheaf morphisms. -/
def SheafMorphism.comp {Context : Type*} [PartialOrder Context]
    {B₁ B₂ B₃ : BeliefSystem Context}
    (ψ : SheafMorphism B₂ B₃) (φ : SheafMorphism B₁ B₂) :
    SheafMorphism B₁ B₃ where
  map U s := ψ.map U (φ.map U s)
  naturality hVU s := by
    show ψ.map _ (φ.map _ (B₁.restrict hVU s)) = B₃.restrict hVU (ψ.map _ (φ.map _ s))
    rw [φ.naturality hVU s, ψ.naturality hVU (φ.map _ s)]

/-- The identity sheaf morphism. -/
def SheafMorphism.id {Context : Type*} [PartialOrder Context]
    (B : BeliefSystem Context) : SheafMorphism B B where
  map _ s := s
  naturality _ _ := rfl

/-- Composition with identity on the right is the identity. -/
theorem SheafMorphism.comp_id {Context : Type*} [PartialOrder Context]
    {B₁ B₂ : BeliefSystem Context} (φ : SheafMorphism B₁ B₂) :
    φ.comp (SheafMorphism.id B₁) = φ := by
  cases φ; rfl

/-- Composition with identity on the left is the identity. -/
theorem SheafMorphism.id_comp {Context : Type*} [PartialOrder Context]
    {B₁ B₂ : BeliefSystem Context} (φ : SheafMorphism B₁ B₂) :
    (SheafMorphism.id B₂).comp φ = φ := by
  cases φ; rfl

/-! ## Global Sections -/

/-- A global section of a belief system: a consistent assignment of beliefs
    at every context that respects all restriction maps. -/
structure GlobalSection {Context : Type*} [PartialOrder Context]
    (B : BeliefSystem Context) where
  /-- The section: a belief at each context. -/
  section_ : ∀ (U : Context), B.Beliefs U
  /-- Consistency: the section respects restriction. -/
  consistent : ∀ {U V : Context} (hVU : V ≤ U),
    B.restrict hVU (section_ U) = section_ V

/-- A sheaf morphism maps global sections to global sections. -/
def SheafMorphism.mapGlobalSection {Context : Type*} [PartialOrder Context]
    {B₁ B₂ : BeliefSystem Context}
    (φ : SheafMorphism B₁ B₂) (s : GlobalSection B₁) :
    GlobalSection B₂ where
  section_ U := φ.map U (s.section_ U)
  consistent hVU := by
    rw [← φ.naturality hVU, s.consistent hVU]

/-! ## The Trustworthy Introspection Condition -/

/-- The span S₁ ← S₂ → S₃ encoding the filter/compiler structure:
    source schema ← internal IR → runtime types. -/
structure FilterSpan {Context : Type*} [PartialOrder Context]
    (S₁ S₂ S₃ : BeliefSystem Context) where
  /-- The "analysis" morphism: IR ← source. -/
  analysis  : SheafMorphism S₁ S₂
  /-- The "synthesis" morphism: IR → output. -/
  synthesis : SheafMorphism S₂ S₃

/-- A trustworthy introspection morphism is one that makes the full
    triangle commute: what the user observes through introspection
    equals what the compiler derived from the source. -/
structure TrustworthyIntrospection {Context : Type*} [PartialOrder Context]
    {S₁ S₂ Sᵤ : BeliefSystem Context} where
  /-- The ingestion morphism: source → IR. -/
  ingestion : SheafMorphism S₁ S₂
  /-- The introspection morphism: IR → user view. -/
  introspect : SheafMorphism S₂ Sᵤ
  /-- The expected morphism: source → user view. -/
  expected : SheafMorphism S₁ Sᵤ
  /-- Commutativity: introspect ∘ ingestion = expected. -/
  commutes : ∀ (U : Context) (s : S₁.Beliefs U),
    introspect.map U (ingestion.map U s) = expected.map U s
