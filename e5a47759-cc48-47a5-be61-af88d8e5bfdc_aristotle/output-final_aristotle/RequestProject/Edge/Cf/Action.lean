/-
# Actions: the atoms of a deployment, and the permissions each one needs

An `Action` is one Cloudflare API call the tool knows how to make.  For
each action three things are fixed here, once and for all:

* `Action.required` — the *exact* set of grants the call needs;
* `Action.role` — the name of the role, hence of the token, that signs it
  (one token per action kind, never a shared one);
* `Action.request` — the API call itself.

Everything else in the project is derived from these three functions: the
token minted for an action is `reduce (required a)` (`Cf.Token`), a
workflow's token bundle is assembled per action (`Cf.Workflow`), and the
emitted JavaScript dispatches on the same constructors (`Cf.JsEmit`).
-/
import RequestProject.Edge.Cf.Api
import RequestProject.Edge.Cf.Perm

namespace CfDeploy

/-- A file of the uploaded bundle that becomes a served asset. -/
structure Asset where
  /-- served path, e.g. `/index.html` -/
  path : String
  /-- MIME type sent to the browser -/
  contentType : String
  /-- size in bytes -/
  size : Nat
  /-- content hash, hex; the deduplication key of the Pages upload API -/
  hash : String
  deriving DecidableEq, Repr, Inhabited

/-- The atomic deployment steps. -/
inductive Action
  /-- `GET /user/tokens/verify` — check a token is live -/
  | verifyToken
  /-- `GET /user/tokens/permission_groups` — resolve group names to ids -/
  | listPermissionGroups
  /-- `POST /user/tokens` — mint the scoped token of a role -/
  | mintRoleToken (role : String)
  /-- `DELETE /user/tokens/{id}` — revoke the scoped token of a role once
  its step has run, so no minted credential outlives the deployment -/
  | revokeRoleToken (role : String)
  /-- `GET /accounts/{a}/pages/projects/{p}` -/
  | getPagesProject (account project : String)
  /-- `POST /accounts/{a}/pages/projects` -/
  | createPagesProject (account project branch : String)
  /-- `POST /accounts/{a}/pages/projects/{p}/upload-token` -/
  | createUploadToken (account project : String)
  /-- `POST /pages/assets/check-missing`, signed by the upload JWT -/
  | checkMissingAssets (account project : String)
  /-- `POST /pages/assets/upload`, signed by the upload JWT -/
  | uploadAssets (account project : String) (assets : List Asset)
  /-- `POST /accounts/{a}/pages/projects/{p}/deployments` -/
  | createDeployment (account project : String)
  /-- `POST /accounts/{a}/pages/projects/{p}/domains` -/
  | addPagesDomain (account project domain : String)
  /-- `PUT /accounts/{a}/storage/kv/namespaces/{ns}/values/{k}` -/
  | putKvValue (account ns key : String)
  /-- `PUT /accounts/{a}/r2/buckets/{b}/objects/{k}` -/
  | putR2Object (account bucket key : String)
  /-- `PUT /accounts/{a}/workers/scripts/{n}` -/
  | putWorkerScript (account script : String)
  /-- `POST /zones/{z}/dns_records` -/
  | putDnsRecord (account zone name target : String)
  /-- `POST /zones/{z}/purge_cache` -/
  | purgeCache (account zone : String)
  deriving DecidableEq, Repr, Inhabited

namespace Action

/-! ## Permissions -/

/-- **The permission contract.**  The exact grants an action needs — no
more.  Everything the tool does with tokens is computed from this
function, so this is the single place where privilege is granted. -/
def required : Action → PermSet
  | .verifyToken => []
  | .listPermissionGroups => [⟨.apiTokens, .read, .user⟩]
  | .mintRoleToken _ => [⟨.apiTokens, .edit, .user⟩]
  | .revokeRoleToken _ => [⟨.apiTokens, .edit, .user⟩]
  | .getPagesProject a _ => [⟨.pages, .read, .account a⟩]
  | .createPagesProject a _ _ => [⟨.pages, .edit, .account a⟩]
  | .createUploadToken a _ => [⟨.pages, .edit, .account a⟩]
  -- signed by the short-lived upload JWT, not by an API token
  | .checkMissingAssets _ _ => []
  | .uploadAssets _ _ _ => []
  | .createDeployment a _ => [⟨.pages, .edit, .account a⟩]
  | .addPagesDomain a _ _ => [⟨.pages, .edit, .account a⟩]
  | .putKvValue a _ _ => [⟨.workersKv, .edit, .account a⟩]
  | .putR2Object a _ _ => [⟨.workersR2, .edit, .account a⟩]
  | .putWorkerScript a _ => [⟨.workersScripts, .edit, .account a⟩]
  | .putDnsRecord a z _ _ => [⟨.dns, .edit, .zone a z⟩]
  | .purgeCache a z => [⟨.cachePurge, .edit, .zone a z⟩]

/-- The role — and hence the token — that signs the action.  Roles are
named after the action kind, so two actions share a token exactly when
they are the same kind of call on the same resource. -/
def role : Action → String
  | .verifyToken => "verify"
  | .listPermissionGroups => "groups-read"
  | .mintRoleToken _ => "token-mint"
  | .revokeRoleToken _ => "token-revoke"
  | .getPagesProject a _ => "pages-read@" ++ a
  | .createPagesProject a _ _ => "pages-create@" ++ a
  | .createUploadToken a _ => "pages-upload-token@" ++ a
  | .checkMissingAssets a p => "pages-assets@" ++ a ++ "/" ++ p
  | .uploadAssets a p _ => "pages-assets@" ++ a ++ "/" ++ p
  | .createDeployment a _ => "pages-deploy@" ++ a
  | .addPagesDomain a _ _ => "pages-domain@" ++ a
  | .putKvValue a n _ => "kv-write@" ++ a ++ "/" ++ n
  | .putR2Object a b _ => "r2-write@" ++ a ++ "/" ++ b
  | .putWorkerScript a _ => "worker-write@" ++ a
  | .putDnsRecord a z _ _ => "dns-write@" ++ a ++ "/" ++ z
  | .purgeCache a z => "cache-purge@" ++ a ++ "/" ++ z

/-- The credential that signs the action's request. -/
def auth : Action → Auth
  | .verifyToken => .roleToken "verify"
  | .checkMissingAssets a p => .uploadJwt a p
  | .uploadAssets a p _ => .uploadJwt a p
  | a => .roleToken a.role

/-- The place a minted token's id takes in a request built before the
token exists.  The runner substitutes the id of the token it minted for
that role; a step whose reference it cannot resolve is refused, never
sent. -/
def mintedIdRef (role : String) : String := "{token:" ++ role ++ "}"

/-! ## Requests -/

private def assetJson (x : Asset) : Json :=
  .obj [("key", .str x.hash), ("base64", .bool true),
        ("metadata", .obj [("contentType", .str x.contentType)]),
        ("path", .str x.path), ("size", .num (x.size : Int))]

/-- The Cloudflare API call an action performs. -/
def request : Action → Request
  | .verifyToken =>
      { method := .get, path := "/user/tokens/verify", auth := .roleToken "verify" }
  | .listPermissionGroups =>
      { method := .get, path := "/user/tokens/permission_groups",
        auth := .roleToken "groups-read" }
  | a@(.mintRoleToken role) =>
      { method := .post, path := "/user/tokens",
        body := some (.obj [("name", .str role)]), auth := a.auth }
  | a@(.revokeRoleToken role) =>
      { method := .delete, path := "/user/tokens/" ++ mintedIdRef role, auth := a.auth }
  | a@(.getPagesProject acct proj) =>
      { method := .get, path := "/accounts/" ++ acct ++ "/pages/projects/" ++ proj,
        auth := a.auth }
  | a@(.createPagesProject acct proj branch) =>
      { method := .post, path := "/accounts/" ++ acct ++ "/pages/projects",
        body := some (.obj [("name", .str proj), ("production_branch", .str branch)]),
        auth := a.auth }
  | a@(.createUploadToken acct proj) =>
      { method := .post,
        path := "/accounts/" ++ acct ++ "/pages/projects/" ++ proj ++ "/upload-token",
        auth := a.auth }
  | a@(.checkMissingAssets _ _) =>
      { method := .post, path := "/pages/assets/check-missing", auth := a.auth }
  | a@(.uploadAssets _ _ assets) =>
      { method := .post, path := "/pages/assets/upload",
        body := some (.arr (assets.map assetJson)), auth := a.auth }
  | a@(.createDeployment acct proj) =>
      { method := .post,
        path := "/accounts/" ++ acct ++ "/pages/projects/" ++ proj ++ "/deployments",
        auth := a.auth }
  | a@(.addPagesDomain acct proj domain) =>
      { method := .post,
        path := "/accounts/" ++ acct ++ "/pages/projects/" ++ proj ++ "/domains",
        body := some (.obj [("name", .str domain)]), auth := a.auth }
  | a@(.putKvValue acct ns key) =>
      { method := .put,
        path := "/accounts/" ++ acct ++ "/storage/kv/namespaces/" ++ ns ++ "/values/" ++ key,
        auth := a.auth }
  | a@(.putR2Object acct bucket key) =>
      { method := .put,
        path := "/accounts/" ++ acct ++ "/r2/buckets/" ++ bucket ++ "/objects/" ++ key,
        auth := a.auth }
  | a@(.putWorkerScript acct script) =>
      { method := .put, path := "/accounts/" ++ acct ++ "/workers/scripts/" ++ script,
        auth := a.auth }
  | a@(.putDnsRecord _ zone name target) =>
      { method := .post, path := "/zones/" ++ zone ++ "/dns_records",
        body := some (.obj [("type", .str "CNAME"), ("name", .str name),
                            ("content", .str target), ("proxied", .bool true)]),
        auth := a.auth }
  | a@(.purgeCache _ zone) =>
      { method := .post, path := "/zones/" ++ zone ++ "/purge_cache",
        body := some (.obj [("purge_everything", .bool true)]), auth := a.auth }

/-- A one-line human description, used in plans and audit logs. -/
def describe : Action → String
  | .verifyToken => "verify the current token"
  | .listPermissionGroups => "list permission groups"
  | .mintRoleToken r => "mint the scoped token for role " ++ r
  | .revokeRoleToken r => "revoke the scoped token of role " ++ r
  | .getPagesProject _ p => "read Pages project " ++ p
  | .createPagesProject _ p _ => "create Pages project " ++ p
  | .createUploadToken _ p => "get a one-project upload JWT for " ++ p
  | .checkMissingAssets _ p => "ask which assets of " ++ p ++ " are missing"
  | .uploadAssets _ p as => "upload " ++ toString as.length ++ " asset(s) to " ++ p
  | .createDeployment _ p => "create a deployment of " ++ p
  | .addPagesDomain _ p d => "attach domain " ++ d ++ " to " ++ p
  | .putKvValue _ n k => "write KV " ++ n ++ "/" ++ k
  | .putR2Object _ b k => "write R2 " ++ b ++ "/" ++ k
  | .putWorkerScript _ s => "upload Worker script " ++ s
  | .putDnsRecord _ z n _ => "create DNS record " ++ n ++ " in zone " ++ z
  | .purgeCache _ z => "purge the cache of zone " ++ z

/-! ## Facts about the permission contract -/

/-- The asset-upload calls need no API-token permission at all: they are
signed by the one-project upload JWT. -/
theorem uploadAssets_required_nil (a p : String) (xs : List Asset) :
    required (.uploadAssets a p xs) = [] := rfl

theorem checkMissingAssets_required_nil (a p : String) :
    required (.checkMissingAssets a p) = [] := rfl

/-- Uploading assets is signed by a JWT bound to that one project. -/
theorem uploadAssets_auth (a p : String) (xs : List Asset) :
    auth (.uploadAssets a p xs) = .uploadJwt a p := rfl

/-- No action ever needs more than one grant: the contract is as fine
grained as the API is. -/
theorem required_length_le_one (a : Action) : (required a).length ≤ 1 := by
  cases a <;> simp [required]

/-- Every action requiring a grant requires it on a resource of the
account (or user) it names — nothing an action needs reaches outside its
own account. -/
theorem required_reduced (a : Action) : PermSet.reduce (required a) = required a := by
  cases a <;> simp [required, PermSet.reduce]

/-- A read action never asks for an edit grant. -/
theorem getPagesProject_read_only (acct proj : String) :
    required (.getPagesProject acct proj) = [⟨.pages, .read, .account acct⟩] := rfl

/-- Revoking a minted token needs the same user-level grant as minting
one, and nothing on any account or zone. -/
theorem revokeRoleToken_required (r : String) :
    required (.revokeRoleToken r) = [⟨.apiTokens, .edit, .user⟩] := rfl

/-- Revocation is a *different role* from minting, so the credential that
cleans up is not the credential that created anything. -/
theorem revoke_role_ne_mint (r s : String) :
    role (.revokeRoleToken r) ≠ role (.mintRoleToken s) := by simp [role]

/-- The request that revokes a role's token addresses that role's token
and no other. -/
theorem revokeRoleToken_request_path (r : String) :
    (request (.revokeRoleToken r)).path = "/user/tokens/" ++ mintedIdRef r := rfl

/-- Purging a zone's cache needs nothing on the account beyond that zone. -/
theorem purgeCache_zone_scoped (acct zone : String) :
    required (.purgeCache acct zone) = [⟨.cachePurge, .edit, .zone acct zone⟩] := rfl

end Action

end CfDeploy
