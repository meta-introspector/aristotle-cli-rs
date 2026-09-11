import RequestProject.Craft.Game

/-!
# The payload of the demo site

`index.html` is generated from what this file emits: the hopper daemon's
TypeScript source, the Lua the verified compiler produced for it, that program's
syntax tree, both of them encrypted with the Lean stream cipher, and the level,
starting position, winning play and resulting position of the game of
`RequestProject.Game`, all serialised as JSON.

The site also carries a table of *test vectors* — inputs together with the
answers Lean's own functions give for them — so the page can check its
JavaScript transcriptions against the Lean model at load time.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Factory

open Hopper CCLua

/-! ## JSON serialisation of the game -/

/-- A JSON string literal (no escaping is needed: every string in the
development is an item id, a path or a glob pattern). -/
def jq (s : String) : String := "\"" ++ s ++ "\""

/-- A list of already-serialised values as a JSON array. -/
def jarr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"

/-- A JSON object from already-serialised fields. -/
def jobj (fs : List (String × String)) : String :=
  "{" ++ String.intercalate "," (fs.map (fun p => jq p.1 ++ ":" ++ p.2)) ++ "}"

/-- A slot, as `null` or `["item", count]`. -/
def jsonSlot : Slot → String
  | none => "null"
  | some st => jarr [jq st.item, toString st.count]

/-- An inventory. -/
def jsonInv (inv : Inventory) : String := jarr (inv.map jsonSlot)

/-- A network of inventories. -/
def jsonNet (net : Network) : String := jarr (net.map jsonInv)

/-- A claim status. -/
def jsonStatus : ClaimLifecycle.Status → String
  | .created => jq "created"
  | .inTransit => jq "inTransit"
  | .arrived => jq "arrived"
  | .delivering => jq "delivering"
  | .completed => jq "completed"
  | .failed => jq "failed"
  | .expired => jq "expired"

/-- A claim. -/
def jsonClaim (c : ClaimLifecycle.Claim) : String :=
  jobj [("status", jsonStatus c.status), ("history", jarr (c.history.map jsonStatus))]

/-- A game state. -/
def jsonState (st : GameState) : String :=
  jobj [("net", jsonNet st.net), ("gates", toString st.gates),
        ("claim", jsonClaim st.claim), ("cwd", jq (String.ofList st.cwd)),
        ("filter", jq st.filter), ("moved", toString st.moved)]

/-- A level.  The stack limit is emitted at the level's target item, which is
all the page needs (every level in the demo uses a constant limit). -/
def jsonLevel (lv : Level) : String :=
  jobj [("limit", toString (lv.limit lv.target)), ("root", jq (String.ofList lv.root)),
        ("target", jq lv.target), ("goal", toString lv.goal),
        ("quota", toString lv.quota)]

/-- A move. -/
def jsonMove : Move → String
  | .push a i b j req => jarr [jq "push", toString a, toString i, toString b,
      toString j, toString req]
  | .wire k on => jarr [jq "wire", toString k, if on then "true" else "false"]
  | .setFilter p => jarr [jq "setFilter", jq p]
  | .cd p => jarr [jq "cd", jq p]
  | .advance t => jarr [jq "advance", jsonStatus t]
  | .runDaemon f => jarr [jq "runDaemon", toString f]

/-- A play. -/
def jsonMoves (ms : List Move) : String := jarr (ms.map jsonMove)

/-! ## The daemon's payload -/

/-- The daemon's TypeScript source, printed. -/
def daemonTSText : String := printTS 0 daemonTS

/-- The Lua text the compiler emitted for the daemon. -/
def daemonText : String := printS 0 daemon

/-- The daemon's syntax tree, as JSON — this is what the page interprets. -/
def daemonJson : String := jsonS daemon

/-- The key-stream seed of the site payload. -/
def siteSeed : ℕ := 20260901

/-- The encrypted Lua text. -/
def daemonTextEnc : List UInt8 := cipher siteSeed daemonText.toUTF8.toList

/-- The encrypted syntax tree. -/
def daemonJsonEnc : List UInt8 := cipher siteSeed daemonJson.toUTF8.toList

/-- **What the site decrypts is the Lua text Lean printed.** -/
theorem daemonTextEnc_decrypt : cipher siteSeed daemonTextEnc = daemonText.toUTF8.toList :=
  cipher_involutive siteSeed _

/-- **What the site runs is the syntax tree Lean serialised.** -/
theorem daemonJsonEnc_decrypt : cipher siteSeed daemonJsonEnc = daemonJson.toUTF8.toList :=
  cipher_involutive siteSeed _

/-! ## The levels the site ships -/

/-- A level, its starting position, a winning play, and the position that play
reaches (`null` if it were rejected, which `solution1_wins` / `solution2_wins`
rule out). -/
def jsonPack (name blurb : String) (lv : Level) (st : GameState) (ms : List Move) : String :=
  jobj [("name", jq name), ("blurb", jq blurb), ("level", jsonLevel lv),
        ("start", jsonState st), ("solution", jsonMoves ms),
        ("final", match run lv st ms with | none => "null" | some s => jsonState s)]

/-- Both levels of the demo site. -/
def levelsJson : String :=
  jarr
    [jsonPack "Level 1 - first delivery"
       "Power the buffer, run the daemon, filter for iron, and fill the order."
       level1 start1 solution1,
     jsonPack "Level 2 - merge two stacks"
       "The order is larger than any one stack, and the buffer also holds dust the filter must keep out."
       level2 start2 solution2]

end Factory
