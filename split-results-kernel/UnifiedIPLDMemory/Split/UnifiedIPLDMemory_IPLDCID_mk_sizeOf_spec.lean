import Split.UnifiedIPLDMemory_IPLDCID_mk
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.UnifiedIPLDMemory_IPLDCID
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

-- UnifiedIPLDMemory.IPLDCID.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.IPLDCID.mk.sizeOf_spec : forall (version : Nat) (codec : UnifiedIPLDMemory.IPLDCodec) (digest : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCID UnifiedIPLDMemory.IPLDCID._sizeOf_inst (UnifiedIPLDMemory.IPLDCID.mk version codec digest)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Nat instSizeOfNat version)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCodec UnifiedIPLDMemory.IPLDCodec._sizeOf_inst codec)) (SizeOf.sizeOf.{1} Nat instSizeOfNat digest))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDCID.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
