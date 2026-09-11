/-
# IPLD Schema — Lean 4 Formalization

This module is a faithful transcription of the **IPLD Schema schema-schema**
(the self-describing schema that defines the IPLD Schema language) into Lean 4
inductive types, structures, and type abbreviations.

Reference: <https://ipld.io/specs/schemas/schema-schema.ipldsch>

## Design notes

* **String aliases** (`TypeName`, `FieldName`, …) are `abbrev`s so that Lean
  treats them as definitionally equal to `String`.  This keeps the model light
  while retaining documentation value.
* **Empty structs** (e.g. `TypeDefnBool`, `AdvancedDataLayout`) are modelled as
  single-constructor structures with no fields.
* **Unions** are modelled as Lean `inductive` types, one constructor per member.
  The string keys that appear in keyed / kinded representations are recorded in
  doc-strings but are *not* part of the core type-level model — serialization
  concerns are kept separate.
* **Maps** in the schema (e.g. `{TypeName : TypeDefn}`) are represented as
  `List (K × V)` (association lists), preserving insertion order — a property
  that IPLD maps guarantee.  One could also use `Batteries.HashMap` or
  `Lean.RBMap`; association lists were chosen for simplicity and no extra
  dependencies.
* **Mutual recursion** among `TypeNameOrInlineDefn`, `InlineDefn`,
  `TypeDefnMap`, `TypeDefnList`, and `StructField` is handled with a single
  `mutual … end` block.
-/

namespace IPLD

-- ============================================================================
-- § 1  Simple aliases
-- ============================================================================

/-- A type name — must start with a capital ASCII letter. -/
abbrev TypeName := String

/-- An advanced data layout name — same conventions as `TypeName`. -/
abbrev AdvancedDataLayoutName := String

/-- A struct field name — should start with a lower-case letter. -/
abbrev FieldName := String

/-- An enum member name. -/
abbrev EnumMember := String

/-- A hexadecimal string, used in `UnionRepresentation_BytesPrefix`. -/
abbrev HexString := String

-- ============================================================================
-- § 2  Simple enumerations
-- ============================================================================

/-- Enumerates all major type kinds (minus the special `copy` pseudo-kind). -/
inductive TypeKind where
  | bool | string | bytes | int | float
  | map | list | link | union | struct | enum | unit | any
  deriving Repr, BEq, Inhabited

/-- The subset of `TypeKind` that exists at the IPLD Data Model level. -/
inductive RepresentationKind where
  | bool | string | bytes | int | float
  | map | list | link
  deriving Repr, BEq, Inhabited

/-- How a `TypeDefnUnit` is represented in the data model. -/
inductive UnitRepresentation where
  | null | «true» | «false» | emptymap
  deriving Repr, BEq, Inhabited

-- ============================================================================
-- § 3  Scalar union & empty marker structs
-- ============================================================================

/-- Union of the basic non-complex IPLD scalar kinds. -/
inductive AnyScalar where
  | bool   (v : Bool)
  | string (v : String)
  | bytes  (v : ByteArray)
  | int    (v : Int)
  | float  (v : Float)
  deriving BEq, Inhabited

instance : Repr AnyScalar where
  reprPrec
    | .bool v, p   => Repr.addAppParen ("IPLD.AnyScalar.bool " ++ repr v) p
    | .string v, p => Repr.addAppParen ("IPLD.AnyScalar.string " ++ repr v) p
    | .bytes v, p  => Repr.addAppParen ("IPLD.AnyScalar.bytes " ++ repr v.toList) p
    | .int v, p    => Repr.addAppParen ("IPLD.AnyScalar.int " ++ repr v) p
    | .float v, p  => Repr.addAppParen ("IPLD.AnyScalar.float " ++ repr v) p

/-- Marker for an advanced data layout entry (currently carries no data). -/
structure AdvancedDataLayout where
  deriving Repr, BEq, Inhabited

/-- `type TypeDefnBool struct {}` -/
structure TypeDefnBool where
  deriving Repr, BEq, Inhabited

/-- `type TypeDefnString struct {}` -/
structure TypeDefnString where
  deriving Repr, BEq, Inhabited

/-- `type TypeDefnInt struct {}` -/
structure TypeDefnInt where
  deriving Repr, BEq, Inhabited

/-- `type TypeDefnFloat struct {}` -/
structure TypeDefnFloat where
  deriving Repr, BEq, Inhabited

/-- `type TypeDefnAny struct {}` -/
structure TypeDefnAny where
  deriving Repr, BEq, Inhabited

/-- `type BytesRepresentation_Bytes struct {}` — the default bytes representation. -/
structure BytesRepresentation_Bytes where
  deriving Repr, BEq, Inhabited

/-- `type MapRepresentation_ListPairs struct {}` -/
structure MapRepresentation_ListPairs where
  deriving Repr, BEq, Inhabited

/-- `type StructRepresentation_ListPairs struct {}` -/
structure StructRepresentation_ListPairs where
  deriving Repr, BEq, Inhabited

-- ============================================================================
-- § 4  Non-recursive representation types
-- ============================================================================

/-- How bytes are serialized — either natively or via an ADL. -/
inductive BytesRepresentation where
  | bytes    : BytesRepresentation_Bytes → BytesRepresentation
  | advanced : AdvancedDataLayoutName    → BytesRepresentation
  deriving Repr, BEq, Inhabited

/-- String-pairs encoding for maps: `"k1=v1,k2=v2"`. -/
structure MapRepresentation_StringPairs where
  innerDelim : String
  entryDelim : String
  deriving Repr, BEq, Inhabited

/-- How a map is represented in the data model. -/
inductive MapRepresentation where
  | stringpairs : MapRepresentation_StringPairs → MapRepresentation
  | listpairs   : MapRepresentation_ListPairs   → MapRepresentation
  | advanced    : AdvancedDataLayoutName         → MapRepresentation
  deriving Repr, BEq, Inhabited

/-- How a list is represented — currently only an ADL override. -/
inductive ListRepresentation where
  | advanced : AdvancedDataLayoutName → ListRepresentation
  deriving Repr, BEq, Inhabited

/-- A link type definition, with an optional expected type (default `"Any"`). -/
structure TypeDefnLink where
  expectedType : TypeName := "Any"
  deriving Repr, BEq, Inhabited

/-- Inline union member within a union — restricted to links. -/
inductive UnionMemberInlineDefn where
  | link : TypeDefnLink → UnionMemberInlineDefn
  deriving Repr, BEq, Inhabited

/-- Identifies a member of a union — either a named type or an inline link. -/
inductive UnionMember where
  | typeName  : TypeName              → UnionMember
  | inlineDefn : UnionMemberInlineDefn → UnionMember
  deriving Repr, BEq, Inhabited

/-- Kinded union: maps `RepresentationKind` → `UnionMember`. -/
abbrev UnionRepresentation_Kinded := List (RepresentationKind × UnionMember)

/-- Keyed union: maps discriminant string → `UnionMember`. -/
abbrev UnionRepresentation_Keyed := List (String × UnionMember)

/-- Envelope union representation. -/
structure UnionRepresentation_Envelope where
  discriminantKey   : String
  contentKey        : String
  discriminantTable : List (String × UnionMember)
  deriving Repr, BEq, Inhabited

/-- Inline union representation. -/
structure UnionRepresentation_Inline where
  discriminantKey   : String
  discriminantTable : List (String × TypeName)
  deriving Repr, BEq, Inhabited

/-- String-prefix union representation. -/
structure UnionRepresentation_StringPrefix where
  prefixes : List (String × TypeName)
  deriving Repr, BEq, Inhabited

/-- Bytes-prefix union representation (hex-encoded prefixes). -/
structure UnionRepresentation_BytesPrefix where
  prefixes : List (HexString × TypeName)
  deriving Repr, BEq, Inhabited

/-- The six union representation strategies. -/
inductive UnionRepresentation where
  | kinded       : UnionRepresentation_Kinded       → UnionRepresentation
  | keyed        : UnionRepresentation_Keyed        → UnionRepresentation
  | envelope     : UnionRepresentation_Envelope     → UnionRepresentation
  | inline       : UnionRepresentation_Inline       → UnionRepresentation
  | stringprefix : UnionRepresentation_StringPrefix → UnionRepresentation
  | bytesprefix  : UnionRepresentation_BytesPrefix  → UnionRepresentation
  deriving Repr, BEq, Inhabited

/-- Per-field details in a map representation of a struct. -/
structure StructRepresentation_Map_FieldDetails where
  rename   : Option String    := none
  implicit : Option AnyScalar := none
  deriving Repr, BEq, Inhabited

/-- Map representation of a struct, with optional per-field overrides. -/
structure StructRepresentation_Map where
  fields : Option (List (FieldName × StructRepresentation_Map_FieldDetails)) := none
  deriving Repr, BEq, Inhabited

/-- Tuple representation of a struct. -/
structure StructRepresentation_Tuple where
  fieldOrder : Option (List FieldName) := none
  deriving Repr, BEq, Inhabited

/-- String-pairs representation of a struct: `"k1=v1,k2=v2"`. -/
structure StructRepresentation_StringPairs where
  innerDelim : String
  entryDelim : String
  deriving Repr, BEq, Inhabited

/-- String-join representation of a struct: values joined by a delimiter. -/
structure StructRepresentation_StringJoin where
  join       : String
  fieldOrder : Option (List FieldName) := none
  deriving Repr, BEq, Inhabited

/-- The five struct representation strategies. -/
inductive StructRepresentation where
  | map         : StructRepresentation_Map         → StructRepresentation
  | tuple       : StructRepresentation_Tuple       → StructRepresentation
  | stringpairs : StructRepresentation_StringPairs → StructRepresentation
  | stringjoin  : StructRepresentation_StringJoin  → StructRepresentation
  | listpairs   : StructRepresentation_ListPairs   → StructRepresentation
  deriving Repr, BEq, Inhabited

/-- String representation for an enum (maps members to custom strings). -/
abbrev EnumRepresentation_String := List (EnumMember × String)

/-- Int representation for an enum (maps members to integers). -/
abbrev EnumRepresentation_Int := List (EnumMember × Int)

/-- How an enum is serialized — as strings or as integers. -/
inductive EnumRepresentation where
  | string : EnumRepresentation_String → EnumRepresentation
  | int    : EnumRepresentation_Int    → EnumRepresentation
  deriving Repr, BEq, Inhabited

-- ============================================================================
-- § 5  Mutually recursive core types
-- ============================================================================

-- The types `TypeNameOrInlineDefn`, `InlineDefn`, `TypeDefnMap`, `TypeDefnList`,
-- and `StructField` form a mutually recursive cluster because inline type
-- definitions (maps, lists, links) can appear wherever a type reference is
-- expected — which includes inside maps, lists, and struct fields.

mutual

/-- Either a reference to a named type, or an anonymous inline definition. -/
inductive TypeNameOrInlineDefn where
  | typeName  : TypeName  → TypeNameOrInlineDefn
  | inlineDefn : InlineDefn → TypeNameOrInlineDefn

/-- An anonymous inline type definition — restricted to map, list, or link. -/
inductive InlineDefn where
  | map  : TypeDefnMap  → InlineDefn
  | list : TypeDefnList → InlineDefn
  | link : TypeDefnLink → InlineDefn

/-- A map type definition. -/
inductive TypeDefnMap where
  | mk
    (keyType        : TypeName)
    (valueType      : TypeNameOrInlineDefn)
    (valueNullable  : Bool := false)
    (representation : Option MapRepresentation := none)
    : TypeDefnMap

/-- A list type definition. -/
inductive TypeDefnList where
  | mk
    (valueType      : TypeNameOrInlineDefn)
    (valueNullable  : Bool := false)
    (representation : Option ListRepresentation := none)
    : TypeDefnList

/-- Describes a single field within a struct type. -/
inductive StructField where
  | mk
    (type_    : TypeNameOrInlineDefn)
    (optional : Bool := false)
    (nullable : Bool := false)
    : StructField

end -- mutual

-- ============================================================================
-- § 6  Compound type definitions (depend on § 5)
-- ============================================================================

/-- `type TypeDefnBytes struct { representation BytesRepresentation }` -/
structure TypeDefnBytes where
  representation : BytesRepresentation := .bytes {}
  deriving Repr, BEq, Inhabited

/-- A union type definition. -/
structure TypeDefnUnion where
  members        : List UnionMember
  representation : UnionRepresentation
  deriving Repr, BEq, Inhabited

/-- A struct type definition. -/
structure TypeDefnStruct where
  fields         : List (FieldName × StructField)
  representation : StructRepresentation
  -- no deriving due to StructField being from a mutual block

/-- An enum type definition. -/
structure TypeDefnEnum where
  members        : List EnumMember
  representation : EnumRepresentation
  deriving Repr, BEq, Inhabited

/-- A unit type — the representation determines how it serializes. -/
structure TypeDefnUnit where
  representation : UnitRepresentation
  deriving Repr, BEq, Inhabited

/-- A copy-type: copies the full definition of another named type. -/
structure TypeDefnCopy where
  fromType : TypeName
  deriving Repr, BEq, Inhabited

-- ============================================================================
-- § 7  TypeDefn — the top-level union of all type kinds
-- ============================================================================

/--
`TypeDefn` is the discriminated union of every kind of type definition.
In the serial form (keyed representation), each variant is identified by
a string key such as `"bool"`, `"map"`, `"struct"`, etc.
-/
inductive TypeDefn where
  | bool   : TypeDefnBool   → TypeDefn
  | string : TypeDefnString → TypeDefn
  | bytes  : TypeDefnBytes  → TypeDefn
  | int    : TypeDefnInt    → TypeDefn
  | float  : TypeDefnFloat  → TypeDefn
  | map    : TypeDefnMap    → TypeDefn
  | list   : TypeDefnList   → TypeDefn
  | link   : TypeDefnLink   → TypeDefn
  | union  : TypeDefnUnion  → TypeDefn
  | struct : TypeDefnStruct → TypeDefn
  | enum   : TypeDefnEnum   → TypeDefn
  | unit   : TypeDefnUnit   → TypeDefn
  | any    : TypeDefnAny    → TypeDefn
  | copy   : TypeDefnCopy   → TypeDefn

-- ============================================================================
-- § 8  Schema — the root type
-- ============================================================================

/-- The map from `AdvancedDataLayoutName` to `AdvancedDataLayout`. -/
abbrev AdvancedDataLayoutMap := List (AdvancedDataLayoutName × AdvancedDataLayout)

/--
`Schema` is the root element of an IPLD Schema document.

```json
{
  "types": {
    "MyFooType": { "string": {} }
  }
}
```
-/
structure Schema where
  /-- The named type definitions that make up this schema. -/
  types    : List (TypeName × TypeDefn)
  /-- Optional map of advanced data layout declarations. -/
  advanced : Option AdvancedDataLayoutMap := none

-- ============================================================================
-- § 9  Convenience constructors & accessors for the mutual-block types
-- ============================================================================

namespace TypeDefnMap

def keyType : TypeDefnMap → TypeName
  | .mk k _ _ _ => k

def valueType : TypeDefnMap → TypeNameOrInlineDefn
  | .mk _ v _ _ => v

def valueNullable : TypeDefnMap → Bool
  | .mk _ _ n _ => n

def representation : TypeDefnMap → Option MapRepresentation
  | .mk _ _ _ r => r

end TypeDefnMap

namespace TypeDefnList

def valueType : TypeDefnList → TypeNameOrInlineDefn
  | .mk v _ _ => v

def valueNullable : TypeDefnList → Bool
  | .mk _ n _ => n

def representation : TypeDefnList → Option ListRepresentation
  | .mk _ _ r => r

end TypeDefnList

namespace StructField

def type_ : StructField → TypeNameOrInlineDefn
  | .mk t _ _ => t

def optional : StructField → Bool
  | .mk _ o _ => o

def nullable : StructField → Bool
  | .mk _ _ n => n

end StructField

-- ============================================================================
-- § 10  Schema-Schema Self-Description
-- ============================================================================

/--
The IPLD Schema schema-schema expressed as a concrete `Schema` value.
This is the fixed-point property: the IPLD Schema language can describe
its own type system using itself.

This encodes the key types from the schema-schema specification.
Not every type is included inline (that would be hundreds of entries),
but the structural skeleton demonstrates the self-hosting property.
-/
def schemaSchema : Schema where
  types := [
    -- § Aliases are just strings
    ("TypeName",              .string {}),
    ("AdvancedDataLayoutName", .string {}),
    ("FieldName",             .string {}),
    ("EnumMember",            .string {}),
    ("HexString",             .string {}),

    -- § TypeKind enum
    ("TypeKind", .enum {
      members := ["Bool", "String", "Bytes", "Int", "Float",
                  "Map", "List", "Link", "Union", "Struct", "Enum", "Unit", "Any"],
      representation := .string []
    }),

    -- § RepresentationKind enum
    ("RepresentationKind", .enum {
      members := ["Bool", "String", "Bytes", "Int", "Float",
                  "Map", "List", "Link"],
      representation := .string []
    }),

    -- § UnitRepresentation enum
    ("UnitRepresentation", .enum {
      members := ["Null", "True", "False", "Emptymap"],
      representation := .string []
    }),

    -- § AnyScalar union (kinded)
    ("AnyScalar", .union {
      members := [.typeName "Bool", .typeName "String",
                  .typeName "Bytes", .typeName "Int", .typeName "Float"],
      representation := .kinded [
        (.bool,   .typeName "Bool"),
        (.string, .typeName "String"),
        (.bytes,  .typeName "Bytes"),
        (.int,    .typeName "Int"),
        (.float,  .typeName "Float")
      ]
    }),

    -- § TypeDefn union (keyed, 14 variants)
    ("TypeDefn", .union {
      members := [.typeName "TypeDefnBool", .typeName "TypeDefnString",
                  .typeName "TypeDefnBytes", .typeName "TypeDefnInt",
                  .typeName "TypeDefnFloat", .typeName "TypeDefnMap",
                  .typeName "TypeDefnList", .typeName "TypeDefnLink",
                  .typeName "TypeDefnUnion", .typeName "TypeDefnStruct",
                  .typeName "TypeDefnEnum", .typeName "TypeDefnUnit",
                  .typeName "TypeDefnAny", .typeName "TypeDefnCopy"],
      representation := .keyed [
        ("bool",   .typeName "TypeDefnBool"),
        ("string", .typeName "TypeDefnString"),
        ("bytes",  .typeName "TypeDefnBytes"),
        ("int",    .typeName "TypeDefnInt"),
        ("float",  .typeName "TypeDefnFloat"),
        ("map",    .typeName "TypeDefnMap"),
        ("list",   .typeName "TypeDefnList"),
        ("link",   .typeName "TypeDefnLink"),
        ("union",  .typeName "TypeDefnUnion"),
        ("struct", .typeName "TypeDefnStruct"),
        ("enum",   .typeName "TypeDefnEnum"),
        ("unit",   .typeName "TypeDefnUnit"),
        ("any",    .typeName "TypeDefnAny"),
        ("copy",   .typeName "TypeDefnCopy")
      ]
    }),

    -- § Schema struct (the root)
    ("Schema", .struct {
      fields := [
        ("types", .mk (.typeName "TypeMap")),
        ("advanced", .mk (.typeName "AdvancedDataLayoutMap") true)
      ],
      representation := .map {}
    }),

    -- § TypeMap is Map<TypeName, TypeDefn>
    ("TypeMap", .map (.mk "TypeName" (.typeName "TypeDefn"))),

    -- § AdvancedDataLayoutMap
    ("AdvancedDataLayoutMap", .map
      (.mk "AdvancedDataLayoutName" (.typeName "AdvancedDataLayout"))),

    -- § Marker structs
    ("TypeDefnBool",   .bool {}),
    ("TypeDefnString", .string {}),
    ("TypeDefnInt",    .int {}),
    ("TypeDefnFloat",  .float {}),
    ("TypeDefnAny",    .any {}),
    ("AdvancedDataLayout", .struct {
      fields := [],
      representation := .map {}
    }),

    -- § TypeDefnLink
    ("TypeDefnLink", .struct {
      fields := [
        ("expectedType", .mk (.typeName "TypeName") false false)
      ],
      representation := .map {}
    }),

    -- § TypeDefnCopy
    ("TypeDefnCopy", .struct {
      fields := [
        ("fromType", .mk (.typeName "TypeName"))
      ],
      representation := .map {}
    }),

    -- § TypeDefnUnit
    ("TypeDefnUnit", .struct {
      fields := [
        ("representation", .mk (.typeName "UnitRepresentation"))
      ],
      representation := .map {}
    })
  ]
  advanced := none

/-- The schema-schema has at least 20 type entries. -/
theorem schemaSchema_types_count :
    schemaSchema.types.length ≥ 20 := by native_decide

-- ============================================================================
-- § 11  TypeDefn ↔ TypeKind projection
-- ============================================================================

/-- Extract the `TypeKind` from a `TypeDefn`. -/
def TypeDefn.kind : TypeDefn → TypeKind
  | .bool _   => .bool
  | .string _ => .string
  | .bytes _  => .bytes
  | .int _    => .int
  | .float _  => .float
  | .map _    => .map
  | .list _   => .list
  | .link _   => .link
  | .union _  => .union
  | .struct _ => .struct
  | .enum _   => .enum
  | .unit _   => .unit
  | .any _    => .any
  | .copy _   => .map  -- copy inherits from source; mapped to map as placeholder

-- ============================================================================
-- § 12  Schema utilities
-- ============================================================================

/-- Look up a type by name in a schema. -/
def Schema.lookupType (s : Schema) (name : TypeName) : Option TypeDefn :=
  (s.types.find? (·.1 == name)).map (·.2)

/-- List all type names in a schema. -/
def Schema.typeNames (s : Schema) : List TypeName :=
  s.types.map (·.1)

/-- Count types in a schema. -/
def Schema.typeCount (s : Schema) : Nat :=
  s.types.length

end IPLD
