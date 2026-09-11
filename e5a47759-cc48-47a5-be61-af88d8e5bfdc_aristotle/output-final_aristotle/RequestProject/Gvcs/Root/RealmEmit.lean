import RequestProject.Gvcs.Realm.Page
import RequestProject.Gvcs.Realm.Play

/-!
# The Realm extractor

`lake exe realm [dir]` writes the game out of the Lean development:

* `realm.html` — the game as one self-contained page, standing at the end of the
  scripted opening below;
* `realm-000.html` … `realm-0NN.html` — the same game one move at a time, which
  is what a pair of players would end up hosting: one static page per move, each
  carrying every position before it and the digest that commits to them;
* `realm-vale-wealth.html`, `realm-horde-wealth.html`, `realm-vale-siege.html` —
  the three finished games of `RequestProject/Realm/Play.lean`, each one a
  single page carrying the whole transcript, so that a victory by wealth for
  either side and a victory by conquest can be replayed in the browser;
* `realm-vectors.json` — what Lean says: the positions after every move in the
  canonical form the page prints, the digest after every move, and a tampered
  transcript together with the index of the first move that breaks a rule, for
  `realm-test.mjs` to check the page's JavaScript against.

The default directory is `web`.
-/

open LifeTrac LifeTrac.Realm

/-- A scripted opening: three turns a side, checked legal by `openingLegal`. -/
def openingScript : List Move :=
  [ -- the Ash Vale
    .march 49 1, .gather 54, .march 57 1, .endTurn,
    -- the Iron Horde
    .gather 9, .march 14 2, .march 6 2, .endTurn,
    -- the Ash Vale
    .gather 50, .build 54 .farm, .march 58 1, .endTurn,
    -- the Iron Horde
    .gather 9, .gather 22, .march 14 1, .endTurn,
    -- the Ash Vale
    .march 54 1, .train 54 .worker, .gather 50, .endTurn]

/-- The prefixes of the opening: one page each. -/
def prefixes : List (List Move) :=
  (List.range (openingScript.length + 1)).map (fun k => openingScript.take k)

/-- A string as a JSON string. -/
def jsonStr (s : String) : String := "\"" ++ s.replace "\"" "\\\"" ++ "\""

/-- A list of strings as a JSON array. -/
def jsonArr (l : List String) : String := "[" ++ String.intercalate "," l ++ "]"

/-- The digest after each prefix. -/
def digests : List Nat := prefixes.map chainDigest

/-- A transcript with the last move swapped for one that breaks a rule: the
Ash Vale marching a piece that is not theirs. -/
def tampered : List Move := openingScript.dropLast ++ [Move.march 9 2]

/-- The three finished games, with the file each is written to. -/
def finishedGames : List (String × List Move) :=
  [("realm-vale-wealth", valeWealth),
   ("realm-horde-wealth", hordeWealth),
   ("realm-vale-siege", valeSiege)]

/-- A finished game as a JSON object: what Lean says the page must agree with. -/
def finishedJson (nm : String) (ms : List Move) : String :=
  let st := run ms
  "{\"name\": " ++ jsonStr nm ++ ", \"codes\": " ++ jsNats (ms.map Move.code) ++
  ", \"state\": " ++ jsonStr ((st.map stateJson).getD "none") ++
  ", \"digest\": " ++ jsonStr (toString (chainDigest ms)) ++
  ", \"winner\": " ++ (match st.bind winner with
      | none => "-1" | some b => if b then "1" else "0") ++
  ", \"aliveVale\": " ++ toString ((st.map (fun s => alive s false)).getD 0) ++
  ", \"aliveHorde\": " ++ toString ((st.map (fun s => alive s true)).getD 0) ++ "}"

/-! ## What the page's input layer must agree with -/

/-- Drags and stick deflections to check the page's `axisDir` against, each
`(dx, dy, dead)`. -/
def axisSamples : List (Int × Int × Nat) :=
  [(0, 0, 24), (10, 0, 24), (24, 24, 24), (25, 0, 24), (-25, 0, 24), (0, -25, 24),
   (0, 25, 24), (30, 30, 24), (-30, 30, 24), (30, -30, 24), (-30, -30, 24),
   (100, 99, 24), (-100, 99, 24), (99, -100, 24), (7, -60, 10), (60, 7, 10),
   (0, 0, 0), (1, 0, 0), (0, 1, 0), (-1, 0, 0), (0, -1, 0), (250, 240, 240)]

/-- Every intent a page can carry. -/
def allIntents : List Intent :=
  (List.range 4).map Intent.march ++ (List.range 4).map Intent.strike ++
  [.gather, .build .farm, .build .barracks, .train .worker, .train .soldier, .endTurn, .undo] ++
  (List.range boardN).map Intent.select

/-- A run of intents from the opening: taps, swipes, a macro's worth of
actions, and four that the rules must refuse (marching with nothing chosen,
gathering on the other side's worker, marching from a tile whose piece has
already walked on, and — once a turn has been taken back — gathering with a
worker whose side is no longer the one to move). -/
def intentScript : List Intent :=
  [ .march 0,                          -- nothing is chosen: refused
    .select 49, .march 0,              -- a worker of the Ash Vale steps north
    .select 54, .gather,               -- and another works its tile
    .select 9, .gather,                -- the Iron Horde's worker: refused
    .select 57, .march 3,              -- a third piece steps west
    .select 57, .march 0,              -- it has walked on: nothing at 57 now, refused
    .endTurn,
    .select 9, .gather,                -- now it is the Horde's turn, so this stands
    .endTurn,
    .undo,                             -- take that turn back
    .select 41, .gather ]              -- an Ash worker, but it is the Horde's move: refused

/-- The session the script arrives at. -/
def scriptSession : Session := runIntents ⟨[], none⟩ intentScript

/-- Expanding each macro of the book the page ships with. -/
def macroExpansions : List (List Intent) :=
  (List.range defaultBook.length).map (fun i => expand defaultBook macroFuel [Step.call i])

/-- What each binding of the layout expands to. -/
def pressExpansions : List (List Intent) :=
  defaultKeymap.map (fun e => expand defaultBook macroFuel [e.2])

/-- A list of naturals as a JSON array. -/
def jsonNats (l : List Nat) : String := "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- The input vectors: what Lean's `RequestProject/Realm/Input.lean` says, for
`web/input-test.mjs` to hold the page's JavaScript to. -/
def inputJson : String :=
  let axis := axisSamples.map (fun t =>
    "[" ++ toString t.1 ++ "," ++ toString t.2.1 ++ "," ++ toString t.2.2 ++ "," ++
      (match axisDir t.1 t.2.1 t.2.2 with | none => "-1" | some d => toString d) ++ "]")
  "{\n  \"config\": " ++ defaultConfigJson ++ ",\n" ++
  "  \"axis\": [" ++ String.intercalate "," axis ++ "],\n" ++
  "  \"intents\": " ++ jsonNats (allIntents.map Intent.code) ++ ",\n" ++
  "  \"script\": " ++ jsonNats (intentScript.map Intent.code) ++ ",\n" ++
  "  \"scriptMoves\": " ++ jsonNats (scriptSession.moves.map Move.code) ++ ",\n" ++
  "  \"scriptSel\": " ++ (match scriptSession.sel with | none => "-1" | some p => toString p) ++
    ",\n" ++
  "  \"scriptValid\": " ++ (if valid scriptSession.moves then "true" else "false") ++ ",\n" ++
  "  \"scriptState\": " ++ jsonStr (((run scriptSession.moves).map stateJson).getD "none") ++
    ",\n" ++
  "  \"macros\": [" ++ String.intercalate ","
      (macroExpansions.map (fun l => jsonNats (l.map Intent.code))) ++ "],\n" ++
  "  \"press\": [" ++ String.intercalate ","
      (pressExpansions.map (fun l => jsonNats (l.map Intent.code))) ++ "]\n }"

/-- The whole vector file. -/
def vectorsJson : String :=
  let states := prefixes.map (fun ms => (run ms).map stateJson)
  "{\n \"terrain\": " ++ jsNats terrainCodes ++ ",\n" ++
  " \"genesis\": " ++ jsonStr (stateJson genesis) ++ ",\n" ++
  " \"codes\": " ++ jsNats (openingScript.map Move.code) ++ ",\n" ++
  " \"text\": " ++ jsonArr (openingScript.map (fun m => jsonStr (moveText m))) ++ ",\n" ++
  " \"valid\": " ++ (if valid openingScript then "true" else "false") ++ ",\n" ++
  " \"states\": " ++ jsonArr (states.map (fun o => jsonStr (o.getD "none"))) ++ ",\n" ++
  " \"digests\": " ++ jsonArr (digests.map (fun d => jsonStr (toString d))) ++ ",\n" ++
  " \"tampered\": " ++ jsNats (tampered.map Move.code) ++ ",\n" ++
  " \"tamperedBad\": " ++ toString ((firstBad tampered).getD 999) ++ ",\n" ++
  " \"tamperedCulprit\": " ++ (match culprit tampered with
      | none => "-1" | some b => if b then "1" else "0") ++ ",\n" ++
  " \"settleTampered\": " ++ (let r := settle tampered 10
      "[" ++ toString r.1 ++ "," ++ toString r.2 ++ "]") ++ ",\n" ++
  " \"settleHonest\": " ++ (let r := settle openingScript 10
      "[" ++ toString r.1 ++ "," ++ toString r.2 ++ "]") ++ ",\n" ++
  " \"finished\": " ++ jsonArr (finishedGames.map (fun g => finishedJson g.1 g.2)) ++ ",\n" ++
  " \"input\": " ++ inputJson ++ "\n}\n"

/-- `000`-style page numbers. -/
def pad3 (n : Nat) : String :=
  let s := toString n
  if s.length ≥ 3 then s else "".pushn '0' (3 - s.length) ++ s

/-- Write the pages and the vectors. -/
def main (args : List String) : IO Unit := do
  let dir := args[0]? |>.getD "web"
  IO.FS.createDirAll dir
  if !valid openingScript then
    throw (IO.userError "the scripted opening is not legal")
  let mut i := 0
  for ms in prefixes do
    IO.FS.writeFile (dir ++ "/realm-" ++ pad3 i ++ ".html") (realmPage ms)
    i := i + 1
  IO.FS.writeFile (dir ++ "/realm.html") (realmPage openingScript)
  for (nm, ms) in finishedGames do
    if !valid ms then
      throw (IO.userError s!"the finished game {nm} is not legal")
    IO.FS.writeFile (dir ++ "/" ++ nm ++ ".html") (realmPage ms)
  IO.FS.writeFile (dir ++ "/realm-vectors.json") vectorsJson
  IO.println s!"wrote {dir}/realm.html ({(realmPage openingScript).length} characters), \
{prefixes.length} numbered pages and {dir}/realm-vectors.json"
  IO.println s!"wrote {finishedGames.length} finished games"
  IO.println s!"the digest of the opening is 0x{String.ofList (Nat.toDigits 16 (chainDigest openingScript))}"
