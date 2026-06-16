import Split.ContentAddressing_Multihash
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq
import Split.ContentAddressing_Multihash_mk
import Split.ContentAddressing_MultihashCodec

-- ContentAddressing.Multihash.mk.sizeOf_spec from environment
-- theorem ContentAddressing.Multihash.mk.sizeOf_spec : forall (codec : ContentAddressing.MultihashCodec) (digestSize : Nat) (digest : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} ContentAddressing.Multihash ContentAddressing.Multihash._sizeOf_inst (ContentAddressing.Multihash.mk codec digestSize digest)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} ContentAddressing.MultihashCodec ContentAddressing.MultihashCodec._sizeOf_inst codec)) (SizeOf.sizeOf.{1} Nat instSizeOfNat digestSize)) (SizeOf.sizeOf.{1} Nat instSizeOfNat digest))

-- Stub: this file represents the declaration `ContentAddressing.Multihash.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
