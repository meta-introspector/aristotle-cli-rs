/-
ClusterDecls.lean — Topologically cluster a Lean environment, compute interfaces, and
emit a provably-minimal coverage manifest per declaration.

This is the executable companion to the verified theory in `RequestProject/Coverage.lean`.
It realises, on the real Lean/Mathlib dependency graph, exactly the constructions that
`Coverage.lean` proves correct:

1. **Topological sort + rank.** Every declaration gets a `rank` = its depth in the
   dependency DAG (atoms with no in-universe dependencies have rank 0). This is the strict
   rank of `Coverage.reaches_antisymm`: it strictly decreases along every edge, so the
   graph is acyclic.

2. **Clustering into groups (layers).** Declarations are grouped by rank into clusters
   `cluster i = { d | rank d = i }` — the `Coverage.rankCluster`. By
   `Coverage.interface_rankCluster_lt`, cluster `i` depends only on strictly-earlier
   clusters, so the clusters form a DAG that builds level by level (level 0 first), with all
   clusters at the same level independent → buildable in parallel.

3. **Interfaces.** For each cluster we compute its `interface` (`Coverage.interface`): the
   external declarations it directly depends on, and how they distribute across earlier
   levels. `Coverage.cover_eq_cluster_interface` proves the interface fully captures a
   cluster's external requirements.

4. **Provably-minimal coverage.** For each seed declaration `d` we compute `cover {d}`
   (`Coverage.cover`) — everything reachable from `d` — by BFS. `Coverage.cover_least`
   proves this is the *unique minimal* self-contained set containing `d`: the least set of
   declarations you must load to use `d`. We report each declaration's minimal-coverage size
   (a direct proxy for its isolated build cost).

Outputs (to the configured output dir, default `./cluster-out`):
  * `clusters.json`   — rank → declarations in that cluster (the layered topological groups)
  * `interfaces.json` — per cluster: interface size + cross-level dependency breakdown
  * `coverage.json`   — per seed declaration: minimal-coverage size + aggregate statistics
  * `build-plan.txt`  — human-readable parallel build plan (level order + sizes)

Usage:
  lake exe clusterdecls <Module> <outputDir>
  lake exe clusterdecls                       -- reads cluster-config.json, else defaults
-/
import Lean

open Lean System

/-! ## Dependency helpers (shared shape with `SplitDecls` / `DupFinder`) -/

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

/-- BFS dependency closure from a set of roots, staying inside `universeSet`.
This computes `Coverage.cover` of the roots: every declaration reachable from a root. -/
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

/-- Topological sort of `names` (dependencies before dependents), iterative DFS post-order. -/
def topoSort (env : Environment) (names : Array Name) (universeSet : NameSet) : Array Name := Id.run do
  let mut depMap : NameMap (Array Name) := {}
  for n in names do
    depMap := depMap.insert n (filterDeps (constDeps env n) universeSet)
  let mut visited : NameSet := {}
  let mut sorted : Array Name := #[]
  for root in names do
    if visited.contains root then continue
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

/-- Compute the rank (dependency depth) of every declaration in `univSet`, in topological
order. `rank d = 0` for atoms; otherwise `1 + max rank of in-universe deps`. This is the
strict rank used by the `Coverage` model (it strictly decreases along every edge). -/
def computeRanks (env : Environment) (univSet : NameSet) : NameMap Nat := Id.run do
  let univArr := univSet.toList.toArray
  let sorted := topoSort env univArr univSet
  let mut rank : NameMap Nat := {}
  for n in sorted do
    let deps := filterDeps (constDeps env n) univSet
    let g := deps.foldl (fun acc d => Nat.max acc ((rank.find? d |>.getD 0) + 1)) 0
    rank := rank.insert n g
  return rank

/-! ## Config -/

/-- Parse a config string: `modules`/`module` + `outputDir`. -/
def parseConfig (s : String) : List String × String :=
  match Json.parse s with
  | .error _ => ([], "./cluster-out")
  | .ok j =>
    let out := (j.getObjValAs? String "outputDir").toOption.getD "./cluster-out"
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

/-- Read configuration from CLI args, or `cluster-config.json`, else defaults. -/
def readConfig (args : List String) : IO (List String × String) := do
  let default : List String := ["Mathlib.Algebra.Vertex.HVertexOperator"]
  match args with
  | [] =>
    let configPath := System.FilePath.mk "cluster-config.json"
    if ← configPath.pathExists then
      let content ← IO.FS.readFile configPath
      let (mods, out) := parseConfig content
      return (if mods.isEmpty then default else mods, out)
    else
      return (default, "./cluster-out")
  | [m] => return ([m], "./cluster-out")
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

/-- Escape a string for embedding in JSON. -/
def jsonEsc (s : String) : String :=
  s.replace "\\" "\\\\" |>.replace "\"" "\\\""

/-! ## Emission -/

/-- Emit `clusters.json`: rank → the declarations in that cluster (a sample, plus the size).
These are the `Coverage.rankCluster` layers, in topological build order. -/
def emitClusters (rank : NameMap Nat) (closure : NameSet) (outDir : System.FilePath) :
    IO Nat := do
  let mut byLevel : Std.HashMap Nat (Array Name) := {}
  let mut maxLevel := 0
  for n in closure.toList do
    let g := rank.find? n |>.getD 0
    byLevel := byLevel.insert g ((byLevel.getD g #[]).push n)
    if g > maxLevel then maxLevel := g
  let mut lines : Array String := #["{"]
  lines := lines.push s!"  \"declarations\": {closure.toList.length},"
  lines := lines.push s!"  \"numLevels\": {maxLevel + 1},"
  lines := lines.push "  \"levels\": {"
  let mut entries : Array String := #[]
  for g in [0:maxLevel+1] do
    let arr := byLevel.getD g #[]
    let sample := arr.toList.take 8
    let names := String.intercalate ", " (sample.map (fun n => "\"" ++ jsonEsc n.toString ++ "\""))
    entries := entries.push ("    \"" ++ toString g ++ "\": { \"size\": " ++ toString arr.size ++ ", \"sample\": [" ++ names ++ "] }")
  lines := lines.push (String.intercalate ",\n" entries.toList)
  lines := lines.push "  }"
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "clusters.json") (String.intercalate "\n" lines.toList ++ "\n")
  return maxLevel

/-- Emit `interfaces.json`: for each cluster (level `i`), the size of its interface
(external declarations it directly depends on) and how those split across earlier levels.
By `Coverage.interface_rankCluster_lt` every interface edge goes to a strictly lower level,
which we also verify numerically (`interfaceMonotone`). -/
def emitInterfaces (env : Environment) (rank : NameMap Nat) (closure : NameSet)
    (maxLevel : Nat) (outDir : System.FilePath) : IO Bool := do
  -- group decls by level
  let mut byLevel : Std.HashMap Nat (Array Name) := {}
  for n in closure.toList do
    let g := rank.find? n |>.getD 0
    byLevel := byLevel.insert g ((byLevel.getD g #[]).push n)
  let mut monotone := true
  let mut lines : Array String := #["{"]
  let mut entries : Array String := #[]
  for i in [0:maxLevel+1] do
    let arr := byLevel.getD i #[]
    -- interface = direct in-closure deps of cluster i that lie OUTSIDE cluster i
    let mut iface : NameSet := {}
    for n in arr do
      for d in filterDeps (constDeps env n) closure do
        let dg := rank.find? d |>.getD 0
        if dg != i then
          iface := iface.insert d
          if dg ≥ i then monotone := false   -- would violate interface_rankCluster_lt
    -- breakdown of interface by source level
    let mut perLevel : Std.HashMap Nat Nat := {}
    for d in iface.toList do
      let dg := rank.find? d |>.getD 0
      perLevel := perLevel.insert dg ((perLevel.getD dg 0) + 1)
    let mut bd : Array String := #[]
    for j in [0:i] do
      let c := perLevel.getD j 0
      if c > 0 then bd := bd.push s!"\"{j}\": {c}"
    let bdStr := String.intercalate ", " bd.toList
    entries := entries.push
      ("    \"" ++ toString i ++ "\": { \"clusterSize\": " ++ toString arr.size ++
        ", \"interfaceSize\": " ++ toString iface.toList.length ++
        ", \"fromLevel\": {" ++ bdStr ++ "} }")
  lines := lines.push s!"  \"interfaceEdgesGoStrictlyDownward\": {monotone},"
  lines := lines.push "  \"clusters\": {"
  lines := lines.push (String.intercalate ",\n" entries.toList)
  lines := lines.push "  }"
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "interfaces.json") (String.intercalate "\n" lines.toList ++ "\n")
  return monotone

/-- Emit `coverage.json`: per seed declaration, the size of its provably-minimal coverage
`cover {d}` (`Coverage.cover_least`), plus aggregate statistics over the seeds. -/
def emitCoverage (env : Environment) (seeds : Array Name) (univSet : NameSet)
    (outDir : System.FilePath) : IO Unit := do
  let mut perDecl : Array (Name × Nat) := #[]
  let mut total := 0
  let mut maxCov := 0
  let mut maxName : Name := Name.anonymous
  for d in seeds do
    let cov := bfsClosure env #[d] univSet
    let sz := cov.toList.length
    perDecl := perDecl.push (d, sz)
    total := total + sz
    if sz > maxCov then maxCov := sz; maxName := d
  let n := perDecl.size
  let avg := if n == 0 then 0 else total / n
  -- sort descending by coverage size for the report (simple insertion via Array.qsort)
  let sortedDecls := perDecl.qsort (fun a b => a.2 > b.2)
  let sample := sortedDecls.toList.take 50
  let mut lines : Array String := #["{"]
  lines := lines.push s!"  \"seeds\": {n},"
  lines := lines.push s!"  \"avgMinimalCoverSize\": {avg},"
  lines := lines.push s!"  \"maxMinimalCoverSize\": {maxCov},"
  lines := lines.push s!"  \"maxCoverDeclaration\": \"{jsonEsc maxName.toString}\","
  lines := lines.push "  \"perDeclaration\": {"
  let entries := sample.map (fun (nm, sz) => s!"    \"{jsonEsc nm.toString}\": {sz}")
  lines := lines.push (String.intercalate ",\n" entries)
  lines := lines.push "  }"
  lines := lines.push "}"
  IO.FS.writeFile (outDir / "coverage.json") (String.intercalate "\n" lines.toList ++ "\n")

/-- Emit `build-plan.txt`: a human-readable parallel build plan — the topological level
order, with cluster sizes (all clusters within a level are independent, so parallel). -/
def emitBuildPlan (rank : NameMap Nat) (closure : NameSet) (maxLevel : Nat)
    (monotone : Bool) (outDir : System.FilePath) : IO Unit := do
  let mut byLevel : Std.HashMap Nat Nat := {}
  for n in closure.toList do
    let g := rank.find? n |>.getD 0
    byLevel := byLevel.insert g ((byLevel.getD g 0) + 1)
  let mut lines : Array String := #[]
  lines := lines.push "# Parallel build plan (topological clustering by dependency depth)"
  lines := lines.push s!"# {closure.toList.length} declarations in {maxLevel + 1} levels."
  lines := lines.push s!"# Interface edges go strictly downward (verified): {monotone}"
  lines := lines.push "# Build levels in order 0,1,2,...; declarations within a level are"
  lines := lines.push "# mutually independent and can be compiled in parallel."
  lines := lines.push ""
  for i in [0:maxLevel+1] do
    let c := byLevel.getD i 0
    lines := lines.push s!"level {i}: {c} declarations (parallel)"
  IO.FS.writeFile (outDir / "build-plan.txt") (String.intercalate "\n" lines.toList ++ "\n")

/-- Main: topologically cluster the requested modules' declaration closure, compute
interfaces, and emit a provably-minimal coverage manifest. -/
def main (args : List String) : IO UInt32 := do
  let (rootMods, outDirStr) ← readConfig args
  let outPath : System.FilePath := System.FilePath.mk outDirStr
  IO.println s!"ClusterDecls: roots={rootMods} out={outDirStr}"
  initSearchPath (← findSysroot)
  let imports := (rootMods.map (fun m => ({module := m.toName} : Import))).toArray
  let env ← importModules imports {}
  -- universe = all non-internal declarations in memory
  let mut univSet : NameSet := {}
  for (n, _) in env.constants.map₁.toList do
    if !n.isInternal && !n.toString.startsWith "_" then
      univSet := univSet.insert n
  IO.println s!"  {univSet.toList.length} declarations in environment (universe)"
  -- seeds + closure (the cover of the seeds)
  let seeds := declsInModules env (rootMods.map (·.toName))
  IO.println s!"  {seeds.size} seed declarations defined in requested modules"
  let closure := bfsClosure env seeds univSet
  IO.println s!"  {closure.toList.length} declarations in dependency closure"
  -- ranks over the whole universe so cross-level edges are accurate
  let rank := computeRanks env univSet
  IO.FS.createDirAll outPath
  let maxLevel ← emitClusters rank closure outPath
  IO.println s!"  clusters.json written ({maxLevel + 1} levels)"
  let monotone ← emitInterfaces env rank closure maxLevel outPath
  IO.println s!"  interfaces.json written (interface edges strictly downward: {monotone})"
  emitCoverage env seeds univSet outPath
  IO.println s!"  coverage.json written ({seeds.size} seed minimal covers)"
  emitBuildPlan rank closure maxLevel monotone outPath
  IO.println s!"  build-plan.txt written"
  return 0
