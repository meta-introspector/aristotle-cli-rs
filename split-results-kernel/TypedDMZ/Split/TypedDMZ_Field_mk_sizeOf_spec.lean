import Split.String
import Split.TypedDMZ_Field
import Split.instOfNatNat
import Split.TypedDMZ_Field_mk
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.TypedDMZ_FieldType
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- TypedDMZ.Field.mk.sizeOf_spec from environment
-- theorem TypedDMZ.Field.mk.sizeOf_spec : forall (name : String) (fieldType : TypedDMZ.FieldType), Eq.{1} Nat (SizeOf.sizeOf.{1} TypedDMZ.Field TypedDMZ.Field._sizeOf_inst (TypedDMZ.Field.mk name fieldType)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst name)) (SizeOf.sizeOf.{1} TypedDMZ.FieldType TypedDMZ.FieldType._sizeOf_inst fieldType))

-- Stub: this file represents the declaration `TypedDMZ.Field.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
