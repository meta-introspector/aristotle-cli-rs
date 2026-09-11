/-
# The shape of a Cloudflare API call

Every step the deployment tool can take is one HTTPS request against
`https://api.cloudflare.com/client/v4`.  This module fixes the data of
such a request — method, path, query, body, and *which credential* signs
it — so that the permission analysis in `RequestProject.Cf.Action` and the
JavaScript emitted in `RequestProject.Cf.JsEmit` are talking about exactly
the same object.
-/
import RequestProject.Edge.Cf.Json

namespace CfDeploy

/-- HTTP methods used by the Cloudflare v4 API. -/
inductive Method
  | get | post | put | patch | delete
  deriving DecidableEq, Repr, Inhabited

def Method.name : Method → String
  | .get => "GET"
  | .post => "POST"
  | .put => "PUT"
  | .patch => "PATCH"
  | .delete => "DELETE"

/-- Which credential signs a request.

Every request is signed by a token minted for exactly one role, except
the asset upload calls, which Cloudflare signs with a short-lived upload
JWT obtained from the Pages API — that JWT is itself scoped to a single
project, so no long-lived credential ever touches the upload path. -/
inductive Auth
  /-- an API token minted for the named role -/
  | roleToken (role : String)
  /-- the short-lived Pages upload JWT for a project -/
  | uploadJwt (account project : String)
  /-- no credential at all (public endpoint) -/
  | anonymous
  deriving DecidableEq, Repr, Inhabited

/-- The environment variable a role's token is read from.  Role names
carry account and resource ids, so they are folded to an upper-case
identifier: `kv-write@acct/NS` becomes `CF_TOKEN_KV_WRITE_ACCT_NS`. -/
def envVarOfRole (role : String) : String :=
  "CF_TOKEN_" ++ String.ofList (role.toList.map fun c =>
    if c.isAlphanum then c.toUpper else '_')

def Auth.header : Auth → String
  | .roleToken role => "Authorization: Bearer $" ++ envVarOfRole role
  | .uploadJwt _ _ => "Authorization: Bearer $CF_UPLOAD_JWT"
  | .anonymous => ""

/-- One Cloudflare API request. -/
structure Request where
  method : Method
  /-- path relative to the API base, starting with `/` -/
  path : String
  query : List (String × String) := []
  body : Option Json := none
  auth : Auth
  deriving Inhabited

namespace Request

/-- The API base every path is relative to. -/
def base : String := "https://api.cloudflare.com/client/v4"

def queryString (r : Request) : String :=
  match r.query with
  | [] => ""
  | qs => "?" ++ String.intercalate "&" (qs.map (fun (k, v) => k ++ "=" ++ v))

/-- The absolute URL of a request. -/
def url (r : Request) : String := base ++ r.path ++ r.queryString

/-- A `curl` line, used by the CLI's dry-run transcript. -/
def curl (r : Request) : String :=
  let hdr := match r.auth with
    | .anonymous => ""
    | a => " -H '" ++ a.header ++ "'"
  let ct := if r.body.isSome then " -H 'Content-Type: application/json'" else ""
  let data := match r.body with
    | none => ""
    | some b => " --data '" ++ Json.render b ++ "'"
  "curl -X " ++ r.method.name ++ " '" ++ r.url ++ "'" ++ hdr ++ ct ++ data

end Request

end CfDeploy
