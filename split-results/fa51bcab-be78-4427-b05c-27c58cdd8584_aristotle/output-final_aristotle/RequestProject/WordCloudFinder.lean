/-
WordCloudFinder.lean — the per-cell "tarot" wordclouds of the Lean periodic table.

This is the executable companion that *decorates* the crystal table of
`RequestProject/PeriodicTable.lean` (and the arrow / fusion structure of
`RequestProject/CFTMorphisms.lean` and `RequestProject/ArrowFinder.lean`) with the
**symbols** that actually live on each branch of the Bott tree.

Every declaration has a crystal cell = the Altland–Zirnbauer real class at residue
`size mod 8`, where `size` is the leaf count of its type (`exprSize`, identical to
`ArrowFinder` / `PeriodicTableFinder` / `SizeSignature.size`).  For each declaration we
read off a multiset of **symbols**:
  * the components of its own name (e.g. `LinearMap`, `comm`, `succ`), and
  * the final components of the constants its *type* references (e.g. `le`, `inv`, `add`).
Each symbol is counted **once per declaration** (so the score is "how many declarations on
this branch mention this symbol").

For every one of the eight real crystal cells we then produce two wordclouds:
  * **top** — the most frequent symbols on that branch (its raw vocabulary), and
  * **distinctive** — the symbols most *over-represented* on that branch relative to the
    whole library (lift = branch-frequency / global-frequency).  These are the symbols that
    give the branch its "tarot card" identity.

Outputs (to the configured output dir, default `./wordcloud-out`):
  * `wordcloud.json` — per-cell `top` and `distinctive` symbol lists with counts/lift.
  * `wordcloud.txt`  — a human-readable rendering of the eight cards.

Usage:
  lake exe wordcloudfinder <Module> <outputDir>
  lake exe wordcloudfinder                       -- reads wordcloud-config.json, else defaults
-/
import Lean

open Lean System

/-- The size signature of an expression: number of leaf sub-terms of the type viewed as a
tree.  Identical to `ArrowFinder.exprSize` and the `Expr` realisation of
`SizeSignature.size`. -/
partial def exprSize : Expr → Nat
  | .bvar _      => 1
  | .fvar _      => 1
  | .mvar _      => 1
  | .sort _      => 1
  | .const _ _   => 1
  | .lit _       => 1
  | .app f a     => exprSize f + exprSize a
  | .lam _ t b _ => exprSize t + exprSize b
  | .forallE _ t b _ => exprSize t + exprSize b
  | .letE _ t v b _  => exprSize t + exprSize v + exprSize b
  | .mdata _ e   => exprSize e
  | .proj _ _ e  => exprSize e

/-- Cartan labels of the eight real Altland–Zirnbauer classes, in Bott-clock order. -/
def realCartanLabels : Array String :=
  #["AI", "BDI", "D", "DIII", "AII", "CII", "C", "CI"]

/-- The crystal cell index (residue `N mod 8`) of a size signature `N`. -/
def cellIndex (N : Nat) : Nat := N % 8

/-- Parse the shared config format (`modules`/`module` + `outputDir`). -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./wordcloud-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./wordcloud-out"
    let modsArr : List String :=
      match j.getObjVal? "modules" with
      | .ok arrJ =>
        match arrJ.getArr? with
        | .ok arr => arr.toList.filterMap (fun x => (x.getStr?).toOption)
        | .error _ => []
      | .error _ => []
    let mods :=
      if modsArr.isEmpty then
        match (j.getObjValAs? String "module").toOption with
        | some m => [m]
        | none => []
      else modsArr
    (mods, out)

/-- Read configuration from CLI args, or `wordcloud-config.json`, else defaults. -/
def readWordCloudConfig (args : List String) : IO (List String × String) := do
  let dflt : List String := ["Mathlib"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "wordcloud-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then dflt else mods, out)
    else
      return (dflt, "./wordcloud-out")
  | [m] => return ([m], "./wordcloud-out")
  | m :: out :: _ => return ([m], out)

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-- Pad a string on the right to width `w`. -/
def padR (s : String) (w : Nat) : String :=
  if s.length >= w then s else s ++ String.ofList (List.replicate (w - s.length) ' ')

/-- Is a string component a usable "symbol"?  Drop empties, single chars, and pure numbers
(anonymous / index components such as `_@`, `0`, `1`, …). -/
def keepToken (s : String) : Bool :=
  s.length ≥ 2 && !(s.all Char.isDigit) && !(s.startsWith "_")

/-- The string components of a `Name` (skipping numeric / anonymous parts). -/
def nameStrTokens (n : Name) : List String :=
  n.components.filterMap fun c =>
    match c with
    | .str _ s => if keepToken s then some s else none
    | _ => none

/-- The "symbol" tokens of one declaration: the components of its own name together with
the final components of the constants referenced in its *type*. -/
def declSymbols (n : Name) (ci : ConstantInfo) : Array String := Id.run do
  let mut seen : Std.HashSet String := {}
  let mut out : Array String := #[]
  -- own name components
  for t in nameStrTokens n do
    if !seen.contains t then seen := seen.insert t; out := out.push t
  -- final components of referenced constants (in the type only)
  for d in ci.type.getUsedConstants do
    match d with
    | .str _ s => if keepToken s && !seen.contains s then seen := seen.insert s; out := out.push s
    | _ => pure ()
  return out

/-- Bump a `HashMap String Nat` count. -/
def bump (m : Std.HashMap String Nat) (k : String) : Std.HashMap String Nat :=
  m.insert k ((m.getD k 0) + 1)

/-- Main: scan declarations, group by crystal cell, and build per-cell symbol clouds. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readWordCloudConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"WordCloudFinder: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- per-cell symbol counts, per-cell declaration counts, and global symbol counts
  let mut cellCounts : Array (Std.HashMap String Nat) := Array.replicate 8 {}
  let mut cellDecls : Array Nat := Array.replicate 8 0
  let mut globalCounts : Std.HashMap String Nat := {}
  let mut globalDecls : Nat := 0
  for (n, ci) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    let c := cellIndex (exprSize ci.type)
    cellDecls := cellDecls.set! c (cellDecls[c]! + 1)
    globalDecls := globalDecls + 1
    let syms := declSymbols n ci
    let mut cc := cellCounts[c]!
    for t in syms do
      cc := bump cc t
      globalCounts := bump globalCounts t
    cellCounts := cellCounts.set! c cc
  IO.println s!"  {globalDecls} declarations across 8 cells"
  for i in List.range 8 do
    IO.println s!"    {realCartanLabels[i]!}: {cellDecls[i]!} decls, {cellCounts[i]!.size} distinct symbols"
  -- thresholds scale with corpus size
  let topN := 40
  let distN := 25
  let minCount := Nat.max 5 (globalDecls / 5000)   -- ignore very rare symbols for "distinctive"
  IO.FS.createDirAll outPath
  -- compute, per cell, top symbols and distinctive symbols
  -- distinctiveness lift = (cellCount/cellDecls) / (globalCount/globalDecls)  (×1000, integer)
  let mut topPerCell : Array (Array (String × Nat)) := Array.replicate 8 #[]
  let mut distPerCell : Array (Array (String × Nat × Nat)) := Array.replicate 8 #[]
  for i in List.range 8 do
    let cc := cellCounts[i]!
    let cd := Nat.max 1 cellDecls[i]!
    let arr := cc.toList.toArray
    -- top by raw count
    let sortedTop := arr.qsort (fun a b => a.2 > b.2)
    topPerCell := topPerCell.set! i (sortedTop.extract 0 topN)
    -- distinctive: lift, restricted to symbols with cellCount ≥ minCount
    let withLift : Array (String × Nat × Nat) := arr.filterMap fun (s, cnt) =>
      if cnt < minCount then none
      else
        let g := Nat.max 1 (globalCounts.getD s 1)
        -- lift ×1000 = (cnt * globalDecls * 1000) / (cd * g)
        let lift := (cnt * globalDecls * 1000) / (cd * g)
        some (s, lift, cnt)
    let sortedDist := withLift.qsort (fun a b => a.2.1 > b.2.1)
    distPerCell := distPerCell.set! i (sortedDist.extract 0 distN)
  -- ===== wordcloud.txt =====
  let mut txt : Array String := #[]
  txt := txt.push "# Tarot wordclouds of the Lean periodic table (per crystal cell / Bott branch)"
  txt := txt.push s!"# {globalDecls} declarations across the 8 real Altland-Zirnbauer cells."
  txt := txt.push "# Each card lists the symbols (name components + referenced constants) of that branch."
  txt := txt.push "#   top         = most frequent symbols (raw vocabulary)"
  txt := txt.push "#   distinctive = most over-represented symbols (lift x1000 vs whole library)"
  txt := txt.push ""
  for i in List.range 8 do
    txt := txt.push s!"================ {realCartanLabels[i]!}  (residue {i}; {cellDecls[i]!} declarations) ================"
    txt := txt.push "  distinctive (symbol  ×lift  [count]):"
    for (s, lift, cnt) in distPerCell[i]! do
      txt := txt.push s!"    {padR s 28} {padR (toString lift) 7} [{cnt}]"
    txt := txt.push "  top (symbol  count):"
    for (s, cnt) in topPerCell[i]! do
      txt := txt.push s!"    {padR s 28} {cnt}"
    txt := txt.push ""
  IO.FS.writeFile (outPath / "wordcloud.txt") (String.intercalate "\n" txt.toList ++ "\n")
  -- ===== wordcloud.json =====
  let mut j : Array String := #["{"]
  j := j.push s!"  \"totalDeclarations\": {globalDecls},"
  j := j.push s!"  \"minCount\": {minCount},"
  j := j.push s!"  \"cells\": ["
  let mut cellEntries : Array String := #[]
  for i in List.range 8 do
    let topStr := String.intercalate ", " (topPerCell[i]!.toList.map (fun (s, cnt) =>
      "[\"" ++ jsonEsc s ++ "\", " ++ toString cnt ++ "]"))
    let distStr := String.intercalate ", " (distPerCell[i]!.toList.map (fun (s, lift, cnt) =>
      "[\"" ++ jsonEsc s ++ "\", " ++ toString lift ++ ", " ++ toString cnt ++ "]"))
    let entry := String.intercalate "\n"
      [ "    {",
        s!"      \"cell\": \"{realCartanLabels[i]!}\",",
        s!"      \"residue\": {i},",
        s!"      \"declarations\": {cellDecls[i]!},",
        s!"      \"top\": [{topStr}],",
        s!"      \"distinctive\": [{distStr}]",
        "    }" ]
    cellEntries := cellEntries.push entry
  j := j.push (String.intercalate ",\n" cellEntries.toList)
  j := j.push "  ]"
  j := j.push "}"
  IO.FS.writeFile (outPath / "wordcloud.json") (String.intercalate "\n" j.toList ++ "\n")
  IO.println s!"  wordcloud.txt / wordcloud.json written to {outDirStr}"
  return 0
