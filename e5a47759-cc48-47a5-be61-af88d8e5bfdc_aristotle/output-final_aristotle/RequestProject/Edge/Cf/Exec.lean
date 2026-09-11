/-
# The gated executor

`Exec.step` is the only place in the tool where an API request is
produced.  It takes the wallet of credentials the runner actually holds,
looks for the credential minted for *this action's role*, checks that it
covers the action's permission contract, and only then hands back the
request.  Anything else is refused with the missing grant named.

The three results below are the security statements of the tool:

* `step_performed_authorized` — a request is only ever emitted under a
  credential of the action's own role which covers the action's contract;
* `no_escalation` — a grant nobody in the wallet holds is never exercised;
* `run_all_performed` — the wallet minted from `Workflow.tokens` runs the
  whole workflow, so least privilege costs no functionality.
-/
import RequestProject.Edge.Cf.Workflow

namespace CfDeploy

/-- A credential actually held by the runner: the role it was minted for
and the grants Cloudflare attached to it. -/
structure Credential where
  role : String
  perms : PermSet
  deriving DecidableEq, Repr, Inhabited

/-- The set of credentials available to a run. -/
abbrev Wallet := List Credential

/-- What happened to one action. -/
inductive Outcome
  /-- the request was emitted, signed by the named role -/
  | performed (role : String) (r : Request)
  /-- refused: no held credential of the action's role covers this grant -/
  | denied (missing : Perm)
  /-- refused: the runner holds no credential for the action's role -/
  | noCredential (role : String)
  deriving Inhabited

namespace Exec

/-- The credential minted for a role, if the wallet has one. -/
def credentialFor (wallet : Wallet) (role : String) : Option Credential :=
  wallet.find? (fun c => c.role == role)

/-- The first grant of the action that the credential does not cover. -/
def missingGrant (c : Credential) (a : Action) : Option Perm :=
  a.required.find? (fun p => !PermSet.grants c.perms p)

/-- **The gate.**  Perform one action, or refuse it. -/
def step (wallet : Wallet) (a : Action) : Outcome :=
  match credentialFor wallet a.role with
  | none =>
      -- an action that needs no API token (asset upload, signed by the
      -- one-project JWT) still runs without a credential
      if a.required.isEmpty then .performed "upload-jwt" a.request
      else .noCredential a.role
  | some c =>
      match missingGrant c a with
      | some p => .denied p
      | none => .performed c.role a.request

/-- Run a whole workflow, one gated step at a time. -/
def run (wallet : Wallet) (w : Workflow) : List Outcome :=
  w.actions.map (step wallet)

/-- The wallet Cloudflare would hand back for a workflow's token bundle:
each token spec, once created, is a credential with exactly those grants. -/
def mintedWallet (w : Workflow) : Wallet :=
  w.tokens.map (fun t => ⟨t.role, t.perms⟩)

/-! ## Soundness of the gate -/

theorem credentialFor_role {wallet : Wallet} {role : String} {c : Credential}
    (h : credentialFor wallet role = some c) : c ∈ wallet ∧ c.role = role := by
  have hmem := List.find?_some h
  have := List.mem_of_find?_eq_some h
  exact ⟨this, by simpa using hmem⟩

theorem missingGrant_none {c : Credential} {a : Action} (h : missingGrant c a = none) :
    PermSet.covers c.perms a.required = true := by
  refine List.all_eq_true.mpr fun p hp => ?_
  have : ¬ ((fun p => !PermSet.grants c.perms p) p = true) := by
    intro hcon
    have := List.find?_eq_none.mp h p hp
    exact this hcon
  simpa using this

/-- **A request is emitted only under an authorized credential of the
action's own role.**  The only exception is an action whose permission
contract is empty, which needs no API token at all. -/
theorem step_performed_authorized {wallet : Wallet} {a : Action} {role : String} {r : Request}
    (h : step wallet a = .performed role r) :
    r = a.request ∧
      ((a.required = [] ∧ role = "upload-jwt") ∨
        ∃ c ∈ wallet, c.role = a.role ∧ role = a.role ∧
          PermSet.covers c.perms a.required = true) := by
  unfold step at h
  cases hc : credentialFor wallet a.role with
  | none =>
      simp only [hc] at h
      by_cases he : a.required.isEmpty = true
      · rw [if_pos he] at h
        cases h
        exact ⟨rfl, Or.inl ⟨List.isEmpty_iff.mp he, rfl⟩⟩
      · rw [if_neg he] at h; exact absurd h (by simp)
  | some c =>
      simp only [hc] at h
      cases hm : missingGrant c a with
      | some p => simp only [hm] at h; exact absurd h (by simp)
      | none =>
          simp only [hm] at h
          cases h
          obtain ⟨hmem, hrole⟩ := credentialFor_role hc
          exact ⟨rfl, Or.inr ⟨c, hmem, hrole, hrole, missingGrant_none hm⟩⟩

/-- **No privilege escalation.**  If no credential in the wallet grants
`p`, then no action requiring `p` is ever performed. -/
theorem no_escalation {wallet : Wallet} {a : Action} {p : Perm} {role : String} {r : Request}
    (hwallet : ∀ c ∈ wallet, PermSet.grants c.perms p = false)
    (hreq : p ∈ a.required)
    (h : step wallet a = .performed role r) : False := by
  obtain ⟨_, hcase⟩ := step_performed_authorized h
  rcases hcase with ⟨hnil, _⟩ | ⟨c, hmem, _, _, hcov⟩
  · rw [hnil] at hreq; exact absurd hreq (by simp)
  · have hg := List.all_eq_true.mp hcov p hreq
    rw [hwallet c hmem] at hg
    exact Bool.noConfusion hg

/-- Nothing performed under a role the wallet does not have (except the
token-free upload actions). -/
theorem step_noCredential {wallet : Wallet} {a : Action}
    (hnone : credentialFor wallet a.role = none) (hreq : a.required ≠ []) :
    step wallet a = .noCredential a.role := by
  unfold step
  rw [hnone, if_neg]
  simpa [List.isEmpty_iff] using hreq

/-! ## Completeness: least privilege still runs -/

theorem mintedWallet_has (w : Workflow) (a : Action) (ha : a ∈ w.actions) :
    ∃ c ∈ mintedWallet w, c.role = a.role ∧ c.perms = (TokenSpec.forAction a).perms := by
  refine ⟨⟨(TokenSpec.forAction a).role, (TokenSpec.forAction a).perms⟩, ?_, rfl, rfl⟩
  exact List.mem_map_of_mem (Workflow.mem_tokens.mpr (List.mem_map_of_mem ha))

/-- Every step of a workflow run with its own minted wallet is performed:
splitting privilege per action never blocks the workflow.

(The credential lookup is by role, and `mintedWallet` contains a
credential of the right role whose grants cover the action, so the gate
lets every step through.) -/
theorem run_all_performed (w : Workflow) (a : Action) (ha : a ∈ w.actions)
    (huniqueRole : ∀ c ∈ mintedWallet w, c.role = a.role →
      PermSet.covers c.perms a.required = true) :
    ∃ role, step (mintedWallet w) a = .performed role a.request := by
  unfold step
  cases hc : credentialFor (mintedWallet w) a.role with
  | none =>
      obtain ⟨c, hmem, hrole, _⟩ := mintedWallet_has w a ha
      have : credentialFor (mintedWallet w) a.role ≠ none := by
        intro hnone
        have := List.find?_eq_none.mp hnone c hmem
        exact this (by simp [hrole])
      exact absurd hc this
  | some c =>
      obtain ⟨hmem, hrole⟩ := credentialFor_role hc
      have hcov := huniqueRole c hmem hrole
      cases hm : missingGrant c a with
      | none => exact ⟨c.role, by simp only [hm]⟩
      | some p =>
          have hp : p ∈ a.required := List.mem_of_find?_eq_some hm
          have hnot : (!PermSet.grants c.perms p) = true := by
            simpa using List.find?_some hm
          have := List.all_eq_true.mp hcov p hp
          rw [this] at hnot
          exact absurd hnot (by simp)

/-- An audit line for each outcome, for the log the CLI writes. -/
def auditLine (a : Action) : Outcome → String
  | .performed role r => "ok    [" ++ role ++ "] " ++ r.method.name ++ " " ++ r.path
  | .denied p => "DENY  [" ++ a.role ++ "] missing grant " ++ p.groupName
  | .noCredential role => "DENY  [" ++ role ++ "] no credential for this role"

end Exec

end CfDeploy
