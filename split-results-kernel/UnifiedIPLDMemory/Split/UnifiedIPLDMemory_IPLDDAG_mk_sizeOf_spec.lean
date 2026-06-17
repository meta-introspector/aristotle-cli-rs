import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.instOfNatNat
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.instAddNat
import Split.Eq_refl
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_mk

-- UnifiedIPLDMemory.IPLDDAG.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.IPLDDAG.mk.sizeOf_spec : forall (root : UnifiedIPLDMemory.IPLDCID) (blocks : List.{0} UnifiedIPLDMemory.IPLDBlock) (blockCount : Nat) (totalLinks : Nat) (count_consistent : Eq.{1} Nat blockCount (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks)), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDDAG UnifiedIPLDMemory.IPLDDAG._sizeOf_inst (UnifiedIPLDMemory.IPLDDAG.mk root blocks blockCount totalLinks count_consistent)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCID UnifiedIPLDMemory.IPLDCID._sizeOf_inst root)) (SizeOf.sizeOf.{1} (List.{0} UnifiedIPLDMemory.IPLDBlock) (List._sizeOf_inst.{0} UnifiedIPLDMemory.IPLDBlock UnifiedIPLDMemory.IPLDBlock._sizeOf_inst) blocks)) (SizeOf.sizeOf.{1} Nat instSizeOfNat blockCount)) (SizeOf.sizeOf.{1} Nat instSizeOfNat totalLinks)) (SizeOf.sizeOf.{0} (Eq.{1} Nat blockCount (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks)) (instSizeOfDefault.{0} (Eq.{1} Nat blockCount (List.length.{0} UnifiedIPLDMemory.IPLDBlock blocks))) count_consistent))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDDAG.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
