import Split.TypedDMZ_Field_noConfusion
import Split.String
import Split.TypedDMZ_Field
import Split.id
import Split.TypedDMZ_Field_mk
import Split.TypedDMZ_FieldType
import Split.Eq

-- TypedDMZ.Field.mk.noConfusion from environment
-- def TypedDMZ.Field.mk.noConfusion : forall {P : Sort.{u}} {name : String} {fieldType : TypedDMZ.FieldType} {name' : String} {fieldType' : TypedDMZ.FieldType}, (Eq.{1} TypedDMZ.Field (TypedDMZ.Field.mk name fieldType) (TypedDMZ.Field.mk name' fieldType')) -> ((Eq.{1} String name name') -> (Eq.{1} TypedDMZ.FieldType fieldType fieldType') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `TypedDMZ.Field.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
