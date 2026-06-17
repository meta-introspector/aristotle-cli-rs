import Split.TypedDMZ_Field
import Split.instOfNatNat
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.TypedDMZ_Schema_mk
import Split.TypedDMZ_Schema
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- TypedDMZ.Schema.mk.sizeOf_spec from environment
-- theorem TypedDMZ.Schema.mk.sizeOf_spec : forall (fields : List.{0} TypedDMZ.Field), Eq.{1} Nat (SizeOf.sizeOf.{1} TypedDMZ.Schema TypedDMZ.Schema._sizeOf_inst (TypedDMZ.Schema.mk fields)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} (List.{0} TypedDMZ.Field) (List._sizeOf_inst.{0} TypedDMZ.Field TypedDMZ.Field._sizeOf_inst) fields))

-- Stub: this file represents the declaration `TypedDMZ.Schema.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
