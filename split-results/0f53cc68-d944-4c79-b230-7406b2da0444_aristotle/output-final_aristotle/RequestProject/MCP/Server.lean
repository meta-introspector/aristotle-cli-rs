import Lean.Data.Json
import RequestProject.MCP.Core

/-!
# A Lean-native stdio MCP server wrapping the verified core logic

This module realizes **Approach 1** from the design discussion: a Model Context
Protocol (MCP) server written entirely in Lean 4, with **zero FFI**. The
untrusted I/O — JSON-RPC framing, parsing, transport — lives here, while every
*decision* is delegated to the pure, formally verified functions in
`RequestProject/MCP/Core.lean` (whose behaviour is proved in
`RequestProject/MCP/Spec.lean`).

Transport: newline-delimited JSON-RPC 2.0 over `stdin`/`stdout`, as used by the
MCP stdio transport. Each line read from `stdin` is one JSON-RPC message; each
response is written as one line to `stdout`.

The exposed tools are thin, total wrappers around the verified core:

| MCP tool            | verified core function          |
|---------------------|---------------------------------|
| `map_api_status`    | `AristotleMCP.mapApiStatus`     |
| `mock_prove`        | `AristotleMCP.mockProveOutcome` |
| `mock_prove_file`   | `AristotleMCP.mockFileOutcome`  |
| `mock_poll`         | `AristotleMCP.mockPoll`         |
| `is_mock_mode`      | `AristotleMCP.isMockValue`      |
| `has_api_key`       | `AristotleMCP.hasApiKeyValue`   |
| `server_status`     | `AristotleMCP.serverReady` / `serverStatusMessage` |
-/

open Lean (Json)

namespace AristotleMCP.Server

/-! ## Rendering verified enum results as strings -/

/-- Client-facing status string for a `MappedStatus` (matches `tools.py`). -/
def MappedStatus.toStr : MappedStatus → String
  | .complete   => "complete"
  | .queued     => "queued"
  | .inProgress => "in_progress"
  | .failed     => "failed"

/-- Outcome string for a `ProveOutcome` (matches `mock.py`). -/
def ProveOutcome.toStr : ProveOutcome → String
  | .proved         => "proved"
  | .counterexample => "counterexample"
  | .failed         => "failed"

/-- Outcome string for a `FileOutcome` (matches `mock.py`). -/
def FileOutcome.toStr : FileOutcome → String
  | .proved         => "proved"
  | .partialSuccess => "partial"
  | .failed         => "failed"

/-- Phase string for a `PollPhase` mock poll step. -/
def PollPhase.toStr : PollPhase → String
  | .queued     => "queued"
  | .inProgress => "in_progress"
  | .final      => "final"

/-- Human-readable message for a server `StatusMessage` (matches `server.py`). -/
def StatusMessage.toStr : StatusMessage → String
  | .notConfigured =>
      "Not configured. Get your API key at https://aristotle.harmonic.fun/ " ++
      "and set ARISTOTLE_API_KEY, or set ARISTOTLE_MOCK=true for testing."
  | .mockMode => "Running in mock mode (no API calls)"
  | .ready    => "Ready to call Aristotle API"

/-! ## JSON helpers -/

/-- A `Nat` rendered as a JSON number. -/
def jnat (n : Nat) : Json := Json.num (n : Int)

/-- Look up a required string argument. -/
def getStrArg (args : Json) (key : String) : Except String String := do
  (← args.getObjVal? key).getStr?

/-- Look up an optional `Nat` argument (absent ⇒ `none`). -/
def getNatArg? (args : Json) (key : String) : Option Nat :=
  match args.getObjVal? key with
  | .ok j => (j.getNat?).toOption
  | .error _ => none

/-- Look up a required `Nat` argument. -/
def getNatArg (args : Json) (key : String) : Except String Nat := do
  (← args.getObjVal? key).getNat?

/-- Look up a required boolean argument. -/
def getBoolArg (args : Json) (key : String) : Except String Bool := do
  (← args.getObjVal? key).getBool?

/-! ## Tool metadata (advertised by `tools/list`) -/

/-- Build a JSON-Schema object with the given required string/number/bool props. -/
private def schema (props : List (String × String)) (required : List String) : Json :=
  Json.mkObj
    [ ("type", Json.str "object")
    , ("properties",
        Json.mkObj (props.map (fun (n, t) => (n, Json.mkObj [("type", Json.str t)]))))
    , ("required", Json.arr (required.map Json.str |>.toArray)) ]

/-- A single tool descriptor for `tools/list`. -/
private def tool (name desc : String) (inputSchema : Json) : Json :=
  Json.mkObj
    [ ("name", Json.str name)
    , ("description", Json.str desc)
    , ("inputSchema", inputSchema) ]

/-- The full list of tools advertised to MCP clients. -/
def toolList : Json :=
  Json.arr #[
    tool "map_api_status"
      "Map an aristotlelib API status string to the client-facing status and message."
      (schema [("status_str", "string"), ("percent_complete", "integer")] ["status_str"]),
    tool "mock_prove"
      "Decide the mock outcome (proved/counterexample/failed) for a Lean code snippet."
      (schema [("code", "string")] ["code"]),
    tool "mock_prove_file"
      "Decide the mock outcome (proved/partial/failed) for a Lean file path."
      (schema [("file_path", "string")] ["file_path"]),
    tool "mock_poll"
      "Advance the mock async polling state machine for a given poll count."
      (schema [("poll_count", "integer")] ["poll_count"]),
    tool "is_mock_mode"
      "Decide whether an ARISTOTLE_MOCK value enables mock mode."
      (schema [("value", "string")] ["value"]),
    tool "has_api_key"
      "Decide whether an ARISTOTLE_API_KEY value counts as configured."
      (schema [("value", "string")] ["value"]),
    tool "server_status"
      "Compute server readiness and status message from mock_mode and api_key_configured."
      (schema [("mock_mode", "boolean"), ("api_key_configured", "boolean")]
        ["mock_mode", "api_key_configured"])
  ]

/-! ## Tool dispatch (delegating to the verified core) -/

/-- Run a single tool by name with the given `arguments` object, returning the
structured JSON result (or an error string). Each branch delegates directly to a
verified function from `Core.lean`. -/
def runTool (name : String) (args : Json) : Except String Json := do
  match name with
  | "map_api_status" =>
      let s ← getStrArg args "status_str"
      let pct := getNatArg? args "percent_complete"
      let (st, msg) := mapApiStatus s pct
      pure <| Json.mkObj [("status", Json.str (MappedStatus.toStr st)), ("message", Json.str msg)]
  | "mock_prove" =>
      let code ← getStrArg args "code"
      pure <| Json.mkObj [("outcome", Json.str (ProveOutcome.toStr (mockProveOutcome code)))]
  | "mock_prove_file" =>
      let fp ← getStrArg args "file_path"
      pure <| Json.mkObj [("outcome", Json.str (FileOutcome.toStr (mockFileOutcome fp)))]
  | "mock_poll" =>
      let pc ← getNatArg args "poll_count"
      let (phase, pct) := mockPoll pc
      pure <| Json.mkObj
        [("phase", Json.str (PollPhase.toStr phase)), ("percent_complete", jnat pct)]
  | "is_mock_mode" =>
      let v ← getStrArg args "value"
      pure <| Json.mkObj [("mock_mode", Json.bool (isMockValue v))]
  | "has_api_key" =>
      let v ← getStrArg args "value"
      pure <| Json.mkObj [("api_key_configured", Json.bool (hasApiKeyValue v))]
  | "server_status" =>
      let mm ← getBoolArg args "mock_mode"
      let ak ← getBoolArg args "api_key_configured"
      pure <| Json.mkObj
        [ ("ready", Json.bool (serverReady mm ak))
        , ("message", Json.str (StatusMessage.toStr (serverStatusMessage mm ak))) ]
  | other => throw s!"Unknown tool: {other}"

/-! ## JSON-RPC framing -/

/-- Server identity for the `initialize` handshake. -/
def serverInfo : Json :=
  Json.mkObj [("name", Json.str "aristotle-lean-mcp"), ("version", Json.str "0.1.0")]

/-- A successful JSON-RPC response with the given id and result payload. -/
def rpcResult (id result : Json) : Json :=
  Json.mkObj [("jsonrpc", Json.str "2.0"), ("id", id), ("result", result)]

/-- A JSON-RPC error response. -/
def rpcError (id : Json) (code : Int) (message : String) : Json :=
  Json.mkObj
    [ ("jsonrpc", Json.str "2.0")
    , ("id", id)
    , ("error", Json.mkObj [("code", Json.num code), ("message", Json.str message)]) ]

/-- Wrap a tool result as MCP `tools/call` content. -/
def toolContent (payload : Json) : Json :=
  Json.mkObj
    [ ("content",
        Json.arr #[Json.mkObj [("type", Json.str "text"), ("text", Json.str payload.compress)]]) ]

/-- Compute the JSON-RPC response for one parsed request message.

Returns `none` for notifications (messages without an `id`), which receive no
reply. -/
def handle (msg : Json) : Option Json :=
  let id? := (msg.getObjVal? "id").toOption
  let method := (msg.getObjVal? "method" >>= (·.getStr?)) |>.toOption |>.getD ""
  match id? with
  | none => none  -- notification: no response
  | some id =>
    match method with
    | "initialize" =>
        rpcResult id <| Json.mkObj
          [ ("protocolVersion", Json.str "2024-11-05")
          , ("capabilities", Json.mkObj [("tools", Json.mkObj [])])
          , ("serverInfo", serverInfo) ]
    | "tools/list" =>
        rpcResult id <| Json.mkObj [("tools", toolList)]
    | "tools/call" =>
        match msg.getObjVal? "params" with
        | .error _ => rpcError id (-32602) "Missing params"
        | .ok params =>
          match (params.getObjVal? "name" >>= (·.getStr?)) with
          | .error _ => rpcError id (-32602) "Missing tool name"
          | .ok name =>
            let args := (params.getObjVal? "arguments").toOption.getD (Json.mkObj [])
            match runTool name args with
            | .ok payload => rpcResult id (toolContent payload)
            | .error e => rpcError id (-32000) e
    | "ping" => rpcResult id (Json.mkObj [])
    | other => rpcError id (-32601) s!"Method not found: {other}"

/-! ## The stdio event loop -/

/-- Read newline-delimited JSON-RPC messages from `stdin`, dispatch each through
`handle`, and write responses to `stdout`. Loops until EOF. -/
partial def serve : IO Unit := do
  let stdin ← IO.getStdin
  let stdout ← IO.getStdout
  let rec loop : IO Unit := do
    let line ← stdin.getLine
    if line.isEmpty then
      pure ()  -- EOF
    else
      if line.toList.all (fun (c : Char) => c.isWhitespace) then
        loop
      else
        match Json.parse line with
        | .error _ =>
            -- Parse error: reply with a JSON-RPC error using a null id.
            stdout.putStrLn (rpcError Json.null (-32700) "Parse error").compress
            stdout.flush
            loop
        | .ok msg =>
            match handle msg with
            | some resp =>
                stdout.putStrLn resp.compress
                stdout.flush
                loop
            | none => loop
  loop

end AristotleMCP.Server
