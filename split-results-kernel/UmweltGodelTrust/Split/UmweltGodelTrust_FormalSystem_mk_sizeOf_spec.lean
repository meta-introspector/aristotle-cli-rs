import Split.UmweltGodelTrust_FormalSystem
import Split.String
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.UmweltGodelTrust_FormalSystem_mk
import Split.Nat
import Split.SizeOf_sizeOf
import Split.Bool
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UmweltGodelTrust.FormalSystem.mk.sizeOf_spec from environment
-- theorem UmweltGodelTrust.FormalSystem.mk.sizeOf_spec : forall (name : String) (expresses_arithmetic : Bool) (consistent : Bool), Eq.{1} Nat (SizeOf.sizeOf.{1} UmweltGodelTrust.FormalSystem UmweltGodelTrust.FormalSystem._sizeOf_inst (UmweltGodelTrust.FormalSystem.mk name expresses_arithmetic consistent)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst name)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst expresses_arithmetic)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst consistent))

-- Stub: this file represents the declaration `UmweltGodelTrust.FormalSystem.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
