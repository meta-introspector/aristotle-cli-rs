/-
DaslSplit/Unified.lean — Main entry point that bridges all three layers:

  Layer 1 (Static)  → regex pre-scan: name, kind, line, imports
  Layer 2 (Core)    → kernel dep extraction: deps, typeDeps, valDeps, DAG
  Layer 3 (Annotate) → deep annotation: size, depth, arity, flow, blade, stage, tags

Produces maximal-semantics unified JSON + split lattice + introspect report.

Usage:
  lake exe dasl-split                         -- read config, all layers
  lake exe dasl-split --static <file.lean>    -- regex-only (layer 1)
  lake exe dasl-split --deep <module>         -- kernel-only (layers 2+3)
  lake exe dasl-split --all <module> <dir>    -- all three layers
-/
import Lean
import DaslSplit.Core
import DaslSplit.Annotate
import DaslSplit.Static
open Lean System

namespace DaslSplit

/-! ## Unified declaration record — maximal semantics -/

structure UnifiedDecl where
  -- Layer 1: Static regex scan
  name       : String
  kind       : String
  line       : Nat
  imports    : List String
  -- Layer 2: Kernel dependency extraction
  deps       : Array Name
  typeDeps   : Nat
  valDeps    : Nat
  -- Layer 3: Deep annotation
  stage      : String
  «namespace»: String
  «module»   : String
  isProp     : Bool
  isFlow     : Bool
  size       : Nat
  depth      : Nat
  arity      : Nat
  wordLen    : Nat
  flow       : Nat
  blade      : Array Nat
  deriving Inhabited, Repr

/-- Unified JSON for one declaration (maximal semantics). -/
def unifiedJson (d : UnifiedDecl) : String :=
  let bladeStr := Annotate.renderNatArr d.blade
  let depsStr := String.intercalate "," (d.deps.toList.map (fun x => s!"\"{x.toString}\""))
  "{" ++ String.intercalate ", "
    [ s!"\"name\": \"{Annotate.jsonEsc d.name}\""
    , s!"\"kind\": \"{Annotate.jsonEsc d.kind}\""
    , s!"\"line\": {d.line}"
    , s!"\"imports\": {Static.jsonArray d.imports}"
    , s!"\"deps\": [{depsStr}]"
    , s!"\"typeDeps\": {d.typeDeps}"
    , s!"\"valDeps\": {d.valDeps}"
    , s!"\"stage\": \"{Annotate.jsonEsc d.stage}\""
    , s!"\"namespace\": \"{Annotate.jsonEsc d.namespace}\""
    , s!"\"module\": \"{Annotate.jsonEsc d.module}\""
    , s!"\"isProp\": {d.isProp}"
    , s!"\"isFlow\": {d.isFlow}"
    , s!"\"size\": {d.size}"
    , s!"\"depth\": {d.depth}"
    , s!"\"arity\": {d.arity}"
    , s!"\"wordLen\": {d.wordLen}"
    , s!"\"flow\": {d.flow}"
    , s!"\"blade\": {bladeStr}"
    ] ++ "}"

/-! ## Bridge: static pre-scan → kernel deep-scan -/

/-- Run layer 1 (regex) on source to get names, then enrich with layers 2+3 (kernel).
    Produces full UnifiedDecl records. -/
def bridgeScan (env : Environment) (sourcePath : System.FilePath) (targetSet : NameSet) : IO (Array UnifiedDecl) := do
  let content <- IO.FS.readFile sourcePath
  let imports := Static.extractImports content
  let staticDecls := Static.findDeclarations content
  let mut results : Array UnifiedDecl := #[]
  for (name, kind, line) in staticDecls do
    let leanName := name.toName
    -- Only process if this is in our target universe
    if targetSet.contains leanName then
      let deps := Core.filterDeps (Core.constDeps env leanName) targetSet
      let ci := env.find? leanName
      let ty := match ci with | some c => c.type | none => mkConst `Unit
      let word := Annotate.exprSizeWord ty
      let modStr := (Annotate.declModule env leanName).map (·.toString) |>.getD "<none>"
      results := results.push {
        name := name
        kind := kind
        line := line
        imports := imports
        deps := deps
        typeDeps := (Core.typeRefs env leanName).toList.length
        valDeps := (Core.valueRefs env leanName).toList.length
        stage := Annotate.stageOf (Annotate.declModule env leanName)
        «namespace» := Annotate.topNamespace leanName
        «module» := modStr
        isProp := match ci with | some c => c.type.isProp || (Annotate.kindTag env leanName == "theorem") | none => false
        isFlow := Annotate.flowLength ty ≥ 3
        size := Annotate.exprSize ty
        depth := Annotate.exprDepth ty
        arity := Annotate.piArity ty
        wordLen := word.size
        flow := Annotate.flowLength ty
        blade := Annotate.cliffordBlade word
      }
  return results

/-! ## Config -/

structure Config where
  mode : String     -- "static", "deep", "all"
  modules : List String
  files : List String
  outputDir : String
  seeds : List String
  emitSplit : Bool
  limit : Option Nat

def defaultConfig : Config := {
  mode := "all"
  modules := ["Lean"]
  files := []
  outputDir := "./dasl-split-out"
  seeds := []
  emitSplit := true
  limit := none
}

def parseArgs (args : List String) : Config :=
  let rec go (args : List String) (cfg : Config) : Config :=
    match args with
    | "--static" :: file :: rest => go rest { cfg with mode := "static", files := [file] }
    | "--deep" :: mod :: rest => go rest { cfg with mode := "deep", modules := [mod] }
    | "--all" :: mod :: dir :: rest => go rest { cfg with mode := "all", modules := [mod], files := [dir] }
    | "--dir" :: dir :: rest => go rest { cfg with files := [dir] }
    | "--module" :: mod :: rest => go rest { cfg with modules := [mod] }
    | "--out" :: out :: rest => go rest { cfg with outputDir := out }
    | "--seed" :: s :: rest => go rest { cfg with seeds := cfg.seeds ++ [s] }
    | "--no-split" :: rest => go rest { cfg with emitSplit := false }
    | "--limit" :: n :: rest => go rest { cfg with limit := n.toNat? }
    | _ :: rest => go rest cfg
    | [] => cfg
  go args defaultConfig

/-! ## Main -/

def main (args : List String) : IO UInt32 := do
  let cfg := parseArgs args
  let outPath : System.FilePath := System.FilePath.mk cfg.outputDir
  IO.println s!"dasl-split: mode={cfg.mode} out={cfg.outputDir}"

  match cfg.mode with
  | "static" =>
    -- Layer 1 only: regex scan, no kernel needed
    if cfg.files.isEmpty then
      IO.eprintln "Usage: dasl-split --static <file.lean>"
      return 1
    let path := System.FilePath.mk (cfg.files.head!.getD "")
    if <- path.isDir then
      let files <- Static.walkLeanFiles path []
      let mut count := 0
      for f in files do
        count := count + (← Static.processFile f)
      IO.eprintln s!"Static scan: {files.length} files, {count} declarations"
    else
      let _ ← Static.processFile path
    return 0

  | _ =>
    -- Layers 1+2+3: full kernel introspection
    initSearchPath (← findSysroot)
    let imports := (cfg.modules.map (fun m => ({module := m.toName} : Import))).toArray
    let env ← importModules imports {}
    -- Build universe
    let mut univ : NameSet := {}
    let mut allArr : Array Name := #[]
    for (n, _) in env.constants.map₁.toList do
      if n.isInternal || n.toString.startsWith "_" then continue
      univ := univ.insert n
      allArr := allArr.push n
    IO.println s!"  {allArr.size} declarations in scanned universe"
    -- Optionally restrict to seed closure
    let targets : Array Name :=
      if cfg.seeds.isEmpty then allArr
      else
        let seeds := (cfg.seeds.map (·.toName)).filter (fun n => (env.find? n).isSome) |>.toArray
        let closure := Core.bfsClosure env seeds univ
        closure.toList.toArray
    let targetSet : NameSet := targets.foldl (fun s n => s.insert n) {}
    IO.println s!"  {targets.size} declarations targeted"
    IO.FS.createDirAll outPath

    -- Full bridge: static pre-scan + kernel enrichment
    let mut allDecls : Array UnifiedDecl := #[]
    let mut count := 0
    -- If files are specified, bridge them; otherwise scan all modules
    if cfg.files.isEmpty then
      -- Kernel-only deep scan (no static pre-scan for unnamed modules)
      for n in targets do
        let deps := Core.filterDeps (Core.constDeps env n) targetSet
        let ci := env.find? n
        let ty := match ci with | some c => c.type | none => mkConst `Unit
        let word := Annotate.exprSizeWord ty
        let modStr := (Annotate.declModule env n).map (·.toString) |>.getD "<none>"
        allDecls := allDecls.push {
          name := n.toString
          kind := Annotate.kindTag env n
          line := 0
          imports := []
          deps := deps
          typeDeps := (Core.typeRefs env n).toList.length
          valDeps := (Core.valueRefs env n).toList.length
          stage := Annotate.stageOf (Annotate.declModule env n)
          «namespace» := Annotate.topNamespace n
          «module» := modStr
          isProp := match ci with | some c => c.type.isProp || (Annotate.kindTag env n == "theorem") | none => false
          isFlow := Annotate.flowLength ty ≥ 3
          size := Annotate.exprSize ty
          depth := Annotate.exprDepth ty
          arity := Annotate.piArity ty
          wordLen := word.size
          flow := Annotate.flowLength ty
          blade := Annotate.cliffordBlade word
        }
        count := count + 1
        if count % 2000 == 0 then IO.println s!"  ... analyzed {count}/{targets.size}"
    else
      for filePath in cfg.files do
        let path := System.FilePath.mk filePath
        let bridged ← bridgeScan env path targetSet
        allDecls := allDecls ++ bridged
        let limit := cfg.limit.getD allDecls.size
        if allDecls.size >= limit then break

    IO.println s!"  {allDecls.size} declarations analyzed"

    -- Output: unified JSON per declaration
    let jsonl := String.intercalate "\n" (allDecls.toList.map unifiedJson)
    IO.FS.writeFile (outPath / "annotations.jsonl") (jsonl ++ "\n")

    -- Output: DAG
    let mut dagMap : Std.HashMap Name (Array Name) := {}
    for d in allDecls do
      dagMap := dagMap.insert d.name.toName d.deps
    Core.emitDag dagMap outPath

    -- Output: per-declaration stub .lean files (split lattice)
    if cfg.emitSplit then
      let splitDir := outPath / "split"
      IO.FS.createDirAll splitDir
      let mut sc := 0
      for d in allDecls do
        Core.emitDeclFile env d.name.toName d.deps splitDir
        sc := sc + 1
        if sc % 2000 == 0 then IO.println s!"  ... emitted {sc}/{allDecls.size} split files"
      IO.println s!"  {sc} split files written to {splitDir}"

    IO.println s!"  annotations.jsonl + dag.json written to {cfg.outputDir}"
    return 0

end DaslSplit
