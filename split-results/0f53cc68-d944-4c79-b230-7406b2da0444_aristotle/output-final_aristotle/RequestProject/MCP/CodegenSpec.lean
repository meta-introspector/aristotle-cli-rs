import RequestProject.MCP.Codegen
import RequestProject.MCP.ClientSpec

/-!
# Specifications for the native code-generation layer

This file certifies the two verifiable guarantees of
`RequestProject/MCP/Codegen.lean`:

1. **Constant faithfulness** — every generated template literally embeds the
   verified constants of `AristotleClient`. Because the generators *interpolate*
   those definitions, these theorems guarantee that the Rust / C++ / Python /
   JavaScript outputs cannot silently diverge from the verified model.

2. **Reference-semantics equivalence** — the Lean model `nativeUrl` of the
   generated URL builder (which, unlike `AristotleClient.url`, also trims a
   trailing slash from the base) agrees with `AristotleClient.url` on the
   verified base URL. This is the "1:1 behavioural equivalence" at the
   algorithmic level.

The residual gap — that the emitted *source text* implements `nativeUrl` once
compiled by a native toolchain — is the documented, irreducible trust boundary.
-/

namespace AristotleClient.Codegen

open AristotleClient

/-! ## `containsStr` -/

theorem containsStr_self_iff (s sub : String) :
    containsStr s sub = true ↔ 2 ≤ (s.splitOn sub).length := by
  unfold containsStr; simp

/-! ## Reference semantics: trailing-slash stripping -/

/-- `dropWhile` is idempotent (helper for `stripTrailingSlashes_idem`). -/
theorem dropWhile_idem (p : Char → Bool) (l : List Char) :
    (l.dropWhile p).dropWhile p = l.dropWhile p := by
  induction l with
  | nil => simp
  | cons a t ih =>
    simp only [List.dropWhile]
    cases h : p a with
    | false => simp [List.dropWhile, h]
    | true => simp [ih]

/-- Stripping trailing slashes is idempotent. -/
theorem stripTrailingSlashes_idem (s : String) :
    stripTrailingSlashes (stripTrailingSlashes s) = stripTrailingSlashes s := by
  unfold stripTrailingSlashes
  rw [String.toList_ofList, List.reverse_reverse]
  congr 2
  exact dropWhile_idem _ _

theorem stripTrailingSlashes_none :
    stripTrailingSlashes "https://x/api/v3" = "https://x/api/v3" := by native_decide

theorem stripTrailingSlashes_some :
    stripTrailingSlashes "https://x/api/v3///" = "https://x/api/v3" := by native_decide

theorem stripTrailingSlashes_empty :
    stripTrailingSlashes "" = "" := by native_decide

/-- The verified base URL has no trailing slash, so stripping is a no-op. -/
theorem stripTrailingSlashes_clientBaseUrl :
    stripTrailingSlashes clientBaseUrl = clientBaseUrl := by native_decide

/-! ## Reference semantics: URL construction -/

/-- The generated `url` reference model agrees with the verified `url` on the
canonical base URL: the extra trailing-slash strip is a no-op there. -/
theorem nativeUrl_clientBaseUrl (e : String) : nativeUrl clientBaseUrl e = url e := by
  unfold nativeUrl url
  rw [stripTrailingSlashes_clientBaseUrl]

/-- End-to-end: a leading-slash endpoint produces the canonical URL. -/
theorem nativeUrl_leadingSlash :
    nativeUrl clientBaseUrl "/projects" = "https://aristotle.harmonic.fun/api/v3/projects" := by
  rw [nativeUrl_clientBaseUrl]; native_decide

/-- The trailing-slash strip really does fire for a base that has one. -/
theorem nativeUrl_trailingBase :
    nativeUrl "https://aristotle.harmonic.fun/api/v3/" "projects"
      = "https://aristotle.harmonic.fun/api/v3/projects" := by native_decide

/-- Endpoints differing only by leading slashes give equal native URLs. -/
theorem nativeUrl_eq_of_trim_eq (base a b : String)
    (h : trimLeadingSlashes a = trimLeadingSlashes b) :
    nativeUrl base a = nativeUrl base b := by
  unfold nativeUrl; rw [h]

/-! ## Constant faithfulness — Rust -/

theorem rust_embeds_apiVersion :
    containsStr (rustTemplate "aristotle_client") apiVersion = true := by native_decide

theorem rust_embeds_timeout :
    containsStr (rustTemplate "aristotle_client") (toString defaultTimeoutSeconds) = true := by
  native_decide

theorem rust_embeds_baseUrl :
    containsStr (rustTemplate "aristotle_client") clientBaseUrl = true := by native_decide

theorem rust_embeds_noApiKeyMessage :
    containsStr (rustTemplate "aristotle_client") noApiKeyMessage = true := by native_decide

theorem rust_embeds_tooManyRequestsMessage :
    containsStr (rustTemplate "aristotle_client") tooManyRequestsMessage = true := by native_decide

/-! ## Constant faithfulness — C++ -/

theorem cpp_embeds_apiVersion :
    containsStr (cppTemplate "aristotle_client") apiVersion = true := by native_decide

theorem cpp_embeds_timeout :
    containsStr (cppTemplate "aristotle_client") (toString defaultTimeoutSeconds) = true := by
  native_decide

theorem cpp_embeds_baseUrl :
    containsStr (cppTemplate "aristotle_client") clientBaseUrl = true := by native_decide

theorem cpp_embeds_noApiKeyMessage :
    containsStr (cppTemplate "aristotle_client") noApiKeyMessage = true := by native_decide

theorem cpp_embeds_tooManyRequestsMessage :
    containsStr (cppTemplate "aristotle_client") tooManyRequestsMessage = true := by native_decide

/-! ## Constant faithfulness — Python -/

theorem python_embeds_apiVersion :
    containsStr (pythonTemplate "aristotle_client") apiVersion = true := by native_decide

theorem python_embeds_timeout :
    containsStr (pythonTemplate "aristotle_client") (toString defaultTimeoutSeconds) = true := by
  native_decide

theorem python_embeds_baseUrl :
    containsStr (pythonTemplate "aristotle_client") clientBaseUrl = true := by native_decide

theorem python_embeds_noApiKeyMessage :
    containsStr (pythonTemplate "aristotle_client") noApiKeyMessage = true := by native_decide

theorem python_embeds_tooManyRequestsMessage :
    containsStr (pythonTemplate "aristotle_client") tooManyRequestsMessage = true := by
  native_decide

/-! ## Constant faithfulness — JavaScript -/

theorem js_embeds_apiVersion :
    containsStr (jsTemplate "aristotle_client") apiVersion = true := by native_decide

theorem js_embeds_timeout :
    containsStr (jsTemplate "aristotle_client") (toString defaultTimeoutSeconds) = true := by
  native_decide

theorem js_embeds_baseUrl :
    containsStr (jsTemplate "aristotle_client") clientBaseUrl = true := by native_decide

theorem js_embeds_noApiKeyMessage :
    containsStr (jsTemplate "aristotle_client") noApiKeyMessage = true := by native_decide

theorem js_embeds_tooManyRequestsMessage :
    containsStr (jsTemplate "aristotle_client") tooManyRequestsMessage = true := by native_decide

/-! ## Dispatcher and configuration -/

theorem generate_rust (m : String) :
    generate { target := .rust, moduleName := m } = rustTemplate m := rfl

theorem generate_cpp (m : String) :
    generate { target := .cpp, moduleName := m } = cppTemplate m := rfl

theorem generate_python (m : String) :
    generate { target := .python, moduleName := m } = pythonTemplate m := rfl

theorem generate_javascript (m : String) :
    generate { target := .javascript, moduleName := m } = jsTemplate m := rfl

theorem fileName_rust :
    fileName { target := .rust, moduleName := "aristotle_client" } = "aristotle_client.rs" := rfl

theorem fileName_cpp :
    fileName { target := .cpp, moduleName := "aristotle_client" } = "aristotle_client.hpp" := rfl

theorem fileName_python :
    fileName { target := .python, moduleName := "aristotle_client" } = "aristotle_client.py" := rfl

theorem fileName_javascript :
    fileName { target := .javascript, moduleName := "aristotle_client" }
      = "aristotle_client.js" := rfl

/-- The default configuration set covers all four target languages. -/
theorem defaultConfigs_targets :
    defaultConfigs.map (·.target) = [.rust, .cpp, .python, .javascript] := rfl

end AristotleClient.Codegen
