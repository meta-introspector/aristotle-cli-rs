/-
# Prove2me §13 — the gateway to the existing HTTP API

The first deployment should not force every client to become a peer.  A
gateway converts server records into signed artifacts, stores the
resulting address in the API metadata, and resolves that address back to
the artifact.

**Caveat, stated in the code as well as in the write-up.**  The record
below is modelled on the specification text, not on a live reading of
the Prove2me HTTP API: field names, endpoint shape and authentication
must be checked against the real service before any of this is fixed in
a wire schema.  What is proved is the *shape* of the bridge, which does
not change when the field names do.

Proved here:

* `bridge_ignores_prose` — two API records differing only in title,
  description or tags map to the same artifact address, so the gateway
  cannot fork a theorem by editing its display text;
* `bridge_roundtrip` — the address the gateway writes into the API
  metadata resolves, in the peer's own store, to exactly the artifact it
  published;
* `apiUrl_inj` — distinct server rows get distinct source URLs, so the
  compatibility record identifies which row an artifact came from;
* `imported_not_accepted` — importing a theorem from the API accepts
  nothing.  The gateway is a producer of candidates, never an authority;
* `gateway_results_need_trust` — results exported by the gateway count
  only for peers that have chosen to trust the gateway's key.
-/
import RequestProject.Kant.Prove2me.Names

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Kant.Prove2me

open Kant Kant.Text

/-! ## The server record -/

/-- A theorem as the existing HTTP API returns it.  Provisional: see the
caveat in the module header. -/
structure ApiTheorem where
  /-- The server's row id. -/
  id : Nat
  /-- The declaration name. -/
  name : Str
  /-- The exact formal statement. -/
  statement : Str
  /-- The imports it is stated against. -/
  imports : List Str
  /-- The definitions it refers to, already addressed. -/
  definitions : List Cid
  /-- The environment, already addressed. -/
  environment : Cid
  /-- Display title. -/
  title : Str
  /-- Display description. -/
  description : Str
  /-- Display tags. -/
  tags : List Str
deriving DecidableEq, Repr

/-- The artifact a server record becomes.  Total: every record maps to
exactly one artifact. -/
def toThm (a : ApiTheorem) : Thm :=
  { core :=
      { statement := a.statement
        imports := a.imports
        definitions := a.definitions
        environment := a.environment }
    name := a.name
    title := a.title
    documentation := a.description
    tags := a.tags }

/-- **Editing the display text does not fork a theorem.** -/
theorem bridge_ignores_prose (A : Addressing) {a a' : ApiTheorem}
    (hs : a.statement = a'.statement) (hi : a.imports = a'.imports)
    (hd : a.definitions = a'.definitions) (he : a.environment = a'.environment) :
    theoremId A (toThm a) = theoremId A (toThm a') :=
  theoremId_ignores_prose A (by simp [toThm, hs, hi, hd, he])

/-! ## The compatibility record -/

/-- Where a record came from. -/
def apiUrl (base : Str) (id : Nat) : Str := base ++ "/api/v1/theorems/".toList ++ natField id

theorem apiUrl_inj {base : Str} {i j : Nat} (h : apiUrl base i = apiUrl base j) : i = j := by
  unfold apiUrl at h
  rw [List.append_assoc, List.append_assoc] at h
  have h1 := List.append_cancel_left h
  exact natField_inj (List.append_cancel_left h1)

/-- The `{source, artifact}` record the gateway writes into the API. -/
structure CompatMeta where
  /-- The HTTP resource this came from. -/
  source : Str
  /-- The artifact address. -/
  artifact : Cid
deriving DecidableEq, Repr

/-- Build the compatibility record for a server row. -/
def compatMeta (A : Addressing) (base : Str) (a : ApiTheorem) : CompatMeta :=
  { source := apiUrl base a.id, artifact := theoremId A (toThm a) }

/-! ## Publishing and resolving -/

/-- Look an address up in a peer's store. -/
def lookup (st : List (Cid × Content)) (cid : Cid) : Option Content :=
  (st.find? (fun p => p.1 == cid)).map Prod.snd

/-- Publish an artifact into a store under its own address. -/
def publish (A : Addressing) (st : List (Cid × Content)) (c : Content) : List (Cid × Content) :=
  (idOf A c, c) :: st

@[simp] theorem lookup_publish (A : Addressing) (st : List (Cid × Content)) (c : Content) :
    lookup (publish A st c) (idOf A c) = some c := by
  simp [lookup, publish]

/-- **The bridge round-trips.**  The address the gateway records in the
API metadata resolves back, in the peer's own store, to exactly the
artifact that was published — with no further help from the server. -/
theorem bridge_roundtrip (A : Addressing) (base : Str) (st : List (Cid × Content))
    (a : ApiTheorem) :
    lookup (publish A st (toThm a).core.content) (compatMeta A base a).artifact
      = some (toThm a).core.content :=
  lookup_publish A st _

/-- The source URL in the compatibility record names the row it came
from. -/
theorem compatMeta_source (A : Addressing) (base : Str) (a : ApiTheorem) :
    (compatMeta A base a).source = apiUrl base a.id := rfl

/-! ## The gateway is not an authority -/

/-- **Importing accepts nothing.**  A theorem pulled from the HTTP API is
a candidate: with no verification results held, no policy accepts
anything about it. -/
theorem imported_not_accepted (P : Policy) (tid envCid sid : Cid) (e : Env) (s : Sub) :
    acceptsB P tid envCid sid e s [] = false := by
  simp only [acceptsB, endorsingVerifiers, endorsements, List.filter_nil, List.map_nil,
    List.dedup_nil, List.length_nil, Bool.and_eq_false_iff, decide_eq_false_iff_not,
    Nat.not_lt, Nat.le_zero]
  omega

/-- **A server result counts only if the peer trusts the server.**  When
the gateway's key is not in the peer's trusted set, everything it
exports is inert — exactly as for any other peer. -/
theorem gateway_results_need_trust {P : Policy} {tid envCid sid : Cid} {e : Env} {s : Sub}
    {rs gatewayResults : List VResult}
    (huntrusted : ∀ r ∈ gatewayResults, r.verifier ∉ P.trustedVerifiers) :
    acceptsB P tid envCid sid e s (rs ++ gatewayResults)
      = acceptsB P tid envCid sid e s rs :=
  untrusted_ignored (fun r hr => Or.inr (huntrusted r hr))

end Kant.Prove2me
