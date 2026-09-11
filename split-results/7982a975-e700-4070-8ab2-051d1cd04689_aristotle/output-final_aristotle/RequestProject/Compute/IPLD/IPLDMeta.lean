/-
# IPLD Schema → Lean 4 Metaprogramming Pipeline

This module uses Lean 4's metaprogramming to **incrementally construct and
kernel-verify** type declarations from an `IPLD.Schema` value.

Each type (or mutually recursive group) is:
1. Generated as Lean 4 source text (via `CodeGen`)
2. Parsed into `Lean.Syntax`
3. Elaborated via `elabCommand` — the **kernel type-checks** the declaration
4. Added to the live environment

Every generated declaration is kernel-verified at the moment it is created.
If any declaration is ill-typed (references an undefined type, fails
the positivity checker, etc.) elaboration fails immediately.

## Usage

```lean

-- Derive all 55 IPLD schema-schema types into namespace `Gen`,
-- each kernel-verified incrementally:
#ipld_derive_self in Gen

-- Now use the generated types:
#check Gen.Schema
#check Gen.TypeDefn
```

## Architecture

```
   IPLD.ipldSchemaSchema : Schema    (compile-time constant)
            ↓
   CodeGen.emitGroup     : String    (per SCC)
            ↓
   Parser.runParserCategory : Syntax
            ↓
   elabCommand                       (kernel checks)
            ↓
   Environment extension             (available to later code)
```
-/

import Lean
import RequestProject.Compute.IPLD.IPLDCodeGen

open Lean Elab Command Parser

namespace IPLD.Meta

-- ============================================================================
-- § 1  Core: parse + elaborate a code fragment
-- ============================================================================

/-- Parse a string as a Lean 4 command and elaborate it into the current
    environment. The kernel type-checks the result, so any ill-formed
    declaration is caught immediately with a precise error. -/
def parseAndElabCommand (code : String) (srcRef : String := "<ipld-codegen>")
    : CommandElabM Unit := do
  let env ← getEnv
  match runParserCategory env `command code srcRef with
  | .ok stx    => elabCommand stx
  | .error msg => throwError "IPLD codegen parse error:\n{msg}\n\nGenerated code:\n{code}"

-- ============================================================================
-- § 2  Incremental schema elaboration
-- ============================================================================

/-- Elaborate all type declarations from an `IPLD.Schema`, one SCC at a time.

    The pipeline:
    1. Computes the dependency graph among the schema's types
    2. Finds strongly connected components (Kosaraju's algorithm)
    3. For each SCC (in dependency order, leaves first):
       a. Generates Lean 4 source text (`structure`, `inductive`, or `abbrev`)
       b. Parses it into `Syntax`
       c. Elaborates it — the **kernel verifies** the declaration
    4. Logs progress after each group

    If any type fails kernel verification (e.g. references an undefined name,
    violates strict positivity), the process stops with an error at that step.
-/
def elaborateSchema (schema : Schema) (ns : Name) : CommandElabM Unit := do
  let typeLookup := schema.types
  let typeNames := typeLookup.map (·.1)

  -- Build adjacency list (only internal deps)
  let adj (name : String) : List String :=
    match typeLookup.find? (·.1 == name) with
    | some (_, td) => (CodeGen.typeDefnDeps td).filter typeNames.contains
    | none => []

  -- Compute SCCs in dependency order (leaves first)
  let sccs := CodeGen.computeSCCs typeNames adj

  -- Open the target namespace
  parseAndElabCommand s!"section {ns}_Section"
  parseAndElabCommand s!"namespace {ns}"

  let mut elaborated : Nat := 0

  -- Elaborate each SCC group incrementally
  for scc in sccs do
    let needsMutual := CodeGen.needsMutualBlock scc adj
    let defs := scc.filterMap fun name =>
      match typeLookup.find? (·.1 == name) with
      | some (_, td) => some (name, td)
      | none => none

    if defs.isEmpty then continue

    -- Generate source text for this group
    let code := CodeGen.emitGroup defs needsMutual

    -- Log what we're about to elaborate
    let tag := if needsMutual then " (mutual)" else ""
    let names := scc.map (s!"  • {·}") |> String.intercalate "\n"
    logInfo m!"⊢ Step {elaborated + 1}: Elaborating{tag}:\n{names}"

    -- Parse and elaborate — kernel verifies this declaration
    parseAndElabCommand code

    elaborated := elaborated + defs.length
    logInfo m!"✓ Kernel-verified ({elaborated}/{typeNames.length}): {scc}"

  -- Close namespace and section
  parseAndElabCommand s!"end {ns}"
  parseAndElabCommand s!"end {ns}_Section"

  logInfo m!"✅ Complete: all {typeNames.length} types elaborated and \
    kernel-verified in namespace `{ns}`."

-- ============================================================================
-- § 3  User-facing commands
-- ============================================================================

/-- `#ipld_derive_self in <ns>` — derive all types from the IPLD schema-schema
    (`ipldSchemaSchema`) into namespace `<ns>`.

    Each type is kernel-checked incrementally. This is the self-describing
    fixed point: the generated types are structurally equivalent to the
    hand-written types in `IPLD.lean`, and they were derived from the
    `IPLD.Schema` value that *uses* those very types. -/
elab "#ipld_derive_self" " in " ns:ident : command => do
  elaborateSchema ipldSchemaSchema ns.getId

/-- `#ipld_debug_self` — print the SCC structure and dependency analysis
    of the IPLD schema-schema without elaborating anything. -/
elab "#ipld_debug_self" : command => do
  logInfo m!"{CodeGen.debugInfo ipldSchemaSchema}"

-- ============================================================================
-- § 4  Source text export (no elaboration)
-- ============================================================================

/-- `#ipld_print_self in <ns>` — print the generated Lean 4 source text for
    the IPLD schema-schema without elaborating it. Useful for inspection
    or pasting into a separate file. -/
elab "#ipld_print_self" " in " ns:ident : command => do
  let code := CodeGen.generate ipldSchemaSchema (toString ns.getId)
  logInfo m!"Generated Lean 4 source ({ipldSchemaSchema.types.length} types):\n\n{code}"

end IPLD.Meta

/-! ## Merged from IPLDDemo.lean (semantic dedup: IPLD meta pipeline) -/

/-
# IPLD Schema Code Generation Demo

This file demonstrates the self-describing fixed point in action:

1. `IPLD.ipldSchemaSchema` is a value of type `IPLD.Schema` that describes
   the IPLD Schema language using the very types defined in `IPLD.lean`.

2. `#ipld_derive_self in Gen` walks that value and **incrementally generates
   and kernel-verifies** all 55 type declarations in namespace `Gen`.

3. The generated types in `Gen` are structurally equivalent to the hand-written
   types in the `IPLD` namespace — closing the self-describing loop.

Each step below is kernel-checked by the Lean elaborator as it is processed.
-/


-- ============================================================================
-- Generate all IPLD schema-schema types into namespace `Gen`
-- ============================================================================

-- This command walks `ipldSchemaSchema`, computes SCCs for mutual recursion,
-- and elaborates each type declaration incrementally.
-- The kernel verifies every declaration as it is added.
set_option maxHeartbeats 400000 in
#ipld_derive_self in Gen

-- ============================================================================
-- Verify the generated types exist and have the expected structure
-- ============================================================================

-- String aliases
#check (Gen.TypeName : Type)
#check (Gen.FieldName : Type)
#check (Gen.HexString : Type)

-- Enumerations
#check (Gen.TypeKind : Type)
#check Gen.TypeKind.bool
#check Gen.TypeKind.struct

#check (Gen.RepresentationKind : Type)
#check Gen.RepresentationKind.map

#check (Gen.UnitRepresentation : Type)

-- Empty marker structs
#check (Gen.TypeDefnBool : Type)
#check (Gen.TypeDefnString : Type)
#check (Gen.AdvancedDataLayout : Type)

-- Compound types
#check (Gen.TypeDefn : Type)
#check (Gen.Schema : Type)
#check (Gen.StructField : Type)

-- The mutual recursive cluster
#check (Gen.TypeNameOrInlineDefn : Type)
#check (Gen.InlineDefn : Type)
#check (Gen.TypeDefnMap : Type)
#check (Gen.TypeDefnList : Type)

-- Representation types
#check (Gen.StructRepresentation : Type)
#check (Gen.UnionRepresentation : Type)
#check (Gen.MapRepresentation : Type)

-- ============================================================================
-- Construct values of the generated types — proving they're usable
-- ============================================================================

-- A simple schema with one string type
example : Gen.Schema where
  types := [("MyString", .typeDefnString {})]
  advanced := none

-- A struct type with fields
example : Gen.TypeDefnStruct where
  fields := [
    ("name",  .mk (.typeName "String") false false),
    ("age",   .mk (.typeName "Int") true false)  -- optional
  ]
  representation := .structRepresentation_Map ⟨none⟩
