import Split.String
import Split.instOfNatNat
import Split.instHAdd
import Split.ContentAddressing_HashFunction_mk
import Split.HAdd_hAdd
import Split.Nat
import Split.ContentAddressing_HashFunction
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- ContentAddressing.HashFunction.mk.sizeOf_spec from environment
-- theorem ContentAddressing.HashFunction.mk.sizeOf_spec : forall (name : String) (apply : String -> Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} ContentAddressing.HashFunction ContentAddressing.HashFunction._sizeOf_inst (ContentAddressing.HashFunction.mk name apply)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst name))

-- Stub: this file represents the declaration `ContentAddressing.HashFunction.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
