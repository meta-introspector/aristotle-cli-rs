/-
MinimalPipeline.lean — a minimal Lean 4 parser/processor pipeline, extracted from the
Lean source code itself.

This is the concrete *output* of the `PipelineSkeleton` tool
(`RequestProject/PipelineSkeleton.lean`).  That tool uses the same exact-dependency
extraction as `SplitDecls` to seed a BFS from the Lean frontend's pipeline entry points
and map out the minimal closure of core declarations that turn source **text** into an
**`Environment`**.  Reading that map off, the whole Lean frontend collapses to four
composable stages:

      Text  ──(1) input──▶  InputContext
            ──(2) parseHeader──▶  header `Syntax`
            ──(3) processHeader──▶  `Environment`
            ──(4) processCommands──▶  `Environment`

Each stage below is a thin, *typed* wrapper around the single core declaration that the
skeleton identifies as the minimal entry point of that stage:

  | stage | entry declaration                | role                         |
  |-------|----------------------------------|------------------------------|
  | 1     | `Lean.Parser.mkInputContext`     | source text → input context  |
  | 2     | `Lean.Parser.parseHeader`        | input → import/prelude header|
  | 3     | `Lean.Elab.processHeader`        | header → base environment     |
  | 4     | `Lean.Elab.IO.processCommands`   | commands → final environment  |

Composing the four stages gives `MinimalPipeline.run : String → IO (Option Environment)`,
a from-scratch, minimal re-implementation of the Lean source processor.  The `#eval`
self-tests at the bottom check that it actually elaborates code (and detects errors).

This file is `Lean`-only (no Mathlib) and matches the project's `Text → Lean → …` flow
philosophy (`SelfModelFlow`): it is the `Text → Lean` half realised against the *real*
kernel API rather than a model of it.
-/
import Lean

namespace MinimalPipeline

open Lean Elab Parser

/-! ## The four pipeline stages

Each stage is the minimal typed arrow between two adjacent data representations of the
Lean frontend.  They are deliberately one-liners: the point is the *shape* of the
pipeline, with all real work delegated to the core declarations the skeleton selected. -/

/-- **Stage 1 — input.** Wrap raw source text in a parser `InputContext`.  This is the
entry to the whole pipeline: it pairs the text with a file name and a position table. -/
def toInput (src : String) (fileName : String := "<input>") : Parser.InputContext :=
  Parser.mkInputContext src fileName

/-- **Stage 2 — parse header.** Read the leading `prelude`/`import` block, returning the
header `Syntax`, the parser state positioned just after the header, and any messages. -/
def parseHeaderStage (ictx : Parser.InputContext) :
    IO (Elab.HeaderSyntax × Parser.ModuleParserState × MessageLog) := do
  let (stx, state, messages) ← Parser.parseHeader ictx
  return (stx, state, messages)

/-- **Stage 3 — elaborate header.** Run the header's imports, producing the base
`Environment` that the commands will extend. -/
def processHeaderStage (header : Elab.HeaderSyntax) (messages : MessageLog)
    (ictx : Parser.InputContext) (opts : Options := {}) : IO (Environment × MessageLog) :=
  processHeader header opts messages ictx

/-- **Stage 4 — process commands.** Parse and elaborate each command in turn, threading
the command state, and return the resulting frontend state (which carries the final
environment and message log). -/
def processCommandsStage (ictx : Parser.InputContext)
    (pstate : Parser.ModuleParserState) (cstate : Command.State) : IO Frontend.State :=
  IO.processCommands ictx pstate cstate

/-! ## The composed pipeline -/

/-- The minimal pipeline run end to end: source **text → environment**.

Returns `none` if any stage logs an error (so the caller can distinguish a clean run from
one with elaboration errors), and `some env` with the final environment otherwise.

This is `Lean.Elab.runFrontend` reduced to its load-bearing core: stage 1 → 2 → 3 → 4. -/
def run (src : String) (opts : Options := {}) (fileName : String := "<input>") :
    IO (Option Environment) := do
  -- Stage 1: text → input context
  let ictx := toInput src fileName
  -- Stage 2: input → header syntax + parser state
  let (header, pstate, messages) ← parseHeaderStage ictx
  -- Stage 3: header → base environment
  let (env, messages) ← processHeaderStage header messages ictx opts
  -- Stage 4: commands → final environment
  let cstate := Command.mkState env messages opts
  let s ← processCommandsStage ictx pstate cstate
  if s.commandState.messages.hasErrors then
    return none
  else
    return some s.commandState.env

/-- A convenience that also reports whether a given declaration name ended up in the
resulting environment — handy for testing the pipeline end to end. -/
def runAndCheck (src : String) (decl : Name)
    (opts : Options := {}) (fileName : String := "<input>") : IO Bool := do
  match ← run src opts fileName with
  | none => return false
  | some env => return (env.find? decl).isSome

/-! ## Self-tests

These run at build time.  They use headers with no imports, so no module search path is
required for the tests to succeed. -/

-- A well-formed declaration is elaborated and lands in the environment.
#eval show IO Unit from do
  let ok ← runAndCheck "def pipelineSelfTest : Nat := 41" `pipelineSelfTest
  IO.println s!"[MinimalPipeline] elaborates `pipelineSelfTest` : {ok}"

-- An ill-typed declaration is rejected (the pipeline reports the error).
#eval show IO Unit from do
  let env? ← run "def bad : Nat := \"not a nat\""
  IO.println s!"[MinimalPipeline] rejects ill-typed input : {env?.isNone}"

end MinimalPipeline
