import Mathlib

/-!
# A descriptive-logic model of the Aristotle MCP server

This file gives a faithful Lean 4 model of the *core decision logic* of the
`aristotle-mcp` Python project (an MCP server wrapping Harmonic's Aristotle
theorem prover).

We model the pure, side-effect-free pieces of the implementation:

* the `aristotlelib` project status enum (`ProjectStatus`);
* the internal status returned to MCP clients (`MappedStatus`);
* `tools._map_api_status` — translating an API status to a client status/message;
* the mock prover's outcome decisions (`mock.mock_prove`, `mock.mock_prove_file`);
* the mock async polling state machine (`mock.mock_check_*`);
* environment detection (`tools.is_mock_mode`, `tools.has_api_key`);
* the server readiness / status-message logic (`server.get_status`);
* unique-path generation (`tools._find_unique_path`);
* result serialization (`models.*.to_dict`, which omits `None` fields).

The companion file `RequestProject/MCP/Spec.lean` states and proves the
behavioural specifications documented in `README.md`, `CLAUDE.md` and
`docs/USER_STORIES.md`.
-/

namespace AristotleMCP

/-! ## API project status (the `aristotlelib.ProjectStatus` enum) -/

/-- The status of a proof project, mirroring `aristotlelib.ProjectStatus`. -/
inductive ProjectStatus
  | notStarted
  | queued
  | inProgress
  | complete
  | failed
  | pendingRetry
  deriving DecidableEq, Repr

/-- The uppercase `status.name` string used by `tools.py` when mapping statuses. -/
def ProjectStatus.name : ProjectStatus → String
  | .notStarted  => "NOT_STARTED"
  | .queued      => "QUEUED"
  | .inProgress  => "IN_PROGRESS"
  | .complete    => "COMPLETE"
  | .failed      => "FAILED"
  | .pendingRetry => "PENDING_RETRY"

/-! ## Internal mapped status -/

/-- The client-facing status produced by `_map_api_status`. -/
inductive MappedStatus
  | complete
  | queued
  | inProgress
  | failed
  deriving DecidableEq, Repr

/-- Model of `tools._map_api_status(status_str, percent_complete)`.

Returns the client status together with the human-readable message, exactly
following the Python `if/elif` cascade. `pct` models `percent_complete or 0`. -/
def mapApiStatus (statusStr : String) (pct : Option Nat) : MappedStatus × String :=
  let p := pct.getD 0
  if statusStr = "COMPLETE" then
    (.complete, "Proof completed")
  else if statusStr = "QUEUED" ∨ statusStr = "NOT_STARTED" then
    (.queued, "Proof is queued, waiting to start")
  else if statusStr = "IN_PROGRESS" then
    (.inProgress, s!"Proof is being computed ({p}% complete)")
  else if statusStr = "PENDING_RETRY" then
    (.inProgress, "Proof is pending retry")
  else if statusStr = "FAILED" then
    (.failed, "Proof failed")
  else
    (.inProgress, s!"Status: {statusStr}")

/-! ## Mock prover outcomes -/

/-- Possible terminal outcomes of a (mock) `prove` call. -/
inductive ProveOutcome
  | proved
  | counterexample
  | failed
  deriving DecidableEq, Repr

/-- Model of the decision in `mock.mock_prove`.

Code mentioning `false_theorem`/`bad_lemma` yields a counterexample; code
mentioning `timeout`/`hard` fails; otherwise the proof succeeds. The check is
case-insensitive (`code.lower()`), and counterexamples take priority over
failures. -/
def mockProveOutcome (code : String) : ProveOutcome :=
  let c := code.toLower
  if c.containsSubstr "false_theorem" ∨ c.containsSubstr "bad_lemma" then
    .counterexample
  else if c.containsSubstr "timeout" ∨ c.containsSubstr "hard" then
    .failed
  else
    .proved

/-- Possible terminal outcomes of a (mock) `prove_file` call. -/
inductive FileOutcome
  | proved
  | partialSuccess
  | failed
  deriving DecidableEq, Repr

/-- Model of the decision in `mock.mock_prove_file`.

A path containing `partial` yields a partial success, one containing `fail`
fails, otherwise it succeeds. The check is case-insensitive on the file path,
and `partial` takes priority over `fail`. -/
def mockFileOutcome (filePath : String) : FileOutcome :=
  let p := filePath.toLower
  if p.containsSubstr "partial" then
    .partialSuccess
  else if p.containsSubstr "fail" then
    .failed
  else
    .proved

/-! ## Mock async polling state machine -/

/-- The phase reported by a mock polling step. -/
inductive PollPhase
  | queued
  | inProgress
  | final
  deriving DecidableEq, Repr

/-- Model of the mock async polling progression in `mock.mock_check_proof`,
`mock.mock_check_prove_file` and `mock.mock_check_formalize`.

`pollCount` is the value *after* the in-method increment, so the first poll
passes `1`. The progression is: `1 ↦ queued (0%)`, `2 ↦ in_progress (50%)`,
and every later poll ↦ `final (100%)`. -/
def mockPoll (pollCount : Nat) : PollPhase × Nat :=
  if pollCount = 1 then (.queued, 0)
  else if pollCount = 2 then (.inProgress, 50)
  else (.final, 100)

/-- The reported percentage of a mock poll step. -/
def mockPollPercent (pollCount : Nat) : Nat := (mockPoll pollCount).2

/-! ## Environment detection -/

/-- Model of `tools.is_mock_mode`: the `ARISTOTLE_MOCK` value enables mock mode
iff (case-insensitively) it is `"true"`, `"1"` or `"yes"`. -/
def isMockValue (v : String) : Bool :=
  let s := v.toLower
  s == "true" || s == "1" || s == "yes"

/-- Model of `tools.has_api_key`: `bool(os.environ.get("ARISTOTLE_API_KEY"))`,
i.e. a non-empty key string. -/
def hasApiKeyValue (v : String) : Bool := v != ""

/-! ## Server readiness and status message (`server.get_status`) -/

/-- Model of `ready = mock_mode or api_key_configured`. -/
def serverReady (mockMode apiKeyConfigured : Bool) : Bool :=
  mockMode || apiKeyConfigured

/-- The three possible status messages produced by `server.get_status`. -/
inductive StatusMessage
  | notConfigured
  | mockMode
  | ready
  deriving DecidableEq, Repr

/-- Model of the message branch in `server.get_status`:
not ready ↦ not configured; else mock mode ↦ mock mode; else ↦ ready. -/
def serverStatusMessage (mockMode apiKeyConfigured : Bool) : StatusMessage :=
  if !(serverReady mockMode apiKeyConfigured) then .notConfigured
  else if mockMode then .mockMode
  else .ready

/-! ## Unique path generation (`tools._find_unique_path`) -/

/-- Candidate paths tried by `_find_unique_path`: the original `base` first,
then `base` with `.1`, `.2`, … `.maxAttempts` inserted before the extension.
Here `stem`/`ext` model `os.path.splitext(path)`. -/
def uniqueCandidates (stem ext : String) (maxAttempts : Nat) : List String :=
  (stem ++ ext) :: (List.range maxAttempts).map (fun i => s!"{stem}.{i + 1}{ext}")

/-- Model of the search in `_find_unique_path`: pick the first candidate that
does not already exist, where `exists?` models the filesystem check. Returns
`none` if every candidate exists (the Python code then raises). -/
def findUniquePath (exists? : String → Bool) (cands : List String) : Option String :=
  cands.find? (fun c => ¬ exists? c)

/-! ## Result serialization (`models.*.to_dict`) -/

/-- A JSON-serializable result value, mirroring
`ResultValue = str | int | None`. `None` fields are simply omitted, so this
type only needs the present cases. -/
inductive ResultValue
  | str (s : String)
  | int (n : Nat)
  deriving DecidableEq, Repr

/-- Model of `models.ProveResult`. Optional fields use `Option`. -/
structure ProveResult where
  status : String
  code : Option String := none
  counterexample : Option String := none
  projectId : Option String := none
  percentComplete : Option Nat := none
  message : String := ""

/-- Append a key/value pair only when the optional payload is present
(`if x is not None`). -/
def optEntry (key : String) : Option ResultValue → List (String × ResultValue)
  | some v => [(key, v)]
  | none => []

/-- Model of `ProveResult.to_dict`. `status` and `message` are always present;
the remaining fields appear iff they are not `None`. -/
def ProveResult.toDict (r : ProveResult) : List (String × ResultValue) :=
  [("status", .str r.status), ("message", .str r.message)]
    ++ optEntry "code" (r.code.map .str)
    ++ optEntry "counterexample" (r.counterexample.map .str)
    ++ optEntry "project_id" (r.projectId.map .str)
    ++ optEntry "percent_complete" (r.percentComplete.map .int)

/-- The set of keys present in the serialized dict. -/
def ProveResult.keys (r : ProveResult) : List String := r.toDict.map Prod.fst

end AristotleMCP
