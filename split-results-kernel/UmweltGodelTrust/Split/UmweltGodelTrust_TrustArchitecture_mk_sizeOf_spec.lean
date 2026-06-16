import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.UmweltGodelTrust_TrustArchitecture_mk
import Split.Nat
import Split.SizeOf_sizeOf
import Split.Bool
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.UmweltGodelTrust_TrustArchitecture

-- UmweltGodelTrust.TrustArchitecture.mk.sizeOf_spec from environment
-- theorem UmweltGodelTrust.TrustArchitecture.mk.sizeOf_spec : forall (minimal_kernel : Bool) (external_audit : Bool) (arch_separation : Bool), Eq.{1} Nat (SizeOf.sizeOf.{1} UmweltGodelTrust.TrustArchitecture UmweltGodelTrust.TrustArchitecture._sizeOf_inst (UmweltGodelTrust.TrustArchitecture.mk minimal_kernel external_audit arch_separation)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst minimal_kernel)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst external_audit)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst arch_separation))

-- Stub: this file represents the declaration `UmweltGodelTrust.TrustArchitecture.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
