import RequestProject.Nix.NixWars.Ledger
import RequestProject.Nix.NixWars.Sha256

/-!
# Writing a game down

A page carries its game as text: the log as JSON, and — for the commitment a
player posts to a chain — the log as one canonical block of ASCII, whose
SHA-256 is the thing to post.

This file is the codec: moves and galaxies to JSON, the canonical log text,
its digest, and base64 (which the page needs to carry its own source).
-/

namespace NixWars

/-- Join a list of strings. -/
def concatStrings (l : List String) : String := l.foldl (· ++ ·) ""

/-- A move as JSON, with the same four keys in the same order the page's
JavaScript writes them, so that the two agree character for character. -/
def moveJson : Move → String
  | .build s => "{\"t\":\"build\",\"a\":" ++ toString s ++ ",\"b\":0,\"n\":0}"
  | .jump a b n =>
      "{\"t\":\"jump\",\"a\":" ++ toString a ++ ",\"b\":" ++ toString b ++
        ",\"n\":" ++ toString n ++ "}"
  | .colonise s => "{\"t\":\"colonise\",\"a\":" ++ toString s ++ ",\"b\":0,\"n\":0}"
  | .research => "{\"t\":\"research\",\"a\":0,\"b\":0,\"n\":0}"
  | .pass => "{\"t\":\"pass\",\"a\":0,\"b\":0,\"n\":0}"

/-- A list as JSON. -/
def jsonList (l : List String) : String :=
  "[" ++ (match l with
          | [] => ""
          | x :: rest => rest.foldl (fun acc y => acc ++ "," ++ y) x) ++ "]"

/-- A log as JSON. -/
def logJson (l : List Move) : String := jsonList (l.map moveJson)

/-- A star system as JSON. -/
def sysJson (s : Sys) : String :=
  "{\"o\":" ++ toString s.owner ++ ",\"p\":" ++ toString s.pop ++ ",\"i\":" ++ toString s.ind ++
    ",\"s1\":" ++ toString s.s1 ++ ",\"s2\":" ++ toString s.s2 ++ "}"

/-- A galaxy as JSON. -/
def galaxyJson (g : Galaxy) : String :=
  "{\"sys\":" ++ jsonList (g.sys.map sysJson) ++
    ",\"c1\":" ++ toString g.cred1 ++ ",\"c2\":" ++ toString g.cred2 ++
    ",\"t1\":" ++ toString g.tech1 ++ ",\"t2\":" ++ toString g.tech2 ++
    ",\"round\":" ++ toString g.round ++ ",\"active\":" ++ toString g.active ++
    ",\"winner\":" ++ toString g.winner ++ "}"

/-- One line of the canonical log text. -/
def moveLine : Move → String
  | .build s => "build " ++ toString s
  | .jump a b n => "jump " ++ toString a ++ " " ++ toString b ++ " " ++ toString n
  | .colonise s => "colonise " ++ toString s
  | .research => "research"
  | .pass => "pass"

/-- The canonical text of a game: a version banner, one line per command, and
the rolling commitment of the chain. This is the block of bytes whose SHA-256
a player posts. -/
def logText (l : List Move) : String :=
  "NIXWARS-EMPIRE/1\n" ++ concatStrings (l.map (fun m => moveLine m ++ "\n")) ++
    "chain " ++ toString (commit genesis l) ++ "\n"

/-- The commitment of a game: the SHA-256 of its canonical text. -/
def commitHex (l : List Move) : String := Sha256.ofString (logText l)

/-- The stake receipt of a game: what a player would post to a chain, a rollup
or a notice board to stake on the position this page carries. It names the
format, the number of commands, the hash of the opening position, the rolling
commitment, the SHA-256 of the canonical log text, and who has won (0 for a
game still in play). -/
def receiptJson (l : List Move) : String :=
  "{\"format\":\"NIXWARS-EMPIRE/1\",\"moves\":" ++ toString l.length ++
  ",\"root\":" ++ toString (rootHash genesis) ++
  ",\"commit\":" ++ toString (commit genesis l) ++
  ",\"sha256\":\"" ++ commitHex l ++ "\"" ++
  ",\"winner\":" ++ toString (replay genesis l).winner ++ "}"

/-! ## base64

The page carries its own source, so it needs an encoder Lean and the browser
agree on. -/

/-- The base64 alphabet. -/
def b64alphabet : List Char :=
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".toList

/-- The `n`th character of the base64 alphabet. -/
def b64char (n : Nat) : Char := b64alphabet.getD n '='

/-- base64 of a byte string. -/
def base64Bytes (bs : Array UInt8) : String := Id.run do
  let mut out := ""
  let mut i := 0
  while i + 2 < bs.size do
    let a := bs[i]!.toNat
    let b := bs[i+1]!.toNat
    let c := bs[i+2]!.toNat
    out := out.push (b64char (a >>> 2))
    out := out.push (b64char (((a &&& 3) <<< 4) ||| (b >>> 4)))
    out := out.push (b64char (((b &&& 15) <<< 2) ||| (c >>> 6)))
    out := out.push (b64char (c &&& 63))
    i := i + 3
  if i + 1 = bs.size then
    let a := bs[i]!.toNat
    out := out.push (b64char (a >>> 2))
    out := out.push (b64char ((a &&& 3) <<< 4))
    out := out.push '='
    out := out.push '='
  else if i + 2 = bs.size then
    let a := bs[i]!.toNat
    let b := bs[i+1]!.toNat
    out := out.push (b64char (a >>> 2))
    out := out.push (b64char (((a &&& 3) <<< 4) ||| (b >>> 4)))
    out := out.push (b64char ((b &&& 15) <<< 2))
    out := out.push '='
  return out

/-- base64 of a string. -/
def base64 (s : String) : String := base64Bytes s.toUTF8.data

/-- The position of a character in the base64 alphabet. -/
def b64index (c : Char) : Nat := (b64alphabet.findIdx? (· == c)).getD 0

/-- Decode base64 back to a byte string. -/
def unbase64Bytes (s : String) : Array UInt8 := Id.run do
  let cs := s.toList.filter (fun c => c != '=' && c != '\n')
  let arr := cs.toArray
  let mut out : Array UInt8 := Array.emptyWithCapacity (arr.size * 3 / 4)
  let mut i := 0
  while i + 1 < arr.size do
    let a := b64index arr[i]!
    let b := b64index arr[i+1]!
    out := out.push (UInt8.ofNat (((a <<< 2) ||| (b >>> 4)) &&& 255))
    if i + 2 < arr.size then
      let c := b64index arr[i+2]!
      out := out.push (UInt8.ofNat ((((b &&& 15) <<< 4) ||| (c >>> 2)) &&& 255))
      if i + 3 < arr.size then
        let d := b64index arr[i+3]!
        out := out.push (UInt8.ofNat ((((c &&& 3) <<< 6) ||| d) &&& 255))
    i := i + 4
  return out

/-- Decode base64 back to a string. -/
def unbase64 (s : String) : String := String.fromUTF8! ⟨unbase64Bytes s⟩

#guard base64 "" = ""
#guard base64 "f" = "Zg=="
#guard base64 "fo" = "Zm8="
#guard base64 "foo" = "Zm9v"
#guard base64 "foobar" = "Zm9vYmFy"
#guard unbase64 (base64 "the quick brown fox, 0123456789!") = "the quick brown fox, 0123456789!"

/-! ## A probe log

A hundred and fifty commands drawn by a linear congruential generator, legal
and illegal alike, out-of-range system numbers included. Nothing is proved
about it: it is there so that the harness can check the page's arithmetic
against Lean's on a run nobody designed. -/

/-- A linear congruential generator. -/
def lcg (x : Nat) : Nat := (x * 1103515245 + 12345) % 2147483648

/-- A command drawn from a number - which may well be illegal where it lands. -/
def probeMove (x : Nat) : Move :=
  match x % 5 with
  | 0 => .build (x / 5 % 13)
  | 1 => .jump (x / 5 % 13) (x / 65 % 13) (x / 845 % 4)
  | 2 => .colonise (x / 5 % 13)
  | 3 => .research
  | _ => .pass

/-- The drawn log. -/
def probeLogAux : Nat → Nat → List Move
  | 0, _ => []
  | n + 1, x => let y := lcg x; probeMove y :: probeLogAux n y

/-- A hundred and fifty drawn commands. -/
def probeLog : List Move := probeLogAux 150 12345

/-! ## What Lean hands the harness -/

/-- Escape a string for JSON. -/
def jsonString (s : String) : String := Id.run do
  let mut out := "\""
  for c in s.toList do
    if c = '"' then out := out ++ "\\\""
    else if c = '\\' then out := out ++ "\\\\"
    else if c = '\n' then out := out ++ "\\n"
    else out := out.push c
  return out ++ "\""

/-- Every state the campaign passes through. -/
def campaignStates : List Galaxy := states genesis campaign

/-- The campaign's chain of hashes. -/
def campaignChain : List Nat := chain genesis campaign

/-- The golden values: what Lean says the campaign is, for the harness to
check the page's own JavaScript against. -/
def goldenJson : String :=
  "{\"genesis\":" ++ galaxyJson genesis ++
  ",\"names\":" ++ jsonList (systemNames.map jsonString) ++
  ",\"campaign\":" ++ logJson campaign ++
  ",\"states\":" ++ jsonList (campaignStates.map galaxyJson) ++
  ",\"chain\":" ++ jsonList (campaignChain.map toString) ++
  ",\"rootHash\":" ++ toString (rootHash genesis) ++
  ",\"commit\":" ++ toString (commit genesis campaign) ++
  ",\"logText\":" ++ jsonString (logText campaign) ++
  ",\"sha256\":" ++ jsonString (commitHex campaign) ++
  ",\"emptyLogText\":" ++ jsonString (logText []) ++
  ",\"emptySha256\":" ++ jsonString (commitHex []) ++
  ",\"emptyCommit\":" ++ toString (commit genesis []) ++
  ",\"probe\":" ++ logJson probeLog ++
  ",\"probeStates\":" ++ jsonList ((states genesis probeLog).map galaxyJson) ++
  ",\"probeChain\":" ++ jsonList ((chain genesis probeLog).map toString) ++
  ",\"probeSha256\":" ++ jsonString (commitHex probeLog) ++
  ",\"emptyReceipt\":" ++ jsonString (receiptJson []) ++
  ",\"campaignReceipt\":" ++ jsonString (receiptJson campaign) ++
  ",\"probeReceipt\":" ++ jsonString (receiptJson probeLog) ++
  ",\"constants\":{\"numSystems\":" ++ toString numSystems ++
    ",\"victory\":" ++ toString victorySystems ++
    ",\"shipCost\":" ++ toString shipCost ++
    ",\"colonyCost\":" ++ toString colonyCost ++
    ",\"techCost\":" ++ toString techCost ++
    ",\"sysCap\":" ++ toString sysCap ++
    ",\"hashPrime\":" ++ toString hashPrime ++
    ",\"hashBase\":" ++ toString hashBase ++ "}}"

end NixWars
