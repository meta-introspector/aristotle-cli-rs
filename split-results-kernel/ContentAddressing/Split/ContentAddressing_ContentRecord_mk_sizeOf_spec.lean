import Split.ContentAddressing_Multihash
import Split.String
import Split.instOfNatNat
import Split.ContentAddressing_ContentRecord
import Split.ContentAddressing_CID
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.ContentAddressing_ContentRecord_mk
import Split.OfNat_ofNat
import Split.Eq

-- ContentAddressing.ContentRecord.mk.sizeOf_spec from environment
-- theorem ContentAddressing.ContentRecord.mk.sizeOf_spec : forall (payload : String) (hashes : List.{0} ContentAddressing.Multihash) (cids : List.{0} ContentAddressing.CID), Eq.{1} Nat (SizeOf.sizeOf.{1} ContentAddressing.ContentRecord ContentAddressing.ContentRecord._sizeOf_inst (ContentAddressing.ContentRecord.mk payload hashes cids)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} String String._sizeOf_inst payload)) (SizeOf.sizeOf.{1} (List.{0} ContentAddressing.Multihash) (List._sizeOf_inst.{0} ContentAddressing.Multihash ContentAddressing.Multihash._sizeOf_inst) hashes)) (SizeOf.sizeOf.{1} (List.{0} ContentAddressing.CID) (List._sizeOf_inst.{0} ContentAddressing.CID ContentAddressing.CID._sizeOf_inst) cids))

-- Stub: this file represents the declaration `ContentAddressing.ContentRecord.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
