import Split.UmweltGodelTrust_Binding_mk
import Split.instOfNatNat
import Split.UmweltGodelTrust_Grade
import Split.UmweltGodelTrust_Binding
import Split.UmweltGodelTrust_BindingType
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UmweltGodelTrust.Binding.mk.sizeOf_spec from environment
-- theorem UmweltGodelTrust.Binding.mk.sizeOf_spec : forall (btype : UmweltGodelTrust.BindingType) (grade : UmweltGodelTrust.Grade), Eq.{1} Nat (SizeOf.sizeOf.{1} UmweltGodelTrust.Binding UmweltGodelTrust.Binding._sizeOf_inst (UmweltGodelTrust.Binding.mk btype grade)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UmweltGodelTrust.BindingType UmweltGodelTrust.BindingType._sizeOf_inst btype)) (SizeOf.sizeOf.{1} UmweltGodelTrust.Grade UmweltGodelTrust.Grade._sizeOf_inst grade))

-- Stub: this file represents the declaration `UmweltGodelTrust.Binding.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
