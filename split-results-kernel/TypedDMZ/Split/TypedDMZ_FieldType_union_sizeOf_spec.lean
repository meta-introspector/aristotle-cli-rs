import Split.congrArg
import Split.instOfNatNat
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.TypedDMZ_FieldType
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Nat_add
import Split.TypedDMZ_FieldType_union

-- TypedDMZ.FieldType.union.sizeOf_spec from environment
-- theorem TypedDMZ.FieldType.union.sizeOf_spec : forall (a._@._internal._hyg.0 : List.{0} TypedDMZ.FieldType), Eq.{1} Nat (SizeOf.sizeOf.{1} TypedDMZ.FieldType TypedDMZ.FieldType._sizeOf_inst (TypedDMZ.FieldType.union a._@._internal._hyg.0)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} TypedDMZ.FieldType) (List._sizeOf_inst.{0} TypedDMZ.FieldType TypedDMZ.FieldType._sizeOf_inst) a._@._internal._hyg.0))

-- Stub: this file represents the declaration `TypedDMZ.FieldType.union.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
