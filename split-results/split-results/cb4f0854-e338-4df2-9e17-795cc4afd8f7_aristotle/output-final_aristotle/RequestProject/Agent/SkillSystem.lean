/-
# SkillSystem — a UML use-case "skill" calculus and its group action on tasks

This module formalizes a *skill system* in the UML use-case style and shows that
the invertible skills form a genuine **group action** on the task space.

## The objects

Fix a *task space* (semantic state) `S`.

* A **skill** is an endomorphism of the task space; the **skill monoid** is
  `Function.End S` (`Skill S`), with composition as multiplication and the
  identity skill as the unit.

* A **use case** (`UseCase P`) is the UML datum of a skill together with a
  *region* `P : S → Prop` (its precondition / invariant domain) and a proof that
  the skill's effect preserves the region (`preserves`).  Use cases over a fixed
  region compose (`UseCase.comp`), have an identity (`UseCase.idCase`), and their
  effects satisfy the monoid laws.  Forgetting the name embeds a use case into the
  **invariant submonoid** `invariantSubmonoid P` of region-preserving skills.

## The group action

The invertible skills are the units `(Function.End S)ˣ` of the skill monoid, here
named `SkillGroup S`.  By `Equiv.Perm.equivUnitsEnd` they are exactly the
permutations of the task space (`skillPerm`), and they act on `S`
(`MulAction (SkillGroup S) S`).  The action laws are recorded as
`skill_action_id` and `skill_action_assoc`.

This is the abstract backbone instantiated by the concrete weight-lifting trainers
in `RequestProject.Agent.WeightLiftingGym`.
-/

import Mathlib

namespace RequestProject.Agent.SkillSystem

universe u
variable {S : Type u}

/-! ## §1. The skill monoid -/

/-- A **skill** is an endomorphism of the task space `S`.  The collection of
    skills is the monoid `Function.End S` under composition. -/
abbrev Skill (S : Type u) := Function.End S

@[simp] theorem skill_mul_apply (f g : Skill S) (s : S) : (f * g) s = f (g s) := rfl

@[simp] theorem skill_one_apply (s : S) : (1 : Skill S) s = s := rfl

/-! ## §2. The invariant submonoid of region-preserving skills -/

/-- The submonoid of skills preserving a region `P : S → Prop`. -/
def invariantSubmonoid (P : S → Prop) : Submonoid (Function.End S) where
  carrier := {f | ∀ s, P s → P (f s)}
  one_mem' := fun _ hs => hs
  mul_mem' := fun ha hb s hs => ha _ (hb s hs)

@[simp] theorem mem_invariantSubmonoid {P : S → Prop} {f : Function.End S} :
    f ∈ invariantSubmonoid P ↔ ∀ s, P s → P (f s) := Iff.rfl

/-! ## §3. UML use cases over a region -/

/-- A **UML use case** over a region `P`: a named skill whose effect is
    guaranteed to keep the task inside the region `P` (precondition = invariant). -/
structure UseCase (P : S → Prop) where
  /-- The use-case name. -/
  name : String
  /-- The skill the use case fires. -/
  effect : Function.End S
  /-- Coherence: the effect preserves the region `P`. -/
  preserves : ∀ s, P s → P (effect s)

/-- Forgetting the name embeds a use case into the invariant submonoid. -/
def UseCase.toSubmonoid {P : S → Prop} (u : UseCase P) : invariantSubmonoid P :=
  ⟨u.effect, u.preserves⟩

/-- The identity use case (does nothing, trivially preserves the region). -/
def UseCase.idCase (P : S → Prop) : UseCase P := ⟨"id", 1, fun _ h => h⟩

/-- Composition of use cases over the same region: `u₂` fires after `u₁`. -/
def UseCase.comp {P : S → Prop} (u₂ u₁ : UseCase P) : UseCase P :=
  ⟨u₂.name ++ " ∘ " ++ u₁.name, u₂.effect * u₁.effect,
   fun s h => u₂.preserves _ (u₁.preserves s h)⟩

@[simp] theorem UseCase.comp_effect {P : S → Prop} (u₂ u₁ : UseCase P) :
    (u₂.comp u₁).effect = u₂.effect * u₁.effect := rfl

/-- Composition of use cases agrees with multiplication in the invariant
    submonoid. -/
theorem UseCase.comp_toSubmonoid {P : S → Prop} (u₂ u₁ : UseCase P) :
    (u₂.comp u₁).toSubmonoid = u₂.toSubmonoid * u₁.toSubmonoid := rfl

/-- The identity use case is a left unit on effects. -/
@[simp] theorem UseCase.idCase_comp_effect {P : S → Prop} (u : UseCase P) :
    ((UseCase.idCase P).comp u).effect = u.effect := one_mul _

/-- The identity use case is a right unit on effects. -/
@[simp] theorem UseCase.comp_idCase_effect {P : S → Prop} (u : UseCase P) :
    (u.comp (UseCase.idCase P)).effect = u.effect := mul_one _

/-- Use-case composition is associative on effects. -/
theorem UseCase.comp_assoc_effect {P : S → Prop} (u₃ u₂ u₁ : UseCase P) :
    ((u₃.comp u₂).comp u₁).effect = (u₃.comp (u₂.comp u₁)).effect := by
  simp [mul_assoc]

/-! ## §4. The group of invertible skills acting on tasks -/

/-- The **skill group**: the invertible skills, i.e. the units of the skill
    monoid. -/
abbrev SkillGroup (S : Type u) := (Function.End S)ˣ

/-- Invertible skills are exactly the permutations of the task space. -/
def skillPerm : SkillGroup S ≃* Equiv.Perm S := Equiv.Perm.equivUnitsEnd.symm

/-- The skill group acts on the task space (the canonical action of the units of
    `Function.End S`). -/
example : MulAction (SkillGroup S) S := inferInstance

/-- The identity skill acts trivially. -/
theorem skill_action_id (s : S) : (1 : SkillGroup S) • s = s := one_smul _ s

/-- Composing skills before acting equals acting in sequence. -/
theorem skill_action_assoc (g h : SkillGroup S) (s : S) :
    g • h • s = (g * h) • s := smul_smul g h s

end RequestProject.Agent.SkillSystem
