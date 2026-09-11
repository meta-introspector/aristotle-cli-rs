/-
# IPLD Schema Schema-Schema — Self-Describing Value

This module defines `IPLD.ipldSchemaSchema`, a term of type `IPLD.Schema` that
encodes the IPLD Schema language's own schema using the very types defined in
`IPLD.lean`. This is the Lean analogue of IPLD's self-describing property:
the schema-schema expressed as a value of its own root type.

Every type from the original JSON schema-schema
(<https://ipld.io/specs/schemas/schema-schema.ipldsch>) is faithfully encoded
as a `(TypeName, TypeDefn)` entry in the `types` list.
-/

import RequestProject.IPLD

namespace IPLD

-- ============================================================================
-- Helper abbreviations to reduce verbosity
-- ============================================================================

/-- A required struct field referencing a named type. -/
private abbrev reqField (name : String) : StructField :=
  .mk (.typeName name)

/-- An optional struct field referencing a named type. -/
private abbrev optField (name : String) : StructField :=
  .mk (.typeName name) (optional := true)

/-- A required struct field with an inline map type. -/
private abbrev reqMapField (k v : String) : StructField :=
  .mk (.inlineDefn (.map (.mk k (.typeName v))))

/-- An optional struct field with an inline map type. -/
private abbrev optMapField (k v : String) : StructField :=
  .mk (.inlineDefn (.map (.mk k (.typeName v)))) (optional := true)

/-- A required struct field with an inline list type. -/
private abbrev reqListField (v : String) : StructField :=
  .mk (.inlineDefn (.list (.mk (.typeName v))))

/-- An optional struct field with an inline list type. -/
private abbrev optListField (v : String) : StructField :=
  .mk (.inlineDefn (.list (.mk (.typeName v)))) (optional := true)

/-- An empty struct with default map representation. -/
private abbrev emptyStruct : TypeDefn :=
  .struct { fields := [], representation := .map {} }

/-- Shorthand for the default (no-override) map struct representation. -/
private abbrev mapRepr : StructRepresentation :=
  .map {}

-- ============================================================================
-- The self-describing schema-schema value
-- ============================================================================

/--
The IPLD Schema schema-schema, encoded as an `IPLD.Schema` value.

This is the self-describing fixed point: the schema that defines the IPLD Schema
language, expressed using the very Lean types it describes. Every type from the
original IPLD schema-schema specification appears as an entry in `types`.

Primitive IPLD Data Model types (`Bool`, `String`, `Bytes`, `Int`, `Float`) are
referenced by name but not defined here — they are built-in to the data model.
-/
def ipldSchemaSchema : Schema where
  types := [
    -- ========================================================================
    -- String aliases
    -- ========================================================================
    ("TypeName",              .string {}),
    ("AdvancedDataLayoutName", .string {}),
    ("FieldName",             .string {}),
    ("EnumMember",            .string {}),
    ("HexString",             .string {}),

    -- ========================================================================
    -- Schema (root type)
    -- ========================================================================
    ("Schema", .struct {
      fields := [
        ("types",    reqMapField "TypeName" "TypeDefn"),
        ("advanced", optField "AdvancedDataLayoutMap")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- Advanced data layout map
    -- ========================================================================
    ("AdvancedDataLayoutMap",
      .map (.mk "AdvancedDataLayoutName" (.typeName "AdvancedDataLayout"))),

    -- ========================================================================
    -- TypeDefn — top-level union of all type kinds
    -- ========================================================================
    ("TypeDefn", .union {
      members := [
        .typeName "TypeDefnBool",   .typeName "TypeDefnString",
        .typeName "TypeDefnBytes",  .typeName "TypeDefnInt",
        .typeName "TypeDefnFloat",  .typeName "TypeDefnMap",
        .typeName "TypeDefnList",   .typeName "TypeDefnLink",
        .typeName "TypeDefnUnion",  .typeName "TypeDefnStruct",
        .typeName "TypeDefnEnum",   .typeName "TypeDefnUnit",
        .typeName "TypeDefnAny",    .typeName "TypeDefnCopy"
      ]
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

    -- ========================================================================
    -- TypeKind — enum of all type kinds (minus copy)
    -- ========================================================================
    ("TypeKind", .enum {
      members := ["Bool", "String", "Bytes", "Int", "Float",
                  "Map", "List", "Link", "Union", "Struct", "Enum", "Unit", "Any"]
      representation := .string [
        ("Bool", "bool"),     ("String", "string"), ("Bytes", "bytes"),
        ("Int", "int"),       ("Float", "float"),   ("Map", "map"),
        ("List", "list"),     ("Link", "link"),     ("Union", "union"),
        ("Struct", "struct"), ("Enum", "enum"),     ("Unit", "unit"),
        ("Any", "any")
      ]
    }),

    -- ========================================================================
    -- RepresentationKind — data-model level kinds
    -- ========================================================================
    ("RepresentationKind", .enum {
      members := ["Bool", "String", "Bytes", "Int", "Float",
                  "Map", "List", "Link"]
      representation := .string [
        ("Bool", "bool"),   ("String", "string"), ("Bytes", "bytes"),
        ("Int", "int"),     ("Float", "float"),   ("Map", "map"),
        ("List", "list"),   ("Link", "link")
      ]
    }),

    -- ========================================================================
    -- AnyScalar — kinded union of scalar data-model kinds
    -- ========================================================================
    ("AnyScalar", .union {
      members := [
        .typeName "Bool", .typeName "String", .typeName "Bytes",
        .typeName "Int",  .typeName "Float"
      ]
      representation := .kinded [
        (.bool,   .typeName "Bool"),
        (.string, .typeName "String"),
        (.bytes,  .typeName "Bytes"),
        (.int,    .typeName "Int"),
        (.float,  .typeName "Float")
      ]
    }),

    -- ========================================================================
    -- Empty marker structs
    -- ========================================================================
    ("AdvancedDataLayout",          emptyStruct),
    ("TypeDefnBool",                emptyStruct),
    ("TypeDefnString",              emptyStruct),
    ("TypeDefnInt",                 emptyStruct),
    ("TypeDefnFloat",               emptyStruct),
    ("TypeDefnAny",                 emptyStruct),
    ("BytesRepresentation_Bytes",   emptyStruct),
    ("MapRepresentation_ListPairs", emptyStruct),
    ("StructRepresentation_ListPairs", emptyStruct),

    -- ========================================================================
    -- TypeDefnBytes
    -- ========================================================================
    ("TypeDefnBytes", .struct {
      fields := [("representation", reqField "BytesRepresentation")]
      representation := mapRepr
    }),

    -- ========================================================================
    -- BytesRepresentation
    -- ========================================================================
    ("BytesRepresentation", .union {
      members := [.typeName "BytesRepresentation_Bytes",
                  .typeName "AdvancedDataLayoutName"]
      representation := .keyed [
        ("bytes",    .typeName "BytesRepresentation_Bytes"),
        ("advanced", .typeName "AdvancedDataLayoutName")
      ]
    }),

    -- ========================================================================
    -- TypeDefnMap
    -- ========================================================================
    ("TypeDefnMap", .struct {
      fields := [
        ("keyType",        reqField "TypeName"),
        ("valueType",      reqField "TypeNameOrInlineDefn"),
        ("valueNullable",  reqField "Bool"),
        ("representation", optField "MapRepresentation")
      ]
      representation := .map {
        fields := some [
          ("valueNullable", { implicit := some (.bool false) })
        ]
      }
    }),

    -- ========================================================================
    -- MapRepresentation
    -- ========================================================================
    ("MapRepresentation", .union {
      members := [
        .typeName "MapRepresentation_StringPairs",
        .typeName "MapRepresentation_ListPairs",
        .typeName "AdvancedDataLayoutName"
      ]
      representation := .keyed [
        ("stringpairs", .typeName "MapRepresentation_StringPairs"),
        ("listpairs",   .typeName "MapRepresentation_ListPairs"),
        ("advanced",    .typeName "AdvancedDataLayoutName")
      ]
    }),

    -- ========================================================================
    -- MapRepresentation_StringPairs
    -- ========================================================================
    ("MapRepresentation_StringPairs", .struct {
      fields := [
        ("innerDelim", reqField "String"),
        ("entryDelim", reqField "String")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- TypeDefnList
    -- ========================================================================
    ("TypeDefnList", .struct {
      fields := [
        ("valueType",      reqField "TypeNameOrInlineDefn"),
        ("valueNullable",  reqField "Bool"),
        ("representation", optField "ListRepresentation")
      ]
      representation := .map {
        fields := some [
          ("valueNullable", { implicit := some (.bool false) })
        ]
      }
    }),

    -- ========================================================================
    -- ListRepresentation
    -- ========================================================================
    ("ListRepresentation", .union {
      members := [.typeName "AdvancedDataLayoutName"]
      representation := .keyed [
        ("advanced", .typeName "AdvancedDataLayoutName")
      ]
    }),

    -- ========================================================================
    -- TypeDefnLink
    -- ========================================================================
    ("TypeDefnLink", .struct {
      fields := [("expectedType", reqField "TypeName")]
      representation := .map {
        fields := some [
          ("expectedType", { implicit := some (.string "Any") })
        ]
      }
    }),

    -- ========================================================================
    -- TypeDefnUnion
    -- ========================================================================
    ("TypeDefnUnion", .struct {
      fields := [
        ("members",        reqListField "UnionMember"),
        ("representation", reqField "UnionRepresentation")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- UnionMember — kinded union (string or map)
    -- ========================================================================
    ("UnionMember", .union {
      members := [.typeName "TypeName", .typeName "UnionMemberInlineDefn"]
      representation := .kinded [
        (.string, .typeName "TypeName"),
        (.map,    .typeName "UnionMemberInlineDefn")
      ]
    }),

    -- ========================================================================
    -- UnionMemberInlineDefn — keyed union (only link)
    -- ========================================================================
    ("UnionMemberInlineDefn", .union {
      members := [.typeName "TypeDefnLink"]
      representation := .keyed [
        ("link", .typeName "TypeDefnLink")
      ]
    }),

    -- ========================================================================
    -- UnionRepresentation — keyed union of six strategies
    -- ========================================================================
    ("UnionRepresentation", .union {
      members := [
        .typeName "UnionRepresentation_Kinded",
        .typeName "UnionRepresentation_Keyed",
        .typeName "UnionRepresentation_Envelope",
        .typeName "UnionRepresentation_Inline",
        .typeName "UnionRepresentation_StringPrefix",
        .typeName "UnionRepresentation_BytesPrefix"
      ]
      representation := .keyed [
        ("kinded",       .typeName "UnionRepresentation_Kinded"),
        ("keyed",        .typeName "UnionRepresentation_Keyed"),
        ("envelope",     .typeName "UnionRepresentation_Envelope"),
        ("inline",       .typeName "UnionRepresentation_Inline"),
        ("stringprefix", .typeName "UnionRepresentation_StringPrefix"),
        ("bytesprefix",  .typeName "UnionRepresentation_BytesPrefix")
      ]
    }),

    -- ========================================================================
    -- UnionRepresentation_Kinded & _Keyed — map types
    -- ========================================================================
    ("UnionRepresentation_Kinded",
      .map (.mk "RepresentationKind" (.typeName "UnionMember"))),

    ("UnionRepresentation_Keyed",
      .map (.mk "String" (.typeName "UnionMember"))),

    -- ========================================================================
    -- UnionRepresentation_Envelope
    -- ========================================================================
    ("UnionRepresentation_Envelope", .struct {
      fields := [
        ("discriminantKey",   reqField "String"),
        ("contentKey",        reqField "String"),
        ("discriminantTable", reqMapField "String" "UnionMember")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- UnionRepresentation_Inline
    -- ========================================================================
    ("UnionRepresentation_Inline", .struct {
      fields := [
        ("discriminantKey",   reqField "String"),
        ("discriminantTable", reqMapField "String" "TypeName")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- UnionRepresentation_StringPrefix
    -- ========================================================================
    ("UnionRepresentation_StringPrefix", .struct {
      fields := [("prefixes", reqMapField "String" "TypeName")]
      representation := mapRepr
    }),

    -- ========================================================================
    -- UnionRepresentation_BytesPrefix
    -- ========================================================================
    ("UnionRepresentation_BytesPrefix", .struct {
      fields := [("prefixes", reqMapField "HexString" "TypeName")]
      representation := mapRepr
    }),

    -- ========================================================================
    -- TypeDefnStruct
    -- ========================================================================
    ("TypeDefnStruct", .struct {
      fields := [
        ("fields",         reqMapField "FieldName" "StructField"),
        ("representation", reqField "StructRepresentation")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- StructField
    -- ========================================================================
    ("StructField", .struct {
      fields := [
        ("type",     reqField "TypeNameOrInlineDefn"),
        ("optional", reqField "Bool"),
        ("nullable", reqField "Bool")
      ]
      representation := .map {
        fields := some [
          ("optional", { implicit := some (.bool false) }),
          ("nullable", { implicit := some (.bool false) })
        ]
      }
    }),

    -- ========================================================================
    -- TypeNameOrInlineDefn — kinded union
    -- ========================================================================
    ("TypeNameOrInlineDefn", .union {
      members := [.typeName "TypeName", .typeName "InlineDefn"]
      representation := .kinded [
        (.string, .typeName "TypeName"),
        (.map,    .typeName "InlineDefn")
      ]
    }),

    -- ========================================================================
    -- InlineDefn — keyed union (map, list, link)
    -- ========================================================================
    ("InlineDefn", .union {
      members := [
        .typeName "TypeDefnMap",
        .typeName "TypeDefnList",
        .typeName "TypeDefnLink"
      ]
      representation := .keyed [
        ("map",  .typeName "TypeDefnMap"),
        ("list", .typeName "TypeDefnList"),
        ("link", .typeName "TypeDefnLink")
      ]
    }),

    -- ========================================================================
    -- StructRepresentation — keyed union of five strategies
    -- ========================================================================
    ("StructRepresentation", .union {
      members := [
        .typeName "StructRepresentation_Map",
        .typeName "StructRepresentation_Tuple",
        .typeName "StructRepresentation_StringPairs",
        .typeName "StructRepresentation_StringJoin",
        .typeName "StructRepresentation_ListPairs"
      ]
      representation := .keyed [
        ("map",         .typeName "StructRepresentation_Map"),
        ("tuple",       .typeName "StructRepresentation_Tuple"),
        ("stringpairs", .typeName "StructRepresentation_StringPairs"),
        ("stringjoin",  .typeName "StructRepresentation_StringJoin"),
        ("listpairs",   .typeName "StructRepresentation_ListPairs")
      ]
    }),

    -- ========================================================================
    -- StructRepresentation_Map
    -- ========================================================================
    ("StructRepresentation_Map", .struct {
      fields := [
        ("fields", optMapField "FieldName" "StructRepresentation_Map_FieldDetails")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- StructRepresentation_Map_FieldDetails
    -- ========================================================================
    ("StructRepresentation_Map_FieldDetails", .struct {
      fields := [
        ("rename",   optField "String"),
        ("implicit", optField "AnyScalar")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- StructRepresentation_Tuple
    -- ========================================================================
    ("StructRepresentation_Tuple", .struct {
      fields := [("fieldOrder", optListField "FieldName")]
      representation := mapRepr
    }),

    -- ========================================================================
    -- StructRepresentation_StringPairs
    -- ========================================================================
    ("StructRepresentation_StringPairs", .struct {
      fields := [
        ("innerDelim", reqField "String"),
        ("entryDelim", reqField "String")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- StructRepresentation_StringJoin
    -- ========================================================================
    ("StructRepresentation_StringJoin", .struct {
      fields := [
        ("join",       reqField "String"),
        ("fieldOrder", optListField "FieldName")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- TypeDefnEnum
    -- ========================================================================
    ("TypeDefnEnum", .struct {
      fields := [
        ("members",        reqListField "EnumMember"),
        ("representation", reqField "EnumRepresentation")
      ]
      representation := mapRepr
    }),

    -- ========================================================================
    -- EnumRepresentation — keyed union (string or int)
    -- ========================================================================
    ("EnumRepresentation", .union {
      members := [.typeName "EnumRepresentation_String",
                  .typeName "EnumRepresentation_Int"]
      representation := .keyed [
        ("string", .typeName "EnumRepresentation_String"),
        ("int",    .typeName "EnumRepresentation_Int")
      ]
    }),

    -- ========================================================================
    -- EnumRepresentation_String & _Int — map types
    -- ========================================================================
    ("EnumRepresentation_String",
      .map (.mk "EnumMember" (.typeName "String"))),

    ("EnumRepresentation_Int",
      .map (.mk "EnumMember" (.typeName "Int"))),

    -- ========================================================================
    -- TypeDefnUnit
    -- ========================================================================
    ("TypeDefnUnit", .struct {
      fields := [("representation", reqField "UnitRepresentation")]
      representation := mapRepr
    }),

    -- ========================================================================
    -- UnitRepresentation — enum
    -- ========================================================================
    ("UnitRepresentation", .enum {
      members := ["Null", "True", "False", "Emptymap"]
      representation := .string [
        ("Null", "null"), ("True", "true"),
        ("False", "false"), ("Emptymap", "emptymap")
      ]
    }),

    -- ========================================================================
    -- TypeDefnCopy
    -- ========================================================================
    ("TypeDefnCopy", .struct {
      fields := [("fromType", reqField "TypeName")]
      representation := mapRepr
    })
  ]
  advanced := none

-- ============================================================================
-- Quick sanity checks
-- ============================================================================

/-- No advanced data layouts are declared in the schema-schema itself. -/
example : ipldSchemaSchema.advanced = none := by rfl

end IPLD
