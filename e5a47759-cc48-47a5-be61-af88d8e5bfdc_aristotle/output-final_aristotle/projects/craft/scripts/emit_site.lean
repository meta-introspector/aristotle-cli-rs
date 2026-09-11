import RequestProject.GameEmit

/-!
Emits the payload of `index.html`:

* the hopper daemon (TypeScript source, emitted Lua, syntax tree, both
  encrypted with the Lean cipher);
* the game's level, starting position, winning play and final position;
* a table of test vectors — inputs together with the answers Lean's own
  functions give — that the page replays against its JavaScript transcriptions.

Usage, from the project root:

    lake build RequestProject.GameEmit
    lake env lean --run scripts/emit_site.lean > /tmp/site.txt
    python3 scripts/build_site.py /tmp/site.txt index.html
-/

open Factory Hopper CCLua

/-- JSON string literal with escaping (the vectors contain backslashes). -/
def esc (s : String) : String :=
  "\"" ++ String.ofList (s.toList.flatMap (fun c =>
    if c = '"' then ['\\', '"'] else if c = '\\' then ['\\', '\\'] else [c])) ++ "\""

def bytesLit (bs : List UInt8) : String :=
  "[" ++ String.intercalate "," (bs.map (fun b => toString b.toNat)) ++ "]"

/-- One test vector. -/
def vec (fn : String) (args : List String) (out : String) : String :=
  jobj [("fn", esc fn), ("args", jarr args), ("out", out)]

def jbool (b : Bool) : String := if b then "true" else "false"

def jopt : Option ℕ → String
  | none => "null"
  | some n => toString n

open CCFileSystem in
def fsVectors : List String :=
  let sanitizeIn := ["/a//./b/", "a/b/../c", "..", "../secret", "a\\b\\c", "rom/programs/",
    "./x/././y", "a/../../b", "disk/factory/orders/../pending", "he*llo?/x"]
  let combineIn := [("disk/factory", "orders"), ("disk/factory", "../secret"),
    ("", "rom/programs"), ("a/b", "../../c"), ("rom", "programs/shell.lua")]
  let containsIn := [("rom", "rom/programs"), ("rom", "rom/../secret"), ("", "a/b"),
    ("", ".."), ("disk/factory", "disk/factory/orders"), ("disk/factory", "disk")]
  sanitizeIn.map (fun p => vec "sanitize" [esc p] (esc (String.ofList (sanitizeL false p.toList))))
  ++ combineIn.map (fun p =>
      vec "combine" [esc p.1, esc p.2] (esc (String.ofList (combineL p.1.toList p.2.toList))))
  ++ containsIn.map (fun p =>
      vec "contains" [esc p.1, esc p.2] (jbool (containsL p.1.toList p.2.toList)))
  ++ ["disk/factory/orders", "rom/programs/shell.lua", "a"].flatMap (fun p =>
      [vec "getDirectory" [esc p] (esc (String.ofList (getDirectoryL p.toList))),
       vec "getName" [esc p] (esc (String.ofList (getNameL p.toList)))])
  ++ [("rom/programs/shell.lua", "rom"), ("disk/factory/orders", "disk/factory")].map (fun p =>
      vec "toLocal" [esc p.1, esc p.2] (esc (String.ofList (toLocalL p.1.toList p.2.toList))))

def globVectors : List String :=
  let cases := [("", "minecraft:stone"), ("*", "minecraft:stone"),
    ("minecraft:*", "minecraft:stone"), ("mekanism:*|minecraft:*", "minecraft:stone"),
    ("mekanism:*|*:dirt", "minecraft:stone"), ("*dust*", "mekanism:dust_iron"),
    ("minecraft:iron*", "minecraft:iron_ingot"), ("minecraft:iron*", "minecraft:dirt"),
    ("*ingot|*nugget", "minecraft:gold_nugget"), ("a*b*c", "axxbyyc")]
  cases.map (fun p => vec "glob" [esc p.1, esc p.2] (jopt (HopperGlob.globStr p.1 p.2)))

open CCColors in
def colorVectors : List String :=
  [vec "colors.combine" ["1", "2"] (toString (combine 1 2)),
   vec "colors.combine" ["6", "8"] (toString (combine 6 8)),
   vec "colors.subtract" ["7", "2"] (toString (subtract 7 2)),
   vec "colors.subtract" ["6", "6"] (toString (subtract 6 6)),
   vec "colors.test" ["6", "2"] (jbool (test 6 2)),
   vec "colors.test" ["6", "8"] (jbool (test 6 8)),
   vec "colors.packRGB" ["240", "240", "240"] (toString (packRGB8 240 240 240)),
   vec "colors.unpackRGB" ["15790320"]
     (let p := unpackRGB8 15790320; jarr [toString p.1, toString p.2.1, toString p.2.2]),
   vec "colors.toBlit" ["10"] (esc (String.ofList [toBlitIdx 10])),
   vec "colors.toBlit" ["15"] (esc (String.ofList [toBlitIdx 15]))]

open ClaimLifecycle in
def claimVectors : List String :=
  let all : List Status := [.created, .inTransit, .arrived, .delivering, .completed,
    .failed, .expired]
  all.flatMap (fun s => all.map (fun t =>
    vec "claim.allowed" [jsonStatus s, jsonStatus t] (jbool (allowed s t))))

def hopperVectors : List String :=
  let limit : Item → ℕ := fun _ => 64
  let net : Network :=
    [[some ⟨"minecraft:cobblestone", 50⟩, none],
     [some ⟨"minecraft:cobblestone", 30⟩, some ⟨"minecraft:dirt", 5⟩]]
  [vec "hopper.push" [jsonNet net, "0", "0", "1", "0", "64"]
     (match pushStep limit net 0 0 1 0 64 with
      | none => "null"
      | some (k, net') => jarr [toString k, jsonNet net']),
   vec "hopper.push" [jsonNet net, "0", "0", "1", "1", "64"]
     (match pushStep limit net 0 0 1 1 64 with
      | none => "null"
      | some (k, net') => jarr [toString k, jsonNet net']),
   vec "hopper.push" [jsonNet net, "0", "0", "0", "1", "64"]
     (match pushStep limit net 0 0 0 1 64 with
      | none => "null"
      | some (k, net') => jarr [toString k, jsonNet net'])]

/-- Plays of the game, with the position Lean's `run` reaches for each.  The
first argument is the index of the level the play is made on. -/
def gameVectors : List String :=
  let plays1 : List (List Move) :=
    [ solution1,
      [.setFilter "*", .push 0 0 2 0 40],
      [.wire 2 true, .setFilter "minecraft:iron*", .push 0 1 2 0 12],
      [.advance ClaimLifecycle.Status.completed],
      [.cd ".."],
      [.cd "orders/../.."],
      [.cd "orders/../pending"],
      [.wire 1 true, .runDaemon 50],
      [.runDaemon 50],
      [.wire 1 true, .wire 2 true, .setFilter "*", .runDaemon 50, .push 1 1 2 1 12] ]
  let plays2 : List (List Move) :=
    [ solution2,
      [.wire 1 true, .runDaemon 50, .setFilter "*ingot_osmium|*ingot", .wire 3 true,
       .push 1 1 3 1 20],
      [.wire 1 true, .runDaemon 50, .wire 1 false, .setFilter "*", .push 1 0 3 0 30],
      [.cd "orders/osmium"],
      [.wire 3 true, .setFilter "*", .push 2 0 3 0 64] ]
  plays1.map (fun ms =>
    vec "game.run" ["0", jsonMoves ms]
      (match run level1 start1 ms with
       | none => "null"
       | some st => jsonState st))
  ++ plays2.map (fun ms =>
    vec "game.run" ["1", jsonMoves ms]
      (match run level2 start2 ms with
       | none => "null"
       | some st => jsonState st))

def main : IO Unit := do
  IO.println "=== TS ==="
  IO.println daemonTSText
  IO.println "=== LUA ==="
  IO.println daemonText
  IO.println "=== TREE ==="
  IO.println daemonJson
  IO.println "=== SEED ==="
  IO.println siteSeed
  IO.println "=== LUAENC ==="
  IO.println (bytesLit daemonTextEnc)
  IO.println "=== TREEENC ==="
  IO.println (bytesLit daemonJsonEnc)
  IO.println "=== LEVELS ==="
  IO.println levelsJson
  IO.println "=== VECTORS ==="
  IO.println (jarr (fsVectors ++ globVectors ++ colorVectors ++ claimVectors ++
    hopperVectors ++ gameVectors))
