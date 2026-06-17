import Split.String
import Split.TypedDMZ_Field
import Split.TypedDMZ_Field_mk
import Split.And
import Split.And_intro
import Split.TypedDMZ_FieldType
import Split.TypedDMZ_Field_mk_noConfusion
import Split.Eq

-- TypedDMZ.Field.mk.inj from environment
-- theorem TypedDMZ.Field.mk.inj : forall {name : String} {fieldType : TypedDMZ.FieldType} {name_1 : String} {fieldType_1 : TypedDMZ.FieldType}, (Eq.{1} TypedDMZ.Field (TypedDMZ.Field.mk name fieldType) (TypedDMZ.Field.mk name_1 fieldType_1)) -> (And (Eq.{1} String name name_1) (Eq.{1} TypedDMZ.FieldType fieldType fieldType_1))

-- Stub: this file represents the declaration `TypedDMZ.Field.mk.inj`.
-- In a full split, the body would be extracted from the environment.
