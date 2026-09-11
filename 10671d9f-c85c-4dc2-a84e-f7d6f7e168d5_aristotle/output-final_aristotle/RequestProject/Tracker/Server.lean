import RequestProject.Tracker.Bus

/-!
# The local HTTP surface (`server.ts`)

The development server binds to loopback, rejects any request whose `Host` (or,
when present, `Origin`) is not local, accepts JSON bodies up to 64 KiB, and
exposes a handful of read endpoints plus three state-changing ones: manual
injection, the live-monitoring switch and the settings patch.

The model below is a pure transition `handle : now → Server → Request →
Server × Status`.  What is proved is the safety envelope of that surface:

* a non-local request is answered `403` and can change nothing;
* every response other than `200` leaves the server state exactly as it was —
  so no rejected or malformed request has a side effect;
* whatever validation the accepted requests claim really holds of them
  (text length, handle shape, poll interval bounds);
* live monitoring cannot be switched on with an empty watchlist;
* the SSE endpoint is read-only and replays exactly the retained frames newer
  than the client's cursor.
-/

namespace Tracker

/-- The HTTP verbs the server distinguishes. -/
inductive Method
  | get | post | other
  deriving DecidableEq, Repr, Inhabited

/-- A parsed `Origin` header. -/
structure Origin where
  scheme : String
  hostname : String
  port : Nat
  deriving DecidableEq, Repr, Inhabited

/-- The settings patch accepted by `POST /api/tracker/settings`. -/
structure SettingsPatch where
  poll : Option Bool := none
  push : Option Bool := none
  skipRetweets : Option Bool := none
  skipReplies : Option Bool := none
  pollMs : Option Nat := none
  deriving DecidableEq, Repr, Inhabited

/-- The parsed JSON bodies the state-changing endpoints understand. -/
inductive Body
  | inject (text : String) (handle : Option String)
  | run (start : Bool)
  | settings (patch : SettingsPatch)
  | empty
  deriving DecidableEq, Repr, Inhabited

/-- An incoming request. -/
structure Request where
  method : Method
  path : String
  /-- The hostname taken from the `Host` header. -/
  host : String
  origin : Option Origin := none
  contentType : Option String := none
  body : Body := Body.empty
  bodyBytes : Nat := 0
  /-- `Last-Event-ID`, used to resume the SSE stream. -/
  lastEventId : Option Bus.Cursor := none
  deriving DecidableEq, Repr, Inhabited

/-- Live tracker settings. -/
structure Settings where
  poll : Bool := true
  push : Bool := true
  pollMs : Nat := 2000
  skipRetweets : Bool := false
  skipReplies : Bool := false
  deriving DecidableEq, Repr, Inhabited

/-- The server: the tracker state, the settings, the bus, the port it is bound
to and whether live monitoring is running. -/
structure Server where
  tracker : State
  settings : Settings := {}
  bus : Bus
  port : Nat := 3313
  running : Bool := false
  deriving Repr, Inhabited

/-! ## The local-only guard -/

/-- The host names the server treats as local. -/
def localHosts : List String := ["127.0.0.1", "localhost", "[::1]"]

/-- `localRequest`: a local `Host`, and — when the browser sent one — an
`Origin` on the same loopback host and port over http(s). -/
def localRequest (port : Nat) (req : Request) : Bool :=
  localHosts.contains req.host &&
    (match req.origin with
     | none => true
     | some o => (o.scheme == "http" || o.scheme == "https") && localHosts.contains o.hostname &&
        o.port == port)

/-! ## Body validation -/

def isWordChar (c : Char) : Bool := c.isAlphanum || c == '_'

/-- `/^@?\w{1,15}$/` without the optional at-sign: the handle shape the server
accepts. -/
def validHandle (h : String) : Bool :=
  0 < h.length && h.length ≤ 15 && h.all isWordChar

/-- Does the body contain anything other than whitespace (`!b.text.trim()`)? -/
def hasVisibleText (text : String) : Bool := text.any (fun c => !c.isWhitespace)

/-- `text` must contain 1–30000 non-blank characters, and the optional handle
must be a Twitter handle. -/
def validInject (text : String) (handle : Option String) : Bool :=
  hasVisibleText text && text.length ≤ 30000 &&
    (match handle with
     | none => true
     | some h => validHandle h)

/-- `pollMs` must be 700–3600000. -/
def validPollMs (v : Nat) : Bool := 700 ≤ v && v ≤ 3600000

def validPatch (p : SettingsPatch) : Bool :=
  match p.pollMs with
  | none => true
  | some v => validPollMs v

def applyPatch (s : Settings) (p : SettingsPatch) : Settings where
  poll := p.poll.getD s.poll
  push := p.push.getD s.push
  pollMs := p.pollMs.getD s.pollMs
  skipRetweets := p.skipRetweets.getD s.skipRetweets
  skipReplies := p.skipReplies.getD s.skipReplies

/-- `Content-Type: application/json` (the server requires it on every POST). -/
def isJson (req : Request) : Bool :=
  match req.contentType with
  | none => false
  | some ct => ct == "application/json"

/-- Accounts that live monitoring can actually watch. -/
def activeAccounts (s : State) : List Watched := s.watch.filter (fun w => !w.muted)

/-! ## Manual injection -/

/-- `inject`: a locally generated card, published unconditionally.  Its
`createdAt` is now, so it reports a zero latency and is honest about it. -/
def manualPost (now : Nat) (id text handle : String) : Tweet where
  id := id
  author := { handle := handle, name := handle }
  body := text
  kind := TweetKind.tweet
  createdAt := now
  seenAt := now
  detectMs := 0
  source := IngestSource.manual

theorem manualPost_timedAt (now : Nat) (id text handle : String) :
    (manualPost now id text handle).timedAt now := by
  simp [Tweet.timedAt, manualPost]

/-- Publishing a manual card: onto the wire and into the bounded recent ring.
It deliberately does not touch the dedupe set, so a post can be re-pulled while
tuning without disturbing the live detector's view. -/
def injectManual (now : Nat) (srv : Server) (id text handle : String) : Server :=
  let t := manualPost now id text handle
  { srv with
    tracker := { srv.tracker with
      log := srv.tracker.log ++ [Event.tweet t]
      recent := pushBounded srv.tracker.cfg.recentMax srv.tracker.recent t }
    bus := srv.bus.publish (Event.tweet t) }

/-! ## The router -/

/-- HTTP status codes the model distinguishes. -/
abbrev Status := Nat

/-- The read endpoints. -/
def routeGet (srv : Server) (req : Request) : Server × Status :=
  if req.path ∈ (["/api/health", "/", "/api/tracker/state", "/api/tracker/accounts",
      "/api/tracker/stream"] : List String) then (srv, 200) else (srv, 404)

/-- The three state-changing endpoints, after the JSON and size guards. -/
def routePost (now : Nat) (srv : Server) (req : Request) (freshId : String) :
    Server × Status :=
  match req.path, req.body with
  | "/api/tracker/inject", Body.inject text h =>
    if validInject text h then (injectManual now srv freshId text (h.getD "manual"), 200)
    else (srv, 400)
  | "/api/tracker/run", Body.run start =>
    if start = true ∧ activeAccounts srv.tracker = [] then (srv, 400)
    else ({ srv with running := start }, 200)
  | "/api/tracker/settings", Body.settings patch =>
    if validPatch patch then ({ srv with settings := applyPatch srv.settings patch }, 200)
    else (srv, 400)
  | _, _ => (srv, 404)

/-- `handle`: the whole request path, from the loopback guard to the handlers. -/
def handle (now : Nat) (srv : Server) (req : Request) (freshId : String) : Server × Status :=
  if localRequest srv.port req = false then (srv, 403)
  else if req.method = Method.get then routeGet srv req
  else if req.method = Method.other then (srv, 404)
  else if isJson req = false then (srv, 415)
  else if 65536 < req.bodyBytes then (srv, 413)
  else routePost now srv req freshId

/-! ## The safety envelope -/

@[simp] theorem routeGet_fst (srv : Server) (req : Request) : (routeGet srv req).1 = srv := by
  unfold routeGet; split <;> rfl

/-- A non-local request is refused. -/
theorem handle_not_local {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (h : localRequest srv.port req = false) :
    handle now srv req freshId = (srv, 403) := by
  simp [handle, h]

/-- Only a local request can get anything other than a `403`. -/
theorem local_of_ne_403 {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (h : (handle now srv req freshId).2 ≠ 403) : localRequest srv.port req = true := by
  by_cases hl : localRequest srv.port req = false
  · exact absurd (by rw [handle_not_local hl]) h
  · simpa using hl

/-- Either the handler left the state alone, or it answered `200`. -/
theorem routePost_cases (now : Nat) (srv : Server) (req : Request) (freshId : String) :
    (routePost now srv req freshId).1 = srv ∨ (routePost now srv req freshId).2 = 200 := by
  unfold routePost
  split
  · split_ifs
    · exact Or.inr rfl
    · exact Or.inl rfl
  · split_ifs
    · exact Or.inl rfl
    · exact Or.inr rfl
  · split_ifs
    · exact Or.inr rfl
    · exact Or.inl rfl
  · exact Or.inl rfl

theorem routePost_unchanged_of_ne_200 {now : Nat} {srv : Server} {req : Request}
    {freshId : String} (h : (routePost now srv req freshId).2 ≠ 200) :
    (routePost now srv req freshId).1 = srv :=
  (routePost_cases now srv req freshId).resolve_right h

theorem handle_cases (now : Nat) (srv : Server) (req : Request) (freshId : String) :
    (handle now srv req freshId).1 = srv ∨ (handle now srv req freshId).2 = 200 := by
  unfold handle
  split_ifs <;>
    first
      | exact Or.inl rfl
      | exact Or.inl (routeGet_fst srv req)
      | exact routePost_cases now srv req freshId

/-- **Nothing but a `200` has a side effect.**  Every refused, malformed or
unknown request leaves the server exactly as it was. -/
theorem handle_unchanged_of_ne_200 {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (h : (handle now srv req freshId).2 ≠ 200) : (handle now srv req freshId).1 = srv :=
  (handle_cases now srv req freshId).resolve_right h

/-- A read endpoint never changes anything. -/
theorem handle_get_readonly {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (h : req.method = Method.get) : (handle now srv req freshId).1 = srv := by
  unfold handle
  split_ifs with h1 <;> simp_all

/-- The POST guards really are guards: a non-JSON body is refused with `415`
and an oversized body with `413`, neither of them reaching a handler. -/
theorem post_requires_json {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (hlocal : localRequest srv.port req = true) (hpost : req.method = Method.post)
    (hjson : isJson req = false) : handle now srv req freshId = (srv, 415) := by
  simp [handle, hlocal, hpost, hjson]

theorem post_size_limit {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (hlocal : localRequest srv.port req = true) (hpost : req.method = Method.post)
    (hjson : isJson req = true) (hsize : 65536 < req.bodyBytes) :
    handle now srv req freshId = (srv, 413) := by
  simp [handle, hlocal, hpost, hjson, hsize]

/-- Reaching a handler at all means the request was local, a POST, JSON and
within the size limit. -/
theorem routePost_of_handle {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (hlocal : localRequest srv.port req = true) (hpost : req.method = Method.post)
    (hjson : isJson req = true) (hsize : ¬ 65536 < req.bodyBytes) :
    handle now srv req freshId = routePost now srv req freshId := by
  simp [handle, hlocal, hpost, hjson, hsize]

/-- An accepted injection really did satisfy the documented input contract. -/
theorem inject_valid_of_accepted {now : Nat} {srv : Server} {req : Request} {freshId : String}
    {text : String} {h? : Option String} (hpath : req.path = "/api/tracker/inject")
    (hbody : req.body = Body.inject text h?)
    (hstatus : (routePost now srv req freshId).2 = 200) : validInject text h? = true := by
  unfold routePost at hstatus
  rw [hpath, hbody] at hstatus
  by_cases hv : validInject text h? = true
  · exact hv
  · simp [hv] at hstatus

/-- An accepted settings patch respects the poll-interval bounds. -/
theorem pollMs_bounds_of_accepted {now : Nat} {srv : Server} {req : Request} {freshId : String}
    {patch : SettingsPatch} {v : Nat} (hpath : req.path = "/api/tracker/settings")
    (hbody : req.body = Body.settings patch) (hv : patch.pollMs = some v)
    (hstatus : (routePost now srv req freshId).2 = 200) : 700 ≤ v ∧ v ≤ 3600000 := by
  have hvalid : validPatch patch = true := by
    unfold routePost at hstatus
    rw [hpath, hbody] at hstatus
    by_cases hp : validPatch patch = true
    · exact hp
    · simp [hp] at hstatus
  rw [validPatch, hv] at hvalid
  simpa [validPollMs] using hvalid

/-- **Live monitoring cannot be started with an empty watchlist.** -/
theorem run_requires_accounts {now : Nat} {srv : Server} {req : Request} {freshId : String}
    (hpath : req.path = "/api/tracker/run") (hbody : req.body = Body.run true)
    (hempty : activeAccounts srv.tracker = []) :
    routePost now srv req freshId = (srv, 400) := by
  unfold routePost
  rw [hpath, hbody]
  simp [hempty]

/-- Starting or stopping live monitoring is the only thing the switch does. -/
theorem run_sets_flag {now : Nat} {srv : Server} {req : Request} {freshId : String}
    {start : Bool} (hpath : req.path = "/api/tracker/run") (hbody : req.body = Body.run start)
    (hok : ¬ (start = true ∧ activeAccounts srv.tracker = [])) :
    routePost now srv req freshId = ({ srv with running := start }, 200) := by
  unfold routePost
  rw [hpath, hbody]
  simp [hok]

/-! ## The SSE endpoint -/

/-- The frames a reconnecting client is replayed. -/
def streamReplay (srv : Server) (req : Request) : List Frame :=
  Bus.replay srv.bus req.lastEventId

/-- Resumption is honest: the client is replayed exactly the retained frames it
has not seen, in increasing sequence order. -/
theorem streamReplay_resumes {srv : Server} (hbus : srv.bus.Wf) (req : Request)
    {c : Bus.Cursor} (hc : req.lastEventId = some c) (hboot : c.bootId = srv.bus.bootId) :
    (∀ f ∈ streamReplay srv req, c.seq < f.seq ∧ f ∈ srv.bus.ring) ∧
      (∀ f ∈ srv.bus.ring, c.seq < f.seq → f ∈ streamReplay srv req) ∧
      (streamReplay srv req).Pairwise (fun f g => f.seq < g.seq) := by
  refine ⟨?_, ?_, ?_⟩
  · intro f hf
    rw [streamReplay, hc] at hf
    exact ⟨Bus.replay_newer hboot hf, Bus.replay_subset hf⟩
  · intro f hf hlt
    rw [streamReplay, hc]
    exact Bus.mem_replay_of_newer hboot hf hlt
  · rw [streamReplay]
    exact Bus.replay_ordered hbus _

end Tracker
