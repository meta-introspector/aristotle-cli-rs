/-
# Executable checks

The theorems in this project pin down the permission model; these `#guard`
checks pin down the *codecs* against real data, at compile time:

* a gzip stream produced by `gzip -9` decompresses to the expected bytes,
  checksum included;
* a `tar.gz` produced by GNU tar yields the expected members;
* a workflow survives the share/parse round trip;
* the executor refuses a step whose role token is absent;
* the gate lets an enrolled browser run exactly this deployment, and
  nothing outside it.

`web/wasm-test.mjs` and `web/deploy-test.mjs` extend the same idea to the
emitted WebAssembly and JavaScript.
-/
import RequestProject.Edge.Cf.Bundle
import RequestProject.Edge.Cf.Share
import RequestProject.Edge.Cf.Exec
import RequestProject.Edge.Cf.Gate

namespace CfDeploy
namespace Tests

/-- `gzip -9` of `"hello, cloudflare\n"` repeated three times. -/
def helloGz : ByteArray := ⟨#[
   31, 139, 8, 0, 158, 44, 152, 106, 2, 255, 203, 72, 205, 201, 201, 215,
   81, 72, 206, 201, 47, 77, 73, 203, 73, 44, 74, 229, 202, 32, 66, 4,
   0, 150, 160, 219, 64, 54, 0, 0, 0]⟩

/-- The plain text that produced it. -/
def helloText : String := "hello, cloudflare\nhello, cloudflare\nhello, cloudflare\n"

#guard (Inflate.gunzip helloGz).isSome
#guard (Inflate.gunzip helloGz).map (·.size) == some helloText.utf8ByteSize
#guard (Inflate.gunzip helloGz) == some helloText.toUTF8

-- Truncating the stream must fail, not return junk.
#guard (Inflate.gunzip (helloGz.extract 0 (helloGz.size - 3))).isNone

-- Corrupting a byte of the compressed data must fail the CRC check.
#guard (Inflate.gunzip (helloGz.set! 20 ((helloGz[20]!) ^^^ 1))).isNone

/-- `tar czf` of a directory `site` holding `index.html` and `style.css`. -/
def siteTgz : ByteArray := ⟨#[
   31, 139, 8, 0, 0, 0, 0, 0, 0, 3, 237, 211, 223, 10, 130, 48,
   20, 199, 241, 61, 138, 79, 144, 115, 58, 189, 145, 222, 165, 82, 80, 176,
   4, 183, 32, 137, 222, 189, 185, 203, 65, 121, 17, 75, 162, 239, 231, 230,
   236, 31, 236, 192, 143, 99, 122, 219, 166, 34, 46, 233, 84, 90, 251, 234,
   132, 213, 175, 51, 173, 138, 82, 170, 82, 21, 185, 144, 153, 116, 59, 145,
   232, 200, 125, 121, 87, 99, 15, 83, 146, 136, 105, 28, 237, 187, 119, 107,
   247, 63, 202, 44, 249, 247, 151, 166, 189, 237, 58, 123, 30, 162, 252, 177,
   4, 92, 22, 197, 235, 252, 179, 60, 200, 95, 105, 119, 148, 200, 40, 221,
   4, 254, 60, 255, 186, 203, 246, 93, 95, 167, 174, 108, 221, 10, 54, 224,
   231, 223, 216, 121, 104, 119, 39, 99, 226, 252, 177, 58, 255, 178, 12, 231,
   63, 175, 20, 243, 255, 13, 199, 177, 153, 239, 143, 173, 187, 0, 0, 0,
   0, 0, 0, 0, 0, 0, 0, 0, 0, 159, 120, 2, 201, 100, 57, 143,
   0, 40, 0, 0]⟩

#guard (Inflate.gunzip siteTgz).isSome

#guard (Bundle.assetsOfTgz true siteTgz).map (·.map (·.path))
  == some ["/index.html", "/style.css"]

#guard (Bundle.assetsOfTgz true siteTgz).map (·.map (·.size)) == some [11, 6]

#guard (Bundle.assetsOfTgz true siteTgz).map (·.map (·.contentType))
  == some ["text/html; charset=utf-8", "text/css; charset=utf-8"]

-- Content addressing is deterministic and distinguishes the two files.
#guard match Bundle.assetsOfTgz true siteTgz with
  | some [a, b] => a.hash != b.hash && a.hash.length == 16
  | _ => false

/-! ## A worked example -/

def demoConfig : Bundle.SiteConfig :=
  { account := "acct", project := "demo", kvNamespace := "ns",
    zone := some "zone", hostname := some "demo.example.com" }

def demoAssets : List Asset :=
  (Bundle.assetsOfTgz true siteTgz).getD []

def demoWorkflow : Workflow :=
  .seq (Bundle.workerSiteWorkflow demoConfig demoAssets)
       (Bundle.dnsWorkflow demoConfig "https://demo.pages.dev")

-- Two KV writes, one Worker upload, one DNS record, one purge.
#guard demoWorkflow.actions.length == 5

-- Four roles: the two KV writes share one token, the rest have their own.
#guard demoWorkflow.tokens.length == 4

-- No token in the bundle carries more than one grant.
#guard demoWorkflow.tokens.all (fun t => t.perms.length ≤ 1)

-- Sharing round-trips on a real workflow.
#guard Share.unshare (Share.share demoWorkflow) == some demoWorkflow

-- Composition survives sharing.
#guard Share.unshare (Share.share (.seq demoWorkflow demoWorkflow))
  == some (Workflow.seq demoWorkflow demoWorkflow)

/-! ## The teardown -/

-- One revocation per minted token, and then the revoking token itself.
#guard (Bundle.teardownWorkflow demoWorkflow).actions.length == demoWorkflow.tokens.length + 1

-- Every role the bootstrap mints for is revoked.
#guard demoWorkflow.tokens.all (fun t =>
  (Bundle.teardownWorkflow demoWorkflow).actions.contains (.revokeRoleToken t.role))

-- The last step revokes the credential that did the revoking.
#guard (Bundle.teardownWorkflow demoWorkflow).actions.getLast? ==
  some (Action.revokeRoleToken Bundle.revokeRole)

-- The teardown is signed by one role of its own, and asks for nothing on
-- any account or zone.
#guard (Bundle.teardownWorkflow demoWorkflow).tokens.length == 1
#guard (Bundle.teardownWorkflow demoWorkflow).required.all
  (fun p => p.scope == Scope.user)

-- Each step names the token of one role, as a reference the runner fills
-- in with the id Cloudflare returned when it minted it.
#guard (Action.revokeRoleToken "kv-write@a/ns").request.path ==
  "/user/tokens/{token:kv-write@a/ns}"

-- A teardown survives being shared and read back, like any other recipe.
#guard Share.unshare (Share.share (Bundle.teardownWorkflow demoWorkflow))
  == some (Bundle.teardownWorkflow demoWorkflow)

/-! ## The gate -/

def kvAction : Action := .putKvValue "acct" "ns" "deadbeefdeadbeef"
def purgeAction : Action := .purgeCache "acct" "zone"

-- The KV token runs the KV write.
#guard match Exec.step [⟨kvAction.role, (TokenSpec.forAction kvAction).perms⟩] kvAction with
  | .performed _ _ => true
  | _ => false

-- It does not run the cache purge: wrong role, and wrong grant.
#guard match Exec.step [⟨kvAction.role, (TokenSpec.forAction kvAction).perms⟩] purgeAction with
  | .noCredential _ => true
  | _ => false

#guard (TokenSpec.forAction kvAction).authorizes purgeAction == false

-- A credential of the right role but stripped of its grant is refused.
#guard match Exec.step [⟨purgeAction.role, []⟩] purgeAction with
  | .denied _ => true
  | _ => false

-- Asset uploads need no API token at all.
#guard match Exec.step [] (.uploadAssets "acct" "demo" demoAssets) with
  | .performed role _ => role == "upload-jwt"
  | _ => false

/-! ## The gate and the plan fit together

A browser enrolled for *this* deployment — this account, this zone, this
Worker script and this KV namespace — is bound to every path the plan
addresses, and to nothing else.  `Gate.bound` is the last guard of
`Gate.judge`, so these checks say the enrolled client can run the whole
recipe, while the same client on another account, or with another script
or namespace named, is refused at every step. -/

/-- One enrolled browser, bound to the demo deployment. -/
def demoClient : Gate.Client :=
  { id := "c1", key := "PUBKEY", accounts := ["acct"], zones := ["zone"],
    names := ["demo", "ns"] }

-- Every step of the recipe is inside the binding.
#guard demoWorkflow.actions.all fun a => Gate.bound demoClient a.request.path

-- Every step is a Cloudflare API path in the first place.
#guard demoWorkflow.actions.all fun a => Gate.isApiPath a.request.path

-- The same client enrolled for another account is refused at every step.
#guard demoWorkflow.actions.all fun a =>
  !Gate.bound { demoClient with accounts := ["other"], zones := [] } a.request.path

-- So is one that names another Worker script and namespace, for every
-- step that addresses a name at all.  (The DNS record and the cache purge
-- address a zone, which a client is bound to by zone id, not by name.)
#guard (Bundle.workerSiteWorkflow demoConfig demoAssets).actions.all fun a =>
  !Gate.bound { demoClient with names := ["other"] } a.request.path

-- The Pages recipe too, including the asset endpoints, which are
-- authorized by the one-project upload JWT rather than by a token.
#guard (Bundle.pagesSiteWorkflow demoConfig demoAssets).actions.all fun a =>
  Gate.bound demoClient a.request.path

-- Minting is not part of the binding unless it is asked for: without
-- `mayMint` the gate refuses `/user/tokens`, so the gate is no way round
-- the per-role tokens.
#guard !Gate.bound demoClient "/user/tokens"
#guard Gate.bound { demoClient with mayMint := true } "/user/tokens"

-- And nothing that is not the Cloudflare API gets through at all.
#guard !Gate.isApiPath "/../etc/passwd"
#guard !Gate.bound { demoClient with mayMint := true } "/graphql"

end Tests
end CfDeploy
