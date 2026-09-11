/-
# IPLD Schema → Lean 4 Source Code Generator

Given an `IPLD.Schema` value, this module generates well-formed Lean 4 source
code that defines the corresponding types. It handles:

- **Dependency analysis** via adjacency-list construction
- **Mutual recursion detection** via Kosaraju's SCC algorithm
- **Topological emission** so each type is defined before it is used
- **Proper declaration kinds**: `abbrev`, `structure`, or `inductive` depending
  on the IPLD type kind and whether mutual recursion is involved

## Mapping from IPLD TypeDefn to Lean declaration

| IPLD TypeDefn                     | Lean declaration                            |
|-----------------------------------|---------------------------------------------|
| `.string {}`                      | `abbrev Foo := String`                      |
| `.bool {} / .int {} / .float {} / .any {}` | `structure Foo`                  |
| `.enum { members, … }`           | `inductive Foo where \| a \| b …`           |
| `.union { members, … }`          | `inductive Foo where \| a : A → Foo …`      |
| `.struct { fields, … }`          | `structure Foo where f₁ : T₁; f₂ : T₂; …`  |
| `.map (.mk k v)`                 | `abbrev Foo := List (K × V)`                |
| `.list (.mk v)`                  | `abbrev Foo := List V`                      |
| `.copy { fromType }`             | `abbrev Foo := Bar`                         |
| `.link { expectedType }`         | `structure Foo where expectedType : String`  |
| `.bytes { … }`                   | `structure Foo`                              |
| `.unit { … }`                    | `structure Foo where repr : UnitRepr`        |

## Usage

```
#eval IO.println (IPLD.CodeGen.generate IPLD.ipldSchemaSchema)
```
-/

import RequestProject.IPLD
import RequestProject.IPLDSelfDescribe

namespace IPLD.CodeGen

-- ============================================================================
-- § 1  Built-in type resolution
-- ============================================================================

/-- Map IPLD Data Model primitive type names to Lean type names.
    These are implicitly available in every IPLD schema. -/
def builtinTypeName : String → Option String
  | "Bool"   => some "Bool"
  | "String" => some "String"
  | "Bytes"  => some "ByteArray"
  | "Int"    => some "Int"
  | "Float"  => some "Float"
  | _        => none

/-- Check whether a type name refers to a built-in IPLD primitive. -/
def isBuiltin (name : String) : Bool :=
  (builtinTypeName name).isSome

/-- Resolve a type name: builtins are mapped to Lean primitives, everything
    else passes through unchanged. -/
def resolveTypeName (name : String) : String :=
  (builtinTypeName name).getD name

-- ============================================================================
-- § 2  Type reference resolution (for source emission)
-- ============================================================================

/-- Convert a `TypeNameOrInlineDefn` to a Lean type expression string. -/
partial def resolveTypeRef : TypeNameOrInlineDefn → String
  | .typeName name => resolveTypeName name
  | .inlineDefn (.map m) =>
    let k := resolveTypeName m.keyType
    let v := resolveTypeRef m.valueType
    s!"(List ({k} × {v}))"
  | .inlineDefn (.list l) =>
    let v := resolveTypeRef l.valueType
    s!"(List {v})"
  | .inlineDefn (.link l) =>
    -- A link is a content-addressed reference; represent as a string (CID).
    -- If the expected type is known, annotate with a comment.
    if l.expectedType == "Any" then "String /- CID -/"
    else s!"String /- CID → {l.expectedType} -/"

/-- Resolve a struct field's type, wrapping with `Option` as needed. -/
def resolveFieldType (sf : StructField) : String :=
  let base := resolveTypeRef sf.type_
  match sf.optional, sf.nullable with
  | false, false => base
  | true,  false => s!"(Option {base})"
  | false, true  => s!"(Option {base})"
  -- optional + nullable: None = absent, Some none = null, Some (Some v) = present
  | true,  true  => s!"(Option (Option {base}))"

-- ============================================================================
-- § 3  Dependency extraction
-- ============================================================================

/-- Collect all non-builtin type names referenced by a `TypeNameOrInlineDefn`. -/
partial def typeRefDeps : TypeNameOrInlineDefn → List String
  | .typeName name => if isBuiltin name then [] else [name]
  | .inlineDefn (.map m) =>
    let kDeps := if isBuiltin m.keyType then [] else [m.keyType]
    kDeps ++ typeRefDeps m.valueType
  | .inlineDefn (.list l) => typeRefDeps l.valueType
  | .inlineDefn (.link _) => []

/-- Collect dependencies of a single struct field. -/
def structFieldDeps (sf : StructField) : List String :=
  typeRefDeps sf.type_

/-- Collect all non-builtin type names that a `TypeDefn` directly references. -/
def typeDefnDeps : TypeDefn → List String
  | .bool _   => []
  | .string _ => []
  | .int _    => []
  | .float _  => []
  | .any _    => []
  | .bytes _  => []
  | .unit _   => []
  | .link l   => if isBuiltin l.expectedType then [] else [l.expectedType]
  | .copy c   => if isBuiltin c.fromType then [] else [c.fromType]
  | .map m    =>
    let kDeps := if isBuiltin m.keyType then [] else [m.keyType]
    kDeps ++ typeRefDeps m.valueType
  | .list l   => typeRefDeps l.valueType
  | .enum _   => []
  | .union u  =>
    u.members.flatMap fun
      | .typeName name => if isBuiltin name then [] else [name]
      | .inlineDefn _  => []
  | .struct s =>
    s.fields.flatMap fun (_, sf) => structFieldDeps sf

-- ============================================================================
-- § 4  SCC computation — Kosaraju's algorithm
-- ============================================================================

/-- Depth-first search, recording nodes in post-order (finish time). -/
private partial def dfsForward
    (adj : String → List String) (node : String)
    (visited : List String) (order : List String)
    : List String × List String :=
  if visited.contains node then (visited, order)
  else
    let visited := node :: visited
    let (visited, order) := (adj node).foldl
      (fun (v, o) next => dfsForward adj next v o) (visited, order)
    (visited, node :: order)

/-- Depth-first search on the transposed graph, collecting a single component. -/
private partial def dfsBackward
    (radj : String → List String) (node : String)
    (visited : List String) (component : List String)
    : List String × List String :=
  if visited.contains node then (visited, component)
  else
    let visited := node :: visited
    let component := node :: component
    (radj node).foldl
      (fun (v, c) next => dfsBackward radj next v c) (visited, component)

/-- Compute the strongly connected components of the type dependency graph.
    Returns SCCs in dependency order (leaves first, roots last). -/
def computeSCCs (typeNames : List String) (adj : String → List String)
    : List (List String) :=
  -- Step 1: DFS on original graph, record finish order
  let (_, finishOrder) := typeNames.foldl
    (fun (v, o) n => dfsForward adj n v o) ([], [])
  -- Step 2: Build reverse adjacency list (transpose graph)
  let radj (node : String) : List String :=
    typeNames.filter fun other => (adj other).contains node
  -- Step 3: DFS on transposed graph in finish order
  --         Each DFS tree is one SCC
  let (_, sccs) := finishOrder.foldl (fun (visited, sccs) node =>
    if visited.contains node then (visited, sccs)
    else
      let (visited, component) := dfsBackward radj node visited []
      (visited, component :: sccs)
  ) ([], [])
  -- `sccs` is accumulated via `::` during the second DFS pass.
  -- Sources (nodes with no outgoing edges in G^T, i.e. leaves in G) are
  -- discovered first and pushed last, so the list is already in
  -- dependency-first (leaf-to-root) order.
  sccs

-- ============================================================================
-- § 5  Source code emission
-- ============================================================================

/-- Lowercase the first character of a string (for constructor names). -/
def toLowerFirst (s : String) : String :=
  if s.isEmpty then s
  else
    let first := s.get ⟨0⟩
    s!"{first.toLower}{s.drop 1}"

/-- Generate a constructor name from a type name.
    E.g. `"TypeDefnBool"` → `"typeDefnBool"`. -/
def toCtorName (typeName : String) : String :=
  toLowerFirst typeName

/-- Pretty-print an `AnyScalar` as a Lean default-value expression. -/
def scalarToLean : AnyScalar → String
  | .bool true  => "true"
  | .bool false => "false"
  | .string s   => s!"\"{s}\""
  | .int n      => toString n
  | .float f    => toString f
  | .bytes _    => "default"

/-- Look up the default value for a field from a struct's map representation. -/
def fieldDefault (fname : FieldName) (repr : StructRepresentation) : Option String :=
  match repr with
  | .map m =>
    m.fields.bind fun flds =>
      match flds.find? (·.1 == fname) with
      | some (_, details) => details.implicit.map scalarToLean
      | none => none
  | _ => none

/-- Emit a single type definition as Lean 4 source text.

    `forceInductive` is `true` when the type is in a mutual block or is
    self-referencing, meaning we must use `inductive` instead of `structure`
    or `abbrev`. -/
def emitTypeDefn (name : String) (td : TypeDefn) (forceInductive : Bool) : String :=
  let ln := name  -- Lean name = IPLD name
  match td with
  -- ── string alias ──────────────────────────────────────────────────────
  | .string _ =>
    if forceInductive then
      s!"inductive {ln} where\n  | mk (val : String)\n"
    else
      s!"abbrev {ln} := String\n"

  -- ── empty marker types ────────────────────────────────────────────────
  | .bool _ | .int _ | .float _ | .any _ | .bytes _ =>
    if forceInductive then
      s!"inductive {ln} where\n  | mk\n"
    else
      s!"structure {ln}\n"

  -- ── unit ──────────────────────────────────────────────────────────────
  | .unit u =>
    if forceInductive then
      s!"inductive {ln} where\n  | mk (representation : UnitRepresentation)\n"
    else
      let reprStr := match u.representation with
        | .null => "null" | .«true» => "true" | .«false» => "false" | .emptymap => "emptymap"
      s!"structure {ln} where\n  representation : UnitRepresentation := .{reprStr}\n"

  -- ── link ──────────────────────────────────────────────────────────────
  | .link l =>
    let ty := resolveTypeName l.expectedType
    if forceInductive then
      s!"inductive {ln} where\n  | mk (expectedType : {ty} := \"Any\")\n"
    else
      s!"structure {ln} where\n  expectedType : {ty} := \"Any\"\n"

  -- ── copy ──────────────────────────────────────────────────────────────
  | .copy c =>
    let target := resolveTypeName c.fromType
    if forceInductive then
      s!"inductive {ln} where\n  | mk (val : {target})\n"
    else
      s!"abbrev {ln} := {target}\n"

  -- ── map ───────────────────────────────────────────────────────────────
  | .map m =>
    let k := resolveTypeName m.keyType
    let v := resolveTypeRef m.valueType
    if forceInductive then
      s!"inductive {ln} where\n  | mk (entries : List ({k} × {v}))\n"
    else
      s!"abbrev {ln} := List ({k} × {v})\n"

  -- ── list ──────────────────────────────────────────────────────────────
  | .list l =>
    let v := resolveTypeRef l.valueType
    if forceInductive then
      s!"inductive {ln} where\n  | mk (entries : List {v})\n"
    else
      s!"abbrev {ln} := List {v}\n"

  -- ── enum ──────────────────────────────────────────────────────────────
  | .enum e =>
    let ctors := e.members.map fun m => s!"  | {toLowerFirst m}"
    let body := String.intercalate "\n" ctors
    s!"inductive {ln} where\n{body}\n"

  -- ── union ─────────────────────────────────────────────────────────────
  | .union u =>
    let ctors := u.members.filterMap fun member =>
      match member with
      | .typeName tname =>
        let ctorNm := toCtorName tname
        let payload := resolveTypeName tname
        some s!"  | {ctorNm} : {payload} → {ln}"
      | .inlineDefn (.link l) =>
        let desc := if l.expectedType == "Any" then ""
                    else s!" /- → {l.expectedType} -/"
        some s!"  | inlineLink : String{desc} → {ln}"
    let body := String.intercalate "\n" ctors
    s!"inductive {ln} where\n{body}\n"

  -- ── struct ────────────────────────────────────────────────────────────
  | .struct st =>
    let fields := st.fields.map fun (fname, sf) =>
      let ftype := resolveFieldType sf
      let dflt := fieldDefault fname st.representation
      let dfltStr := match dflt with
        | some d => s!" := {d}"
        | none   => ""
      (fname, ftype, dfltStr)
    if forceInductive then
      -- Emit as inductive with single .mk constructor
      let args := fields.map fun (fname, ftype, dfltStr) =>
        s!"    ({fname} : {ftype}{dfltStr})"
      let body := String.intercalate "\n" args
      s!"inductive {ln} where\n  | mk\n{body}\n    : {ln}\n"
    else
      let flds := fields.map fun (fname, ftype, dfltStr) =>
        s!"  {fname} : {ftype}{dfltStr}"
      let body := String.intercalate "\n" flds
      s!"structure {ln} where\n{body}\n"

/-- Emit a group of type definitions as a single block.
    Multi-element or self-referencing SCCs get a `mutual … end` wrapper. -/
def emitGroup (defs : List (String × TypeDefn)) (needsMutual : Bool) : String :=
  if needsMutual then
    let body := defs.map fun (name, td) => emitTypeDefn name td true
    let inner := String.intercalate "\n" body
    s!"mutual\n\n{inner}\nend -- mutual\n"
  else
    match defs with
    | [(name, td)] => emitTypeDefn name td false
    | _ => -- shouldn't happen
      (defs.map fun (n, td) => emitTypeDefn n td false) |> String.intercalate "\n"

-- ============================================================================
-- § 6  Main pipeline
-- ============================================================================

/-- Check whether an SCC requires a `mutual` block.
    True if the SCC has multiple members, or if a single member references itself. -/
def needsMutualBlock (scc : List String) (adj : String → List String) : Bool :=
  match scc with
  | [v] => (adj v).contains v  -- self-loop
  | _   => scc.length > 1

/-- Generate Lean 4 source code from an IPLD Schema.

    The output is a self-contained namespace containing `abbrev`, `structure`,
    and `inductive` declarations for every type in the schema, emitted in
    dependency order with `mutual … end` blocks where needed.

    - `schema` — the IPLD schema to compile
    - `ns` — the Lean namespace to wrap declarations in (default `"Generated"`)
-/
def generate (schema : Schema) (ns : String := "Generated") : String :=
  -- Build type lookup
  let typeLookup := schema.types
  let typeNames := typeLookup.map (·.1)

  -- Adjacency list: only edges to types defined in this schema
  let adj (name : String) : List String :=
    match typeLookup.find? (·.1 == name) with
    | some (_, td) => (typeDefnDeps td).filter fun dep => typeNames.contains dep
    | none => []

  -- Compute SCCs in dependency-first order
  let sccs := computeSCCs typeNames adj

  -- Emit each SCC as a declaration group
  let groups := sccs.map fun scc =>
    let mutual_ := needsMutualBlock scc adj
    let defs := scc.filterMap fun name =>
      match typeLookup.find? (·.1 == name) with
      | some (_, td) => some (name, td)
      | none => none
    emitGroup defs mutual_

  -- Assemble final output
  let header := s!"/-!\n  Auto-generated Lean 4 types from IPLD Schema.\n  Do not edit — regenerate from the schema instead.\n-/\n\nnamespace {ns}\n\n"
  let footer := s!"\nend {ns}\n"
  header ++ String.intercalate "\n" groups ++ footer

-- ============================================================================
-- § 7  Statistics & debugging helpers
-- ============================================================================

/-- Summarize the dependency graph and SCC structure of a schema. -/
def debugInfo (schema : Schema) : String :=
  let typeLookup := schema.types
  let typeNames := typeLookup.map (·.1)
  let adj (name : String) : List String :=
    match typeLookup.find? (·.1 == name) with
    | some (_, td) => (typeDefnDeps td).filter fun dep => typeNames.contains dep
    | none => []
  let sccs := computeSCCs typeNames adj
  let lines := (sccs.zip (List.range sccs.length)).map fun (scc, i) =>
    let mutual_ := needsMutualBlock scc adj
    let tag := if mutual_ then " [MUTUAL]" else ""
    s!"  SCC {i}: {scc}{tag}"
  s!"Schema has {typeNames.length} types in {sccs.length} SCCs:\n" ++
    String.intercalate "\n" lines

-- ============================================================================
-- § 8  Demonstration — self-describing fixed point
-- ============================================================================

-- Uncomment the following lines to see the generated code and debug info:
-- #eval IO.println (debugInfo ipldSchemaSchema)
-- #eval IO.println (generate ipldSchemaSchema "IPLD")

/-- Generate Lean 4 source for the IPLD schema-schema itself.
    This is the self-describing fixed point: the generated code should be
    structurally equivalent to the hand-written types in `IPLD.lean`. -/
def selfDescribingSource : String :=
  generate ipldSchemaSchema "IPLD"

end IPLD.CodeGen
