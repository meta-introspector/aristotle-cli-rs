import RequestProject.MCP.Client

/-!
# Behavioural specifications of the Aristotle Rust-client model

This file states and proves the behavioural specifications of the model in
`RequestProject/MCP/Client.lean`, which mirrors the pure decision logic of the
Aristotle Rust HTTP client.
-/

open Lean (Json)

namespace AristotleClient

/-! ## Constants -/

theorem apiVersion_eq : apiVersion = "3" := rfl

theorem baseUrl_eq : baseUrl = "https://aristotle.harmonic.fun/api/v3" := rfl

theorem defaultTimeoutSeconds_eq : defaultTimeoutSeconds = 30 := rfl

/-- The `base_url()` method and the `BASE_URL` constant agree. -/
theorem clientBaseUrl_eq_baseUrl : clientBaseUrl = baseUrl := rfl

/-! ## `AristotleError::status_code` -/

@[simp] theorem statusCode_api (m : String) (sc : Option Nat) :
    (AristotleError.api m sc).statusCode = sc := rfl

@[simp] theorem statusCode_request (m : String) :
    (AristotleError.request m).statusCode = none := rfl

@[simp] theorem statusCode_config (m : String) :
    (AristotleError.config m).statusCode = none := rfl

@[simp] theorem statusCode_other (m : String) :
    (AristotleError.other m).statusCode = none := rfl

/-- Only `Api` errors ever carry a status code. -/
theorem statusCode_isSome_iff (e : AristotleError) :
    e.statusCode.isSome ↔ ∃ m sc, e = .api m (some sc) := by
  cases e with
  | api m sc => cases sc <;> simp [AristotleError.statusCode]
  | request m => simp [AristotleError.statusCode]
  | config m => simp [AristotleError.statusCode]
  | other m => simp [AristotleError.statusCode]

/-! ## `get_api_key` / `set_api_key` -/

/-- The in-memory stored key takes priority over the environment variable. -/
theorem getApiKey_stored (k : String) (env : Option String) :
    getApiKey (some k) env = .ok k := rfl

/-- With no stored key, the environment variable is used. -/
theorem getApiKey_env (v : String) :
    getApiKey none (some v) = .ok v := rfl

/-- With neither source set, a `Config` error is returned. -/
theorem getApiKey_none :
    getApiKey none none = .error (.config noApiKeyMessage) := rfl

/-- `get_api_key` succeeds iff at least one source provides a key. -/
theorem getApiKey_isOk_iff (stored env : Option String) :
    (getApiKey stored env).toOption.isSome ↔ (stored.isSome ∨ env.isSome) := by
  cases stored <;> cases env <;>
    simp [getApiKey, Except.toOption, Option.isSome]

/-- `set_api_key` echoes its argument. -/
theorem setApiKey_eq (k : String) : setApiKey k = k := rfl

/-! ## URL construction -/

theorem trimLeadingSlashes_noSlash :
    trimLeadingSlashes "foo/bar" = "foo/bar" := by native_decide

theorem trimLeadingSlashes_oneSlash :
    trimLeadingSlashes "/foo" = "foo" := by native_decide

theorem trimLeadingSlashes_manySlashes :
    trimLeadingSlashes "///foo" = "foo" := by native_decide

theorem trimLeadingSlashes_empty :
    trimLeadingSlashes "" = "" := by native_decide

/-- Leading slashes never affect the trimmed result: trimming is idempotent. -/
theorem trimLeadingSlashes_idem (s : String) :
    trimLeadingSlashes (trimLeadingSlashes s) = trimLeadingSlashes s := by
  unfold trimLeadingSlashes
  rw [String.toList_ofList]
  congr 1
  induction s.toList with
  | nil => simp
  | cons a t ih =>
    by_cases h : (a = '/')
    · simp [List.dropWhile, h, ih]
    · simp [List.dropWhile, h]

/-- A representative end-to-end URL with a leading slash. -/
theorem url_leadingSlash :
    url "/projects" = "https://aristotle.harmonic.fun/api/v3/projects" := by native_decide

/-- The same endpoint without a leading slash produces the same URL. -/
theorem url_noLeadingSlash :
    url "projects" = "https://aristotle.harmonic.fun/api/v3/projects" := by native_decide

/-- Endpoints differing only by leading slashes map to the same URL. -/
theorem url_eq_of_trim_eq (a b : String)
    (h : trimLeadingSlashes a = trimLeadingSlashes b) : url a = url b := by
  unfold url; rw [h]

/-! ## `extractErrorMessage` -/

/-- A `detail` string field is used directly. -/
theorem extractErrorMessage_detail :
    extractErrorMessage (some (Json.mkObj [("detail", Json.str "boom")])) "S" = "boom" := by
  native_decide

/-- With no `detail`, the `message` field is used. -/
theorem extractErrorMessage_message :
    extractErrorMessage (some (Json.mkObj [("message", Json.str "oops")])) "S" = "oops" := by
  native_decide

/-- `detail` is preferred over `message` when both are present. -/
theorem extractErrorMessage_detail_over_message :
    extractErrorMessage
      (some (Json.mkObj [("detail", Json.str "d"), ("message", Json.str "m")])) "S" = "d" := by
  native_decide

/-- An empty JSON object (neither field) yields `"Unknown error"`. -/
theorem extractErrorMessage_unknown :
    extractErrorMessage (some (Json.mkObj [])) "S" = "Unknown error" := by
  native_decide

/-- A non-JSON body (`none`) falls back to the raw status string. -/
theorem extractErrorMessage_noBody (statusStr : String) :
    extractErrorMessage none statusStr = statusStr := rfl

/-! ## `handle_response` -/

/-- On success the parsed body is returned unchanged. -/
theorem handleResponse_success (sc : Nat) (s : String) (j : Json) :
    handleResponse true sc s (some j) = .ok j := rfl

/-- A `429` status yields the fixed rate-limit message, regardless of body. -/
theorem handleResponse_429 (s : String) (body : Option Json) :
    handleResponse false 429 s body = .error (.api tooManyRequestsMessage (some 429)) := rfl

/-- A non-`429` failure formats the status code and extracted message, and the
returned error carries that status code. -/
theorem handleResponse_other_statusCode (sc : Nat) (s : String) (body : Option Json)
    (h : sc ≠ 429) :
    ∃ m, handleResponse false sc s body = .error (.api m (some sc)) := by
  refine ⟨s!"API request failed with status {sc}: {extractErrorMessage body s}", ?_⟩
  unfold handleResponse
  simp [h]

/-- A failure response always produces an `Api` error carrying the HTTP status
code (so callers can recover it via `status_code()`). -/
theorem handleResponse_failure_statusCode (sc : Nat) (s : String) (body : Option Json) :
    ∃ m, handleResponse false sc s body = .error (.api m (some sc)) := by
  by_cases h : sc = 429
  · subst h
    exact ⟨tooManyRequestsMessage, handleResponse_429 s body⟩
  · exact handleResponse_other_statusCode sc s body h

/-- Concrete `404` example. -/
theorem handleResponse_404 :
    handleResponse false 404 "404 Not Found" (some (Json.mkObj [("detail", Json.str "nope")]))
      = .error (.api "API request failed with status 404: nope" (some 404)) := by
  rfl

end AristotleClient
