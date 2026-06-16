import Split.ContentAddressing_CID_mk
import Split.ContentAddressing_Multihash
import Split.instOfNatNat
import Split.ContentAddressing_CIDVersion
import Split.ContentAddressing_CID
import Split.instHAdd
import Split.ContentAddressing_Multicodec
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- ContentAddressing.CID.mk.sizeOf_spec from environment
-- theorem ContentAddressing.CID.mk.sizeOf_spec : forall (version : ContentAddressing.CIDVersion) (contentCodec : ContentAddressing.Multicodec) (hash : ContentAddressing.Multihash), Eq.{1} Nat (SizeOf.sizeOf.{1} ContentAddressing.CID ContentAddressing.CID._sizeOf_inst (ContentAddressing.CID.mk version contentCodec hash)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} ContentAddressing.CIDVersion ContentAddressing.CIDVersion._sizeOf_inst version)) (SizeOf.sizeOf.{1} ContentAddressing.Multicodec ContentAddressing.Multicodec._sizeOf_inst contentCodec)) (SizeOf.sizeOf.{1} ContentAddressing.Multihash ContentAddressing.Multihash._sizeOf_inst hash))

-- Stub: this file represents the declaration `ContentAddressing.CID.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
