import Split.ContentAddressing_VerifiedRecord_mk
import Split.instSizeOfDefault
import Split.instOfNatNat
import Split.ContentAddressing_ContentRecord
import Split.Bool_true
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.ContentAddressing_acceptRecord
import Split.Nat
import Split.ContentAddressing_HashFunction
import Split.SizeOf_sizeOf
import Split.Bool
import Split.instAddNat
import Split.Eq_refl
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.ContentAddressing_VerifiedRecord
import Split.ContentAddressing_MultihashCodec
import Split.ContentAddressing_ContentRecord_hashesConsistent

-- ContentAddressing.VerifiedRecord.mk.sizeOf_spec from environment
-- theorem ContentAddressing.VerifiedRecord.mk.sizeOf_spec : forall (record : ContentAddressing.ContentRecord) (hashFns : List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)) (consistent : ContentAddressing.ContentRecord.hashesConsistent record hashFns) (accepted : Eq.{1} Bool (ContentAddressing.acceptRecord record) Bool.true), Eq.{1} Nat (SizeOf.sizeOf.{1} ContentAddressing.VerifiedRecord ContentAddressing.VerifiedRecord._sizeOf_inst (ContentAddressing.VerifiedRecord.mk record hashFns consistent accepted)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} ContentAddressing.ContentRecord ContentAddressing.ContentRecord._sizeOf_inst record)) (SizeOf.sizeOf.{1} (List.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction)) (List._sizeOf_inst.{0} (Prod.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction) (Prod._sizeOf_inst.{0, 0} ContentAddressing.MultihashCodec ContentAddressing.HashFunction ContentAddressing.MultihashCodec._sizeOf_inst ContentAddressing.HashFunction._sizeOf_inst)) hashFns)) (SizeOf.sizeOf.{0} (Eq.{1} Bool (ContentAddressing.acceptRecord record) Bool.true) (instSizeOfDefault.{0} (Eq.{1} Bool (ContentAddressing.acceptRecord record) Bool.true)) accepted))

-- Stub: this file represents the declaration `ContentAddressing.VerifiedRecord.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
