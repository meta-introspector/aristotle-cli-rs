import RequestProject.Solfunmeme.Meme.Commit
import RequestProject.Solfunmeme.Meme.Tape
import RequestProject.Solfunmeme.Meme.Svg
import RequestProject.Solfunmeme.Meme.Stake

/-!
# `solfunmeme-game`: the verifying runtime

The command line twin of the browser game.  It replays a tape with exactly the
same engine the proofs are about, so anything the page claims can be re-checked
here — or by anybody else who builds this repository.

    solfunmeme-game play   TAPE            replay a tape and report
    solfunmeme-game verify TAPE SHARECODE  check a published claim
    solfunmeme-game svg    TAPE            render the badge card to stdout
    solfunmeme-game vectors                emit the conformance vectors as JSON

A `TAPE` is either the human form — a comma separated list of `t` (tap), `m`
(mint), `d` (day tick), `sN` (steal), `bN` (build), `hN` (hold) — or the
canonical base-58 form printed by `play`.  Both denote the same list of inputs;
the base-58 form is the one with a round-trip proof (`Meme.Tape`).
-/

namespace Meme.Cli

open Meme.Engine Meme.Share Meme.Tape

/-- Parse one human-form token. -/
def parseToken (t : String) : Option Input :=
  match t.toList with
  | [] => none
  | c :: rest =>
      let arg := String.ofList rest
      let n? : Option Nat := if rest.isEmpty then none else arg.toNat?
      match c, n? with
      | 't', none => some .tap
      | 'm', none => some .mint
      | 'd', none => some .tick
      | 's', some n => some (.steal n)
      | 'b', some n => some (.build n)
      | 'h', some n => some (.hold n)
      | _, _ => none

/-- Parse a human-form tape, e.g. `h1000,t,t,t,m,d,d`. -/
def parseTapeText (s : String) : Option (List Input) :=
  let trim (t : String) : String := t.trimAscii.toString
  ((s.splitOn ",").map trim).filter (fun t => !t.isEmpty) |>.mapM parseToken

/-- Print a tape in human form. -/
def tapeToText (xs : List Input) : String :=
  String.intercalate "," <| xs.map fun
    | .tap => "t"
    | .mint => "m"
    | .tick => "d"
    | .steal n => "s" ++ toString n
    | .build n => "b" ++ toString n
    | .hold n => "h" ++ toString n

/-- Accept either form of tape. -/
def parseTape (s : String) : Option (List Input) :=
  match parseTapeText s with
  | some xs => some xs
  | none => decodeTape s

/-- A state as JSON.  Fields are quoted because `commit` is a 64-bit number and
JavaScript's `JSON.parse` would round it to a double. -/
def stateJson (s : State) : String :=
  let f (k : String) (v : Nat) : String := "\"" ++ k ++ "\":\"" ++ toString v ++ "\""
  "{" ++ String.intercalate ","
    [ f "day" s.day, f "brainrot" s.brainrot, f "parts" s.parts, f "memes" s.memes,
      f "blocks" s.blocks, f "stake" s.stake, f "earned" s.earned, f "spent" s.spent,
      f "commit" s.commit ] ++ "}"

/-- The badges of a state as a JSON array of labels. -/
def badgesJson (s : State) : String :=
  "[" ++ String.intercalate ","
    ((unlocked s).map (fun b => "\"" ++ Meme.Svg.badgeLabel b ++ "\"")) ++ "]"

/-- The scenarios the browser checks itself against on load. -/
def scenarios : List (String × List Input) :=
  [ ("tap-and-mint",
      [.tap, .tap, .tap, .steal 200, .mint, .mint, .tick])
  , ("tycoon",
      [.steal 5000, .build 25, .tick, .tick, .tick, .mint])
  , ("diamond-hands",
      [.hold 1000] ++ List.replicate 30 .tick)
  , ("broke",
      [.tap, .mint, .build 3])
  , ("brainrot-tycoon",
      [.hold 4200, .steal 10000, .build 40, .mint, .mint, .mint]
        ++ List.replicate 12 .tick ++ [.mint, .mint]) ]

/-- One conformance vector. -/
def vectorJson (name : String) (xs : List Input) : String :=
  let s := run (start 0) xs
  "{\"name\":\"" ++ name ++ "\",\"tape\":\"" ++ tapeToText xs ++
    "\",\"tape58\":\"" ++ encodeTape xs ++
    "\",\"share\":\"" ++ encodeShare s ++
    "\",\"badges\":" ++ badgesJson s ++
    ",\"final\":" ++ stateJson s ++ "}"

/-- All conformance vectors, as a JSON document. -/
def vectorsJson : String :=
  "{\"engine\":\"fhme-1\",\"partCost\":" ++ toString partCost ++
    ",\"mintCost\":" ++ toString mintCost ++ ",\"vectors\":[" ++
    String.intercalate "," (scenarios.map (fun p => vectorJson p.1 p.2)) ++ "]}"

/-- The text report for a replay. -/
def report (xs : List Input) : String :=
  let s := run (start 0) xs
  let pos := Meme.Stake.ofState s
  "tape      " ++ tapeToText xs ++ "\n" ++
  "tape58    " ++ encodeTape xs ++ "\n" ++
  "share     " ++ encodeShare s ++ "\n" ++
  "day       " ++ toString s.day ++ "\n" ++
  "brainrot  " ++ toString s.brainrot ++ "\n" ++
  "parts     " ++ toString s.parts ++ "\n" ++
  "memes     " ++ toString s.memes ++ "\n" ++
  "blocks    " ++ toString s.blocks ++ "\n" ++
  "stake     " ++ toString s.stake ++ "\n" ++
  "earned    " ++ toString s.earned ++ "\n" ++
  "spent     " ++ toString s.spent ++ "\n" ++
  "commit    " ++ toString s.commit ++ "\n" ++
  "payout    " ++ toString (Meme.Stake.payout pos) ++ "\n" ++
  "badges    " ++ String.intercalate ", " ((unlocked s).map Meme.Svg.badgeLabel) ++ "\n"

/-- A checkpoint proof over the last `k` inputs of a tape. -/
def checkpointJson (xs : List Input) (k : Nat) : String :=
  let n := xs.length - k
  let pre := xs.take n
  let seg := xs.drop n
  let before := (run (start 0) pre).commit
  let after := (run (start 0) xs).commit
  "{\"before\":\"" ++ toString before ++ "\",\"seg\":\"" ++ tapeToText seg ++
    "\",\"after\":\"" ++ toString after ++ "\"}"

/-- Usage text. -/
def usage : String :=
  "solfunmeme-game — replay and verify SOLFUNMEME brainrot tycoon games\n\n" ++
  "  solfunmeme-game play       TAPE                 replay a tape and report\n" ++
  "  solfunmeme-game verify     TAPE SHARECODE       check a published claim\n" ++
  "  solfunmeme-game svg        TAPE                 render the badge card\n" ++
  "  solfunmeme-game checkpoint TAPE K               disclose only the last K moves\n" ++
  "  solfunmeme-game segment    BEFORE TAPE AFTER    check such a disclosure\n" ++
  "  solfunmeme-game vectors                         emit conformance vectors as JSON\n\n" ++
  "TAPE is either t,m,d,sN,bN,hN in the human form, or a base-58 tape code.\n"

/-- Entry point. -/
def main (args : List String) : IO UInt32 := do
  match args with
  | ["vectors"] => IO.println vectorsJson; return 0
  | ["play", t] =>
      match parseTape t with
      | none => IO.eprintln "could not parse tape"; return 1
      | some xs => IO.print (report xs); return 0
  | ["svg", t] =>
      match parseTape t with
      | none => IO.eprintln "could not parse tape"; return 1
      | some xs => IO.println (Meme.Svg.render (run (start 0) xs)); return 0
  | ["checkpoint", t, k] =>
      match parseTape t, k.toNat? with
      | none, _ => IO.eprintln "could not parse tape"; return 1
      | _, none => IO.eprintln "could not parse K"; return 1
      | some xs, some n => IO.println (checkpointJson xs n); return 0
  | ["segment", before, t, after] =>
      match before.toNat?, parseTape t, after.toNat? with
      | some b, some xs, some a =>
          let sg : Segment := { before := b, seg := xs, after := a }
          if sg.verify then IO.println "SEGMENT VERIFIED"; return 0
          else IO.println "SEGMENT REJECTED"; return 1
      | _, _, _ => IO.eprintln "could not parse segment"; return 1
  | ["verify", t, code] =>
      match parseTape t, decodeShare code with
      | none, _ => IO.eprintln "could not parse tape"; return 1
      | _, none => IO.eprintln "could not parse share code"; return 1
      | some xs, some claimed =>
          let c : Claim := { blocks := 0, tape := xs, final := claimed }
          if c.verify then
            IO.println "VERIFIED"
            IO.println ("memes     " ++ toString claimed.memes)
            IO.println ("blocks    " ++ toString claimed.blocks)
            IO.println ("stake     " ++ toString claimed.stake)
            return 0
          else
            IO.println "REJECTED"
            IO.println ("expected  " ++ encodeShare (run (start 0) xs))
            return 1
  | _ => IO.print usage; return 0

end Meme.Cli

/-- `lake exe solfunmeme-game` -/
def main (args : List String) : IO UInt32 := Meme.Cli.main args
