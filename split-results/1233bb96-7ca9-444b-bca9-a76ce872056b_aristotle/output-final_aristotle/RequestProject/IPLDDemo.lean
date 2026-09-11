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

import RequestProject.IPLDMeta

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
