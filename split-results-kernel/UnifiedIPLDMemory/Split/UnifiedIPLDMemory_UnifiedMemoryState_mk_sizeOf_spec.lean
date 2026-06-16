import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMemoryState_mk
import Split.instOfNatNat
import Split.ZMod
import Split.List
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.instAddNat
import Split.Eq_refl
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.UnifiedMemoryState.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.UnifiedMemoryState.mk.sizeOf_spec : forall (dag : UnifiedIPLDMemory.IPLDDAG) (taggedBlocks : List.{0} UnifiedIPLDMemory.TaggedBlock) (tag_consistent : Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks) (UnifiedIPLDMemory.IPLDDAG.blockCount dag)) (basePoint : FiberedUniverse.S_ss), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.UnifiedMemoryState UnifiedIPLDMemory.UnifiedMemoryState._sizeOf_inst (UnifiedIPLDMemory.UnifiedMemoryState.mk dag taggedBlocks tag_consistent basePoint)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDDAG UnifiedIPLDMemory.IPLDDAG._sizeOf_inst dag)) (SizeOf.sizeOf.{1} (List.{0} UnifiedIPLDMemory.TaggedBlock) (List._sizeOf_inst.{0} UnifiedIPLDMemory.TaggedBlock UnifiedIPLDMemory.TaggedBlock._sizeOf_inst) taggedBlocks)) (SizeOf.sizeOf.{0} (Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks) (UnifiedIPLDMemory.IPLDDAG.blockCount dag)) (instSizeOfDefault.{0} (Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks) (UnifiedIPLDMemory.IPLDDAG.blockCount dag))) tag_consistent)) (SizeOf.sizeOf.{1} FiberedUniverse.S_ss (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)))) (Prod._sizeOf_inst.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59)))) (instSizeOfDefault.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))))) basePoint))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryState.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
