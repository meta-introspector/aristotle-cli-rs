import Lean.Data.Json

/-!
# A descriptive-logic model of the Aristotle Rust HTTP client

This file gives a faithful Lean 4 model of the *pure decision logic* of the
Aristotle Rust client (`AristotleClient`). The original Rust code performs real
HTTP requests via `reqwest`; those effectful pieces are inherently outside the
verified boundary (they are I/O against a remote server). What *is* pure — and
hence what we model and verify here — is:

* the API constants (`API_VERSION`, `BASE_URL`, `DEFAULT_TIMEOUT_SECONDS`);
* the error type (`AristotleError`) and its `status_code()` accessor;
* API-key resolution (`get_api_key` / `set_api_key`);
* URL construction (`AristotleClient::base_url` / `AristotleClient::url`), which
  trims leading slashes from the endpoint;
* HTTP response handling (`AristotleClient::handle_response`), including the
  `detail`/`message` error-body extraction and the special `429` message.

The companion file `RequestProject/MCP/ClientSpec.lean` states and proves the
behavioural specifications of this model.

Following the project's "Approach 1" philosophy (see `docs/MCP_ARCHITECTURE.md`),
the model is total and FFI-free: the I/O wrapper would call into these verified
functions, so the trust boundary is just the JSON/HTTP transport.
-/

open Lean (Json)

namespace AristotleClient

/-! ## Constants -/

/-- `API_VERSION` (the `v3` API). -/
def apiVersion : String := "3"

/-- `BASE_URL = "https://aristotle.harmonic.fun/api/v" ++ API_VERSION`. -/
def baseUrl : String := "https://aristotle.harmonic.fun/api/v" ++ apiVersion

/-- `DEFAULT_TIMEOUT_SECONDS`. -/
def defaultTimeoutSeconds : Nat := 30

/-! ## The error type (`AristotleError`) -/

/-- Model of the Rust `AristotleError` enum.

The `request`/`other` cases wrap library errors (`reqwest::Error` /
`anyhow::Error`); we model their externally observable payload as a message
string. The `api` case additionally carries an optional HTTP status code. -/
inductive AristotleError
  /-- `Api { message, status_code }`. -/
  | api (message : String) (statusCode : Option Nat)
  /-- `Request(reqwest::Error)`. -/
  | request (message : String)
  /-- `Config(String)`. -/
  | config (message : String)
  /-- `Other(anyhow::Error)`. -/
  | other (message : String)
  deriving DecidableEq, Repr

/-- Model of `AristotleError::status_code`: only `Api` errors carry a code. -/
def AristotleError.statusCode : AristotleError → Option Nat
  | .api _ sc => sc
  | .request _ => none
  | .config _ => none
  | .other _ => none

/-- The error message shown when no API key is configured. -/
def noApiKeyMessage : String :=
  "API key has not been set. Call set_api_key() or set the ARISTOTLE_API_KEY environment variable."

/-! ## API key resolution (`get_api_key` / `set_api_key`) -/

/-- Model of `get_api_key`.

The Rust code first checks the in-memory `API_KEY` (`stored`); if unset it falls
back to the `ARISTOTLE_API_KEY` environment variable (`envVar`); if both are
absent it returns a `Config` error. -/
def getApiKey (stored : Option String) (envVar : Option String) :
    Except AristotleError String :=
  match stored with
  | some k => .ok k
  | none =>
    match envVar with
    | some v => .ok v
    | none => .error (.config noApiKeyMessage)

/-- Model of `set_api_key`: it stores the key and echoes it back. The stateful
write to `API_KEY` is the effect; the pure return value is the key itself. -/
def setApiKey (apiKey : String) : String := apiKey

/-! ## URL construction (`base_url` / `url`) -/

/-- Drop all leading `'/'` characters, modelling `str::trim_start_matches('/')`. -/
def trimLeadingSlashes (s : String) : String :=
  String.ofList (s.toList.dropWhile (· = '/'))

/-- Model of `AristotleClient::base_url`: `format!("https://aristotle.harmonic.fun/api/v{}", API_VERSION)`. -/
def clientBaseUrl : String := "https://aristotle.harmonic.fun/api/v" ++ apiVersion

/-- Model of `AristotleClient::url`: trim leading slashes from the endpoint and
join it to the base URL with a single `/`. -/
def url (endpoint : String) : String :=
  clientBaseUrl ++ "/" ++ trimLeadingSlashes endpoint

/-! ## Response handling (`handle_response`) -/

/-- Extract the error message from a (possibly absent) JSON response body,
modelling the body-parsing branch of `handle_response`.

If the body parsed as JSON (`some j`), take the `detail` field if present, else
the `message` field, then read it as a string, defaulting to `"Unknown error"`.
If the body did not parse as JSON (`none`), use the raw status string. -/
def extractErrorMessage (body : Option Json) (statusStr : String) : String :=
  match body with
  | none => statusStr
  | some j =>
    let field := (j.getObjVal? "detail").toOption.orElse
      (fun _ => (j.getObjVal? "message").toOption)
    (field.bind (·.getStr?.toOption)).getD "Unknown error"

/-- The fixed message returned for HTTP `429 Too Many Requests`. -/
def tooManyRequestsMessage : String :=
  "You have too many requests in progress. Please cancel or wait for a project to complete before starting a new one."

/-- Model of `AristotleClient::handle_response`.

* `isSuccess` is `status.is_success()`; on success the parsed JSON body is
  returned (the `?` after `resp.json()` is modelled by requiring `some` here,
  with a `Request` error otherwise).
* On failure, status `429` yields the fixed rate-limit message, and any other
  status yields `"API request failed with status {code}: {message}"`, where the
  message is extracted by `extractErrorMessage`. -/
def handleResponse (isSuccess : Bool) (statusCode : Nat) (statusStr : String)
    (body : Option Json) : Except AristotleError Json :=
  if isSuccess then
    match body with
    | some j => .ok j
    | none => .error (.request "failed to decode JSON response body")
  else
    let errMsg := extractErrorMessage body statusStr
    if statusCode = 429 then
      .error (.api tooManyRequestsMessage (some 429))
    else
      .error (.api s!"API request failed with status {statusCode}: {errMsg}"
        (some statusCode))

end AristotleClient
