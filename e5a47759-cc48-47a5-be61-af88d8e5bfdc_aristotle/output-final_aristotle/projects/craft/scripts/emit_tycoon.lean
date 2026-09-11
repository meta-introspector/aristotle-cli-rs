import RequestProject.TycoonCC

/-!
Emits the payload of `tycoon.html`:

* the three example agent games, as recordings (start position, move list,
  final position) computed **in Lean**;
* a demo factory and the exact SVG document Lean's renderer produces for it,
  and for the final position of the builder's game;
* the strategy database's variations, best score and recommendation at the
  starting position;
* a table of `step` vectors — a position, a move, and the position Lean's
  `GameState.step` produces.

The page replays all of it through its own JavaScript transcription and reports
any disagreement on its Self-check tab.

Usage, from the project root:

    lake build RequestProject.StrategyDB
    lake env lean --run scripts/emit_tycoon.lean > /tmp/tycoon.txt
    python3 scripts/build_tycoon.py /tmp/tycoon.txt tycoon.html
    node scripts/test_tycoon.js tycoon.html
-/

open Tycoon

def esc (s : String) : String :=
  "\"" ++ String.ofList (s.toList.flatMap (fun c =>
    if c = '"' then ['\\', '"'] else if c = '\\' then ['\\', '\\'] else [c])) ++ "\""

def jarr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"

def jobj (fs : List (String × String)) : String :=
  "{" ++ String.intercalate "," (fs.map (fun f => esc f.1 ++ ":" ++ f.2)) ++ "}"

def kindTag : Kind → String
  | .miner => "miner"
  | .smelter => "smelter"
  | .seller => "seller"
  | .belt => "belt"
  | .pillar => "pillar"

def v3J (v : V3) : String := jarr [toString v.x, toString v.y, toString v.z]

def partJ (p : Part) : String := jarr [esc (kindTag p.kind), v3J p.pos]

def actJ : Action → String
  | .place k p => jobj [("t", esc "place"), ("k", esc (kindTag k)), ("p", v3J p)]
  | .remove i => jobj [("t", esc "remove"), ("i", toString i)]
  | .tickWorld => jobj [("t", esc "tick")]
  | .sell n => jobj [("t", esc "sell"), ("n", toString n)]

def stateJ (g : GameState) : String :=
  jobj [("parts", jarr (g.scene.map partJ)), ("cash", toString g.cash),
        ("ore", toString g.ore), ("ingot", toString g.ingot), ("tick", toString g.tick)]

def recJ (name : String) (r : Recording) : String :=
  jobj [("name", esc name), ("init", stateJ r.init),
        ("moves", jarr (r.moves.map actJ)), ("final", stateJ r.final)]

/-- A factory used for the renderer demo: one of every kind. -/
def demoScene : Scene :=
  [⟨.miner, ⟨0, 0, 0⟩⟩, ⟨.smelter, ⟨3, 0, 0⟩⟩, ⟨.seller, ⟨6, 0, 0⟩⟩,
   ⟨.pillar, ⟨0, 0, 3⟩⟩, ⟨.belt, ⟨2, 0, 3⟩⟩, ⟨.miner, ⟨4, 0, 4⟩⟩,
   ⟨.miner, ⟨0, 2, 0⟩⟩]

def stepVectors : List String :=
  let states : List GameState := [startPos, GameState.demoStart,
    GameState.run GameState.demoStart (List.replicate 7 .tickWorld),
    { GameState.demoStart with cash := 0, ingot := 12 }]
  let acts : List Action := [.tickWorld, .sell 3, .sell 100, .place .miner ⟨0, 0, 0⟩,
    .place .miner ⟨10, 0, 10⟩, .place .pillar ⟨15, 15, 15⟩, .remove 0, .remove 9]
  states.flatMap (fun g => acts.map (fun a =>
    jobj [("state", stateJ g), ("action", actJ a), ("out", stateJ (g.step a))]))

def shopJ (name : String) (sh : Shop) : String :=
  jobj [("name", esc name), ("permit", esc sh.permit), ("gates", toString sh.gates),
        ("payout", toString sh.payout), ("root", esc (String.ofList sh.root)),
        ("permits", jarr ([Kind.miner, .smelter, .seller, .belt, .pillar].map (fun k =>
            jarr [esc (kindTag k), esc (Tycoon.kindName k), if sh.permits k then "true" else "false"]))),
        ("payoutOn", if sh.payoutOn then "true" else "false"),
        ("films", jarr (["builder", "../../secret", "runs/one", "a\\b"].map (fun n =>
            jarr [esc n, esc (String.ofList (sh.filmPath n)),
                  if sh.saveOk n then "true" else "false"]))),
        ("steps", jarr ([Action.place .seller ⟨10, 0, 10⟩, .place .miner ⟨10, 0, 10⟩,
              .sell 2, .tickWorld].map (fun a =>
            jobj [("state", stateJ GameState.demoStart), ("action", actJ a),
                  ("out", stateJ (sh.stepCC GameState.demoStart a))])))]

def main : IO Unit := do
  let games : List String :=
    [recJ "idle bot" (Policy.recordOf idleBot startPos 120),
     recJ "frugal bot" (Policy.recordOf frugalBot startPos 120),
     recJ "builder bot" (Policy.recordOf buildBot startPos 120)]
  let vars : List String :=
    (variations demoDB startPos).map (fun mv => jarr [actJ mv.1, toString mv.2])
  IO.println "=== payload ==="
  IO.println (jobj [
    ("games", jarr games),
    ("demoScene", jarr (demoScene.map partJ)),
    ("demoSVG", esc (renderSVG demoScene)),
    ("builderFinalSVG", esc (renderSVG (Policy.simulate buildBot startPos 120).scene)),
    ("startVariations", jarr vars),
    ("startBestScore", toString (bestScore demoDB startPos)),
    ("startBestMove", match bestMove demoDB startPos with
        | none => "null"
        | some m => actJ m),
    ("stepVectors", jarr stepVectors),
    ("frameCount", toString (Policy.recordOf buildBot startPos 120).frames.length),
    ("gridSize", toString V3.gridSize),
    ("maxParts", toString Scene.maxParts),
    ("ingotPrice", toString ingotPrice),
    ("shops", jarr [shopJ "permissive shop" demoShop, shopJ "restricted shop" restrictedShop])
  ])
