import RequestProject.MCP.Client

/-!
# Native code-generation / transpilation layer for the verified client model

This module projects the *verified* decision logic of `AristotleClient`
(see `RequestProject/MCP/Client.lean`) into native source code for several
target languages (Rust, C++, Python, JavaScript), so the exact constants and
algorithms proved correct in Lean can drive native runtimes.

## Design (honest trust boundary)

There is an irreducible gap between *a string of source code* and *its runtime
behaviour once compiled by a native toolchain* — Lean cannot run `rustc`, `g++`,
CPython, or Node. We therefore split the layer into three verifiable pieces,
following the project's "Approach 1" (zero-FFI) honesty:

1. **Constant faithfulness.** The generated templates do not hard-code their
   constants; they *interpolate the verified definitions* (`apiVersion`,
   `defaultTimeoutSeconds`, `clientBaseUrl`, `noApiKeyMessage`,
   `tooManyRequestsMessage`). `CodegenSpec.lean` proves each emitted template
   literally contains these verified values, so any change to the model
   propagates to all four languages and cannot silently diverge.

2. **Reference semantics.** For the one place where the native templates differ
   structurally from the model — URL joining, where the generated code also
   strips a *trailing* slash from the base URL (`trim_end_matches`/`rstrip`/…) —
   we give a Lean `nativeUrl` reference model and prove in `CodegenSpec.lean`
   that, applied to the verified base URL, it agrees with `AristotleClient.url`.
   This is the "1:1 behavioural equivalence" at the algorithmic level.

3. **The remaining boundary** — that the emitted text actually implements the
   reference semantics when compiled — is the documented, irreducible trust
   boundary (mirroring the existing Lean↔JS oracle boundary).

Everything here is total and dependency-free; the optional `IO` writers at the
end are the only effectful code and merely serialise the proven-faithful strings
to disk.
-/

namespace AristotleClient.Codegen

open AristotleClient

/-! ## Target languages -/

/-- The native targets we can transpile the verified logic to. -/
inductive TargetLang
  | rust
  | cpp
  | python
  | javascript
  deriving DecidableEq, Repr

/-- Short canonical name of a target (used in messages / paths). -/
def TargetLang.name : TargetLang → String
  | .rust => "rust"
  | .cpp => "cpp"
  | .python => "python"
  | .javascript => "javascript"

/-- Conventional source-file extension for a target. -/
def TargetLang.fileExtension : TargetLang → String
  | .rust => "rs"
  | .cpp => "hpp"
  | .python => "py"
  | .javascript => "js"

/-- Configuration for a single code-generation invocation. -/
structure CodegenConfig where
  target : TargetLang
  /-- Name used for the emitted module / namespace. -/
  moduleName : String
  deriving Repr

/-! ## String helpers (for the faithfulness specification) -/

/-- A decidable "contains substring" test used by `CodegenSpec.lean` to certify
that a generated template embeds a verified constant. `s.splitOn sub` produces
at least two pieces exactly when `sub` occurs in `s` (for non-empty `sub`). -/
def containsStr (s sub : String) : Bool := (s.splitOn sub).length ≥ 2

/-! ## Reference semantics for URL construction

The native templates emit `url(endpoint)` as
`format!("{}/{}", BASE_URL.trim_end_matches('/'), trim_leading_slashes(endpoint))`
(and the analogous `rstrip('/')` / `replace(/\/+$/,'')` / `erase` in the other
languages). The only structural difference from `AristotleClient.url` is the
extra *trailing*-slash strip on the base URL; we model that here and prove
equivalence on the verified base in `CodegenSpec.lean`. -/

/-- Drop all trailing `'/'` characters (models `str::trim_end_matches('/')`,
Python `rstrip('/')`, JS `replace(/\/+$/, '')`). -/
def stripTrailingSlashes (s : String) : String :=
  String.ofList ((s.toList.reverse.dropWhile (· = '/')).reverse)

/-- Reference semantics of the generated `url(base, endpoint)`: strip the
trailing slash from the base, the leading slashes from the endpoint, and join
with a single `/`. -/
def nativeUrl (base endpoint : String) : String :=
  stripTrailingSlashes base ++ "/" ++ trimLeadingSlashes endpoint

/-! ## Code templates

Each generator interpolates the verified constants rather than hard-coding them.
We build the strings with `++` (not interpolation) so that literal `{`/`}` in the
target syntax need no escaping. -/

/-- Generate a Rust source module implementing the verified logic. -/
def rustTemplate (moduleName : String) : String :=
  "// Auto-generated from the verified Lean model `AristotleClient`\n" ++
  "// (RequestProject/MCP/Client.lean). Module: " ++ moduleName ++ "\n" ++
  "// Constants/messages are emitted verbatim from the verified definitions;\n" ++
  "// RequestProject/MCP/CodegenSpec.lean proves they match the model.\n\n" ++
  "pub const API_VERSION: &str = \"" ++ apiVersion ++ "\";\n" ++
  "pub const DEFAULT_TIMEOUT_SECONDS: u64 = " ++ toString defaultTimeoutSeconds ++ ";\n" ++
  "pub const BASE_URL: &str = \"" ++ clientBaseUrl ++ "\";\n\n" ++
  "#[derive(Debug, Clone)]\n" ++
  "pub enum AristotleError {\n" ++
  "    Api { message: String, status_code: Option<u16> },\n" ++
  "    Request(String),\n" ++
  "    Config(String),\n" ++
  "    Other(String),\n" ++
  "}\n\n" ++
  "impl AristotleError {\n" ++
  "    pub fn status_code(&self) -> Option<u16> {\n" ++
  "        match self {\n" ++
  "            AristotleError::Api { status_code, .. } => *status_code,\n" ++
  "            _ => None,\n" ++
  "        }\n" ++
  "    }\n" ++
  "}\n\n" ++
  "pub const NO_API_KEY_MESSAGE: &str = \"" ++ noApiKeyMessage ++ "\";\n" ++
  "pub const TOO_MANY_REQUESTS_MESSAGE: &str = \"" ++ tooManyRequestsMessage ++ "\";\n\n" ++
  "pub fn trim_leading_slashes(endpoint: &str) -> &str {\n" ++
  "    endpoint.trim_start_matches('/')\n" ++
  "}\n\n" ++
  "pub fn url(endpoint: &str) -> String {\n" ++
  "    format!(\"{}/{}\", BASE_URL.trim_end_matches('/'), trim_leading_slashes(endpoint))\n" ++
  "}\n"

/-- Generate a C++ header implementing the verified logic. -/
def cppTemplate (moduleName : String) : String :=
  "// Auto-generated from the verified Lean model `AristotleClient`\n" ++
  "// (RequestProject/MCP/Client.lean). Namespace: " ++ moduleName ++ "\n" ++
  "#pragma once\n" ++
  "#include <string>\n" ++
  "#include <optional>\n" ++
  "#include <cstdint>\n" ++
  "#include <algorithm>\n\n" ++
  "namespace " ++ moduleName ++ " {\n\n" ++
  "inline const std::string API_VERSION = \"" ++ apiVersion ++ "\";\n" ++
  "inline constexpr uint64_t DEFAULT_TIMEOUT_SECONDS = " ++
    toString defaultTimeoutSeconds ++ ";\n" ++
  "inline const std::string BASE_URL = \"" ++ clientBaseUrl ++ "\";\n" ++
  "inline const std::string NO_API_KEY_MESSAGE = \"" ++ noApiKeyMessage ++ "\";\n" ++
  "inline const std::string TOO_MANY_REQUESTS_MESSAGE = \"" ++
    tooManyRequestsMessage ++ "\";\n\n" ++
  "enum class ErrorType { Api, Request, Config, Other };\n\n" ++
  "struct AristotleError {\n" ++
  "    ErrorType type;\n" ++
  "    std::optional<uint16_t> status_code;\n" ++
  "    std::string message;\n" ++
  "};\n\n" ++
  "inline std::string trim_leading_slashes(std::string endpoint) {\n" ++
  "    endpoint.erase(endpoint.begin(),\n" ++
  "        std::find_if(endpoint.begin(), endpoint.end(),\n" ++
  "            [](unsigned char ch) { return ch != '/'; }));\n" ++
  "    return endpoint;\n" ++
  "}\n\n" ++
  "inline std::string url(const std::string& endpoint) {\n" ++
  "    std::string base = BASE_URL;\n" ++
  "    while (!base.empty() && base.back() == '/') base.pop_back();\n" ++
  "    return base + \"/\" + trim_leading_slashes(endpoint);\n" ++
  "}\n\n" ++
  "} // namespace " ++ moduleName ++ "\n"

/-- Generate a Python module implementing the verified logic. -/
def pythonTemplate (moduleName : String) : String :=
  "# Auto-generated from the verified Lean model `AristotleClient`\n" ++
  "# (RequestProject/MCP/Client.lean). Module: " ++ moduleName ++ "\n" ++
  "from typing import Optional\n" ++
  "import re\n\n" ++
  "API_VERSION = \"" ++ apiVersion ++ "\"\n" ++
  "DEFAULT_TIMEOUT_SECONDS = " ++ toString defaultTimeoutSeconds ++ "\n" ++
  "BASE_URL = \"" ++ clientBaseUrl ++ "\"\n" ++
  "NO_API_KEY_MESSAGE = \"" ++ noApiKeyMessage ++ "\"\n" ++
  "TOO_MANY_REQUESTS_MESSAGE = \"" ++ tooManyRequestsMessage ++ "\"\n\n" ++
  "class AristotleError(Exception):\n" ++
  "    def __init__(self, error_type: str, message: str = \"\",\n" ++
  "                 status_code: Optional[int] = None):\n" ++
  "        self.error_type = error_type\n" ++
  "        self.message = message\n" ++
  "        self.status_code = status_code if error_type == \"api\" else None\n" ++
  "        super().__init__(message)\n\n" ++
  "def trim_leading_slashes(endpoint: str) -> str:\n" ++
  "    return re.sub(r'^/+', '', endpoint)\n\n" ++
  "def url(endpoint: str) -> str:\n" ++
  "    return f\"{BASE_URL.rstrip('/')}/{trim_leading_slashes(endpoint)}\"\n"

/-- Generate a JavaScript (ES module) implementing the verified logic. -/
def jsTemplate (moduleName : String) : String :=
  "// Auto-generated from the verified Lean model `AristotleClient`\n" ++
  "// (RequestProject/MCP/Client.lean). Module: " ++ moduleName ++ "\n" ++
  "export const API_VERSION = \"" ++ apiVersion ++ "\";\n" ++
  "export const DEFAULT_TIMEOUT_SECONDS = " ++ toString defaultTimeoutSeconds ++ ";\n" ++
  "export const BASE_URL = \"" ++ clientBaseUrl ++ "\";\n" ++
  "export const NO_API_KEY_MESSAGE = \"" ++ noApiKeyMessage ++ "\";\n" ++
  "export const TOO_MANY_REQUESTS_MESSAGE = \"" ++ tooManyRequestsMessage ++ "\";\n\n" ++
  "export class AristotleError extends Error {\n" ++
  "  constructor(errorType, message, statusCode) {\n" ++
  "    super(message);\n" ++
  "    this.errorType = errorType;\n" ++
  "    this.statusCode = errorType === \"api\" ? (statusCode ?? null) : null;\n" ++
  "  }\n" ++
  "}\n\n" ++
  "export function trimLeadingSlashes(endpoint) {\n" ++
  "  return endpoint.replace(/^\\/+/, \"\");\n" ++
  "}\n\n" ++
  "export function url(endpoint) {\n" ++
  "  return `${BASE_URL.replace(/\\/+$/, \"\")}/${trimLeadingSlashes(endpoint)}`;\n" ++
  "}\n"

/-- Dispatch to the generator for a configuration's target language. -/
def generate (cfg : CodegenConfig) : String :=
  match cfg.target with
  | .rust => rustTemplate cfg.moduleName
  | .cpp => cppTemplate cfg.moduleName
  | .python => pythonTemplate cfg.moduleName
  | .javascript => jsTemplate cfg.moduleName

/-- Suggested output file name for a configuration. -/
def fileName (cfg : CodegenConfig) : String :=
  cfg.moduleName ++ "." ++ cfg.target.fileExtension

/-- A default set of configurations covering all four targets. -/
def defaultConfigs : List CodegenConfig :=
  [ { target := .rust,       moduleName := "aristotle_client" },
    { target := .cpp,        moduleName := "aristotle_client" },
    { target := .python,     moduleName := "aristotle_client" },
    { target := .javascript, moduleName := "aristotle_client" } ]

/-! ## Optional IO writers

These are the only effectful definitions: they serialise the proven-faithful
strings produced above to disk. They contain no decision logic of their own. -/

/-- Write a single configuration's generated source to `dir/fileName cfg`. -/
def writeConfig (dir : String) (cfg : CodegenConfig) : IO Unit := do
  let path := dir ++ "/" ++ fileName cfg
  IO.FS.writeFile path (generate cfg)
  IO.println s!"wrote {path}"

/-- Write all of `cfgs` into directory `dir`. -/
def writeAll (dir : String) (cfgs : List CodegenConfig := defaultConfigs) : IO Unit :=
  cfgs.forM (writeConfig dir)

end AristotleClient.Codegen
