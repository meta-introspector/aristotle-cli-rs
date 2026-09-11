import RequestProject.Nix.NixWars.Trade.Sync
import RequestProject.Nix.NixWars.Trade.Nft

/-!
# The tables the merged page carries

`www/frontier-voxel.html` merges the frontier run with the voxel view, and it
does not carry a single hand-written number: everything it draws — the goods,
the eight ports and where they stand in the `71 × 59 × 47` box, the price
board, the production circuit, the parts catalogue, the ships on the shelf,
the demo recording and its hash chain, the token registry and the sync — is
emitted here from the definitions the theorems are about.

The golden vectors (`demoStates`, `demoChain`, the price boards, the registry
snapshots) are what the page and `www/frontier-voxel-selftest.mjs` check their
own JavaScript against, step by step: if the two ever disagree, the page says
so before it lets anyone fly.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade
namespace Page

/-! ## Printing -/

/-- A list of numbers as a JSON array. -/
def jNats (l : List Nat) : String := "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- A list of lists of numbers as JSON. -/
def jNats2 (l : List (List Nat)) : String :=
  "[" ++ String.intercalate ",\n" (l.map jNats) ++ "]"

/-- Three deep. -/
def jNats3 (l : List (List (List Nat))) : String :=
  "[" ++ String.intercalate ",\n" (l.map jNats2) ++ "]"

/-- A list of strings as a JSON array. -/
def jStrs (l : List String) : String :=
  "[" ++ String.intercalate "," (l.map (fun s => "\"" ++ s ++ "\"")) ++ "]"

/-! ## The market -/

/-- The eight ports, with the cell each stands on in the voxel box. -/
def portsJson : String :=
  "[" ++ String.intercalate ",\n" (ports.map (fun p =>
    "{\"name\":\"" ++ p.name ++ "\",\"cell\":" ++
      jNats [(portCell p).1, (portCell p).2.1, (portCell p).2.2] ++
      ",\"start\":" ++ jNats p.start ++ ",\"inputs\":" ++ jNats p.inputs ++
      ",\"out\":" ++ toString p.output ++ "}")) ++ "]"

/-- The price board of the first four production rounds, computed in Lean. -/
def priceBoardsJson : String :=
  jNats3 [priceBoard initialEconomy, priceBoard (tick initialEconomy),
    priceBoard (tick (tick initialEconomy)),
    priceBoard (tick (tick (tick initialEconomy)))]

/-- The production circuit as an edge list. -/
def circuitJson : String :=
  jNats2 (circuitEdges.map (fun e => [e.1, e.2]))

/-- What a hold of five ORE and two RELICS fetches at each of the eight ports:
the same load, eight different values. -/
def cargoValuesJson : String :=
  jNats ((List.range numPorts).map (fun i => cargoValue initialEconomy i [5, 0, 0, 0, 2]))

/-! ## The shipyard -/

/-- One part of the catalogue. -/
def partJson (p : Part) : String :=
  "{\"slot\":" ++ toString p.slot ++ ",\"name\":\"" ++ p.name ++ "\",\"mass\":" ++
    toString p.mass ++ ",\"cost\":" ++ toString p.cost ++ ",\"frame\":" ++ toString p.frame ++
    ",\"thrust\":" ++ toString p.thrust ++ ",\"tank\":" ++ toString p.tankCap ++
    ",\"hold\":" ++ toString p.holdCap ++ "}"

/-- The whole catalogue. -/
def partsJson : String :=
  "[" ++ String.intercalate ",\n" (partCatalog.map partJson) ++ "]"

/-- A build, with the number that is the build and the statistics Lean reads
off it. -/
def specJson (s : ShipSpec) : String :=
  "{\"name\":\"" ++ s.name ++ "\",\"hull\":" ++ toString s.hull ++ ",\"engine\":" ++
    toString s.engine ++ ",\"tank\":" ++ toString s.tank ++ ",\"hold\":" ++ toString s.hold ++
    ",\"livery\":" ++ toString s.livery ++ ",\"hue\":" ++ toString s.hue ++ ",\"code\":" ++
    toString (encodeSpec s) ++ ",\"stats\":" ++
    jNats [(shipStats s).maxSpeed, (shipStats s).tank, (shipStats s).hold, (shipStats s).mass,
      (shipStats s).cost] ++ ",\"print\":" ++ toString (fingerprint s) ++ "}"

/-- The six ships on the shelf. -/
def stockShipsJson : String :=
  "[" ++ String.intercalate ",\n" (stockShips.map specJson) ++ "]"

/-! ## The demo voyage -/

/-- A voyage as numbers, for the page to check itself against. -/
def voySummary (s : Voyage) : List Nat :=
  [s.x, s.y, s.z, s.hdg, s.speed, s.fuel, s.docked, s.credits, s.turn, s.econ.round] ++
    s.hold ++ s.econ.stocks.flatten

/-- The state after every prefix of the demo run. -/
def demoStates : List (List Nat) :=
  (List.range (tradeRun.length + 1)).map
    (fun k => voySummary (voyageRun demoVoyage (tradeRun.take k)))

/-- The demo run's commands, as numbers. -/
def demoCmdsJson : String := jNats (tradeRun.map encodeCmd)

/-- The states the demo run passes through. -/
def demoStatesJson : String := jNats2 demoStates

/-- Its hash chain and commitment. -/
def demoChainJson : String := jNats demoLog.chain

/-! ## The registry -/

/-- One token. -/
def tokenJson (t : Token) : String :=
  "{\"id\":" ++ toString t.id ++ ",\"code\":" ++ toString (encodeSpec t.spec) ++
    ",\"name\":\"" ++ t.spec.name ++ "\",\"owner\":" ++ toString t.owner ++
    ",\"ask\":" ++ toString t.ask ++ "}"

/-- A registry. -/
def yardJson (y : Yard) : String :=
  "{\"tokens\":[" ++ String.intercalate "," (y.tokens.map tokenJson) ++ "],\"next\":" ++
    toString y.next ++ ",\"balances\":" ++ jNats y.balances ++ "}"

/-! ## The whole data block -/

/-- Every table the page carries. -/
def frontierVoxelData : String :=
  "const GOODS = " ++ jStrs goodNames ++ ";\n" ++
  "const BASE = " ++ jNats baseValues ++ ";\n" ++
  "const STOCKREF = " ++ toString stockRef ++ ";\n" ++
  "const RATE = " ++ toString rate ++ ";\n" ++
  "const FUELGOOD = " ++ toString fuelGood ++ ";\n" ++
  "const FUELPERUNIT = " ++ toString fuelPerUnit ++ ";\n" ++
  "const BOX = " ++ jNats boxAxes ++ ";\n" ++
  "const PORTS = " ++ portsJson ++ ";\n" ++
  "const PRICE_BOARDS = " ++ priceBoardsJson ++ ";\n" ++
  "const CIRCUIT = " ++ circuitJson ++ ";\n" ++
  "const CARGO_VALUES = " ++ cargoValuesJson ++ ";\n" ++
  "const PARTS = " ++ partsJson ++ ";\n" ++
  "const STOCK_SHIPS = " ++ stockShipsJson ++ ";\n" ++
  "const LEGAL_BUILDS = " ++ toString (allBuilds.filter (fun s => decide (ShipOk s))).length ++
    ";\n" ++
  "const ALL_BUILDS = " ++ toString allBuilds.length ++ ";\n" ++
  "const DEMO_SHIP = " ++ toString demoLog.ship ++ ";\n" ++
  "const DEMO_CMDS = " ++ demoCmdsJson ++ ";\n" ++
  "const DEMO_STATES = " ++ demoStatesJson ++ ";\n" ++
  "const DEMO_CHAIN = " ++ demoChainJson ++ ";\n" ++
  "const DEMO_COMMIT = " ++ toString demoLog.commit ++ ";\n" ++
  "const DEMO_SAVED = \"" ++ saveLog demoLog ++ "\";\n" ++
  "const HASH_PRIME = " ++ toString hashPrime ++ ";\n" ++
  "const HASH_BASE = " ++ toString hashBase ++ ";\n" ++
  "const URL_TABLE = \"" ++
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_" ++ "\";\n" ++
  "const URL_PREFIX = \"https://bbs.8080.monster/nixwars#\";\n" ++
  "const NUMPLAYERS = " ++ toString numPlayers ++ ";\n" ++
  "const DEMO_YARD = " ++ yardJson demoYard ++ ";\n" ++
  "const DEMO_SALE = " ++ yardJson demoSale ++ ";\n" ++
  "const DEMO_SWAP = " ++ yardJson demoSwap ++ ";\n" ++
  "const SYNC_FORK = " ++ toString (firstDiff demoMine.cmds demoOther.cmds) ++ ";\n" ++
  "const SYNC_THEIRS = " ++ jNats (demoTheirs.cmds.map encodeCmd) ++ ";\n" ++
  "const SYNC_OTHER = " ++ jNats (demoOther.cmds.map encodeCmd) ++ ";\n" ++
  "const UUCP_NODES = " ++ toString Foundry.uucpNodes ++ ";\n" ++
  "const UUCP_ROUTE = " ++ jNats (Foundry.uucpRoute 0 5) ++ ";\n" ++
  "const UUCP_PATH = \"" ++ Foundry.bangPath 0 5 "player" ++ "\";\n" ++
  "const MINTOUCH = 44;\n"

end Page
end Trade
end NixWars
