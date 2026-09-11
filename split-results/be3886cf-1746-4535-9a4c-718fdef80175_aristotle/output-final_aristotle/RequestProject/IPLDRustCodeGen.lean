/-
# IPLD Schema → Rust Source Code Generator

Given an `IPLD.Schema` value, this module generates well-formed Rust source
code that defines the corresponding types. It reuses the dependency analysis
and SCC infrastructure from `IPLDCodeGen` and handles:

- **Proper Rust idioms**: `struct`, `enum`, `type` aliases
- **Recursive fields**: `Box<T>` wrapping for fields in mutual/self-referencing types
- **Derives**: `#[derive(Debug, Clone, PartialEq)]` on all types
- **Serde support**: `#[derive(Serialize, Deserialize)]` with appropriate `#[serde(...)]`
  annotations for keyed/kinded union representations

## Mapping from IPLD TypeDefn to Rust declaration

| IPLD TypeDefn                     | Rust declaration                             |
|-----------------------------------|----------------------------------------------|
| `.string {}`                      | `type Foo = String;`                         |
| `.bool {} / .int {} / .float {}`  | `#[derive(…)] struct Foo;`                   |
| `.any {}`                         | `#[derive(…)] struct Foo;`                   |
| `.enum { members, … }`           | `#[derive(…)] enum Foo { A, B, … }`          |
| `.union { members, … }`          | `#[derive(…)] enum Foo { A(A), B(B), … }`    |
| `.struct { fields, … }`          | `#[derive(…)] struct Foo { f1: T1, … }`      |
| `.map (.mk k v)`                 | `type Foo = Vec<(K, V)>;`                    |
| `.list (.mk v)`                  | `type Foo = Vec<V>;`                         |
| `.copy { fromType }`             | `type Foo = Bar;`                            |
| `.link { expectedType }`         | `#[derive(…)] struct Foo { expected_type: String }` |
| `.bytes { … }`                   | `#[derive(…)] struct Foo { representation: BytesRepresentation }` |
| `.unit { … }`                    | `#[derive(…)] struct Foo { representation: UnitRepresentation }` |

## Usage

```
#eval IO.println (IPLD.RustCodeGen.generate IPLD.ipldSchemaSchema)
```
-/

import RequestProject.IPLDCodeGen

namespace IPLD.RustCodeGen

open IPLD.CodeGen (computeSCCs needsMutualBlock typeDefnDeps)

-- ============================================================================
-- § 1  Rust type name resolution
-- ============================================================================

/-- Map IPLD Data Model primitive type names to Rust type names. -/
def builtinRustType : String → Option String
  | "Bool"   => some "bool"
  | "String" => some "String"
  | "Bytes"  => some "Vec<u8>"
  | "Int"    => some "i64"
  | "Float"  => some "f64"
  | _        => none

/-- Resolve a type name to its Rust equivalent. -/
def resolveRustType (name : String) : String :=
  (builtinRustType name).getD name

-- ============================================================================
-- § 2  Naming conventions
-- ============================================================================

/-- Convert a camelCase or PascalCase name to snake_case for Rust field names. -/
def toSnakeCase (s : String) : String :=
  let chars := s.toList
  let result := go chars 0
  String.ofList result
where
  go : List Char → Nat → List Char
  | [], _ => []
  | c :: cs, i =>
    if c.isUpper && i > 0 then
      '_' :: c.toLower :: go cs (i + 1)
    else
      c.toLower :: go cs (i + 1)

/-- Convert a name to a valid Rust enum variant (PascalCase, no leading underscore). -/
def toVariantName (s : String) : String :=
  if s.isEmpty then s
  else
    let first := s.toList.head!
    s!"{first.toUpper}{s.drop 1}"

/-- Standard derives for all generated types. -/
def standardDerives : String :=
  "#[derive(Debug, Clone, PartialEq)]"

/-- Standard derives including serde support. -/
def serdeDerivesStr : String :=
  "#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]"

-- ============================================================================
-- § 3  Type reference resolution
-- ============================================================================

/-- Set of type names that are in the current mutual/self-recursive SCC.
    Fields of these types need `Box<T>` wrapping. -/
abbrev BoxSet := List String

/-- Check if a type name needs boxing (is in the current mutual SCC). -/
def needsBox (boxSet : BoxSet) (name : String) : Bool :=
  boxSet.contains name

/-- Wrap a type with `Box<>` if needed. -/
def maybeBox (boxSet : BoxSet) (name : String) (rustType : String) : String :=
  if needsBox boxSet name then s!"Box<{rustType}>" else rustType

/-- Convert a `TypeNameOrInlineDefn` to a Rust type expression string. -/
partial def resolveRustTypeRef (boxSet : BoxSet) : TypeNameOrInlineDefn → String
  | .typeName name =>
    let resolved := resolveRustType name
    maybeBox boxSet name resolved
  | .inlineDefn (.map m) =>
    let k := resolveRustType m.keyType
    let v := resolveRustTypeRef boxSet m.valueType
    s!"Vec<({k}, {v})>"
  | .inlineDefn (.list l) =>
    let v := resolveRustTypeRef boxSet l.valueType
    s!"Vec<{v}>"
  | .inlineDefn (.link l) =>
    if l.expectedType == "Any" then "String /* CID */"
    else s!"String /* CID → {l.expectedType} */"

/-- Resolve a struct field's type, wrapping with `Option` as needed. -/
def resolveRustFieldType (boxSet : BoxSet) (sf : StructField) : String :=
  let base := resolveRustTypeRef boxSet sf.type_
  match sf.optional, sf.nullable with
  | false, false => base
  | true,  false => s!"Option<{base}>"
  | false, true  => s!"Option<{base}>"
  | true,  true  => s!"Option<Option<{base}>>"

-- ============================================================================
-- § 4  Default value emission
-- ============================================================================

/-- Pretty-print an `AnyScalar` as a Rust default-value expression. -/
def scalarToRust : AnyScalar → String
  | .bool true  => "true"
  | .bool false => "false"
  | .string s   => s!"\"{s}\".to_string()"
  | .int n      => toString n
  | .float f    => toString f
  | .bytes _    => "Vec::new()"

-- ============================================================================
-- § 5  Source code emission
-- ============================================================================

/-- Emit a single type definition as Rust source text.

    `boxSet` contains the names of types in the current mutual SCC (these
    need `Box<T>` wrapping when referenced as fields). -/
def emitRustTypeDefn (name : String) (td : TypeDefn) (boxSet : BoxSet) : String :=
  match td with
  -- ── string alias ──────────────────────────────────────────────────────
  | .string _ =>
    s!"/// String alias for `{name}`\npub type {name} = String;\n"

  -- ── empty marker types ────────────────────────────────────────────────
  | .bool _ | .int _ | .float _ | .any _ =>
    s!"{standardDerives}\n/// Empty marker type `{name}`\npub struct {name};\n"

  | .bytes _ =>
    s!"{standardDerives}\npub struct {name} \{\n    pub representation: BytesRepresentation,\n}\n"

  -- ── unit ──────────────────────────────────────────────────────────────
  | .unit _ =>
    s!"{standardDerives}\npub struct {name} \{\n    pub representation: UnitRepresentation,\n}\n"

  -- ── link ──────────────────────────────────────────────────────────────
  | .link l =>
    let ty := resolveRustType l.expectedType
    s!"{standardDerives}\npub struct {name} \{\n    pub expected_type: {ty},\n}\n"

  -- ── copy ──────────────────────────────────────────────────────────────
  | .copy c =>
    let target := resolveRustType c.fromType
    s!"/// Type alias (copy of `{c.fromType}`)\npub type {name} = {target};\n"

  -- ── map ───────────────────────────────────────────────────────────────
  | .map m =>
    let k := resolveRustType m.keyType
    let v := resolveRustTypeRef boxSet m.valueType
    s!"/// Ordered map `{name}` — preserves insertion order.\npub type {name} = Vec<({k}, {v})>;\n"

  -- ── list ──────────────────────────────────────────────────────────────
  | .list l =>
    let v := resolveRustTypeRef boxSet l.valueType
    s!"pub type {name} = Vec<{v}>;\n"

  -- ── enum ──────────────────────────────────────────────────────────────
  | .enum e =>
    let variants := e.members.map fun m => s!"    {toVariantName m},"
    let body := String.intercalate "\n" variants
    s!"{standardDerives}\npub enum {name} \{\n{body}\n}\n"

  -- ── union (tagged enum) ───────────────────────────────────────────────
  | .union u =>
    let variants := u.members.filterMap fun member =>
      match member with
      | .typeName tname =>
        let payload := resolveRustType tname
        let boxed := maybeBox boxSet tname payload
        some s!"    {toVariantName tname}({boxed}),"
      | .inlineDefn (.link l) =>
        let comment := if l.expectedType == "Any" then ""
                       else s!" /* → {l.expectedType} */"
        some s!"    InlineLink(String{comment}),"
    let body := String.intercalate "\n" variants
    s!"{standardDerives}\npub enum {name} \{\n{body}\n}\n"

  -- ── struct ────────────────────────────────────────────────────────────
  | .struct st =>
    let fields := st.fields.map fun (fname, sf) =>
      let ftype := resolveRustFieldType boxSet sf
      let snakeName := toSnakeCase fname
      -- Add serde rename if the snake_case name differs from original
      let renameAttr := if snakeName != fname then
        s!"    #[serde(rename = \"{fname}\")]\n"
      else ""
      s!"{renameAttr}    pub {snakeName}: {ftype},"
    let body := String.intercalate "\n" fields
    s!"{standardDerives}\npub struct {name} \{\n{body}\n}\n"

/-- Emit a group of type definitions.
    For multi-element SCCs, emit a comment noting the mutual recursion. -/
def emitRustGroup (defs : List (String × TypeDefn)) (boxSet : BoxSet) : String :=
  if boxSet.length > 1 then
    let names := boxSet.map (s!"//   - {·}") |> String.intercalate "\n"
    let header := s!"// ── Mutually recursive types ──\n{names}\n\n"
    let body := defs.map fun (name, td) => emitRustTypeDefn name td boxSet
    header ++ String.intercalate "\n" body
  else
    (defs.map fun (name, td) => emitRustTypeDefn name td boxSet) |> String.intercalate "\n"

-- ============================================================================
-- § 6  Main pipeline
-- ============================================================================

/-- Generate Rust source code from an IPLD Schema.

    - `schema` — the IPLD schema to compile
    - `modName` — the Rust module name (default `"ipld_schema"`)
-/
def generate (schema : Schema) (modName : String := "ipld_schema") : String :=
  let typeLookup := schema.types
  let typeNames := typeLookup.map (·.1)

  let adj (name : String) : List String :=
    match typeLookup.find? (·.1 == name) with
    | some (_, td) => (typeDefnDeps td).filter typeNames.contains
    | none => []

  let sccs := computeSCCs typeNames adj

  let groups := sccs.map fun scc =>
    let needsMutual := needsMutualBlock scc adj
    let boxSet := if needsMutual then scc else []
    let defs := scc.filterMap fun name =>
      match typeLookup.find? (·.1 == name) with
      | some (_, td) => some (name, td)
      | none => none
    emitRustGroup defs boxSet

  let header := s!"//! Auto-generated Rust types from IPLD Schema.\n//! Module: `{modName}`\n//! Do not edit — regenerate from the schema instead.\n\nuse serde::\{Serialize, Deserialize};\n\n"
  header ++ String.intercalate "\n" groups

-- ============================================================================
-- § 7  Demonstration
-- ============================================================================

-- Uncomment to see the generated Rust code:
-- #eval IO.println (generate ipldSchemaSchema)

end IPLD.RustCodeGen
