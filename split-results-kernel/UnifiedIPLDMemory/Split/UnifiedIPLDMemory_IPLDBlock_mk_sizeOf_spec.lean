import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.UnifiedIPLDMemory_IPLDBlock_mk
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.IPLDBlock.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.IPLDBlock.mk.sizeOf_spec : forall (cid : UnifiedIPLDMemory.IPLDCID) (payloadSize : Nat) (linkCount : Nat), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDBlock UnifiedIPLDMemory.IPLDBlock._sizeOf_inst (UnifiedIPLDMemory.IPLDBlock.mk cid payloadSize linkCount)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCID UnifiedIPLDMemory.IPLDCID._sizeOf_inst cid)) (SizeOf.sizeOf.{1} Nat instSizeOfNat payloadSize)) (SizeOf.sizeOf.{1} Nat instSizeOfNat linkCount))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDBlock.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
