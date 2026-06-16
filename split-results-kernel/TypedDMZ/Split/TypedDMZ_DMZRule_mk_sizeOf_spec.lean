import Split.String
import Split.TypedDMZ_DMZRule
import Split.KernelGovernance_Dataset
import Split.TypedDMZ_DMZRule_mk
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.TypedDMZ_Capability
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- TypedDMZ.DMZRule.mk.sizeOf_spec from environment
-- theorem TypedDMZ.DMZRule.mk.sizeOf_spec : forall (dataset : KernelGovernance.Dataset) (fieldName : String) (capability : TypedDMZ.Capability), Eq.{1} Nat (SizeOf.sizeOf.{1} TypedDMZ.DMZRule TypedDMZ.DMZRule._sizeOf_inst (TypedDMZ.DMZRule.mk dataset fieldName capability)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} KernelGovernance.Dataset KernelGovernance.Dataset._sizeOf_inst dataset)) (SizeOf.sizeOf.{1} String String._sizeOf_inst fieldName)) (SizeOf.sizeOf.{1} TypedDMZ.Capability TypedDMZ.Capability._sizeOf_inst capability))

-- Stub: this file represents the declaration `TypedDMZ.DMZRule.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
