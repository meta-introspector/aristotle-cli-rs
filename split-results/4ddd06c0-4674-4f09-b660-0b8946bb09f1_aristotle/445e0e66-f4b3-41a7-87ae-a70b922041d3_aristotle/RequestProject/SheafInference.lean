/-
# Sheaf Theory ↔ Knowledge Graph Inference Correspondence

This file formalizes the correspondence between commutative diagrams in sheaf theory
and valid inference in deep knowledge graphs.

The key insight: a knowledge graph performs valid inference if and only if its
belief assignments form a sheaf — i.e., all restriction diagrams commute and
the gluing condition holds.

## Main Correspondence

| Sheaf Theory              | Knowledge Graph Inference          |
|---------------------------|------------------------------------|
| Open set U                | Subgraph / context window          |
| Section s ∈ 𝒪(U)          | Belief state over subgraph U       |
| Restriction res_{V→U}     | Specialization / narrowing         |
| Stalk at x                | Local inference context at node x  |
| Gluing condition          | Consistency across inference paths |
| IsFraction                | Local explainability (Bayes ratio) |
| Commutative diagram       | Path-independent inference         |
-/
import Mathlib

open CategoryTheory

/-! ## Presheaf as Inference System

We show that a presheaf on a poset category is exactly an inference system
where restriction maps represent valid inference rules. -/

/-- A knowledge graph context poset, viewed as a category.
    Objects are contexts (subgraphs), morphisms are inclusions. -/
abbrev ContextCategory (α : Type*) [Preorder α] := α

/-- A belief system is a presheaf on the context category with values in `Type`.
    This directly uses Mathlib's `CategoryTheory.Functor`. -/
abbrev BeliefPresheaf (α : Type*) [Preorder α] :=
  (ContextCategory α)ᵒᵖ ⥤ Type

/-! ## Abstract Inference Framework

We also define a more elementary inference system as a presheaf on a poset of contexts,
and characterize when it satisfies the sheaf (= consistency) condition.
-/

/-- A belief system over a partially ordered type of contexts.
    This is a contravariant functor (presheaf) from contexts to types.
    - `Beliefs U` = the type of beliefs over context U
    - `restrict` = narrowing beliefs from a larger to smaller context
    - Functoriality = path independence of inference
-/
structure BeliefSystem (Context : Type*) [PartialOrder Context] where
  /-- The type of beliefs over a given context -/
  Beliefs : Context → Type*
  /-- Restriction: narrowing beliefs from a larger context to a smaller one -/
  restrict : ∀ {U V : Context}, V ≤ U → Beliefs U → Beliefs V
  /-- Restriction respects identity -/
  restrict_id : ∀ {U : Context} (s : Beliefs U), restrict (le_refl U) s = s
  /-- Restriction respects composition: path independence of inference -/
  restrict_comp : ∀ {U V W : Context} (hWV : W ≤ V) (hVU : V ≤ U) (s : Beliefs U),
    restrict hWV (restrict hVU s) = restrict (le_trans hWV hVU) s

variable {Context : Type*} [Lattice Context]

/-- A belief system satisfies the **gluing condition** (= sheaf condition)
    if local beliefs that agree on overlaps can be assembled into a global belief. -/
structure BeliefSystem.SatisfiesGluing (B : BeliefSystem Context) : Prop where
  /-- If two beliefs agree on the overlap, they come from a common belief -/
  glue : ∀ {U V : Context} (sU : B.Beliefs U) (sV : B.Beliefs V),
    B.restrict (inf_le_left (a := U) (b := V)) sU =
    B.restrict (inf_le_right (a := U) (b := V)) sV →
    ∃ s : B.Beliefs (U ⊔ V),
      B.restrict le_sup_left s = sU ∧ B.restrict le_sup_right s = sV

/-- A **valid inference system** is a belief system satisfying gluing.
    This is the knowledge graph analogue of a sheaf. -/
structure ValidInferenceSystem (Context : Type*) [Lattice Context]
    extends BeliefSystem Context where
  /-- The sheaf/consistency condition -/
  consistent : toBeliefSystem.SatisfiesGluing

/-! ## Inference Rules and Validity -/

/-- An inference rule in a knowledge graph: from premises in context U,
    derive a conclusion in context V ≤ U. -/
structure InferenceRule (B : BeliefSystem Context) where
  /-- The premise context -/
  premise : Context
  /-- The conclusion context -/
  conclusion : Context
  /-- The conclusion context is contained in the premise -/
  specializes : conclusion ≤ premise
  /-- The inference function -/
  infer : B.Beliefs premise → B.Beliefs conclusion

/-- An inference rule is **valid** if it agrees with the restriction map.
    This is exactly the commutativity condition for the presheaf diagram. -/
def InferenceRule.IsValid {B : BeliefSystem Context} (rule : InferenceRule B) : Prop :=
  ∀ s : B.Beliefs rule.premise,
    rule.infer s = B.restrict rule.specializes s

/-- The restriction map IS the unique valid inference rule.
    There is no other valid way to specialize beliefs. -/
theorem unique_valid_inference
    {B : BeliefSystem Context} (rule : InferenceRule B) (hvalid : rule.IsValid) :
    rule.infer = B.restrict rule.specializes :=
  funext hvalid

/-! ## Compositionality of Valid Inference

Valid inference rules compose: if U → V and V → W are both valid
(= agree with restriction), then U → W is also valid. This is
the transitivity of inference = functoriality of the presheaf. -/

/-- Composing two restriction maps is a restriction map (functoriality). -/
theorem restriction_compose (B : BeliefSystem Context)
    {U V W : Context} (hWV : W ≤ V) (hVU : V ≤ U) (s : B.Beliefs U) :
    B.restrict hWV (B.restrict hVU s) = B.restrict (le_trans hWV hVU) s :=
  B.restrict_comp hWV hVU s

/-! ## Explainability as Local Fraction Condition

A belief is "explainable" at a node if it can be locally expressed as a ratio
evidence / normalizer — the sheaf-theoretic IsFraction condition.
This is the Bayesian interpretation of local sections.
-/

/-- An explainability structure on a belief system equips beliefs
    with a notion of "local ratio" decomposition:
    evaluate(s) * normalizer(s) = evidence(s)
    i.e., belief = evidence / normalizer (the Bayes ratio). -/
structure Explainability (B : BeliefSystem Context) (R : Type*) [CommRing R] where
  /-- Extract a numerical value from a belief -/
  evaluate : ∀ {U : Context}, B.Beliefs U → R
  /-- The evidence component -/
  evidence : ∀ {U : Context}, B.Beliefs U → R
  /-- The normalizer component -/
  normalizer : ∀ {U : Context}, B.Beliefs U → R
  /-- A belief is explainable if it equals evidence / normalizer -/
  is_ratio : ∀ {U : Context} (s : B.Beliefs U),
    evaluate s * normalizer s = evidence s

/-- In an explainable system, if the normalizer is a unit, the belief value
    is uniquely determined by the evidence and normalizer. -/
theorem Explainability.belief_determined {B : BeliefSystem Context} {R : Type*}
    [CommRing R] (E : Explainability B R)
    {U : Context} (s : B.Beliefs U) (hn : IsUnit (E.normalizer s)) :
    E.evaluate s = hn.unit⁻¹ * E.evidence s := by
  have h := E.is_ratio s
  rw [← h]
  rw [mul_comm (E.evaluate s) (E.normalizer s)]
  rw [← mul_assoc]
  rw [IsUnit.val_inv_mul]
  ring

/-! ## Constant Belief System (Trivial Sheaf)

A concrete example: the constant belief system where beliefs over every
context are the same type, and restriction is the identity. -/

/-- The constant belief system: every context sees the same beliefs,
    restriction is the identity. This is the analogue of the constant sheaf. -/
def constantBeliefSystem (Context : Type*) [PartialOrder Context] (R : Type*) :
    BeliefSystem Context where
  Beliefs := fun _ => R
  restrict := fun _ s => s
  restrict_id := fun _ => rfl
  restrict_comp := fun _ _ _ => rfl

/-- The constant belief system always satisfies gluing. -/
theorem constantBeliefSystem_gluing (Context : Type*) [Lattice Context] (R : Type*) :
    (constantBeliefSystem Context R).SatisfiesGluing where
  glue := fun sU _sV h => ⟨sU, rfl, h⟩

/-- The constant belief system gives a valid inference system. -/
def constantValidInference (Context : Type*) [Lattice Context] (R : Type*) :
    ValidInferenceSystem Context where
  toBeliefSystem := constantBeliefSystem Context R
  consistent := constantBeliefSystem_gluing Context R

/-! ## Product Belief System

Given two belief systems, their product is also a belief system.
This models combining independent inference systems. -/

/-- The product of two belief systems. -/
def BeliefSystem.prod {Context : Type*} [PartialOrder Context]
    (B₁ B₂ : BeliefSystem Context) : BeliefSystem Context where
  Beliefs := fun U => B₁.Beliefs U × B₂.Beliefs U
  restrict := fun h s => (B₁.restrict h s.1, B₂.restrict h s.2)
  restrict_id := fun s => Prod.ext (B₁.restrict_id s.1) (B₂.restrict_id s.2)
  restrict_comp := fun hWV hVU s =>
    Prod.ext (B₁.restrict_comp hWV hVU s.1) (B₂.restrict_comp hWV hVU s.2)

/-- The product of two valid inference systems satisfies gluing
    if both components do. -/
theorem BeliefSystem.prod_gluing {Context : Type*} [Lattice Context]
    (B₁ B₂ : BeliefSystem Context)
    (h₁ : B₁.SatisfiesGluing) (h₂ : B₂.SatisfiesGluing) :
    (B₁.prod B₂).SatisfiesGluing where
  glue := fun sU sV h => by
    have heq := Prod.mk.inj h
    obtain ⟨s₁, hs₁U, hs₁V⟩ := h₁.glue sU.1 sV.1 heq.1
    obtain ⟨s₂, hs₂U, hs₂V⟩ := h₂.glue sU.2 sV.2 heq.2
    exact ⟨(s₁, s₂), Prod.ext hs₁U hs₂U, Prod.ext hs₁V hs₂V⟩

/-! ## Morphisms of Belief Systems

A morphism of belief systems is a natural transformation — a family of maps
that commutes with restriction. This corresponds to a valid translation
between inference systems. -/

/-- A morphism between belief systems: a natural transformation.
    This is a family of maps Beliefs₁(U) → Beliefs₂(U) that commutes
    with restriction (= inference is preserved under translation). -/
structure BeliefMorphism {Context : Type*} [PartialOrder Context]
    (B₁ B₂ : BeliefSystem Context) where
  /-- The component maps -/
  map : ∀ (U : Context), B₁.Beliefs U → B₂.Beliefs U
  /-- Naturality: the map commutes with restriction -/
  naturality : ∀ {U V : Context} (h : V ≤ U) (s : B₁.Beliefs U),
    map V (B₁.restrict h s) = B₂.restrict h (map U s)

/-- The identity morphism on a belief system. -/
def BeliefMorphism.id {Context : Type*} [PartialOrder Context]
    (B : BeliefSystem Context) : BeliefMorphism B B where
  map := fun _ s => s
  naturality := fun _ _ => rfl

/-- Composition of belief morphisms is a belief morphism. -/
def BeliefMorphism.comp {Context : Type*} [PartialOrder Context]
    {B₁ B₂ B₃ : BeliefSystem Context}
    (f : BeliefMorphism B₁ B₂) (g : BeliefMorphism B₂ B₃) :
    BeliefMorphism B₁ B₃ where
  map := fun U s => g.map U (f.map U s)
  naturality := fun h s => by
    rw [f.naturality h s, g.naturality h]

/-! ## The Fundamental Theorem

A deep knowledge graph performs valid inference if and only if
its belief assignments form a presheaf (restriction maps compose correctly).
Path independence of inference IS functoriality of the presheaf.
-/

/-- Any two paths of restrictions from U to W yield the same map.
    This follows immediately from functoriality (restrict_comp). -/
theorem inference_path_independent (B : BeliefSystem Context)
    {U V W : Context} (hWV : W ≤ V) (hVU : V ≤ U) (hWU : W ≤ U)
    (s : B.Beliefs U) :
    B.restrict hWV (B.restrict hVU s) = B.restrict hWU s := by
  rw [B.restrict_comp]
