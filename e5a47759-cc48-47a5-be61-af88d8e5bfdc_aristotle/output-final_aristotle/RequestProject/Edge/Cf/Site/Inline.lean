/-
# Inlining, base64 and the constants the page needs

The small pieces `RequestProject.Cf.Site` is built from: turning an ES
module into a script the page can carry inline, base64 for the embedded
WebAssembly kernel, and the Lean values (the selection preset, the shell
script, the agent, the gate) handed to the browser as JavaScript.
-/
import RequestProject.Edge.Cf.JsEmit
import RequestProject.Edge.Cf.WasmKernel
import RequestProject.Edge.Cf.Select
import RequestProject.Edge.Cf.Offline
import RequestProject.Edge.Cf.Gate
import RequestProject.Edge.Cf.Profiles

namespace CfDeploy
namespace Site

/-! ## Inlining an ES module into a page -/

/-- How many backticks a line carries that are not escaped: an odd count
means the line opens or closes a template literal. -/
def unescapedBackticks (s : String) : Nat :=
  let rec go : List Char → Bool → Nat → Nat
    | [], _, n => n
    | c :: cs, esc, n =>
      if esc then go cs false n
      else if c = '\\' then go cs true n
      else if c = '`' then go cs false (n + 1)
      else go cs false n
  go s.toList false 0

/-- Turn an ES module into code that can be concatenated with others
inside a single inline `<script type="module">`: drop the `import` lines
(everything it imported is concatenated with it) and the `export`
keywords (an inline module exports to nobody).

Only *code* lines are touched.  A line inside a template literal is data —
the generated Worker, the agent and the shell script are all carried in
template literals, and several of them begin a line with `import` or
`export` — so the fold tracks whether it is inside one and leaves those
lines exactly as they are. -/
def inlineModule (src : String) : String :=
  let step := fun (acc : List String × Bool) (l : String) =>
    let (out, inTemplate) := acc
    let out :=
      if inTemplate then l :: out
      else if l.startsWith "import " then out
      else if l.startsWith "export " then (l.drop 7).toString :: out
      else l :: out
    (out, if unescapedBackticks l % 2 == 1 then !inTemplate else inTemplate)
  String.intercalate "\n" ((src.splitOn "\n").foldl step ([], false)).1.reverse

/-- How many `import`/`export` statements a script still carries outside
every template literal — that is, how many of them the browser would read
as module syntax. -/
def moduleStatements (src : String) : Nat :=
  let step := fun (acc : Nat × Bool) (l : String) =>
    let (n, inTemplate) := acc
    let n :=
      if !inTemplate && (l.startsWith "import " || l.startsWith "export ") then n + 1 else n
    (n, if unescapedBackticks l % 2 == 1 then !inTemplate else inTemplate)
  ((src.splitOn "\n").foldl step (0, false)).1

/-! ## The build stamp -/

/-- The content hash of a generated artefact: sixteen hex digits of the
same FNV-1a the bundle reader uses.  The page carries one of these, so
“is the site I am looking at the site I built?” has an answer. -/
def buildIdOf (s : String) : String := Bundle.hex16 (Bundle.fnv1a64 s.toUTF8)

/-! ## Base64, for the inlined WebAssembly kernel -/

def b64Alphabet : Array Char :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".toList.toArray

/-- Standard base64 with padding. -/
def base64 (bs : ByteArray) : String := Id.run do
  let n := bs.size
  let mut out : String := ""
  for j in [0 : (n + 2) / 3] do
    let i := 3 * j
    let b0 := bs[i]!.toNat
    let b1 := if i + 1 < n then bs[i + 1]!.toNat else 0
    let b2 := if i + 2 < n then bs[i + 2]!.toNat else 0
    let v := b0 * 65536 + b1 * 256 + b2
    out := out.push (b64Alphabet[v / 262144]!)
    out := out.push (b64Alphabet[(v / 4096) % 64]!)
    out := out.push (if i + 1 < n then b64Alphabet[(v / 64) % 64]! else '=')
    out := out.push (if i + 2 < n then b64Alphabet[v % 64]! else '=')
  return out

/-- Escape a string so it can be embedded in a JavaScript template
literal. -/
def quoteTemplate (s : String) : String :=
  ((s.replace "\\" "\\\\").replace "`" "\\`").replace "${" "\\${"

/-! ## The Lean values the browser needs, emitted as JavaScript -/

/-- A list of strings as a JavaScript array literal. -/
def jsStringArray (xs : List String) : String :=
  "[" ++ String.intercalate ", " (xs.map fun s => "'" ++ s ++ "'") ++ "]"

/-- The constants the browser mirrors of `Cf.Select` and `Cf.Offline` read:
the pruning preset, Cloudflare's per-asset cap and the fixed part of the
shell script.  They are emitted from the Lean definitions themselves, so
the page and the CLI cannot drift apart. -/
def generatedConstsJs : String :=
  "// Generated from Lean: the values of RequestProject.Cf.Select and .Offline.\n" ++
  "export const LEAN_PRESET = " ++ jsStringArray Select.leanPreset ++ ";\n" ++
  "export const CF_MAX_ASSET = " ++ toString Select.cloudflareMaxAsset ++ ";\n" ++
  "export const SHELL_PRELUDE = `" ++ quoteTemplate Offline.shellPrelude ++ "`;\n"

/-- The configuration convention, handed to the browser: the keys, what
each one sets, the built-in defaults, the short names a file may use and
the profiles declared in Lean with `@[cf_site]`.  All of it is generated
from `RequestProject.Cf.Config`, so a `cfdeploy.toml` means the same
thing in the page as it does in the CLI. -/
def configConstsJs : String :=
  "// Generated from Lean: RequestProject.Cf.Config and .Profiles.\n" ++
  "export const CONFIG_KEYS = " ++ jsStringArray Config.knownKeys ++ ";\n" ++
  "export const CONFIG_FIELDS = " ++
    Json.render (.obj (Config.keyFields.map fun (k, f, kind) =>
      (k, Json.arr [.str f, .str kind]))) ++ ";\n" ++
  "export const CONFIG_SHORT_KEYS = " ++
    Json.render (.obj (Config.shortKeys.map fun (k, v) => (k, Json.str v))) ++ ";\n" ++
  "export const CONFIG_DEFAULTS = " ++
    Json.render (Config.Resolved.fieldsJson {}) ++ ";\n" ++
  "export const CONFIG_FILE_NAME = 'cfdeploy.toml';\n" ++
  "export const CF_PROFILES = " ++
    Json.render (.arr (Config.registered.map Config.Profile.json)) ++ ";\n"

/-- The two programs the page can hand you for a browser that cannot
reach the API: the local agent, and the standalone CORS proxy Worker. -/
def offlineProgramsJs : String :=
  "// Generated from Lean: RequestProject.Cf.Offline.agentJs and .corsProxyWorkerJs.\n" ++
  "export const AGENT_JS = `" ++ quoteTemplate Offline.agentJs ++ "`;\n" ++
  "export const PROXY_JS = `" ++ quoteTemplate Offline.corsProxyWorkerJs ++ "`;\n" ++
  "export const AGENT_INSTALL = `" ++ quoteTemplate Offline.agentInstallCommand ++ "`;\n" ++
  "export const GATE_JS = `" ++ quoteTemplate Gate.gateWorkerJs ++ "`;\n" ++
  "export const GATE_TOML = `" ++
    quoteTemplate (Gate.gateWranglerToml "cfdeploy-gate" none) ++ "`;\n"
end Site
end CfDeploy
