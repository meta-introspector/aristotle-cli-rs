import Split.UmweltGodelTrust_FormalSystem
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.UmweltGodelTrust_GodelStatement
import Split.Nat
import Split.SizeOf_sizeOf
import Split.Bool
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.UmweltGodelTrust_GodelStatement_mk

-- UmweltGodelTrust.GodelStatement.mk.sizeOf_spec from environment
-- theorem UmweltGodelTrust.GodelStatement.mk.sizeOf_spec : forall {S : UmweltGodelTrust.FormalSystem} (well_formed : Bool) (self_referential : Bool), Eq.{1} Nat (SizeOf.sizeOf.{1} (UmweltGodelTrust.GodelStatement S) (UmweltGodelTrust.GodelStatement._sizeOf_inst S) (UmweltGodelTrust.GodelStatement.mk S well_formed self_referential)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst well_formed)) (SizeOf.sizeOf.{1} Bool Bool._sizeOf_inst self_referential))

-- Stub: this file represents the declaration `UmweltGodelTrust.GodelStatement.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
