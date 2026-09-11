/-
# One token per action: minting, and what "exactly the permissions needed" means

The rule this project enforces is: *no shared credential*.  Each action
kind gets its own short-lived Cloudflare API token, carrying the reduced
set of grants that action needs and nothing else.

`TokenSpec.forAction` mints that token, and this module proves the three
properties that make the rule meaningful:

* `forAction_authorizes` — the token is *enough*: it authorizes its action;
* `forAction_no_excess` — the token is *not too much*: every grant it
  carries is one the action explicitly requires;
* `forAction_minimal` — the token is *tight*: drop any single grant and
  the action is no longer authorized.

It also renders a token spec into the body of `POST /user/tokens`, which
is what the CLI prints (or sends) to have Cloudflare create the token.
-/
import RequestProject.Edge.Cf.Action

namespace CfDeploy

/-- The specification of a token to be created:  a role name, the grants,
a lifetime, and an optional IP allow-list. -/
structure TokenSpec where
  role : String
  perms : PermSet
  /-- lifetime in minutes; the CLI defaults to a quarter of an hour -/
  ttlMinutes : Nat := 15
  /-- optional `request.ip in` condition -/
  ipAllow : List String := []
  deriving Repr, Inhabited, DecidableEq

instance : BEq TokenSpec := instBEqOfDecidableEq
instance : LawfulBEq TokenSpec := by infer_instance

namespace TokenSpec

/-- Does the token authorize the action? -/
def authorizes (t : TokenSpec) (a : Action) : Bool :=
  PermSet.covers t.perms a.required

/-- **The minter.**  The token of an action: its role, and the reduced set
of grants it requires. -/
def forAction (a : Action) : TokenSpec :=
  { role := a.role, perms := PermSet.reduce a.required }

/-- The token minted for an action authorizes it. -/
theorem forAction_authorizes (a : Action) : (forAction a).authorizes a = true := by
  simpa [authorizes, forAction] using PermSet.reduce_covers a.required

/-- Every grant the minted token carries is a grant the action explicitly
requires: the token carries no excess privilege. -/
theorem forAction_no_excess (a : Action) :
    ∀ p ∈ (forAction a).perms, p ∈ a.required :=
  PermSet.reduce_subset a.required

/-- The minted token is tight: removing any one of its grants breaks the
action. -/
theorem forAction_minimal (a : Action) (p : Perm) (hp : p ∈ (forAction a).perms) :
    ¬ (PermSet.covers ((forAction a).perms.erase p) a.required = true) := by
  intro hcov
  have hp' : p ∈ a.required := forAction_no_excess a p hp
  have hgr : PermSet.grants ((forAction a).perms.erase p) p = true :=
    List.all_eq_true.mp hcov p hp'
  have := PermSet.reduce_erase_not_grants a.required p hp
  simp [forAction] at hgr
  rw [this] at hgr
  exact Bool.noConfusion hgr

/-- **Separation of duties.**  A token minted for one action authorizes
another only if the first action's own grants already cover the second's:
tokens never leak privilege across actions. -/
theorem forAction_authorizes_iff (a b : Action) :
    (forAction a).authorizes b = PermSet.covers a.required b.required := by
  simp only [authorizes, forAction, PermSet.covers]
  apply Bool.eq_iff_iff.mpr
  constructor
  · intro h
    exact List.all_eq_true.mpr fun p hp => by
      have := List.all_eq_true.mp h p hp
      rwa [PermSet.grants_reduce] at this
  · intro h
    exact List.all_eq_true.mpr fun p hp => by
      have := List.all_eq_true.mp h p hp
      rwa [PermSet.grants_reduce]

/-- Corollary: if the second action needs a grant the first does not have,
its token is refused. -/
theorem forAction_not_authorizes (a b : Action) (p : Perm)
    (hp : p ∈ b.required) (hno : PermSet.grants a.required p = false) :
    (forAction a).authorizes b = false := by
  rw [forAction_authorizes_iff]
  cases h : PermSet.covers a.required b.required with
  | false => rfl
  | true =>
      have := List.all_eq_true.mp h p hp
      rw [hno] at this
      exact Bool.noConfusion this

/-- The asset-upload actions get a token with no permissions at all —
they are signed by the one-project upload JWT instead. -/
theorem forAction_uploadAssets_perms (a p : String) (xs : List Asset) :
    (forAction (.uploadAssets a p xs)).perms = [] := rfl

/-! ## Rendering the `POST /user/tokens` body -/

/-- A resolved permission-group catalog: the `name → id` table returned by
`GET /user/tokens/permission_groups`. -/
abbrev GroupCatalog := List (String × String)

/-- The distinct scopes a token touches, in order of first appearance. -/
def scopes (t : TokenSpec) : List Scope :=
  t.perms.foldl (fun acc p => if acc.contains p.scope then acc else acc ++ [p.scope]) []

/-- The permission-group names the token asks for on a given scope. -/
def groupNamesOn (t : TokenSpec) (s : Scope) : List String :=
  (t.perms.filter (fun p => p.scope == s)).map Perm.groupName

/-- Every group name that appears in a policy is the name of one of the
token's own grants: the rendered request cannot ask for more than the
token spec. -/
theorem groupNamesOn_sound (t : TokenSpec) (s : Scope) (n : String)
    (hn : n ∈ groupNamesOn t s) : ∃ p ∈ t.perms, p.groupName = n := by
  obtain ⟨p, hp, hpn⟩ := List.mem_map.mp hn
  exact ⟨p, (List.mem_filter.mp hp).1, hpn⟩

/-- One policy of the token request: an `allow` effect, the resource keys
of one scope, and the permission groups asked for there. -/
def policyJson (userId : String) (catalog : GroupCatalog) (t : TokenSpec) (s : Scope) : Json :=
  let groups := (groupNamesOn t s).map (fun n =>
    match catalog.find? (fun kv => kv.1 == n) with
    | some (_, id) => Json.obj [("id", .str id), ("name", .str n)]
    | none => Json.obj [("name", .str n)])
  .obj [("effect", .str "allow"),
        ("resources", .obj [(s.resourceKey userId, .str "*")]),
        ("permission_groups", .arr groups)]

/-- The body of `POST /user/tokens` that creates this token. -/
def requestJson (userId : String) (catalog : GroupCatalog) (expiresOn : String)
    (t : TokenSpec) : Json :=
  let base : List (String × Json) :=
    [("name", .str ("aristotle-deploy/" ++ t.role)),
     ("policies", .arr ((scopes t).map (policyJson userId catalog t))),
     ("expires_on", .str expiresOn)]
  match t.ipAllow with
  | [] => .obj base
  | ips => .obj (base ++
      [("condition", .obj [("request.ip", .obj [("in", .arr (ips.map Json.str))])])])

/-- Group names the catalog could not resolve to ids.  The CLI refuses to
send a token request while this is non-empty, rather than silently asking
for a wrong permission group. -/
def unresolved (catalog : GroupCatalog) (t : TokenSpec) : List String :=
  (t.perms.map Perm.groupName).filter (fun n => !catalog.any (fun kv => kv.1 == n))

/-- With a complete catalog nothing is unresolved. -/
theorem unresolved_nil_of_complete (catalog : GroupCatalog) (t : TokenSpec)
    (h : ∀ p ∈ t.perms, catalog.any (fun kv => kv.1 == p.groupName) = true) :
    unresolved catalog t = [] := by
  refine List.filter_eq_nil_iff.mpr ?_
  intro n hn
  obtain ⟨p, hp, rfl⟩ := List.mem_map.mp hn
  simp [h p hp]

end TokenSpec

end CfDeploy
