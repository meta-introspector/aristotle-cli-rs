/-
SplitDecls.lean — Split a Lean environment into a one-file-per-declaration lattice

Uses the Lean 4 kernel `Environment` API to:
1. Load an environment (via `importModules`)
2. Extract every declaration and its exact dependencies
3. Emit one `.lean` file per declaration
4. Generate a `flake.nix` for each declaration in the lattice

This gives exact dependency tracking (not regex) and enables:
- Minimal recompilation: change one decl → rebuild only its dependents
- Parallel builds: independent branches compile in parallel
- Cherry-pick imports: `import Split.<decl>` pulls only what's needed

Usage (as an executable):
  lake exe splitdecls Mathlib.Algebra.Vertex.HVertexOperator ./split-out
  lake exe splitdecls RequestProject.SplitDecls ./split-self

Or, with no arguments, it reads `split-config.json` from the current directory:
  { "modules": ["Mathlib.Algebra.Vertex.HVertexOperator"], "outputDir": "./split-out" }
-/
import Lean

open Lean System

/-- Collect all constant names referenced in an expression. -/
def collectRefs (e : Expr) : NameSet :=
  e.foldConsts {} fun n s => s.insert n

/-- Get all dependencies of a constant (from its type + value). -/
def constDeps (env : Environment) (n : Name) : NameSet :=
  match env.find? n with
  | some ci =>
    let fromType := collectRefs ci.type
    let fromVal := match ci with
      | .defnInfo v => collectRefs v.value
      | .thmInfo v  => collectRefs v.value
      | .opaqueInfo v => collectRefs v.value
      | _ => {}
    fromType.union fromVal
  | none => {}

/-- Filter a dependency set down to only names that are in our target universe. -/
def filterDeps (deps : NameSet) (targets : NameSet) : Array Name := Id.run do
  let mut result : Array Name := #[]
  for n in deps.toList do
    if targets.contains n then result := result.push n
  return result

/-- Sanitize a Lean name into a valid relative filename (for the comment header). -/
def nameToFile (n : Name) : String :=
  n.toString.replace "." "/" ++ ".lean"

/-- Sanitize a Lean name into a flat module name suitable for `import`. -/
def nameToSimpleMod (n : Name) : String :=
  "Split." ++ n.toString.replace "." "_"

/-- BFS dependency closure starting from a set of root names, staying inside `universeSet`. -/
def bfsClosure (env : Environment) (roots : Array Name) (universeSet : NameSet) : NameSet := Id.run do
  let mut visited : NameSet := {}
  let mut queue : Array Name := roots
  let mut head := 0
  while head < queue.size do
    let n := queue[head]!
    head := head + 1
    if visited.contains n then continue
    if !universeSet.contains n then continue
    visited := visited.insert n
    for d in (constDeps env n).toList do
      if universeSet.contains d && !visited.contains d then
        queue := queue.push d
  return visited

/-- Topological sort of `names` so that dependencies appear before dependents.

Uses an iterative depth-first post-order traversal (O(V+E)). Dependency edges are
restricted to `universeSet`. Cycles (e.g. mutually recursive declarations) are
broken arbitrarily rather than causing non-termination. -/
def topoSort (env : Environment) (names : Array Name) (universeSet : NameSet) : Array Name := Id.run do
  -- Precompute the in-universe dependencies of each name once.
  let mut depMap : NameMap (Array Name) := {}
  for n in names do
    depMap := depMap.insert n (filterDeps (constDeps env n) universeSet)
  let mut visited : NameSet := {}
  let mut sorted : Array Name := #[]
  for root in names do
    if visited.contains root then continue
    -- Explicit stack of (node, next-child-index) for iterative DFS.
    let mut stack : Array (Name × Nat) := #[(root, 0)]
    while stack.size > 0 do
      let top := stack[stack.size - 1]!
      let n := top.1
      let ci := top.2
      if ci == 0 && visited.contains n then
        stack := stack.pop
      else
        if ci == 0 then
          visited := visited.insert n
        let deps := depMap.getD n #[]
        if ci < deps.size then
          stack := stack.set! (stack.size - 1) (n, ci + 1)
          let d := deps[ci]!
          if !visited.contains d then
            stack := stack.push (d, 0)
        else
          sorted := sorted.push n
          stack := stack.pop
  return sorted

/-- Emit a `flake.nix` for one declaration, wiring its dependency flakes as inputs. -/
def emitDeclFlake (n : Name) (deps : Array Name) (absOutDir : System.FilePath) : IO Unit := do
  let declDir := absOutDir / n.toString.replace "." "/"
  IO.FS.createDirAll declDir
  let mut inputsLines : Array String := #[]
  for d in deps do
    let dPath := d.toString.replace "." "-"
    let dDeclDir := absOutDir / d.toString.replace "." "/"
    let dUrl := s!"    {dPath}.url = \"path:{dDeclDir}\";"
    inputsLines := inputsLines.push dUrl
  let inputsBlock := if inputsLines.isEmpty then "" else "\n" ++ String.intercalate "\n" inputsLines.toList ++ "\n  "
  let inputsPart := "{ nixpkgs.url = \"github:NixOS/nixpkgs/nixos-unstable\"; flake-utils.url = \"github:numtide/flake-utils\"; " ++ inputsBlock ++ "}"
  let sys := "x86_64-linux"
  let preamble := "{\n  description = \"Lean declaration: " ++ n.toString ++ "\";\n  inputs = " ++ inputsPart ++ ";\n  outputs = { self, nixpkgs, flake-utils }:"
  let body := "\n    let\n      system = \"" ++ sys ++ "\";\n      pkgs = nixpkgs.legacyPackages.${system};\n    in {\n      packages.${system}.default = pkgs.stdenv.mkDerivation {\n        pname = \"decl-" ++ n.toString ++ "\";\n        version = \"0.1.0\";\n        src = ./.;\n        phases = [ \"unpackPhase\" \"installPhase\" ];\n        installPhase = ''\n          mkdir -p $out\n          cp " ++ (nameToFile n) ++ " $out/\n        '';\n      };\n    };\n}"
  let flakeContent := preamble ++ body
  IO.FS.writeFile (declDir / "flake.nix") flakeContent

/-- Emit a single `.lean` file for one declaration — now with ACTUAL body. -/
def emitDeclFile (env : Environment) (n : Name) (deps : Array Name) (outDir : System.FilePath) : IO Unit := do
  let relPath := (nameToSimpleMod n).replace "." "/" ++ ".lean"
  let path := outDir / relPath
  let parent := path.parent.getD outDir
  IO.FS.createDirAll parent
  let mut lines : Array String := #[]
  -- Header comment with spec info
  lines := lines.push s!"import Mathlib"
  lines := lines.push ""
  -- Emit actual body based on declaration kind
  match env.find? n with
  | some (.defnInfo v) =>
    lines := lines.push s!"set_option pp.all true"
    lines := lines.push s!"-- spec: {n} : {v.type}"
    lines := lines.push s!"def {n} : {v.type} :="
    lines := lines.push s!"  {v.value}"
  | some (.thmInfo v) =>
    lines := lines.push s!"-- spec: theorem {n} : {v.type}"
    lines := lines.push s!"theorem {n} : {v.type} :="
    lines := lines.push s!"  {v.value}"
  | some (.axiomInfo v) =>
    lines := lines.push s!"-- spec: axiom {n} : {v.type}"
    lines := lines.push s!"axiom {n} : {v.type}"
  | some (.opaqueInfo v) =>
    lines := lines.push s!"-- spec: opaque {n} : {v.type}"
    lines := lines.push s!"opaque {n} : {v.type} :="
    lines := lines.push s!"  {v.value}"
  | some (.inductInfo v) =>
    lines := lines.push s!"-- spec: inductive {n} : {v.type} (ctors: {v.ctors})"
    lines := lines.push s!"-- inductive body not extracted (use #print {n})"
  | some (.ctorInfo v) =>
    lines := lines.push s!"-- spec: constructor {n} : {v.type}"
  | some (.recInfo v) =>
    lines := lines.push s!"-- spec: recursor {n} : {v.type}"
  | some (.quotInfo _) =>
    lines := lines.push s!"-- spec: quot {n}"
  | none => lines := lines.push s!"-- {n} not found in environment"
  IO.FS.writeFile path (String.intercalate "\n" (lines.toList ++ [""]))

/-- Generate a `lakefile.toml` for the split project. -/
def emitLakefile (names : Array Name) (outDir : System.FilePath) : IO Unit := do
  let mut lines : Array String := #["name = \"lean-split\"", "version = \"0.1.0\"", "", "[[require]]", "name = \"mathlib\"", "git = \"https://github.com/leanprover-community/mathlib4\"", "rev = \"v4.28.0\"", ""]
  let mut seen : NameSet := {}
  for n in names do
    let mod := nameToSimpleMod n
    let root := mod.splitOn "." |>.head? |>.getD "Split"
    let rootName := root.toName
    if !seen.contains rootName then
      seen := seen.insert rootName
      lines := lines ++ ["[[lean_lib]]", s!"name = \"{root}\"", ""]
  IO.FS.writeFile (outDir / "lakefile.toml") (String.intercalate "\n" lines.toList ++ "\n")

/-- Generate a DAG summary as JSON: each declaration mapped to its in-closure deps. -/
def emitDag (env : Environment) (names : Array Name) (universeSet : NameSet) (outDir : System.FilePath) : IO Unit := do
  let mut lines : Array String := #["{"]
  let mut idx := 0
  for n in names.toList do
    let deps := filterDeps (constDeps env n) universeSet
    let depsStr := deps.map (fun d => s!"\"{d}\"") |>.toList
    let comma := if idx + 1 < names.size then "," else ""
    lines := lines.push s!"  \"{n}\": [{String.intercalate ", " depsStr}]{comma}"
    idx := idx + 1
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "dag.json") (String.intercalate "\n" lines.toList ++ "\n")

/-- Parse a `split-config.json` string into a list of module names and an output dir.

Supports either a single `"module"` string or a `"modules"` array, plus an
optional `"outputDir"`. -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./split-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./split-out"
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

/-- Read configuration from CLI args, or from `split-config.json`, or fall back to defaults. -/
def readConfig (args : List String) : IO (List String × String) := do
  let default : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "split-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then default else mods, out)
    else
      return (default, "./split-out")
  | [m] => return ([m], "./split-out")
  | m :: out :: _ => return ([m], out)

/-- Find every (non-internal) declaration that is *defined in* one of the given modules. -/
def declsInModules (env : Environment) (mods : List Name) : Array Name := Id.run do
  let modSet : NameSet := mods.foldl (fun s m => s.insert m) {}
  let mut result : Array Name := #[]
  for (n, _) in env.constants.map₁.toList do
    if n.isInternal || n.toString.startsWith "_" then
      continue
    match env.getModuleIdxFor? n with
    | some idx =>
      match env.header.moduleNames[idx.toNat]? with
      | some m => if modSet.contains m then result := result.push n
      | none => pure ()
    | none => pure ()
  return result

/-- Main: split the requested modules' declarations (and their closure) into a lattice. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"SplitDecls: roots={rootMods} out={outDirStr}"
  -- Initialise the module search path (reads the `LEAN_PATH` env var, e.g. set by `lake env`).
  initSearchPath (← findSysroot)
  let opts := {}
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports opts
  let mut allNames : NameSet := {}
  for (n, _) in env.constants.map₁.toList do
    if !n.isInternal && !n.toString.startsWith "_" then
      allNames := allNames.insert n
  IO.println s!"  {allNames.toList.length} declarations in environment"
  let seeds := declsInModules env (rootMods.map (·.toName))
  IO.println s!"  {seeds.size} seed declarations defined in requested modules"
  let closure := bfsClosure env seeds allNames
  let closureArr := closure.toList.toArray
  IO.println s!"  {closureArr.size} declarations in dependency closure"
  let sorted := topoSort env closureArr closure
  IO.println s!"  {sorted.size} declarations after topo sort"
  IO.FS.createDirAll outPath
  let absOutDir ← IO.FS.realPath outPath
  let mut count := 0
  for n in sorted do
    let deps := filterDeps (constDeps env n) closure
    emitDeclFile env n deps outPath
    emitDeclFlake n deps absOutDir
    count := count + 1
    if count % 500 == 0 then IO.println s!"  ... {count}/{sorted.size} files emitted"
  emitLakefile sorted outPath
  emitDag env sorted closure outPath
  IO.println s!"  {count} declaration files written to {outDirStr}"
  IO.println s!"  dag.json written"
  IO.println s!"  lakefile.toml written"
  return 0
