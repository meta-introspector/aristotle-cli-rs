import Lean
open Lean

/-!
# Proof-fact extractor for the aristotle-cli-rs local checker

Usage: `lean --run inspect_proof_facts.lean <Module> [<RequiredTheorem> ...]`

`<Module>` must already be compiled to an `.olean` on `LEAN_PATH` (and should
already have been replayed through the kernel with `leanchecker`).

The module is loaded with `importModules (loadExts := false)`: none of the
submission's initializers, attributes, macros or elaborators run in this
process, and this file is parsed before the submission is loaded, so the
submission cannot change how this file is read.

Axiom dependencies are computed by walking the stored declaration bodies
directly (the same traversal as `#print axioms`), instead of trusting any
axiom summary cached inside the submission's `.olean`.

The tool reports facts only, as exactly one JSON line on stdout.  The
accept/reject policy is decided by the Rust caller.  A non-zero exit code
means the facts could not be produced.
-/

/-- Transitive dependency walk: `(visited, axioms, unresolved)`. -/
abbrev WalkM := StateM (NameSet × NameSet × NameSet)

partial def walkConst (env : Environment) (c : Name) : WalkM Unit := do
  let (visited, axs, unres) ← get
  if visited.contains c then return
  set (visited.insert c, axs, unres)
  let walkExpr (e : Expr) : WalkM Unit := e.getUsedConstants.forM (walkConst env)
  match env.find? c with
  | some (.axiomInfo v) =>
    modify fun (vs, as, us) => (vs, as.insert c, us)
    walkExpr v.type
  | some (.defnInfo v) => walkExpr v.type *> walkExpr v.value
  | some (.thmInfo v) => walkExpr v.type *> walkExpr v.value
  | some (.opaqueInfo v) => walkExpr v.type *> walkExpr v.value
  | some (.quotInfo _) => pure ()
  | some (.ctorInfo v) => walkExpr v.type
  | some (.recInfo v) => walkExpr v.type
  | some (.inductInfo v) => walkExpr v.type *> v.ctors.forM (walkConst env)
  | none => modify fun (vs, as, us) => (vs, as, us.insert c)

def sortedNames (s : NameSet) : Array Name :=
  s.toArray.qsort Name.lt

/-- `(axioms, unresolved constants)` reachable from `c`. -/
def axiomsOf (env : Environment) (c : Name) : Array Name × Array Name :=
  let (_, _, axs, unres) := ((walkConst env c).run ({}, {}, {})).run
  (sortedNames axs, sortedNames unres)

def kindOf : ConstantInfo → String
  | .axiomInfo _ => "axiom"
  | .defnInfo _ => "def"
  | .thmInfo _ => "theorem"
  | .opaqueInfo _ => "opaque"
  | .quotInfo _ => "quot"
  | .inductInfo _ => "inductive"
  | .ctorInfo _ => "constructor"
  | .recInfo _ => "recursor"

def namesJson (ns : Array Name) : Json :=
  Json.arr (ns.map fun n => Json.str n.toString)

/-- Does the declaration's type or value mention `sorryAx` directly? -/
def mentionsSorry (ci : ConstantInfo) : Bool :=
  let uses (e : Expr) := e.getUsedConstants.contains ``sorryAx
  uses ci.type || match ci with
    | .defnInfo v => uses v.value
    | .thmInfo v => uses v.value
    | .opaqueInfo v => uses v.value
    | _ => false

def main (args : List String) : IO UInt32 := do
  let modStr :: required := args
    | IO.eprintln "usage: inspect_proof_facts <Module> [<RequiredTheorem> ...]"; return 2
  let mod := modStr.toName
  if mod.isAnonymous then
    IO.eprintln s!"invalid module name {modStr}"; return 2
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := mod }] {} (trustLevel := 0) (loadExts := false)
  let env := env.setExporting false
  let some idx := env.getModuleIdx? mod
    | IO.eprintln s!"module {mod} was not loaded"; return 3
  let some data := env.header.moduleData[idx.toNat]?
    | IO.eprintln s!"no module data for {mod}"; return 3
  let mut declaredAxioms : Array Name := #[]
  let mut sorryDecls : Array Name := #[]
  let mut theorems : Array Name := #[]
  for ci in data.constants do
    if ci matches .axiomInfo _ then declaredAxioms := declaredAxioms.push ci.name
    if ci matches .thmInfo _ then theorems := theorems.push ci.name
    if mentionsSorry ci then sorryDecls := sorryDecls.push ci.name
  let mut req : Array Json := #[]
  for r in required do
    let n := r.toName
    -- Only declarations made by the submitted module itself count.
    let ci? := if !n.isAnonymous && env.getModuleIdxFor? n == some idx then env.find? n else none
    match ci? with
    | none =>
      req := req.push <| Json.mkObj [("name", Json.str r), ("found", Json.bool false)]
    | some ci =>
      let (axs, unres) := axiomsOf env n
      req := req.push <| Json.mkObj [("name", Json.str r), ("found", Json.bool true),
        ("kind", Json.str (kindOf ci)), ("axioms", namesJson axs),
        ("unresolved", namesJson unres)]
  let sortArr (a : Array Name) := a.qsort Name.lt
  let out := Json.mkObj [
    ("module", Json.str mod.toString),
    ("lean_version", Json.str Lean.versionString),
    ("declared_axioms", namesJson (sortArr declaredAxioms)),
    ("sorry_decls", namesJson (sortArr sorryDecls)),
    ("theorems", namesJson (sortArr theorems)),
    ("required", Json.arr req)]
  IO.println out.compress
  return 0
