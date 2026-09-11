/-
# From an Aristotle `.tar.gz` to a deployment workflow

This is where the two halves of the tool meet: `Inflate.gunzip` +
`Tar.entries` turn an uploaded bundle into files, and the functions here
turn those files into `Asset`s and into the `Workflow` that publishes
them.

Two publishing recipes are provided, and both are ordinary values that can
be composed with `Workflow.seq` and shared with `Share.share`:

* `workerSiteWorkflow` — write every asset into a Workers KV namespace and
  upload a Worker that serves them (self-hosting with two capabilities:
  `Workers KV Storage Write` and `Workers Scripts Write`);
* `pagesSiteWorkflow` — the Cloudflare Pages direct-upload flow, where the
  bulk of the work is done under a one-project upload JWT rather than an
  API token.

`workerSite_scoped` and `pagesSite_scoped` prove the property that makes
these safe to hand to somebody else: whatever the bundle contains, the
recipe never asks for a grant outside the account (and optional zone) the
user configured.
-/
import RequestProject.Edge.Cf.Workflow
import RequestProject.Edge.Cf.Tar
import RequestProject.Edge.Cf.Inflate
import RequestProject.Edge.Cf.Digits

namespace CfDeploy
namespace Bundle

/-! ## Content addressing -/

/-- FNV-1a, 64 bit — the content hash the tool uses as the KV key and as
the `ETag` the Worker serves. -/
def fnv1a64 (bs : ByteArray) : UInt64 := Id.run do
  let mut h : UInt64 := 14695981039346656037
  for i in [0:bs.size] do
    h := (h ^^^ bs[i]!.toUInt64) * 1099511628211
  return h

def hexDigit (n : Nat) : Char :=
  if n < 10 then Char.ofNat (48 + n) else Char.ofNat (87 + n)

/-- Sixteen hex digits of a 64-bit hash. -/
def hex16 (v : UInt64) : String := Id.run do
  let mut cs : List Char := []
  let mut x := v.toNat
  for _ in [0:16] do
    cs := hexDigit (x % 16) :: cs
    x := x / 16
  return String.ofList cs

/-! ## Assets -/

/-- MIME type from the file extension; `application/octet-stream` when
unknown, never a guess based on contents. -/
def contentTypeOf (path : String) : String :=
  let ext := (path.splitOn ".").getLast!
  if ext == "html" || ext == "htm" then "text/html; charset=utf-8"
  else if ext == "css" then "text/css; charset=utf-8"
  else if ext == "js" || ext == "mjs" then "text/javascript; charset=utf-8"
  else if ext == "json" then "application/json"
  else if ext == "svg" then "image/svg+xml"
  else if ext == "png" then "image/png"
  else if ext == "jpg" || ext == "jpeg" then "image/jpeg"
  else if ext == "webp" then "image/webp"
  else if ext == "ico" then "image/x-icon"
  else if ext == "wasm" then "application/wasm"
  else if ext == "txt" || ext == "md" || ext == "lean" || ext == "toml" then
    "text/plain; charset=utf-8"
  else "application/octet-stream"

/-- Drop the first path component (Aristotle bundles are wrapped in a
single top-level directory). -/
def stripTopLevel (p : String) : String :=
  match p.splitOn "/" with
  | _ :: rest => String.intercalate "/" rest
  | [] => p

/-- The served path of an archive member. -/
def servedPath (strip : Bool) (p : String) : String :=
  "/" ++ (if strip then stripTopLevel p else p)

/-- Turn archive members into assets. -/
def assetsOfEntries (strip : Bool) (es : List Tar.Entry) : List Asset :=
  es.filterMap fun e =>
    let path := servedPath strip e.path
    if path == "/" then none
    else some { path := path, contentType := contentTypeOf e.path,
                size := e.contents.size, hash := hex16 (fnv1a64 e.contents) }

/-- The whole pipeline: gzip → tar → assets. -/
def assetsOfTgz (strip : Bool) (tgz : ByteArray) : Option (List Asset) :=
  match Inflate.gunzip tgz with
  | none => none
  | some tar => some (assetsOfEntries strip (Tar.entries tar))

/-- The upload manifest, as JSON, for the record the CLI writes next to a
deployment. -/
def manifestJson (assets : List Asset) : Json :=
  .arr (assets.map fun a =>
    .obj [("path", .str a.path), ("contentType", .str a.contentType),
          ("size", .num (a.size : Int)), ("hash", .str a.hash)])

/-! ## Site configuration -/

/-- What the user has to tell the tool to publish a bundle. -/
structure SiteConfig where
  /-- Cloudflare account id -/
  account : String
  /-- Pages project name, or Worker script name -/
  project : String
  /-- Workers KV namespace id holding the assets (Worker recipe) -/
  kvNamespace : String := ""
  /-- production branch name for the Pages recipe -/
  branch : String := "main"
  /-- optional zone (id) for DNS and cache actions -/
  zone : Option String := none
  /-- optional hostname to attach -/
  hostname : Option String := none
  deriving Repr, Inhabited

/-! ## Recipes -/

/-- Write every asset into KV. -/
def kvUploads (cfg : SiteConfig) (assets : List Asset) : Workflow :=
  Workflow.steps (assets.map fun a => Action.putKvValue cfg.account cfg.kvNamespace a.hash)

/-- Publish a bundle as a Worker serving assets out of KV. -/
def workerSiteWorkflow (cfg : SiteConfig) (assets : List Asset) : Workflow :=
  .seq (kvUploads cfg assets) (.act (.putWorkerScript cfg.account cfg.project))

/-- Publish a bundle through the Pages direct-upload flow. -/
def pagesSiteWorkflow (cfg : SiteConfig) (assets : List Asset) : Workflow :=
  Workflow.steps
    ([ .createPagesProject cfg.account cfg.project cfg.branch,
       .createUploadToken cfg.account cfg.project,
       .checkMissingAssets cfg.account cfg.project,
       .uploadAssets cfg.account cfg.project assets,
       .createDeployment cfg.account cfg.project ] ++
     (match cfg.hostname with
      | some h => [Action.addPagesDomain cfg.account cfg.project h]
      | none => []))

/-- Point a hostname at the deployment and drop the cache. -/
def dnsWorkflow (cfg : SiteConfig) (target : String) : Workflow :=
  match cfg.zone, cfg.hostname with
  | some z, some h =>
      Workflow.steps [ .putDnsRecord cfg.account z h target, .purgeCache cfg.account z ]
  | _, _ => .nil

/-- The bootstrap: check the token, resolve permission-group ids, and mint
one scoped token per role of the workflow to be run. -/
def bootstrapWorkflow (w : Workflow) : Workflow :=
  Workflow.steps
    ([Action.verifyToken, Action.listPermissionGroups] ++
      w.tokens.map (fun t => Action.mintRoleToken t.role))

/-- The role that signs the teardown, and whose own token is revoked
last. -/
def revokeRole : String := "token-revoke"

/-- The teardown: revoke every scoped token the bootstrap minted, and
then the revoking token itself, so that no credential this deployment
created outlives it. -/
def teardownWorkflow (w : Workflow) : Workflow :=
  Workflow.steps (w.tokens.map (fun t => Action.revokeRoleToken t.role) ++
    [Action.revokeRoleToken revokeRole])

/-- **The teardown covers every minted token.**  Each token of the
bundle — that is, each token the bootstrap mints — is revoked. -/
theorem teardown_revokes_every_minted_role (w : Workflow) :
    ∀ t ∈ w.tokens, Action.revokeRoleToken t.role ∈ (teardownWorkflow w).actions := by
  intro t ht
  simp only [teardownWorkflow, Workflow.actions_steps, List.mem_append, List.mem_map]
  exact Or.inl ⟨t, ht, rfl⟩

/-- **The teardown revokes its own credential too**, as its last step, so
nothing minted for the deployment survives it. -/
theorem teardown_revokes_itself_last (w : Workflow) :
    (teardownWorkflow w).actions.getLast? = some (Action.revokeRoleToken revokeRole) := by
  simp [teardownWorkflow]

/-- **And nothing else.**  Every step of the teardown revokes a token of
the workflow's own bundle; no other credential is touched. -/
theorem teardown_revokes_nothing_else (w : Workflow) :
    ∀ a ∈ (teardownWorkflow w).actions, ∃ r,
      a = Action.revokeRoleToken r ∧ (r ∈ w.tokens.map TokenSpec.role ∨ r = revokeRole) := by
  intro a ha
  simp only [teardownWorkflow, Workflow.actions_steps, List.mem_append, List.mem_map,
    List.mem_singleton] at ha
  rcases ha with ⟨t, ht, rfl⟩ | rfl
  · exact ⟨t.role, rfl, Or.inl (List.mem_map_of_mem ht)⟩
  · exact ⟨revokeRole, rfl, Or.inr rfl⟩

/-- **The teardown needs one capability.**  Revoking the scoped tokens
requires nothing but API-token access on the user — no account or zone
privilege at all. -/
theorem teardown_only_token_perms (w : Workflow) :
    ∀ p ∈ (teardownWorkflow w).required, p = ⟨.apiTokens, .edit, .user⟩ := by
  intro p hp
  simp only [teardownWorkflow, Workflow.required, Workflow.actions_steps,
    List.flatMap_append, List.flatMap_map, List.mem_append, List.mem_flatMap] at hp
  rcases hp with ⟨t, _, hpt⟩ | hp
  · simpa [Action.required] using hpt
  · simpa [Action.required] using hp

/-- The teardown is signed by one role of its own, distinct from every
role the deployment itself uses to touch an account. -/
theorem teardown_roles (w : Workflow) :
    ∀ a ∈ (teardownWorkflow w).actions, a.role = "token-revoke" := by
  intro a ha
  obtain ⟨r, rfl, _⟩ := teardown_revokes_nothing_else w a ha
  rfl

/-! ## Every recipe stays inside the configured account -/

/-- A grant is *inside* a configuration when it is attached to that
account, or to a zone of that account. -/
def InsideAccount (cfg : SiteConfig) (p : Perm) : Prop :=
  p.scope = .account cfg.account ∨ ∃ z, p.scope = .zone cfg.account z

theorem kvUploads_scoped (cfg : SiteConfig) (assets : List Asset) :
    ∀ p ∈ (kvUploads cfg assets).required, InsideAccount cfg p := by
  intro p hp
  unfold kvUploads Workflow.steps at hp
  induction assets with
  | nil => simp [Workflow.all, Workflow.required] at hp
  | cons a as ih =>
      simp only [List.map_cons, Workflow.all, Workflow.required, Workflow.actions,
        List.flatMap_append, List.mem_append] at hp ⊢
      rcases hp with h | h
      · simp [Action.required] at h
        exact Or.inl (by simp [h])
      · exact ih (by simpa [Workflow.required] using h)

/-- The Worker recipe only ever asks for grants on the configured
account. -/
theorem workerSite_scoped (cfg : SiteConfig) (assets : List Asset) :
    ∀ p ∈ (workerSiteWorkflow cfg assets).required, InsideAccount cfg p := by
  intro p hp
  rw [workerSiteWorkflow, Workflow.required_seq, List.mem_append] at hp
  rcases hp with h | h
  · exact kvUploads_scoped cfg assets p h
  · simp [Workflow.required, Workflow.actions, Action.required] at h
    exact Or.inl (by simp [h])

/-- The Pages recipe only ever asks for grants on the configured account —
and the asset upload itself asks for nothing at all, being signed by the
one-project upload JWT. -/
theorem pagesSite_scoped (cfg : SiteConfig) (assets : List Asset) :
    ∀ p ∈ (pagesSiteWorkflow cfg assets).required, InsideAccount cfg p := by
  intro p hp
  unfold pagesSiteWorkflow Workflow.steps at hp
  cases hh : cfg.hostname with
  | none =>
      rw [hh] at hp
      simp [Workflow.all, Workflow.required, Workflow.actions, Action.required] at hp
      exact Or.inl (by simp [hp])
  | some hn =>
      rw [hh] at hp
      simp [Workflow.all, Workflow.required, Workflow.actions, Action.required] at hp
      exact Or.inl (by simp [hp])

/-- **The bootstrap needs one capability.**  Creating all the scoped
tokens of a workflow requires nothing but API-token access on the user —
no account or zone privilege at all. -/
theorem bootstrap_only_token_perms (w : Workflow) :
    ∀ p ∈ (bootstrapWorkflow w).required,
      p = ⟨.apiTokens, .read, .user⟩ ∨ p = ⟨.apiTokens, .edit, .user⟩ := by
  intro p hp
  unfold bootstrapWorkflow Workflow.steps at hp
  simp only [List.map_append, List.map_cons, List.map_nil] at hp
  have hmint : ∀ (ts : List TokenSpec) (q : Perm),
      q ∈ (Workflow.all (ts.map (fun t => Workflow.act (.mintRoleToken t.role)))).required →
        q = ⟨.apiTokens, .edit, .user⟩ := by
    intro ts
    induction ts with
    | nil => intro q hq; simp [Workflow.all, Workflow.required] at hq
    | cons t ts ih =>
        intro q hq
        simp only [List.map_cons, Workflow.all, Workflow.required, Workflow.actions,
          List.flatMap_append, List.mem_append] at hq
        rcases hq with h | h
        · simpa [Action.required] using h
        · exact ih q (by simpa [Workflow.required] using h)
  simp only [List.cons_append, List.nil_append, Workflow.all, Workflow.required,
    Workflow.actions, List.flatMap_cons, Action.required, List.mem_cons,
    List.nil_append] at hp
  rcases hp with h | h
  · exact Or.inl h
  · exact Or.inr (hmint _ p (by simpa [Workflow.required, List.map_map, Function.comp] using h))

end Bundle
end CfDeploy
