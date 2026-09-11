import RequestProject.MCP.Core

/-!
# Behavioural specifications of the Aristotle MCP server model

This file states and proves the behavioural specifications of the model in
`RequestProject/MCP/Core.lean`. The properties mirror the behaviour documented
in `README.md`, `CLAUDE.md` ("Mock Mode Behavior") and `docs/USER_STORIES.md`,
and verified by the project's Python test-suite (`tests/`).
-/

namespace AristotleMCP

/-! ## `_map_api_status` (cf. `tests/test_helpers.py::TestMapApiStatus`) -/

@[simp] theorem mapApiStatus_complete (pct : Option Nat) :
    mapApiStatus "COMPLETE" pct = (.complete, "Proof completed") := by
  rfl

@[simp] theorem mapApiStatus_queued (pct : Option Nat) :
    mapApiStatus "QUEUED" pct = (.queued, "Proof is queued, waiting to start") := by
  rfl

/-- `NOT_STARTED` is mapped to the same client status as `QUEUED`. -/
theorem mapApiStatus_notStarted (pct : Option Nat) :
    mapApiStatus "NOT_STARTED" pct = (.queued, "Proof is queued, waiting to start") := by
  rfl

/-- `IN_PROGRESS` reports the percentage in its message. -/
theorem mapApiStatus_inProgress :
    mapApiStatus "IN_PROGRESS" (some 42)
      = (.inProgress, "Proof is being computed (42% complete)") := by
  rfl

/-- A missing percentage is reported as `0%` (`percent_complete or 0`). -/
theorem mapApiStatus_inProgress_none :
    mapApiStatus "IN_PROGRESS" none
      = (.inProgress, "Proof is being computed (0% complete)") := by
  rfl

theorem mapApiStatus_pendingRetry (pct : Option Nat) :
    mapApiStatus "PENDING_RETRY" pct = (.inProgress, "Proof is pending retry") := by
  rfl

theorem mapApiStatus_failed (pct : Option Nat) :
    mapApiStatus "FAILED" pct = (.failed, "Proof failed") := by
  rfl

/-- Any unrecognised status defaults to `in_progress`, echoing the raw status. -/
theorem mapApiStatus_unknown :
    mapApiStatus "UNKNOWN_STATUS" (some 25) = (.inProgress, "Status: UNKNOWN_STATUS") := by
  rfl

/-- The mapped status is `complete` exactly when the API status is `COMPLETE`. -/
theorem mapApiStatus_complete_iff (pct : Option Nat) (s : String) :
    (mapApiStatus s pct).1 = MappedStatus.complete ↔ s = "COMPLETE" := by
  unfold mapApiStatus
  split_ifs <;> simp_all

/-! ## `mock_prove` outcomes (cf. `tests/test_mock.py`, `tests/test_edge_cases.py`) -/

theorem mockProve_false_theorem :
    mockProveOutcome "theorem false_theorem : 1 = 2 := by sorry" = .counterexample := by
  native_decide

theorem mockProve_bad_lemma :
    mockProveOutcome "theorem bad_lemma : foo := by sorry" = .counterexample := by
  native_decide

theorem mockProve_timeout :
    mockProveOutcome "theorem timeout_test : x := by sorry" = .failed := by
  native_decide

theorem mockProve_hard :
    mockProveOutcome "theorem hard_theorem : 1 = 1 := by sorry" = .failed := by
  native_decide

theorem mockProve_simple :
    mockProveOutcome "theorem one_plus_one : 1 + 1 = 2 := by sorry" = .proved := by
  native_decide

/-- The keyword matching is case-insensitive (`code.lower()`). -/
theorem mockProve_case_insensitive :
    mockProveOutcome "theorem FALSE_THEOREM : 1 = 2 := by sorry" = .counterexample := by
  native_decide

/-- Counterexample detection takes priority over failure detection. -/
theorem mockProve_counterexample_priority :
    mockProveOutcome "hard false_theorem" = .counterexample := by
  native_decide

/-! ## `mock_prove_file` outcomes -/

theorem mockFile_partial :
    mockFileOutcome "partial_test.lean" = .partialSuccess := by
  native_decide

theorem mockFile_fail :
    mockFileOutcome "fail_case.lean" = .failed := by
  native_decide

theorem mockFile_proved :
    mockFileOutcome "Arithmetic.lean" = .proved := by
  native_decide

/-- `partial` takes priority over `fail` in the path check. -/
theorem mockFile_partial_priority :
    mockFileOutcome "partial_fail.lean" = .partialSuccess := by
  native_decide

/-! ## Mock async polling state machine -/

theorem mockPoll_first : mockPoll 1 = (PollPhase.queued, 0) := by
  rfl

theorem mockPoll_second : mockPoll 2 = (PollPhase.inProgress, 50) := by
  rfl

/-- From the third poll onward, the job is reported complete at 100%. -/
theorem mockPoll_final (n : Nat) (h : 3 ≤ n) : mockPoll n = (PollPhase.final, 100) := by
  unfold mockPoll
  rw [if_neg (by omega), if_neg (by omega)]

/-- Once the polling reports `final`, the reported progress is exactly 100%. -/
theorem mockPoll_final_percent (n : Nat) (h : (mockPoll n).1 = PollPhase.final) :
    (mockPoll n).2 = 100 := by
  unfold mockPoll at h ⊢
  split_ifs at h ⊢ with h1 h2
  · simp_all

/-- The reported progress is always between 0% and 100%. -/
theorem mockPollPercent_le_100 (n : Nat) : mockPollPercent n ≤ 100 := by
  simp only [mockPollPercent, mockPoll]
  split_ifs <;> simp

/-- The reported progress never decreases as polling continues (poll counts
start at `1`). -/
theorem mockPollPercent_mono {a b : Nat} (ha : 1 ≤ a) (hab : a ≤ b) :
    mockPollPercent a ≤ mockPollPercent b := by
  simp only [mockPollPercent, mockPoll]
  split_ifs <;> omega

/-! ## Environment detection (`is_mock_mode`, `has_api_key`) -/

theorem isMockValue_true : isMockValue "true" = true := by native_decide
theorem isMockValue_one : isMockValue "1" = true := by native_decide
theorem isMockValue_yes : isMockValue "yes" = true := by native_decide
theorem isMockValue_upper : isMockValue "TRUE" = true := by native_decide
theorem isMockValue_false : isMockValue "false" = false := by native_decide
theorem isMockValue_empty : isMockValue "" = false := by native_decide

theorem hasApiKey_empty : hasApiKeyValue "" = false := by native_decide
theorem hasApiKey_nonempty : hasApiKeyValue "sk-123" = true := by native_decide

/-! ## Server readiness and status messages (`server.get_status`) -/

/-- The server is ready iff mock mode is on or an API key is configured. -/
theorem serverReady_iff (m a : Bool) :
    serverReady m a = true ↔ (m = true ∨ a = true) := by
  simp [serverReady]

/-- A configured API key alone makes the server ready. -/
theorem serverReady_of_apiKey (m : Bool) : serverReady m true = true := by
  simp [serverReady]

/-- Mock mode alone makes the server ready. -/
theorem serverReady_of_mock (a : Bool) : serverReady true a = true := by
  simp [serverReady]

/-- With neither mock mode nor an API key, the server reports "not configured". -/
theorem statusMessage_notConfigured :
    serverStatusMessage false false = .notConfigured := by
  rfl

/-- Mock mode takes precedence over the "ready" message even with an API key. -/
theorem statusMessage_mock (a : Bool) :
    serverStatusMessage true a = .mockMode := by
  rfl

/-- With an API key but no mock mode, the server reports "ready". -/
theorem statusMessage_ready :
    serverStatusMessage false true = .ready := by
  rfl

/-- The "not configured" message appears exactly when the server is not ready. -/
theorem statusMessage_notConfigured_iff (m a : Bool) :
    serverStatusMessage m a = .notConfigured ↔ serverReady m a = false := by
  cases m <;> cases a <;> simp [serverStatusMessage, serverReady]

/-! ## Unique-path generation (`_find_unique_path`) -/

/-- If the base path does not exist, `_find_unique_path` returns it unchanged. -/
theorem findUnique_base (exists? : String → Bool) (stem ext : String) (n : Nat)
    (h : exists? (stem ++ ext) = false) :
    findUniquePath exists? (uniqueCandidates stem ext n) = some (stem ++ ext) := by
  simp [findUniquePath, uniqueCandidates, h]

/-- Any path returned by `_find_unique_path` does not already exist. -/
theorem findUnique_not_exists (exists? : String → Bool) (cands : List String) (p : String)
    (h : findUniquePath exists? cands = some p) : exists? p = false := by
  have := List.find?_some h
  simpa using this

/-- Any returned path is one of the candidates that were tried. -/
theorem findUnique_mem (exists? : String → Bool) (cands : List String) (p : String)
    (h : findUniquePath exists? cands = some p) : p ∈ cands :=
  List.mem_of_find?_eq_some h

/-! ## Result serialization (`ProveResult.to_dict`) -/

/-- `status` and `message` are always present in the serialized dict. -/
theorem toDict_has_status (r : ProveResult) : "status" ∈ r.keys := by
  simp [ProveResult.keys, ProveResult.toDict]

theorem toDict_has_message (r : ProveResult) : "message" ∈ r.keys := by
  simp [ProveResult.keys, ProveResult.toDict]

/-- The `code` key appears in the dict iff `code` is not `None`. -/
theorem toDict_code_iff (r : ProveResult) : "code" ∈ r.keys ↔ r.code.isSome := by
  obtain ⟨s, code, cex, pid, pct, msg⟩ := r
  rcases code <;> rcases cex <;> rcases pid <;> rcases pct <;>
    simp [ProveResult.keys, ProveResult.toDict, optEntry]

/-- The `counterexample` key appears iff the field is present. -/
theorem toDict_counterexample_iff (r : ProveResult) :
    "counterexample" ∈ r.keys ↔ r.counterexample.isSome := by
  obtain ⟨s, code, cex, pid, pct, msg⟩ := r
  rcases code <;> rcases cex <;> rcases pid <;> rcases pct <;>
    simp [ProveResult.keys, ProveResult.toDict, optEntry]

/-- The `percent_complete` key appears iff the field is present. -/
theorem toDict_percent_iff (r : ProveResult) :
    "percent_complete" ∈ r.keys ↔ r.percentComplete.isSome := by
  obtain ⟨s, code, cex, pid, pct, msg⟩ := r
  rcases code <;> rcases cex <;> rcases pid <;> rcases pct <;>
    simp [ProveResult.keys, ProveResult.toDict, optEntry]

/-- A `None` field is omitted: a minimal result serializes to exactly two keys. -/
theorem toDict_minimal (status message : String) :
    (ProveResult.mk status none none none none message).keys = ["status", "message"] := by
  simp [ProveResult.keys, ProveResult.toDict, optEntry]

end AristotleMCP
