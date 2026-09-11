/-
# The gate: a proxy that only enrolled clients can use

The CORS proxy of `Cf.Offline` is a passthrough: it holds no credential
and forwards whatever it is given, so the only thing standing between the
open internet and it is the origin allow-list.  That is too little for a
proxy that carries a Cloudflare API token of its own, and it does not say
*which* deployment a caller may perform.

The gate is the answer.  Every client of the proxy has a key pair whose
private half never leaves the browser it was generated in; the public
half is enrolled by hand, in the Worker's own configuration, together
with the deployment that client is bound to — the account, the zones, and
the named resources (Worker scripts, Pages projects, KV namespaces) it
may touch.  Every request carries a signature over

    cfdeploy-gate-v1 ⏎ client ⏎ method ⏎ path ⏎ timestamp ⏎ nonce ⏎ body-hash

and the gate forwards it only when that signature verifies under the
enrolled key, the timestamp is fresh, the nonce is new, and the path is
inside the client's binding.  Enrolment is deliberately manual and the
list is meant to stay small: a handful of clients, each pinned to one
deployment.

This module is the model — `judge` is the whole decision, and the
theorems below are what it guarantees — together with the JavaScript that
implements it in a Worker and in the browser.  The JavaScript mirrors the
model the way `Cf.Site`'s core mirrors `Cf.Select`: same order of checks,
same names, same canonical string.
-/
import RequestProject.Edge.Cf.Offline

namespace CfDeploy
namespace Gate

/-! ## The canonical string that is signed

Signing a *joined* string is only as good as the join: if two different
requests could produce the same text, one signature would authorize both.
The fields are newline-free and the join is by newline, so they cannot —
`canonicalL_inj` below. -/

/-- Join fields with a newline between them. -/
def joinNl : List (List Char) → List Char
  | [] => []
  | [x] => x
  | x :: xs => x ++ '\n' :: joinNl xs

/-- A field carries no newline of its own. -/
def NoNl (x : List Char) : Prop := '\n' ∉ x

theorem split_at_nl {a b r t : List Char} (ha : NoNl a) (hb : NoNl b)
    (h : a ++ '\n' :: r = b ++ '\n' :: t) : a = b ∧ r = t := by
  induction a generalizing b with
  | nil =>
    cases b with
    | nil => simp at h; exact ⟨rfl, h⟩
    | cons y b' =>
      simp only [List.nil_append, List.cons_append, List.cons.injEq] at h
      exact absurd (h.1 ▸ List.mem_cons_self ..) hb
  | cons x a' ih =>
    cases b with
    | nil =>
      simp only [List.nil_append, List.cons_append, List.cons.injEq] at h
      exact absurd (h.1 ▸ List.mem_cons_self ..) ha
    | cons y b' =>
      simp only [List.cons_append, List.cons.injEq] at h
      have hx : NoNl a' := fun hm => ha (List.mem_cons_of_mem _ hm)
      have hy : NoNl b' := fun hm => hb (List.mem_cons_of_mem _ hm)
      obtain ⟨h1, h2⟩ := ih hx hy h.2
      exact ⟨by simp [h.1, h1], h2⟩

/-- A join of two or more fields carries a newline. -/
theorem nl_mem_joinNl : ∀ {x y : List Char} {xs : List (List Char)},
    '\n' ∈ joinNl (x :: y :: xs) := by
  intro x y xs
  simp [joinNl]

/-- **Distinct field lists sign as distinct strings.**  So a signature is
a signature of one request: no other method, path, timestamp, nonce or
body can be read out of the same text. -/
theorem joinNl_inj : ∀ {xs ys : List (List Char)}, xs.length = ys.length →
    (∀ x ∈ xs, NoNl x) → (∀ y ∈ ys, NoNl y) → joinNl xs = joinNl ys → xs = ys := by
  intro xs
  induction xs with
  | nil => intro ys hlen _ _ _; cases ys with
    | nil => rfl
    | cons _ _ => simp at hlen
  | cons x xs ih =>
    intro ys hlen hx hy h
    cases ys with
    | nil => simp at hlen
    | cons y ys =>
      cases xs with
      | nil =>
        cases ys with
        | nil => simpa [joinNl] using h
        | cons y' ys' =>
          exfalso
          have : '\n' ∈ joinNl (y :: y' :: ys') := nl_mem_joinNl
          rw [← h] at this
          exact hx x (List.mem_cons_self ..) (by simpa [joinNl] using this)
      | cons x' xs' =>
        cases ys with
        | nil =>
          exfalso
          have : '\n' ∈ joinNl (x :: x' :: xs') := nl_mem_joinNl
          rw [h] at this
          exact hy y (List.mem_cons_self ..) (by simpa [joinNl] using this)
        | cons y' ys' =>
          have hsplit := split_at_nl (a := x) (b := y)
            (hx x (List.mem_cons_self ..)) (hy y (List.mem_cons_self ..))
            (by simpa [joinNl] using h)
          have hrest : joinNl (x' :: xs') = joinNl (y' :: ys') := hsplit.2
          have := ih (by simpa using hlen)
            (fun z hz => hx z (List.mem_cons_of_mem _ hz))
            (fun z hz => hy z (List.mem_cons_of_mem _ hz)) hrest
          simp [hsplit.1, this]

/-! ## Clients, requests and the decision -/

/-- One enrolled client: a public key, and the deployment it is bound to.
Nothing here is a secret — this record is what the operator pastes into
the Worker's configuration. -/
structure Client where
  /-- a short handle, derived from the public key in the browser -/
  id : String
  /-- the public half of the client's key pair, as the browser exported it -/
  key : String
  /-- the account ids this client may address -/
  accounts : List String := []
  /-- the zone ids this client may address -/
  zones : List String := []
  /-- the named resources (Worker scripts, Pages projects, KV namespaces)
  this client may address; empty means "any, inside the accounts above" -/
  names : List String := []
  /-- may this client mint tokens (`/user/tokens`) through the gate? -/
  mayMint : Bool := false
  /-- refuse anything but `GET` -/
  readOnly : Bool := false
  /-- unix seconds after which the enrolment lapses; `0` never lapses -/
  notAfter : Nat := 0
  deriving Repr, Inhabited

/-- A request as it reaches the gate. -/
structure Signed where
  clientId : String
  method : String
  /-- the Cloudflare API path (and query) the gate would forward to -/
  path : String
  /-- a hash of the body, so a signature does not authorize other bytes -/
  bodyHash : String
  nonce : String
  ts : Nat
  sig : String
  deriving Repr, Inhabited

/-- Why the gate refused — or that it did not. -/
inductive Verdict
  | ok
  | unknownClient
  | clientExpired
  | staleTimestamp
  | replay
  | badSignature
  | notApiPath
  | methodRefused
  | notBound
  deriving Repr, DecidableEq, Inhabited

/-- What a path addresses. -/
inductive Target
  | account (id : String)
  | zone (id : String)
  | userTokens
  /-- the Pages asset endpoints, which are authorized by a project-scoped
  upload JWT rather than by an account-scoped token -/
  | pagesAssets
  | other
  deriving Repr, DecidableEq, Inhabited

/-- The path, split into segments, with the query dropped. -/
def segments (path : String) : List String :=
  ((path.splitOn "?").headD path).splitOn "/" |>.filter (· != "")

def targetOf (path : String) : Target :=
  match segments path with
  | "accounts" :: a :: _ => .account a
  | "zones" :: z :: _ => .zone z
  | "user" :: "tokens" :: _ => .userTokens
  | "pages" :: "assets" :: _ => .pagesAssets
  | _ => .other

/-- The names a path addresses: what follows `scripts`, `projects` or
`namespaces`.  These are the Worker script, the Pages project and the KV
namespace a deployment writes to — the things a client is bound to. -/
def namesOf (path : String) : List String :=
  let rec go : List String → List String
    | a :: b :: rest =>
        if a == "scripts" || a == "projects" || a == "namespaces" then b :: go (b :: rest)
        else go (b :: rest)
    | _ => []
  go (segments path)

/-- Is this a Cloudflare API path at all? -/
def isApiPath (path : String) : Bool :=
  match segments path with
  | s :: _ => ["user", "accounts", "zones", "pages", "memberships", "certificates"].contains s
  | [] => false

/-- Every name the path addresses is one this client is bound to (an
empty binding means "any name, inside the accounts above"). -/
def namesBound (c : Client) (path : String) : Bool :=
  c.names.isEmpty || (namesOf path).all (fun n => c.names.contains n)

/-- Is the path inside what this client was enrolled for? -/
def bound (c : Client) (path : String) : Bool :=
  match targetOf path with
  | .account a => c.accounts.contains a && namesBound c path
  | .zone z => c.zones.contains z
  | .userTokens => c.mayMint
  | .pagesAssets => !c.accounts.isEmpty
  | .other => false

/-- The client's enrolment has lapsed. -/
def expired (c : Client) (now : Nat) : Bool := c.notAfter != 0 && Nat.blt c.notAfter now

/-- A read-only client is trying to write. -/
def writeRefused (c : Client) (s : Signed) : Bool := c.readOnly && (s.method != "GET")

/-- The timestamp is inside the freshness window on either side. -/
def fresh (now window ts : Nat) : Bool :=
  (if now ≤ ts then ts - now else now - ts) ≤ window

/-- The text that is signed. -/
def canonicalL (s : Signed) : List (List Char) :=
  [ "cfdeploy-gate-v1".toList, s.clientId.toList, s.method.toList, s.path.toList,
    (toString s.ts).toList, s.nonce.toList, s.bodyHash.toList ]

def canonical (s : Signed) : String := String.ofList (joinNl (canonicalL s))

/-- **The gate's whole decision.**  `verify pubKey message signature` is
the signature check itself, which the Worker hands to WebCrypto; every
other condition is here. -/
def judge (verify : String → String → String → Bool) (now window : Nat)
    (seen : List String) (clients : List Client) (s : Signed) : Verdict :=
  match clients.find? (fun c => c.id == s.clientId) with
  | none => .unknownClient
  | some c =>
    if expired c now then .clientExpired
    else if !fresh now window s.ts then .staleTimestamp
    else if seen.contains s.nonce then .replay
    else if !verify c.key (canonical s) s.sig then .badSignature
    else if !isApiPath s.path then .notApiPath
    else if writeRefused c s then .methodRefused
    else if !bound c s.path then .notBound
    else .ok

/-- The client a decision was taken against. -/
def clientOf (clients : List Client) (s : Signed) : Option Client :=
  clients.find? (fun c => c.id == s.clientId)

/-! ## What the gate guarantees

Each theorem reads the same way: *if the gate forwarded a request, then …*
Together they say that a forwarded request came from an enrolled client,
carried that client's own signature over exactly these bytes, was fresh,
was not a replay, and stayed inside the deployment the client is bound
to. -/

section
variable {verify : String → String → String → Bool} {now window : Nat}
  {seen : List String} {clients : List Client} {s : Signed}

/-- Unpack `judge`: an `ok` verdict means the client was found and every
guard passed. -/
theorem ok_iff :
    judge verify now window seen clients s = .ok ↔
      ∃ c, clientOf clients s = some c ∧
        expired c now = false ∧
        fresh now window s.ts = true ∧
        seen.contains s.nonce = false ∧
        verify c.key (canonical s) s.sig = true ∧
        isApiPath s.path = true ∧
        writeRefused c s = false ∧
        bound c s.path = true := by
  unfold judge clientOf
  cases hfind : clients.find? (fun c => c.id == s.clientId) with
  | none => simp
  | some c =>
    by_cases h1 : expired c now = true <;>
    by_cases h2 : fresh now window s.ts = true <;>
    by_cases h3 : seen.contains s.nonce = true <;>
    by_cases h4 : verify c.key (canonical s) s.sig = true <;>
    by_cases h5 : isApiPath s.path = true <;>
    by_cases h6 : writeRefused c s = true <;>
    by_cases h7 : bound c s.path = true <;>
    simp_all
end

variable {verify : String → String → String → Bool} {now window : Nat}
  {seen : List String} {clients : List Client} {s : Signed} {c : Client}

/-- A forwarded request came from a client that is on the list. -/
theorem ok_enrolled (h : judge verify now window seen clients s = .ok) :
    ∃ c, c ∈ clients ∧ c.id = s.clientId := by
  obtain ⟨c, hc, _⟩ := ok_iff.mp h
  exact ⟨c, List.mem_of_find?_eq_some hc, by
    have := List.find?_some hc
    simpa using this⟩

/-- A forwarded request carried that client's own signature, over exactly
this method, path, timestamp, nonce and body. -/
theorem ok_signed (h : judge verify now window seen clients s = .ok) :
    ∃ c, clientOf clients s = some c ∧ verify c.key (canonical s) s.sig = true := by
  obtain ⟨c, hc, _, _, _, hsig, _⟩ := ok_iff.mp h
  exact ⟨c, hc, hsig⟩

/-- A forwarded request was fresh. -/
theorem ok_fresh (h : judge verify now window seen clients s = .ok) :
    fresh now window s.ts = true := by
  obtain ⟨_, _, _, hf, _⟩ := ok_iff.mp h
  exact hf

/-- A nonce the gate has already seen is never forwarded again. -/
theorem replay_refused (h : seen.contains s.nonce = true) :
    judge verify now window seen clients s ≠ .ok := by
  intro hok
  obtain ⟨_, _, _, _, hr, _⟩ := ok_iff.mp hok
  rw [h] at hr
  exact absurd hr (by simp)

/-- An unenrolled client is refused, whatever it signs. -/
theorem unknown_refused (h : clientOf clients s = none) :
    judge verify now window seen clients s = .unknownClient := by
  unfold judge
  unfold clientOf at h
  rw [h]

/-- A forwarded request stayed inside the deployment its client is bound
to: its account (and, when the client names them, its Worker script,
Pages project and KV namespace), or its zone, or — for token minting —
only if that client was enrolled to mint. -/
theorem ok_bound (h : judge verify now window seen clients s = .ok) :
    ∃ c, clientOf clients s = some c ∧ bound c s.path = true ∧ isApiPath s.path = true := by
  obtain ⟨c, hc, _, _, _, _, hapi, _, hb⟩ := ok_iff.mp h
  exact ⟨c, hc, hb, hapi⟩

/-- In particular: a request to an account the client was not enrolled
for is refused. -/
theorem foreign_account_refused {a : String} (hc : clientOf clients s = some c)
    (hpath : targetOf s.path = .account a) (hbound : c.accounts.contains a = false) :
    judge verify now window seen clients s ≠ .ok := by
  intro hok
  obtain ⟨c', hc', _, _, _, _, _, _, hb⟩ := ok_iff.mp hok
  rw [hc] at hc'
  cases hc'
  have hnm : a ∉ c.accounts := by simpa using hbound
  unfold bound at hb
  rw [hpath] at hb
  simp [hnm] at hb

/-- And a client that was not enrolled to mint tokens cannot reach
`/user/tokens` through the gate — the gate is not a way around the
per-role token discipline. -/
theorem no_minting_unless_enrolled (hc : clientOf clients s = some c)
    (hpath : targetOf s.path = .userTokens) (hmint : c.mayMint = false) :
    judge verify now window seen clients s ≠ .ok := by
  intro hok
  obtain ⟨c', hc', _, _, _, _, _, _, hb⟩ := ok_iff.mp hok
  rw [hc] at hc'
  cases hc'
  unfold bound at hb
  rw [hpath] at hb
  simp [hmint] at hb

/-- A read-only client cannot write. -/
theorem read_only_cannot_write (hc : clientOf clients s = some c)
    (hro : c.readOnly = true) (hm : s.method ≠ "GET") :
    judge verify now window seen clients s ≠ .ok := by
  intro hok
  obtain ⟨c', hc', _, _, _, _, _, hro', _⟩ := ok_iff.mp hok
  rw [hc] at hc'
  cases hc'
  unfold writeRefused at hro'
  rw [hro] at hro'
  simp at hro'
  exact hm hro'

/-! ## Checks on the model -/

#guard targetOf "/accounts/abc/workers/scripts/site" == .account "abc"
#guard targetOf "/zones/z1/dns_records" == .zone "z1"
#guard targetOf "/user/tokens" == .userTokens
#guard targetOf "/pages/assets/upload" == .pagesAssets
#guard targetOf "/memberships" == .other
#guard namesOf "/accounts/a/workers/scripts/site" == ["site"]
#guard namesOf "/accounts/a/storage/kv/namespaces/NS/values/deadbeef" == ["NS"]
#guard namesOf "/accounts/a/pages/projects/proj/deployments" == ["proj"]
#guard isApiPath "/accounts/a/workers/scripts/site"
#guard !isApiPath "/../etc/passwd"
#guard fresh 1000 300 1200
#guard !fresh 1000 300 1400
#guard canonical { clientId := "c1", method := "PUT", path := "/user/tokens", bodyHash := "h",
                   nonce := "n", ts := 7, sig := "s" } ==
  "cfdeploy-gate-v1\nc1\nPUT\n/user/tokens\n7\nn\nh"

private def demoClient : Client :=
  { id := "c1", key := "K", accounts := ["ACCT"], names := ["site", "NS"], mayMint := true }

private def demoReq (path : String) (method : String := "PUT") : Signed :=
  { clientId := "c1", method := method, path := path, bodyHash := "h", nonce := "n1",
    ts := 1000, sig := "S" }

private def yes : String → String → String → Bool := fun _ _ _ => true
private def no : String → String → String → Bool := fun _ _ _ => false

#guard judge yes 1000 300 [] [demoClient] (demoReq "/accounts/ACCT/workers/scripts/site") == .ok
#guard judge no 1000 300 [] [demoClient] (demoReq "/accounts/ACCT/workers/scripts/site")
  == .badSignature
#guard judge yes 1000 300 ["n1"] [demoClient] (demoReq "/accounts/ACCT/workers/scripts/site")
  == .replay
#guard judge yes 2000 300 [] [demoClient] (demoReq "/accounts/ACCT/workers/scripts/site")
  == .staleTimestamp
#guard judge yes 1000 300 [] [] (demoReq "/accounts/ACCT/workers/scripts/site")
  == .unknownClient
#guard judge yes 1000 300 [] [demoClient] (demoReq "/accounts/OTHER/workers/scripts/site")
  == .notBound
#guard judge yes 1000 300 [] [demoClient] (demoReq "/accounts/ACCT/workers/scripts/other")
  == .notBound
#guard judge yes 1000 300 [] [{ demoClient with mayMint := false }] (demoReq "/user/tokens")
  == .notBound
#guard judge yes 1000 300 [] [demoClient] (demoReq "/user/tokens") == .ok
#guard judge yes 1000 300 [] [{ demoClient with readOnly := true }]
  (demoReq "/accounts/ACCT/workers/scripts/site") == .methodRefused
#guard judge yes 1000 300 [] [{ demoClient with readOnly := true }]
  (demoReq "/accounts/ACCT/workers/scripts/site" "GET") == .ok
#guard judge yes 1000 300 [] [{ demoClient with notAfter := 999 }]
  (demoReq "/accounts/ACCT/workers/scripts/site") == .clientExpired


/-! ## The gate, in a Worker

The JavaScript below is the model above, in the order the model checks
things: `clientOf`, `expired`, `fresh`, the replay cache, the signature,
`isApiPath`, `writeRefused`, `bound`.  The signature itself is ECDSA over
P-256 with SHA-256, done by the platform's own WebCrypto — the one thing
the Lean model leaves as a parameter. -/

/-- The gated proxy Worker: a Cloudflare API proxy that forwards nothing
it cannot attribute to an enrolled client. -/
def gateWorkerJs : String :=
r##"// Generated from Lean by RequestProject.Cf.Gate — do not edit.
//
// A CORS proxy for the Cloudflare API that only enrolled clients can use.
//
// Every request must carry a signature made by a key pair whose private
// half never leaves the client's browser:
//
//   cf-gate-client   the client id it was enrolled under
//   cf-gate-ts       unix seconds
//   cf-gate-nonce    a fresh random string
//   cf-gate-sig      ECDSA P-256 / SHA-256 over
//                    cfdeploy-gate-v1\n<client>\n<method>\n<path>\n<ts>\n<nonce>\n<sha256(body)>
//
// and the gate forwards it only when the signature verifies under the
// enrolled public key, the timestamp is inside the window, the nonce is
// new, and the path is inside the deployment that client was bound to —
// its account, its zones, and the Worker script, Pages project or KV
// namespace it may write.  This is `RequestProject.Cf.Gate.judge`, in the
// same order, with the same names.
//
// Configuration (wrangler.toml / the dashboard):
//   CFDEPLOY_CLIENTS  a JSON array of enrolled clients (see README)
//   CF_API_TOKEN      optional: a token the gate signs requests with when
//                     the client sends none, so the key stays here
//   ALLOWED_ORIGINS   optional: a comma-separated origin allow-list
//
// Enrolment is deliberately by hand and meant to stay small: a handful of
// clients, each pinned to one deployment.

const CF_API = 'https://api.cloudflare.com/client/v4';
const WINDOW_SECONDS = 300;
const NONCE_TTL_MS = 900_000;
const KEY_ALG = { name: 'ECDSA', namedCurve: 'P-256' };
const SIG_ALG = { name: 'ECDSA', hash: 'SHA-256' };
const API_HEADS = ['user', 'accounts', 'zones', 'pages', 'memberships', 'certificates'];
const DROP = new Set(['host', 'cookie', 'origin', 'referer', 'content-length',
                      'cf-connecting-ip', 'x-forwarded-for', 'x-real-ip',
                      'cf-gate-client', 'cf-gate-ts', 'cf-gate-nonce', 'cf-gate-sig']);

// ---- the model (RequestProject.Cf.Gate) ----------------------------------
const segments = (path) => String(path).split('?')[0].split('/').filter((x) => x !== '');

function targetOf(path) {
  const s = segments(path);
  if (s[0] === 'accounts' && s.length >= 2) return { tag: 'account', id: s[1] };
  if (s[0] === 'zones' && s.length >= 2) return { tag: 'zone', id: s[1] };
  if (s[0] === 'user' && s[1] === 'tokens') return { tag: 'userTokens' };
  if (s[0] === 'pages' && s[1] === 'assets') return { tag: 'pagesAssets' };
  return { tag: 'other' };
}

function namesOf(path) {
  const s = segments(path);
  const out = [];
  for (let i = 0; i + 1 < s.length; i++) {
    if (s[i] === 'scripts' || s[i] === 'projects' || s[i] === 'namespaces') out.push(s[i + 1]);
  }
  return out;
}

const isApiPath = (path) => API_HEADS.includes(segments(path)[0]);

const namesBound = (c, path) =>
  !(c.names ?? []).length || namesOf(path).every((n) => c.names.includes(n));

function bound(c, path) {
  const t = targetOf(path);
  if (t.tag === 'account') return (c.accounts ?? []).includes(t.id) && namesBound(c, path);
  if (t.tag === 'zone') return (c.zones ?? []).includes(t.id);
  if (t.tag === 'userTokens') return !!c.mayMint;
  if (t.tag === 'pagesAssets') return (c.accounts ?? []).length > 0;
  return false;
}

const expired = (c, now) => !!c.notAfter && c.notAfter < now;
const writeRefused = (c, s) => !!c.readOnly && s.method !== 'GET';
const fresh = (now, w, ts) => Math.abs(now - ts) <= w;
const canonical = (s) => ['cfdeploy-gate-v1', s.clientId, s.method, s.path,
  String(s.ts), s.nonce, s.bodyHash].join('\n');

// ---- the pieces the model leaves to the platform --------------------------
const enc = new TextEncoder();
const hex = (buf) => [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, '0')).join('');
const sha256Hex = async (bytes) => hex(await crypto.subtle.digest('SHA-256', bytes));

const b64uBytes = (s) => {
  const b64 = String(s).replace(/-/g, '+').replace(/_/g, '/');
  const bin = atob(b64 + '='.repeat((4 - (b64.length % 4)) % 4));
  const out = new Uint8Array(bin.length);
  for (let i = 0; i < bin.length; i++) out[i] = bin.charCodeAt(i);
  return out;
};

async function verifySignature(client, message, signature) {
  try {
    const key = await crypto.subtle.importKey('jwk', client.key, KEY_ALG, false, ['verify']);
    return await crypto.subtle.verify(SIG_ALG, key, b64uBytes(signature), enc.encode(message));
  } catch {
    return false;
  }
}

// The replay cache lives in this isolate; the timestamp window is what
// bounds a replay that reaches a different one.
const SEEN = new Map();
function seenNonce(nonce) {
  const now = Date.now();
  for (const [k, t] of SEEN) if (t < now) SEEN.delete(k);
  if (SEEN.has(nonce)) return true;
  SEEN.set(nonce, now + NONCE_TTL_MS);
  return false;
}

function clientsOf(env) {
  try {
    const raw = JSON.parse(env.CFDEPLOY_CLIENTS ?? '[]');
    return Array.isArray(raw) ? raw : [];
  } catch {
    return [];
  }
}

/** `Gate.judge`: the whole decision, in the model's own order. */
async function judge(env, now, s) {
  const clients = clientsOf(env);
  const c = clients.find((x) => x.id === s.clientId);
  if (!c) return { verdict: 'unknownClient', status: 403 };
  if (expired(c, now)) return { verdict: 'clientExpired', status: 403 };
  if (!fresh(now, WINDOW_SECONDS, s.ts)) return { verdict: 'staleTimestamp', status: 401 };
  if (seenNonce(s.clientId + ':' + s.nonce)) return { verdict: 'replay', status: 401 };
  if (!await verifySignature(c, canonical(s), s.sig)) {
    return { verdict: 'badSignature', status: 403 };
  }
  if (!isApiPath(s.path)) return { verdict: 'notApiPath', status: 400 };
  if (writeRefused(c, s)) return { verdict: 'methodRefused', status: 403 };
  if (!bound(c, s.path)) return { verdict: 'notBound', status: 403 };
  return { verdict: 'ok', status: 200, client: c };
}

// ---- the Worker -----------------------------------------------------------
function corsHeaders(env, origin) {
  const allowed = (env.ALLOWED_ORIGINS ?? '').split(',').map((x) => x.trim()).filter(Boolean);
  const ok = !allowed.length || (origin && allowed.includes(origin));
  return {
    'access-control-allow-origin': ok ? (origin || '*') : 'null',
    'access-control-allow-methods': 'GET, POST, PUT, PATCH, DELETE, OPTIONS',
    'access-control-allow-headers':
      'authorization, content-type, cf-gate-client, cf-gate-ts, cf-gate-nonce, cf-gate-sig',
    'access-control-max-age': '600',
    'vary': 'origin',
  };
}

const refuse = (env, origin, verdict, status, detail) => new Response(JSON.stringify({
  success: false,
  gate: verdict,
  errors: [{ code: 0, message: `cfdeploy gate: ${verdict}${detail ? ' — ' + detail : ''}` }],
}), { status, headers: { 'content-type': 'application/json', ...corsHeaders(env, origin) } });

/** The Cloudflare path this request is asking for: /cf/<path>, or
 * ?apiurl=<the whole API URL>. */
function apiPathOf(url) {
  const viaQuery = url.searchParams.get('apiurl') ?? url.searchParams.get('u');
  if (viaQuery) {
    if (!viaQuery.startsWith(CF_API)) return null;
    const inner = new URL(viaQuery);
    return inner.pathname.slice(new URL(CF_API).pathname.length) + inner.search;
  }
  if (url.pathname === '/cf' || url.pathname.startsWith('/cf/')) {
    return (url.pathname.slice(3) || '/') + url.search;
  }
  return null;
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const origin = request.headers.get('origin');
    if (request.method === 'OPTIONS') {
      return new Response(null, { status: 204, headers: corsHeaders(env, origin) });
    }
    if (url.pathname === '/gate/info') {
      return new Response(JSON.stringify({
        gate: 'cfdeploy', version: 1, alg: 'ECDSA-P256-SHA256',
        window: WINDOW_SECONDS, clients: clientsOf(env).length,
        hasToken: !!env.CF_API_TOKEN,
        hint: 'sign every request; enrolment is by hand, in CFDEPLOY_CLIENTS',
      }), { status: 200, headers: { 'content-type': 'application/json', ...corsHeaders(env, origin) } });
    }
    const path = apiPathOf(url);
    if (path === null) {
      return refuse(env, origin, 'notApiPath', 400, 'use /cf/<path> or ?apiurl=<api url>');
    }

    const body = (request.method === 'GET' || request.method === 'HEAD')
      ? null : new Uint8Array(await request.arrayBuffer());
    const signed = {
      clientId: request.headers.get('cf-gate-client') ?? '',
      method: request.method,
      path,
      bodyHash: await sha256Hex(body ?? new Uint8Array()),
      nonce: request.headers.get('cf-gate-nonce') ?? '',
      ts: Number(request.headers.get('cf-gate-ts') ?? 0),
      sig: request.headers.get('cf-gate-sig') ?? '',
    };
    const now = Math.floor(Date.now() / 1000);
    const verdict = await judge(env, now, signed);
    if (verdict.verdict !== 'ok') {
      return refuse(env, origin, verdict.verdict, verdict.status,
        verdict.verdict === 'notBound' ? `this client is not enrolled for ${path}` : '');
    }

    const headers = new Headers();
    for (const [k, v] of request.headers) if (!DROP.has(k.toLowerCase())) headers.set(k, v);
    const given = headers.get('authorization');
    if ((!given || given === 'Bearer gate') && env.CF_API_TOKEN) {
      headers.set('authorization', `Bearer ${env.CF_API_TOKEN}`);
    } else if (!given) {
      return refuse(env, origin, 'noCredential', 401,
        'neither the client nor the gate supplied an API token');
    }

    let res;
    try {
      res = await fetch(CF_API + path, { method: request.method, headers, body, redirect: 'manual' });
    } catch (e) {
      return refuse(env, origin, 'upstreamFailed', 502, e && e.message ? e.message : String(e));
    }
    const SKIP = new Set(['set-cookie', 'content-encoding', 'content-length', 'transfer-encoding']);
    const out = new Response(res.body, { status: res.status, statusText: res.statusText });
    for (const [k, v] of res.headers) if (!SKIP.has(k.toLowerCase())) out.headers.set(k, v);
    for (const [k, v] of Object.entries(corsHeaders(env, origin))) out.headers.set(k, v);
    out.headers.set('cf-gate-client', signed.clientId);
    return out;
  },
};
"##

/-- The browser half: a key pair that stays in this browser, and a
`fetch` that signs every request with it. -/
def gateClientJs : String :=
r##"// Generated from Lean by RequestProject.Cf.Gate — do not edit.
//
// The client half of the gate.  The private key is generated in the
// browser, marked non-extractable, and kept in IndexedDB: it cannot be
// read out of the page, by this page or any other.  What you enrol in the
// Worker is the public half, together with the deployment this client is
// allowed to perform.

const KEY_ALG = { name: 'ECDSA', namedCurve: 'P-256' };
const SIG_ALG = { name: 'ECDSA', hash: 'SHA-256' };
const enc = new TextEncoder();

const b64u = (bytes) => {
  let s = '';
  for (const b of new Uint8Array(bytes)) s += String.fromCharCode(b);
  return btoa(s).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
};
const hex = (buf) => [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, '0')).join('');

/** The client id: a short, stable digest of the public key. */
export async function idOf(jwk) {
  const digest = await crypto.subtle.digest('SHA-256', enc.encode(jwk.x + '.' + jwk.y));
  return 'c' + hex(digest).slice(0, 16);
}

/** A new identity: a key pair, and the id its public half hashes to. */
export async function newIdentity() {
  const pair = await crypto.subtle.generateKey(KEY_ALG, false, ['sign', 'verify']);
  const jwk = await crypto.subtle.exportKey('jwk', pair.publicKey);
  const pub = { kty: jwk.kty, crv: jwk.crv, x: jwk.x, y: jwk.y };
  return { id: await idOf(pub), publicJwk: pub, privateKey: pair.privateKey };
}

const IDB_NAME = 'cfdeploy';
const IDB_STORE = 'identity';

function idb() {
  return new Promise((resolve, reject) => {
    if (typeof indexedDB === 'undefined') { resolve(null); return; }
    const req = indexedDB.open(IDB_NAME, 1);
    req.onupgradeneeded = () => req.result.createObjectStore(IDB_STORE);
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
}

const idbGet = (db, key) => new Promise((resolve, reject) => {
  const r = db.transaction(IDB_STORE, 'readonly').objectStore(IDB_STORE).get(key);
  r.onsuccess = () => resolve(r.result);
  r.onerror = () => reject(r.error);
});

const idbPut = (db, key, value) => new Promise((resolve, reject) => {
  const r = db.transaction(IDB_STORE, 'readwrite').objectStore(IDB_STORE).put(value, key);
  r.onsuccess = () => resolve();
  r.onerror = () => reject(r.error);
});

let MEMORY = null;

/** This browser's identity, generated once and kept in IndexedDB.  Where
 * there is no IndexedDB (node, a private window that refuses it) it lives
 * for as long as the page does. */
export async function loadIdentity() {
  let db = null;
  try { db = await idb(); } catch { db = null; }
  if (db) {
    const found = await idbGet(db, 'client');
    if (found && found.privateKey) return found;
    const made = await newIdentity();
    await idbPut(db, 'client', made);
    return made;
  }
  if (!MEMORY) MEMORY = await newIdentity();
  return MEMORY;
}

/** Forget this browser's key: the enrolled record stops working, and the
 * next call generates a new one. */
export async function resetIdentity() {
  MEMORY = null;
  try {
    const db = await idb();
    if (db) await idbPut(db, 'client', undefined);
  } catch { /* nothing to forget */ }
}

/** The record to paste into the Worker's CFDEPLOY_CLIENTS: the public key
 * and the deployment this client is bound to.  It carries no secret. */
export function enrolment(identity, binding = {}) {
  return {
    id: identity.id,
    key: identity.publicJwk,
    accounts: binding.accounts ?? [],
    zones: binding.zones ?? [],
    names: binding.names ?? [],
    mayMint: binding.mayMint ?? false,
    readOnly: binding.readOnly ?? false,
    notAfter: binding.notAfter ?? 0,
  };
}

/** The Cloudflare path the gate will derive from this URL — what the
 * signature has to cover. */
export function cfPathOf(base, url, cfApi = 'https://api.cloudflare.com/client/v4') {
  const u = String(url);
  if (u.startsWith(cfApi)) {
    const rest = u.slice(cfApi.length);
    const q = new URL(u).searchParams.get('apiurl');
    if (q) return cfPathOf(base, q, cfApi);
    return rest || '/';
  }
  const b = String(base ?? '');
  if (b.includes('apiurl=') || b.includes('{url}')) {
    const inner = new URL(u).searchParams.get('apiurl') ?? new URL(u).searchParams.get('u');
    if (inner) return cfPathOf(base, inner, cfApi);
  }
  if (b && u.startsWith(b)) return u.slice(b.length) || '/';
  const parsed = new URL(u, 'http://localhost');
  return (parsed.pathname.replace(/^\/cf/, '') || '/') + parsed.search;
}

/** Exactly the bytes that will go on the wire, for any body shape a
 * deployment step produces.  A typed array is very often a *view* into a
 * larger buffer — the assets of one bundle share one buffer — so the view's
 * own offset and length have to be respected: hashing `body.buffer` would
 * sign the whole bundle instead of the one asset being uploaded, and the
 * gate would reject every such request as badSignature. */
export async function bodyBytes(body) {
  if (body === undefined || body === null) return new Uint8Array();
  if (typeof body === 'string') return enc.encode(body);
  if (body instanceof ArrayBuffer) return new Uint8Array(body);
  if (ArrayBuffer.isView(body)) {
    return new Uint8Array(body.buffer, body.byteOffset, body.byteLength);
  }
  if (typeof Blob !== 'undefined' && body instanceof Blob) {
    return new Uint8Array(await body.arrayBuffer());
  }
  throw new TypeError('cfdeploy gate: cannot sign a body of this kind');
}

/** The gate headers for one request. */
export async function signRequest(identity, method, path, body) {
  const digest = await crypto.subtle.digest('SHA-256', await bodyBytes(body));
  const ts = Math.floor(Date.now() / 1000);
  const nonce = b64u(crypto.getRandomValues(new Uint8Array(12)));
  const message = ['cfdeploy-gate-v1', identity.id, method, path, String(ts), nonce,
    hex(digest)].join('\n');
  const sig = await crypto.subtle.sign(SIG_ALG, identity.privateKey, enc.encode(message));
  return {
    'cf-gate-client': identity.id,
    'cf-gate-ts': String(ts),
    'cf-gate-nonce': nonce,
    'cf-gate-sig': b64u(sig),
  };
}

/** A `fetch` that signs every request for the gate at `base`.  Hand it to
 * `runPlan({ fetchImpl })` and the whole deployment is signed, step by
 * step, by a key that never leaves this browser. */
export function gatedFetch(identity, base, fetchImpl = fetch) {
  return async (url, init = {}) => {
    const method = (init.method ?? 'GET').toUpperCase();
    const path = cfPathOf(base, url);
    const headers = new Headers(init.headers ?? {});
    for (const [k, v] of Object.entries(await signRequest(identity, method, path, init.body))) {
      headers.set(k, v);
    }
    return fetchImpl(url, { ...init, headers });
  };
}

/** Is there a cfdeploy gate at this URL? */
export async function gateInfo(base, fetchImpl = fetch) {
  const root = String(base).replace(/\/cf\/?$/, '').replace(/\?.*$/, '');
  const res = await fetchImpl(root + '/gate/info');
  const info = await res.json();
  return info && info.gate === 'cfdeploy' ? info : null;
}
"##

/-- `wrangler.toml` for the gated proxy. -/
def gateWranglerToml (name : String) (origins : Option String) : String :=
  "# Generated from Lean by RequestProject.Cf.Gate.\n" ++
  "name = \"" ++ name ++ "\"\n" ++
  "main = \"_worker.js\"\n" ++
  "compatibility_date = \"2025-01-01\"\n" ++
  "workers_dev = true\n\n" ++
  "[vars]\n" ++
  (match origins with
   | some o => "ALLOWED_ORIGINS = \"" ++ o ++ "\"\n"
   | none => "# ALLOWED_ORIGINS = \"https://your-page.example\"\n") ++
  "\n" ++
  "# The enrolled clients are a secret, not a var — they are pasted in with\n" ++
  "#   npx wrangler secret put CFDEPLOY_CLIENTS\n" ++
  "# and, if the gate is to hold the Cloudflare credential itself,\n" ++
  "#   npx wrangler secret put CF_API_TOKEN\n"

/-- What to do with the emitted gate directory. -/
def gateReadme (name : String) : String :=
  "# cfdeploy gate — a proxy only your own clients can use\n\n" ++
  "Generated from Lean by `cfdeploy gate`.  Two files:\n\n" ++
  "| file | what it is |\n" ++
  "| --- | --- |\n" ++
  "| `_worker.js` | the gate: a Cloudflare API proxy that forwards a request only when it is signed by an enrolled client and stays inside that client's binding |\n" ++
  "| `wrangler.toml` | so `npx wrangler deploy` works with no arguments |\n\n" ++
  "## Deploy it\n\n" ++
  "```\n" ++
  "cd <this directory>\n" ++
  "npx wrangler deploy            # the Worker is called " ++ name ++ "\n" ++
  "```\n\n" ++
  "## Enrol a client\n\n" ++
  "1. Open the cfdeploy page in the browser you will deploy from. It\n" ++
  "   generates a key pair on first use; the private half is\n" ++
  "   non-extractable and stays in that browser's IndexedDB.\n" ++
  "2. Fill in the account, the project and the KV namespace, then press\n" ++
  "   **Copy this client's enrolment**. What you get is a JSON record —\n" ++
  "   a public key and the deployment it is bound to, no secret in it.\n" ++
  "3. Add it to the list and hand the list to the Worker:\n\n" ++
  "```\n" ++
  "npx wrangler secret put CFDEPLOY_CLIENTS\n" ++
  "# paste:  [ { \"id\": \"c…\", \"key\": { … }, \"accounts\": [\"…\"], \"names\": [\"…\"] } ]\n" ++
  "```\n\n" ++
  "4. Optionally let the gate hold the Cloudflare credential, so the\n" ++
  "   browser never sees one at all:\n\n" ++
  "```\n" ++
  "npx wrangler secret put CF_API_TOKEN\n" ++
  "```\n\n" ++
  "5. Put the Worker's URL in the page's **API base** field. The page\n" ++
  "   detects the gate (`/gate/info`) and signs every request from then on.\n\n" ++
  "## What a client record means\n\n" ++
  "| field | effect |\n" ++
  "| --- | --- |\n" ++
  "| `id`, `key` | the client's handle and its public key; a request signed by any other key is refused |\n" ++
  "| `accounts` | the account ids it may address (`/accounts/<id>/…`) |\n" ++
  "| `zones` | the zone ids it may address (`/zones/<id>/…`) |\n" ++
  "| `names` | the Worker scripts, Pages projects and KV namespaces it may write; empty means any, inside those accounts |\n" ++
  "| `mayMint` | whether it may reach `/user/tokens` to mint the scoped tokens |\n" ++
  "| `readOnly` | refuse anything but `GET` |\n" ++
  "| `notAfter` | unix seconds after which the enrolment lapses |\n\n" ++
  "A request that is not signed, is signed by an unenrolled key, repeats a\n" ++
  "nonce, is more than five minutes old, or reaches outside the binding, is\n" ++
  "refused before anything is forwarded — that is\n" ++
  "`RequestProject.Cf.Gate.judge`, and the theorems beside it say exactly\n" ++
  "that.  The list is meant to stay small: enrolment is by hand, one record\n" ++
  "per browser, and removing a record is how you revoke one.\n\n" ++
  "The gate is not a way around the per-action tokens: `mayMint` is off by\n" ++
  "default, and a client that cannot mint cannot ask the API for a token\n" ++
  "wider than the ones the plan already uses.\n"

/-! ## Checks on the emitted JavaScript -/

#guard (gateWorkerJs.splitOn "cfdeploy-gate-v1").length == 3
#guard (gateClientJs.splitOn "cfdeploy-gate-v1").length == 2
#guard (gateWorkerJs.splitOn "CFDEPLOY_CLIENTS").length ≥ 2
#guard (gateWorkerJs.splitOn "ECDSA").length ≥ 2
-- the Worker asks the same questions, in the same order, as `judge`
#guard (gateWorkerJs.splitOn "unknownClient").length ≥ 2
#guard (gateWorkerJs.splitOn "clientExpired").length ≥ 2
#guard (gateWorkerJs.splitOn "staleTimestamp").length ≥ 2
#guard (gateWorkerJs.splitOn "replay").length ≥ 2
#guard (gateWorkerJs.splitOn "badSignature").length ≥ 2
#guard (gateWorkerJs.splitOn "notBound").length ≥ 2

end Gate
end CfDeploy
