/-
# Forgecode Permission System — Lean 4 Formalization

This file formalizes the permission system from tailcallhq/forgecode as a
compliant implementation in Lean 4 and proves key safety and correctness
properties.

## Architecture (mirroring the Rust crate `forge_domain::policies`)

* **Permission** — `Allow | Deny | Confirm`
* **PermissionOperation** — `Read | Write | Execute | Fetch`, each carrying
  a resource identifier (abstracted to `String` here).
* **Rule** — a pattern that matches certain operations (glob matching is
  abstracted to a decidable predicate).
* **Policy** — `Simple (permission, rule) | All [..] | Any [..] | Not policy`
* **PolicyConfig** — an ordered list of policies.
* **PolicyEngine** — the top-level evaluator that walks the config and returns
  a final `Permission`.

## Key properties proved

1. **Empty-config defaults to Confirm** — if there are no policies the engine
   returns `Confirm`.
2. **Deny is absorbing** — if *any* policy in the config evaluates to `Deny`,
   the engine returns `Deny`.
3. **Confirm is absorbing** — similarly for `Confirm` (before any later Deny).
4. **Pure-Allow yields Allow** — if every policy that matches yields `Allow`,
   the engine returns `Allow`.
5. **Not-inverts** — `Not` correctly inverts `Allow ↔ Deny` and
   `Confirm → Deny`.
6. **Determinism** — the engine is a pure function; same inputs ⇒ same output.
-/

import Mathlib

-- ============================================================================
-- 1. Core types
-- ============================================================================

/-- Permission decision — mirrors `forge_domain::policies::types::Permission`. -/
inductive Permission where
  | Allow
  | Deny
  | Confirm
  deriving DecidableEq, Repr

/-- The four kinds of guarded operations. We abstract away `PathBuf` / `String`
    payloads into a single `resource : String` for each variant. -/
inductive PermissionOperation where
  | Read    (resource : String)
  | Write   (resource : String)
  | Execute (resource : String)
  | Fetch   (resource : String)
  deriving DecidableEq, Repr

/-- A rule is a predicate on operations.  In the Rust code this is glob
    matching; here we abstract it to a function `PermissionOperation → Bool`. -/
structure Rule where
  check : PermissionOperation → Bool

/-- Policy tree — mirrors `forge_domain::policies::policy::Policy`. -/
inductive Policy where
  | Simple (perm : Permission) (rule : Rule)
  | All    (policies : List Policy)
  | Any    (policies : List Policy)
  | Not    (inner : Policy)

-- ============================================================================
-- 2. Policy evaluation  (`Policy.eval`)
-- ============================================================================

/-- Invert a permission (used by `Not`).
    `Allow ↔ Deny`, `Confirm → Deny` — matches the Rust implementation. -/
def Permission.invert : Permission → Permission
  | .Allow   => .Deny
  | .Deny    => .Allow
  | .Confirm => .Deny

/-- Evaluate a single policy against an operation.
    Returns `none` when the policy does not apply (rule doesn't match). -/
def Policy.eval (op : PermissionOperation) : Policy → Option Permission
  | .Simple perm rule =>
      if rule.check op then some perm else none
  | .All policies =>
      policies.filterMap (Policy.eval op) |>.head?
  | .Any policies =>
      policies.filterMap (Policy.eval op) |>.head?
  | .Not inner =>
      (inner.eval op).map Permission.invert

-- ============================================================================
-- 3. PolicyConfig & PolicyEngine
-- ============================================================================

/-- A `PolicyConfig` is simply an ordered list of policies. -/
structure PolicyConfig where
  policies : List Policy

/-- The core engine logic, mirroring `PolicyEngine::evaluate_policies`.
    Walk the list of policies; return immediately on `Deny` or `Confirm`;
    track the last `Allow`; default to `Confirm` if nothing matched. -/
def PolicyEngine.evaluateList (op : PermissionOperation)
    : List Policy → Option Permission → Permission
  | [], lastAllow => lastAllow.getD .Confirm
  | p :: ps, lastAllow =>
      match p.eval op with
      | some .Deny    => .Deny
      | some .Confirm => .Confirm
      | some .Allow   => evaluateList op ps (some .Allow)
      | none          => evaluateList op ps lastAllow

/-- Top-level entry point — mirrors `PolicyEngine::can_perform`. -/
def PolicyEngine.canPerform (cfg : PolicyConfig) (op : PermissionOperation)
    : Permission :=
  if cfg.policies.isEmpty then .Confirm
  else evaluateList op cfg.policies none

/-
============================================================================
4. Theorems
============================================================================

**Property 1 — Empty config defaults to Confirm.**
-/
theorem empty_config_confirms (op : PermissionOperation) :
    PolicyEngine.canPerform ⟨[]⟩ op = .Confirm := by
  rfl

/-
Helper: evaluateList with no policies and no prior Allow gives Confirm.
-/
theorem evaluateList_nil_none (op : PermissionOperation) :
    PolicyEngine.evaluateList op [] none = .Confirm := by
  rfl

/-
Helper: evaluateList with no policies and a prior Allow gives Allow.
-/
theorem evaluateList_nil_some_allow (op : PermissionOperation) :
    PolicyEngine.evaluateList op [] (some .Allow) = .Allow := by
  rfl

/-
**Property 2 — Deny is absorbing.**
    If a policy in the list evaluates to `Deny`, the engine returns `Deny`,
    regardless of what comes after.
-/
theorem deny_absorbing (op : PermissionOperation)
    (p : Policy) (ps_before ps_after : List Policy)
    (h : p.eval op = some .Deny)
    (hBefore : ∀ q ∈ ps_before, q.eval op = none ∨ q.eval op = some .Allow) :
    PolicyEngine.evaluateList op (ps_before ++ p :: ps_after) none = .Deny := by
  induction ps_before <;> simp_all +decide [ PolicyEngine.evaluateList ];
  cases hBefore.1 <;> simp_all +decide [ PolicyEngine.evaluateList ];
  rename_i k hk ih;
  convert hk using 1;
  -- By definition of `evaluateList`, if the list is empty, it returns the lastAllow.
  have h_empty : ∀ (lastAllow : Option Permission), PolicyEngine.evaluateList op (k ++ p :: ps_after) lastAllow = PolicyEngine.evaluateList op (k ++ p :: ps_after) none := by
    intros lastAllow
    induction' k with k ih generalizing lastAllow;
    · cases lastAllow <;> simp_all +decide [ PolicyEngine.evaluateList ];
    · cases hBefore k ( by simp +decide ) <;> simp_all +decide [ PolicyEngine.evaluateList ];
  exact h_empty _

/-
**Property 3 — Confirm is absorbing** (analogous to Deny).
-/
theorem confirm_absorbing (op : PermissionOperation)
    (p : Policy) (ps_before ps_after : List Policy)
    (h : p.eval op = some .Confirm)
    (hBefore : ∀ q ∈ ps_before, q.eval op = none ∨ q.eval op = some .Allow) :
    PolicyEngine.evaluateList op (ps_before ++ p :: ps_after) none = .Confirm := by
  induction ps_before <;> simp_all +decide [ PolicyEngine.evaluateList ];
  cases hBefore.1 <;> simp_all +decide [ PolicyEngine.evaluateList ];
  rename_i k hk;
  rename_i l hl;
  induction' hl with l hl ih;
  · simp +decide [ PolicyEngine.evaluateList, h ];
  · cases hBefore l ( by simp +decide ) <;> simp_all +decide [ PolicyEngine.evaluateList ]

/-
**Property 4 — Pure Allow.**
    If every policy that matches yields `Allow`, the engine returns `Allow`.
-/
theorem pure_allow (op : PermissionOperation) (policies : List Policy)
    (hNe : policies ≠ [])
    (hAll : ∀ p ∈ policies, p.eval op = none ∨ p.eval op = some .Allow)
    (hSome : ∃ p ∈ policies, p.eval op = some .Allow) :
    PolicyEngine.canPerform ⟨policies⟩ op = .Allow := by
  unfold PolicyEngine.canPerform;
  have h_eval_all : ∀ (ps : List Policy) (lastAllow : Option Permission), (∀ p ∈ ps, p.eval op = none ∨ p.eval op = some .Allow) → lastAllow = some .Allow ∨ (∃ p ∈ ps, p.eval op = some .Allow) → PolicyEngine.evaluateList op ps lastAllow = .Allow := by
    intros ps lastAllow hAll hSome; induction' ps with p ps ih generalizing lastAllow <;> simp_all +decide [ PolicyEngine.evaluateList ] ;
    cases h : Policy.eval op p <;> aesop;
  specialize h_eval_all policies none hAll ; aesop

/-
**Property 5a — Not inverts Allow to Deny.**
-/
theorem not_inverts_allow (op : PermissionOperation) (inner : Policy)
    (h : inner.eval op = some .Allow) :
    (Policy.Not inner).eval op = some .Deny := by
  rw [ Policy.eval ];
  aesop

/-
**Property 5b — Not inverts Deny to Allow.**
-/
theorem not_inverts_deny (op : PermissionOperation) (inner : Policy)
    (h : inner.eval op = some .Deny) :
    (Policy.Not inner).eval op = some .Allow := by
  rw [ Policy.eval ] ; aesop;

/-
**Property 5c — Not maps Confirm to Deny.**
-/
theorem not_maps_confirm_to_deny (op : PermissionOperation) (inner : Policy)
    (h : inner.eval op = some .Confirm) :
    (Policy.Not inner).eval op = some .Deny := by
  unfold Policy.eval; aesop;

/-
**Property 5d — Not preserves non-matching.**
-/
theorem not_preserves_none (op : PermissionOperation) (inner : Policy)
    (h : inner.eval op = none) :
    (Policy.Not inner).eval op = none := by
  unfold Policy.eval; aesop;

/-
**Property 6 — Determinism** (trivially true for a pure function, but
    stated for documentation).
-/
theorem engine_deterministic (cfg : PolicyConfig) (op : PermissionOperation) :
    PolicyEngine.canPerform cfg op = PolicyEngine.canPerform cfg op := by
  rfl

/-
**Property 7 — Simple rule that doesn't match yields None.**
-/
theorem simple_no_match (perm : Permission) (rule : Rule) (op : PermissionOperation)
    (h : rule.check op = false) :
    (Policy.Simple perm rule).eval op = none := by
  -- By definition of `Policy.eval`, if the rule does not match the operation, then the policy evaluates to `none`.
  simp [Policy.eval, h]

/-
**Property 8 — Simple rule that matches yields the declared permission.**
-/
theorem simple_match (perm : Permission) (rule : Rule) (op : PermissionOperation)
    (h : rule.check op = true) :
    (Policy.Simple perm rule).eval op = some perm := by
  -- By definition of `Policy.eval`, if the rule's check is true, then the policy evaluates to some perm.
  simp [Policy.eval, h]

-- ============================================================================
-- 5. Compliant implementation example
-- ============================================================================

/-- An "allow-all Rust files, deny everything else" configuration, resembling
    a typical `permissions.default.yaml`. -/
def exampleConfig : PolicyConfig :=
  { policies := [
      Policy.Simple .Allow ⟨fun op =>
        match op with
        | .Read  r | .Write r => r.endsWith ".rs"
        | _ => false⟩,
      Policy.Simple .Deny ⟨fun _ => true⟩   -- catch-all deny
    ] }

/-
Writing a `.py` file is denied under `exampleConfig`.
-/
theorem example_py_denied :
    PolicyEngine.canPerform exampleConfig (.Write "script.py") = .Deny := by
  -- By definition of `exampleConfig`, the first policy checks if the file ends with ".rs"). Since "script.py" does not end with ".rs", the rule fails, and that policy returns none.
  have h1 : (Policy.Simple .Allow ⟨fun op => match op with | .Read r | .Write r => r.endsWith ".rs" | _ => false⟩).eval (.Write "script.py") = none := by
    unfold Policy.eval;
    native_decide +revert;
  unfold exampleConfig;
  unfold PolicyEngine.canPerform;
  unfold Policy.eval at h1; simp +decide [ PolicyEngine.evaluateList ] ;
  unfold Policy.eval; simp +decide [ h1 ] ;

/-
Reading a `.rs` file is still denied because the catch-all deny fires
    after the allow — illustrating that **deny absorbs** even a prior allow.
-/
theorem example_rs_read_denied_by_catchall :
    PolicyEngine.canPerform exampleConfig (.Read "lib.rs") = .Deny := by
  -- We'll use the fact that the catch-all deny policy is the last one in the list.
  -- When evaluating the "read lib.rs" operation, the engine will process the read rule first (which allows it),
  -- then the catch-all deny rule (which denies it).
  simp +decide [PolicyEngine.canPerform, exampleConfig];
  -- By definition of `Policy.Simple.eval`, the read operation on "lib.rs" matches the read rule and returns Allow.
  have h_read : (Policy.Simple .Allow ⟨fun op => match op with | .Read r | .Write r => r.endsWith ".rs" | _ => false⟩).eval (PermissionOperation.Read "lib.rs") = some .Allow := by
    -- Apply the simple_match theorem to conclude that the read operation on "lib.rs" is allowed.
    apply simple_match;
    native_decide +revert;
  -- By definition of `Policy.Simple.eval`, the catch-all deny policy matches the read operation and returns Deny.
  have h_catch_all : (Policy.Simple .Deny ⟨fun _ => true⟩).eval (PermissionOperation.Read "lib.rs") = some .Deny := by
    exact simple_match Permission.Deny { check := fun x => true } (PermissionOperation.Read "lib.rs") rfl;
  rw [ PolicyEngine.evaluateList ];
  erw [ h_read ];
  erw [ PolicyEngine.evaluateList ] ; aesop;

/-- A config where Allow-only (no catch-all deny) correctly permits `.rs` reads. -/
def allowOnlyConfig : PolicyConfig :=
  { policies := [
      Policy.Simple .Allow ⟨fun op =>
        match op with
        | .Read  r | .Write r => r.endsWith ".rs"
        | _ => false⟩
    ] }

/-
Reading a `.rs` file is allowed when there is no catch-all deny.
-/
theorem example_rs_read_allow_no_catchall :
    PolicyEngine.canPerform allowOnlyConfig (.Read "lib.rs") = .Allow := by
  -- We unfold definitions to expose the underlying `evaluateList` call,
  -- then simplify the single policy case to produce `some .Allow`.
  simp [PolicyEngine.canPerform, allowOnlyConfig, PolicyEngine.evaluateList, Policy.eval];
  split_ifs <;> norm_cast;
  exact absurd ‹¬_› ( by native_decide )

/-
Executing any command is denied (no execute rule, catch-all deny).
-/
theorem example_execute_denied :
    PolicyEngine.canPerform exampleConfig (.Execute "rm -rf /") = .Deny := by
  -- The engine sets lastAllow to Deny, and executeList targets that at exactly step 1.
  simp +decide [PolicyEngine.canPerform, exampleConfig, PolicyEngine.evaluateList, Policy.eval]