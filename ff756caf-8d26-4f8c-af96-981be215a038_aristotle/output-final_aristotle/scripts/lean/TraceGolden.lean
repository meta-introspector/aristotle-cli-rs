/-
Generate `tests/data/trace-golden.json`: a corpus of quoted programs, the
bindings applied to them, and the traces replayed — all computed by the **Lean
definitions** of `RequestProject/Anim/Trace.lean`.

    bash scripts/gen-trace-golden.sh

Everything printed here comes from `Hesper.Trace.holes`, `subst`, `check`,
`flatten`, `pop`, `traceTerm` and `replay`: the very definitions the theorems in
that file are about (`check_subst`, `subst_traceTerm`, `pop_flatten_nil`,
`replay_append`, `verify_iff`).  `tests/node/test_trace.mjs` replays the corpus
through `web/js/trace.js` and requires exact agreement.

There is no floating point here: terms are trees of strings and a replayed
state is a natural number, so the comparison is exact.
-/
import RequestProject.Anim.Trace

open Hesper.Trace

namespace TraceGolden

def quoted (s : String) : String := "\"" ++ s ++ "\""

def joinWith (sep : String) (xs : List String) : String := String.intercalate sep xs

def jsonStrings (xs : List String) : String := "[" ++ joinWith "," (xs.map quoted) ++ "]"

def jsonNats (xs : List Nat) : String := "[" ++ joinWith "," (xs.map toString) ++ "]"

def jsonBool (b : Bool) : String := if b then "true" else "false"

/-- The wire text of a token, the way a link writes it: `?name` for a hole,
`name/arity` for a node.  The corpus uses names that need no escaping. -/
def tokText : Tok → String
  | .hole n => "?" ++ n
  | .node n k => n ++ "/" ++ toString k

/-- The wire text of a term: its postfix tokens, space separated. -/
def wire (t : Term) : String := joinWith " " ((flatten t).map tokText)

/-! ## The corpus -/

def app (n : String) (args : List Term) : Term := .node n args
def hole (n : String) : Term := .hole n

/-- The signature the recipient checks against. -/
def sigList : List (String × Nat) :=
  [("step", 2), ("and", 2), ("or", 2), ("not", 1), ("true", 0), ("false", 0),
   ("mp", 2), ("ax", 0), ("ca", 2), ("rule30", 0), ("w41", 0), ("trace", 3), (".", 0)]

def sig (n : String) : Option Nat := (sigList.find? (fun p => p.1 == n)).map (fun p => p.2)

structure TermCase where
  name : String
  term : Term

def termCases : List TermCase :=
  [ { name := "hole", term := hole "x" },
    { name := "closed-ax", term := app "ax" [] },
    { name := "modus-ponens-partial", term := app "mp" [app "ax" [], hole "goal"] },
    { name := "two-holes", term := app "and" [hole "l", hole "r"] },
    { name := "repeated-hole", term := app "and" [hole "x", app "not" [hole "x"]] },
    { name := "deep",
      term := app "or" [app "and" [app "true" [], hole "p"], app "not" [app "false" []]] },
    { name := "bad-arity", term := app "not" [app "ax" [], app "ax" []] },
    { name := "unknown-operator", term := app "nope" [hole "x"] },
    { name := "trace-of-a-run",
      term := app "trace" [app "ca" [app "rule30" [], app "w41" []], app "ax" [],
        traceTerm [".", ".", "."] "rest"] } ]

def termJson (c : TermCase) : String :=
  "{" ++ joinWith "," [
    quoted "name" ++ ":" ++ quoted c.name,
    quoted "wire" ++ ":" ++ quoted (wire c.term),
    quoted "holes" ++ ":" ++ jsonStrings (holes c.term),
    quoted "closed" ++ ":" ++ jsonBool (holes c.term == []),
    quoted "check" ++ ":" ++ jsonBool (check sig c.term),
    quoted "roundTrip" ++ ":" ++
      jsonBool (((pop (flatten c.term) []).map (fun st => st.map wire)) == some [wire c.term])
  ] ++ "}"

structure SubstCase where
  name : String
  x : String
  u : Term
  t : Term

def substCases : List SubstCase :=
  [ { name := "fill-the-goal", x := "goal", u := app "ax" [],
      t := app "mp" [app "ax" [], hole "goal"] },
    { name := "fill-both-copies", x := "x", u := app "true" [],
      t := app "and" [hole "x", app "not" [hole "x"]] },
    { name := "absent-hole", x := "zzz", u := app "ax" [],
      t := app "and" [hole "l", hole "r"] },
    { name := "fill-with-a-partial-term", x := "l", u := app "mp" [hole "a", hole "b"],
      t := app "and" [hole "l", hole "r"] } ]

def substJson (c : SubstCase) : String :=
  let r := subst c.x c.u c.t
  "{" ++ joinWith "," [
    quoted "name" ++ ":" ++ quoted c.name,
    quoted "x" ++ ":" ++ quoted c.x,
    quoted "u" ++ ":" ++ quoted (wire c.u),
    quoted "t" ++ ":" ++ quoted (wire c.t),
    quoted "result" ++ ":" ++ quoted (wire r),
    quoted "holes" ++ ":" ++ jsonStrings (holes r),
    quoted "check" ++ ":" ++ jsonBool (check sig r)
  ] ++ "}"

structure BindCase where
  name : String
  first : List String
  tail : String
  more : List String
  tail2 : String

def bindCases : List BindCase :=
  [ { name := "continue-a-run", first := [".", ".", "."], tail := "rest",
      more := [".", "."], tail2 := "rest2" },
    { name := "continue-nothing", first := [], tail := "rest", more := [".", "."],
      tail2 := "done" },
    { name := "continue-with-nothing", first := [".", "."], tail := "rest", more := [],
      tail2 := "done" } ]

def bindJson (c : BindCase) : String :=
  let t := traceTerm c.first c.tail
  let u := traceTerm c.more c.tail2
  "{" ++ joinWith "," [
    quoted "name" ++ ":" ++ quoted c.name,
    quoted "first" ++ ":" ++ jsonStrings c.first,
    quoted "tail" ++ ":" ++ quoted c.tail,
    quoted "more" ++ ":" ++ jsonStrings c.more,
    quoted "tail2" ++ ":" ++ quoted c.tail2,
    quoted "quoted" ++ ":" ++ quoted (wire t),
    quoted "bound" ++ ":" ++ quoted (wire (subst c.tail u t)),
    quoted "concat" ++ ":" ++ quoted (wire (traceTerm (c.first ++ c.more) c.tail2))
  ] ++ "}"

/-! A concrete replay, so the fold the runtime performs is checked too: the
state is a natural number and a move is a natural number. -/

def stepf (s m : Nat) : Nat := (s * 2 + m) % 1000

structure ReplayCase where
  name : String
  seed : Nat
  moves : List Nat

def replayCases : List ReplayCase :=
  [ { name := "empty", seed := 7, moves := [] },
    { name := "short", seed := 1, moves := [1, 2, 3] },
    { name := "wraps", seed := 999, moves := [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5] },
    { name := "long", seed := 0, moves := (List.range 40).map (fun i => i % 7) } ]

def replayJson (c : ReplayCase) : String :=
  let r : Run Nat Nat := ⟨c.seed, c.moves⟩
  let half := c.moves.length / 2
  let a := c.moves.take half
  let b := c.moves.drop half
  "{" ++ joinWith "," [
    quoted "name" ++ ":" ++ quoted c.name,
    quoted "seed" ++ ":" ++ toString c.seed,
    quoted "moves" ++ ":" ++ jsonNats c.moves,
    quoted "final" ++ ":" ++ toString (replay stepf r),
    quoted "split" ++ ":" ++ toString half,
    quoted "mid" ++ ":" ++ toString (replay stepf ⟨c.seed, a⟩),
    quoted "append" ++ ":" ++ toString (replay stepf ⟨replay stepf ⟨c.seed, a⟩, b⟩),
    quoted "verify" ++ ":" ++ jsonBool (verify stepf r (replay stepf r))
  ] ++ "}"

def document : String :=
  "{\n" ++
  "  \"note\": \"generated by scripts/lean/TraceGolden.lean from Hesper.Trace\",\n" ++
  "  \"signature\": {" ++
    joinWith "," (sigList.map (fun p => quoted p.1 ++ ":" ++ toString p.2)) ++ "},\n" ++
  "  \"terms\": [" ++ joinWith ",\n    " (termCases.map termJson) ++ "],\n" ++
  "  \"subst\": [" ++ joinWith ",\n    " (substCases.map substJson) ++ "],\n" ++
  "  \"bind\": [" ++ joinWith ",\n    " (bindCases.map bindJson) ++ "],\n" ++
  "  \"replay\": [" ++ joinWith ",\n    " (replayCases.map replayJson) ++ "]\n" ++
  "}\n"

def write : IO Unit := do
  IO.FS.createDirAll "tests/data"
  IO.FS.writeFile "tests/data/trace-golden.json" document
  IO.println s!"wrote tests/data/trace-golden.json ({termCases.length} terms, {substCases.length} bindings, {bindCases.length} continuations, {replayCases.length} replays)"

end TraceGolden

#eval TraceGolden.write
