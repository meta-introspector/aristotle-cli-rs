import RequestProject.Market

/-!
Emits the payload of `broadcast.html`:

* the trained model — its weights, its score, and the scores of the models and
  agents it was measured against;
* the clip of its game: the SVG frames Lean's own renderer produced, thinned to
  one frame in fifteen, together with their byte sizes;
* the still of the finished factory, and the 280-character update;
* the four books of the betting market, with their settlements, pools, payouts
  and prices, all computed in Lean;
* a table of payout vectors and settlement vectors the page replays through its
  own JavaScript on the Self-check tab.

Usage, from the project root:

    lake build RequestProject.Market
    lake env lean --run scripts/emit_broadcast.lean > /tmp/broadcast.txt
    python3 scripts/build_broadcast.py /tmp/broadcast.txt broadcast.html
    node scripts/test_broadcast.js broadcast.html
-/

open Tycoon
open Tycoon.Broadcast
open Tycoon.Market

def esc (s : String) : String :=
  "\"" ++ String.ofList (s.toList.flatMap (fun c =>
    if c = '"' then ['\\', '"']
    else if c = '\\' then ['\\', '\\']
    else if c = '\n' then ['\\', 'n']
    else [c])) ++ "\""

def jarr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"

def jobj (fs : List (String × String)) : String :=
  "{" ++ String.intercalate "," (fs.map (fun f => esc f.1 ++ ":" ++ f.2)) ++ "}"

def jnat (n : Nat) : String := toString n

def jbool (b : Bool) : String := if b then "true" else "false"

/-- The clip the page carries: one frame in fifteen. -/
def pageStride : Nat := 14

def pageFrames : List String := clipBody trainedGame pageStride

def betJson (x : Bet) : String :=
  jobj [("punter", jnat x.punter), ("yes", jbool x.yes), ("stake", jnat x.stake)]

def bookJson (label : String) (question : String) (b : Book) : String :=
  jobj [("label", esc label),
        ("question", esc question),
        ("bets", jarr (b.bets.map betJson)),
        ("outcome", jbool (b.outcome trainedGame)),
        ("pool", jnat b.pool),
        ("winPool", jnat (b.winPool trainedGame)),
        ("payouts", jarr (b.bets.map (fun x => jnat (b.payout trainedGame x)))),
        ("total", jnat (b.totalPayout trainedGame)),
        ("priceYes", jnat (b.price true)),
        ("priceNo", jnat (b.price false))]

/-- Payout vectors: outcome, pool, winning pool, one bet, and what Lean pays. -/
def payoutVectors : List String :=
  let bets : List Bet := [⟨1, true, 100⟩, ⟨2, false, 300⟩, ⟨3, true, 0⟩, ⟨4, false, 75⟩]
  let cases : List (Bool × Nat × Nat) :=
    [(true, 500, 200), (false, 500, 300), (true, 400, 0), (false, 100, 50),
     (true, 1000, 999), (false, 7, 3)]
  cases.flatMap (fun c =>
    bets.map (fun x =>
      jobj [("out", jbool c.1), ("pool", jnat c.2.1), ("win", jnat c.2.2),
            ("yes", jbool x.yes), ("stake", jnat x.stake),
            ("payout", jnat (payoutIn c.1 c.2.1 c.2.2 x))]))

def games : List (String × Recording) :=
  [("trained", trainedGame),
   ("builder", Policy.recordOf buildBot startPos 120),
   ("frugal", Policy.recordOf frugalBot startPos 120),
   ("idle", Policy.recordOf idleBot startPos 120)]

/-- Settlement vectors: how each attribute settles on each recorded game. -/
def settleVectors : List String :=
  let attrs : List (String × Attr) :=
    [("score>=2000", .score 2000), ("score>=1500", .score 1500),
     ("size>=20", .size 20), ("size>=10", .size 10),
     ("speed 1000 by 60", .speed 1000 60), ("speed 100 by 60", .speed 100 60),
     ("clean", .clean coachedDB)]
  games.flatMap (fun g =>
    attrs.map (fun a =>
      jobj [("game", esc g.1), ("attr", esc a.1),
            ("settled", jbool (settle a.2 g.2))]))

/-- Update vectors: the post each game generates, and its length. -/
def updateVectors : List String :=
  games.map (fun g =>
    let u := updateOf coachedDB g.2
    jobj [("game", esc g.1), ("text", esc (postText u)),
          ("length", jnat (postText u).length),
          ("tick", jnat u.tick), ("cash", jnat u.cash), ("parts", jnat u.parts),
          ("flagged", jnat u.flagged), ("book", jnat u.book)])

def main : IO Unit := do
  IO.println "=== META ==="
  IO.println (jobj [
    ("weights", jobj [("cash", jnat trainedWeights.cash), ("ore", jnat trainedWeights.ore),
       ("ingot", jnat trainedWeights.ingot), ("miner", jnat trainedWeights.miner),
       ("smelter", jnat trainedWeights.smelter), ("seller", jnat trainedWeights.seller)]),
    ("scoreBase", jnat (score startPos 120 baseWeights)),
    ("scorePooled", jnat (score startPos 120 pooledWeights)),
    ("scoreTrained", jnat (score startPos 120 trainedWeights)),
    ("scoreBuildBot", jnat (Policy.simulate buildBot startPos 120).cash),
    ("scoreFrugalBot", jnat (Policy.simulate frugalBot startPos 120).cash),
    ("scoreIdleBot", jnat (Policy.simulate idleBot startPos 120).cash),
    ("blundersTrained", jnat (critique coachedDB trainedGame).length),
    ("blundersIdle", jnat (critique coachedDB (Policy.recordOf idleBot startPos 120)).length),
    ("maxClipBytes", jnat maxClipBytes),
    ("clipStride", jnat (pageStride + 1)),
    ("clipFrames", jnat pageFrames.length),
    ("clipBytes", jnat (bytes (clip trainedGame pageStride))),
    ("fullFilmBytes", jnat (bytes (joinS (filmChunks trainedGame 0)))),
    ("stillBytes", jnat (bytes (still trainedGame.final))),
    ("post", esc (postText trainedUpdate)),
    ("postLength", jnat (postText trainedUpdate).length)])
  IO.println "=== HEADER ==="
  IO.println (esc svgHeader)
  IO.println "=== FOOTER ==="
  IO.println (esc svgFooter)
  IO.println "=== FRAMES ==="
  IO.println (jarr (pageFrames.map esc))
  IO.println "=== FRAMEBYTES ==="
  IO.println (jarr (pageFrames.map (fun f => jnat (bytes f))))
  IO.println "=== STILL ==="
  IO.println (esc (still trainedGame.final))
  IO.println "=== BOOKS ==="
  IO.println (jarr [
    bookJson "score" "Does the game finish with at least 2000 cash?" scoreBook,
    bookJson "size" "Are at least 20 parts standing at the end?" sizeBook,
    bookJson "speed" "Does cash reach 1000 within 60 moves?" speedBook,
    bookJson "clean" "Does the critic flag nothing in the game?" cleanBook])
  IO.println "=== PAYOUTVECTORS ==="
  IO.println (jarr payoutVectors)
  IO.println "=== SETTLEVECTORS ==="
  IO.println (jarr settleVectors)
  IO.println "=== UPDATEVECTORS ==="
  IO.println (jarr updateVectors)
