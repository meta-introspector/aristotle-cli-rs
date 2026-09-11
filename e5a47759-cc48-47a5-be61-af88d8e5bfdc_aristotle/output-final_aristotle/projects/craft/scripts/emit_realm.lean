/-
Emit the published pages of the demonstration game: one self-contained HTML file per
move, plus `realm.html`, the index.

Run from the project root with

    lake env lean --run scripts/emit_realm.lean

Every number written into a page — the opening position, every block, every state
hash, every commitment — is computed here by the Lean definitions of
`RequestProject/Realm.lean` and `RequestProject/RealmChain.lean`.  The page only
replays them.
-/
import RequestProject.RealmDemo

open Realm

/-! ## JSON helpers -/

private def jstr (s : String) : String := "\"" ++ s ++ "\""

private def jarr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"

private def jnum (n : Nat) : String := toString n

private def hex16 (n : Nat) : String :=
  let ds := String.ofList (Nat.toDigits 16 n)
  "0x" ++ String.ofList (List.replicate (16 - ds.length) '0') ++ ds

/-! ## The data block -/

def resJson (r : Res) : String :=
  "{\"food\":" ++ jnum r.food ++ ",\"wood\":" ++ jnum r.wood ++ ",\"gold\":" ++ jnum r.gold ++ "}"

def pieceJson (u : Piece) : String :=
  "{\"owner\":" ++ jnum u.owner ++ ",\"kind\":" ++ jnum u.kind.code ++
  ",\"x\":" ++ jnum u.x ++ ",\"y\":" ++ jnum u.y ++ ",\"hp\":" ++ jnum u.hp ++
  ",\"acted\":" ++ (if u.acted then "true" else "false") ++ "}"

def cityJson (c : City) : String :=
  "{\"owner\":" ++ jnum c.owner ++ ",\"x\":" ++ jnum c.x ++ ",\"y\":" ++ jnum c.y ++
  ",\"hp\":" ++ jnum c.hp ++ "}"

def stateJson (st : State) : String :=
  "{\"turn\":" ++ jnum st.turn ++ ",\"active\":" ++ jnum st.active ++
  ",\"pieces\":" ++ jarr (st.pieces.map pieceJson) ++
  ",\"cities\":" ++ jarr (st.cities.map cityJson) ++
  ",\"red\":" ++ resJson st.red ++ ",\"blue\":" ++ resJson st.blue ++ "}"

def blockJson (b : Block) : String :=
  "{\"i\":" ++ jnum b.idx ++ ",\"mv\":" ++ jarr (b.mv.enc.map jnum) ++
  ",\"prev\":" ++ jstr (hex16 b.prev) ++ ",\"state\":" ++ jstr (hex16 b.state) ++ "}"

def theoremsJson : String :=
  jarr ([ ("step_wf", "a legal move keeps the board sane: nobody leaves the board, nobody stands in the water, no two live pieces share a tile")
        , ("step_hp_le", "health never goes up — the dead stay dead")
        , ("step_pieces_length_le", "a piece is never removed from the list, so a move index means the same thing in every replay")
        , ("step_bank_le", "only gathering and the turn's income bring resources in: nothing is conjured")
        , ("over_terminal", "once a player has won, no move at all is legal")
        , ("State.enc_injective", "the numbers on the page determine the position (a decoder is exhibited)")
        , ("verify_record", "a game played by the rules always produces a page that verifies")
        , ("verify_playable", "a page that verifies replays: every move on it is legal in turn")
        , ("verify_eq_record", "the hashes on a verified page are forced by its moves")
        , ("verify_states", "every state hash on the page is the hash of the position the moves really reach")
        , ("verify_prefix", "an old page is still a valid page")
        , ("page_extends", "the next page contains this one, block for block")
        , ("page_commit_unique", "under collision-freedom, the committed number determines the page")
        , ("settle_conserves", "settling a challenge conserves the bond exactly")
        , ("play_never_slashed", "a player who publishes the moves they played can never be slashed")
        , ("honest_claims_agree", "under collision-freedom, no rival history can answer to the same commitment")
        ].map fun p => "[" ++ jstr p.1 ++ "," ++ jstr p.2 ++ "]")

def chainData (n : Nat) (blocks : List Block) : String :=
  "{\"move\":" ++ jnum n ++
  ",\"map\":" ++ jarr (mapRows.map jstr) ++
  ",\"rules\":{\"workerHp\":" ++ jnum (startHp .worker) ++ ",\"soldierHp\":" ++
      jnum (startHp .soldier) ++ ",\"cityHp\":" ++ jnum cityHp ++ ",\"damage\":3}" ++
  ",\"theorems\":" ++ theoremsJson ++
  ",\"init\":" ++ stateJson initial ++
  ",\"blocks\":" ++ jarr (blocks.map blockJson) ++
  ",\"expect\":{\"commit\":" ++ jstr (hex16 (headHash initial blocks)) ++
      ",\"genesis\":" ++ jstr (hex16 (genesisHash initial)) ++ "}}"

/-! ## The index page -/

def pad3 (n : Nat) : String :=
  let s := toString n
  String.ofList (List.replicate (3 - s.length) '0') ++ s

def moveText : Move → String
  | .march i d => "march " ++ toString i ++ " " ++
      (match d with | .north => "north" | .south => "south" | .west => "west" | .east => "east")
  | .strike i d => "strike " ++ toString i ++ " " ++
      (match d with | .north => "north" | .south => "south" | .west => "west" | .east => "east")
  | .gather i => "gather " ++ toString i
  | .found i => "found " ++ toString i
  | .train c k => "train city " ++ toString c ++ " " ++
      (match k with | .worker => "worker" | .soldier => "soldier")
  | .endTurn => "end turn"

def indexHtml (blocks : List Block) : String :=
  let rows := (List.range (blocks.length + 1)).map fun n =>
    let bs := blocks.take n
    let mv := if n = 0 then "the opening position" else moveText (blocks[n-1]!).mv
    let who := if n = 0 then "" else
      (if ((trace initial demo)[n-1]!).active = 0 then "Red" else "Blue")
    "<tr><td><a href=\"realm/move-" ++ pad3 n ++ ".html\">move-" ++ pad3 n ++ ".html</a></td>" ++
    "<td>" ++ who ++ "</td><td>" ++ mv ++ "</td><td class=\"hash\">" ++
    hex16 (headHash initial bs) ++ "</td></tr>"
  "<!DOCTYPE html>\n<html lang=\"en\"><head><meta charset=\"utf-8\">\n" ++
  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n" ++
  "<title>Realm — one static page per move</title>\n<style>\n" ++
  "body{margin:0;background:#11151c;color:#dde5f0;font:14px/1.6 ui-monospace,Menlo,Consolas,monospace}\n" ++
  "header{padding:16px 20px;border-bottom:1px solid #2b3644;background:#1a212b}\n" ++
  "h1{margin:0 0 4px;font-size:18px}main{padding:18px;max-width:1000px}\n" ++
  ".sub{color:#8fa0b6;font-size:12px}\n" ++
  ".card{background:#1a212b;border:1px solid #2b3644;border-radius:8px;padding:12px 16px;margin-bottom:16px}\n" ++
  "h2{font-size:13px;text-transform:uppercase;letter-spacing:.08em;color:#8fa0b6;margin:0 0 8px}\n" ++
  "table{border-collapse:collapse;font-size:12px;width:100%}\n" ++
  "th,td{border:1px solid #2b3644;padding:3px 8px;text-align:left}\n" ++
  ".hash{color:#8fa0b6;font-size:11px}a{color:#7fb2ff}\n" ++
  "ul{margin:6px 0 0 18px}code{color:#c9d6e5}\n</style></head><body>\n" ++
  "<header><h1>REALM — one static page per move</h1>\n" ++
  "<div class=\"sub\">A civilisation-style game whose rules are a Lean definition.  Each move " ++
  "publishes a new self-contained HTML file that carries the whole history — every move and " ++
  "every state hash — verifies itself in the browser, is playable, and writes the next page " ++
  "when you move.  The only thing that has to go on chain is one 64-bit number per page.</div>" ++
  "</header>\n<main>\n" ++
  "<div class=\"card\"><h2>How it works</h2><ul>\n" ++
  "<li>A page is <code>Realm.Page</code>: the opening position and one block per move.  A " ++
  "block is <code>⟨index, move, hash of the previous block, hash of the state after the move⟩</code>.</li>\n" ++
  "<li>Reading a page is <code>Realm.verify</code>: replay the moves against the rules, " ++
  "recompute every hash, follow every link.  It needs nothing but the page.</li>\n" ++
  "<li>Playing a move in the page writes the next page, with one more block and a new head " ++
  "hash.  Host it wherever you like; commit the head hash and stake on it.</li>\n" ++
  "<li>A challenger presents a page; the judge runs the same check.  An honest page is never " ++
  "slashed, and — assuming the hash has no collisions — no other history can answer to the " ++
  "same commitment.</li></ul></div>\n" ++
  "<div class=\"card\"><h2>The published game (Red wins in " ++ toString blocks.length ++
  " moves)</h2>\n<table><tr><th>page</th><th>player</th><th>move</th><th>commitment</th></tr>\n" ++
  String.intercalate "\n" rows ++ "\n</table></div>\n" ++
  "<div class=\"card\"><h2>Where the rules are</h2><div class=\"sub\">" ++
  "<code>RequestProject/Realm.lean</code> — the game; " ++
  "<code>RequestProject/RealmWF.lean</code> — what a move may and may not do; " ++
  "<code>RequestProject/RealmChain.lean</code> — the encoding, the hash, the chain; " ++
  "<code>RequestProject/RealmPage.lean</code> — pages, staking and slashing; " ++
  "<code>RequestProject/RealmDemo.lean</code> — this game.  See <code>REALM.md</code>." ++
  "</div></div>\n</main></body></html>\n"

/-! ## Writing the files -/

def main : IO Unit := do
  let template ← IO.FS.readFile "scripts/realm_template.html"
  let blocks := record initial demo
  IO.FS.createDirAll "realm"
  for n in List.range (blocks.length + 1) do
    let bs := blocks.take n
    let page := template.replace "__CHAIN_DATA__" (chainData n bs)
    IO.FS.writeFile ("realm/move-" ++ pad3 n ++ ".html") page
  IO.FS.writeFile "realm.html" (indexHtml blocks)
  IO.println s!"wrote {blocks.length + 1} pages into realm/ and realm.html"
  IO.println s!"genesis {hex16 (genesisHash initial)}"
  IO.println s!"head    {hex16 (headHash initial blocks)}"
