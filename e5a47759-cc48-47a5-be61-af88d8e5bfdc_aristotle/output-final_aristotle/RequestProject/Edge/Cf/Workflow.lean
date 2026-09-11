/-
# Workflows: composing actions, and the token bundle a workflow needs

A `Workflow` is a sequence of actions built with `nil` and `seq`, so
workflows form a monoid under composition — that is what makes them
shareable building blocks ("upload a bundle", "point a domain at it",
"purge the cache") that users can paste together.

The deployment tool never runs a workflow with one big credential.  It
computes `Workflow.tokens`, one minimal token per distinct action, and
each request is signed by its own.  The results below say that this is
both sufficient and least-privilege:

* `tokens_authorize` — every action of the workflow has a token in the
  bundle that authorizes it;
* `bundle_no_excess` — every grant appearing anywhere in the bundle is
  required by some action of the workflow;
* `token_minimal` — no token in the bundle can lose a grant and still
  authorize its action.
-/
import RequestProject.Edge.Cf.Token

namespace CfDeploy

/-- Deduplicate, keeping the last occurrence of each element. -/
def uniq {α : Type} [BEq α] [LawfulBEq α] : List α → List α
  | [] => []
  | a :: as => if as.contains a then uniq as else a :: uniq as

theorem mem_uniq {α : Type} [BEq α] [LawfulBEq α] {x : α} :
    ∀ {l : List α}, x ∈ uniq l ↔ x ∈ l
  | [] => by simp [uniq]
  | a :: as => by
      rw [uniq]
      by_cases h : as.contains a = true
      · rw [if_pos h]
        constructor
        · intro hx; exact List.mem_cons_of_mem _ (mem_uniq.mp hx)
        · intro hx
          rcases List.mem_cons.mp hx with rfl | hx
          · exact mem_uniq.mpr (List.mem_of_elem_eq_true h)
          · exact mem_uniq.mpr hx
      · rw [if_neg h]
        constructor
        · intro hx
          rcases List.mem_cons.mp hx with rfl | hx
          · exact List.mem_cons_self
          · exact List.mem_cons_of_mem _ (mem_uniq.mp hx)
        · intro hx
          rcases List.mem_cons.mp hx with rfl | hx
          · exact List.mem_cons_self
          · exact List.mem_cons_of_mem _ (mem_uniq.mpr hx)

/-- A composable deployment workflow. -/
inductive Workflow
  /-- do nothing -/
  | nil
  /-- perform one action -/
  | act (a : Action)
  /-- do one workflow, then another -/
  | seq (w₁ w₂ : Workflow)
  deriving DecidableEq, Repr, Inhabited

namespace Workflow

/-- The actions of a workflow, in execution order. -/
def actions : Workflow → List Action
  | .nil => []
  | .act a => [a]
  | .seq w₁ w₂ => w₁.actions ++ w₂.actions

/-- Compose a list of workflows in order. -/
def all : List Workflow → Workflow
  | [] => .nil
  | w :: ws => .seq w (all ws)

/-- Perform a list of actions in order. -/
def steps (as : List Action) : Workflow := all (as.map Workflow.act)

/-- All grants the workflow needs, with repetition. -/
def required (w : Workflow) : PermSet := w.actions.flatMap Action.required

/-- The token bundle: one minimal token per distinct action. -/
def tokens (w : Workflow) : List TokenSpec :=
  uniq (w.actions.map TokenSpec.forAction)

/-- A single token that would run the whole workflow.  The tool does not
use it — it exists so that the "one token per action" bundle can be
compared against the monolithic alternative. -/
def monolithicToken (w : Workflow) : TokenSpec :=
  { role := "monolithic", perms := PermSet.reduce w.required }

/-! ## Composition -/

@[simp] theorem actions_nil : actions .nil = [] := rfl
@[simp] theorem actions_act (a : Action) : actions (.act a) = [a] := rfl
@[simp] theorem actions_seq (w₁ w₂ : Workflow) :
    actions (.seq w₁ w₂) = w₁.actions ++ w₂.actions := rfl

/-- Composition is associative on actions. -/
theorem actions_seq_assoc (w₁ w₂ w₃ : Workflow) :
    actions (.seq (.seq w₁ w₂) w₃) = actions (.seq w₁ (.seq w₂ w₃)) := by
  simp [actions, List.append_assoc]

@[simp] theorem actions_nil_seq (w : Workflow) : actions (.seq .nil w) = w.actions := by
  simp [actions]

@[simp] theorem actions_seq_nil (w : Workflow) : actions (.seq w .nil) = w.actions := by
  simp [actions]

/-- Performing a list of actions performs exactly those actions. -/
@[simp] theorem actions_steps (as : List Action) : (steps as).actions = as := by
  induction as with
  | nil => rfl
  | cons a as ih => simpa [steps, all, actions] using ih

/-- Permissions add up along composition. -/
@[simp] theorem required_seq (w₁ w₂ : Workflow) :
    required (.seq w₁ w₂) = w₁.required ++ w₂.required := by
  simp [required, List.flatMap_append]

theorem required_seq_assoc (w₁ w₂ w₃ : Workflow) :
    required (.seq (.seq w₁ w₂) w₃) = required (.seq w₁ (.seq w₂ w₃)) := by
  simp [List.append_assoc]

/-- Composing workflows never needs a grant neither part needed. -/
theorem required_seq_covered (w₁ w₂ : Workflow) :
    PermSet.covers (w₁.required ++ w₂.required) (required (.seq w₁ w₂)) = true := by
  simp

/-- Extending a workflow only ever adds privilege, never removes it. -/
theorem required_mono_left (w₁ w₂ : Workflow) :
    PermSet.covers (required (.seq w₁ w₂)) w₁.required = true := by
  simpa using PermSet.covers_append_left w₁.required w₂.required

theorem required_mono_right (w₁ w₂ : Workflow) :
    PermSet.covers (required (.seq w₁ w₂)) w₂.required = true := by
  simpa using PermSet.covers_append_right w₁.required w₂.required

/-! ## The token bundle -/

theorem mem_tokens {w : Workflow} {t : TokenSpec} :
    t ∈ w.tokens ↔ t ∈ w.actions.map TokenSpec.forAction := by
  unfold tokens
  exact mem_uniq

/-- **Every step can run.**  For each action of the workflow the bundle
contains a token that authorizes it. -/
theorem tokens_authorize (w : Workflow) (a : Action) (ha : a ∈ w.actions) :
    ∃ t ∈ w.tokens, t.authorizes a = true := by
  refine ⟨TokenSpec.forAction a, mem_tokens.mpr (List.mem_map_of_mem ha), ?_⟩
  exact TokenSpec.forAction_authorizes a

/-- **No excess privilege in the bundle.**  Every grant carried by any
token of the bundle is required by some action of the workflow. -/
theorem bundle_no_excess (w : Workflow) (t : TokenSpec) (ht : t ∈ w.tokens)
    (p : Perm) (hp : p ∈ t.perms) : p ∈ w.required := by
  obtain ⟨a, ha, rfl⟩ := List.mem_map.mp (mem_tokens.mp ht)
  have hpa : p ∈ a.required := TokenSpec.forAction_no_excess a p hp
  exact List.mem_flatMap.mpr ⟨a, ha, hpa⟩

/-- **Each token is tight.**  Dropping a grant from a token of the bundle
breaks the action it was minted for. -/
theorem token_minimal (a : Action)
    (p : Perm) (hp : p ∈ (TokenSpec.forAction a).perms) :
    ¬ (PermSet.covers ((TokenSpec.forAction a).perms.erase p) a.required = true) :=
  TokenSpec.forAction_minimal a p hp

/-- The bundle never grants more than the monolithic token would: the
per-action split is a strict improvement, never a widening. -/
theorem bundle_within_monolith (w : Workflow) (t : TokenSpec) (ht : t ∈ w.tokens) :
    PermSet.covers (monolithicToken w).perms t.perms = true := by
  refine List.all_eq_true.mpr fun p hp => ?_
  have : p ∈ w.required := bundle_no_excess w t ht p hp
  simpa [monolithicToken, PermSet.grants_reduce] using PermSet.grants_of_mem this

/-- Actions that need no API token get a token with no grants; in
particular a workflow of nothing but asset uploads needs no privilege. -/
theorem uploadOnly_no_perms (acct proj : String) (xs : List Asset) :
    (Workflow.act (.uploadAssets acct proj xs)).required = [] := rfl

/-! ## Plans -/

/-- A human-readable plan: what will happen, with which role. -/
def plan (w : Workflow) : List String :=
  w.actions.map fun a =>
    a.request.method.name ++ " " ++ a.request.path ++ "  [role " ++ a.role ++ "] — "
      ++ a.describe

/-- The `curl` transcript of a workflow (dry run). -/
def transcript (w : Workflow) : List String := w.actions.map (fun a => a.request.curl)

end Workflow

end CfDeploy
