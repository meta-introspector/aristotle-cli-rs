import Split.UnifiedIPLDMemory_BlockPacking_mk
import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.instAddNat
import Split.Eq_refl
import Split.UnifiedIPLDMemory_BlockPacking
import Split.instSizeOfNat
import Split.OfNat_ofNat
import Split.Fin
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.BlockPacking.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.BlockPacking.mk.sizeOf_spec : forall {dag : UnifiedIPLDMemory.IPLDDAG} (unitCount : Nat) (assignment : (Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount)) (packing_efficiency : LE.le.{0} Nat instLENat unitCount (UnifiedIPLDMemory.IPLDDAG.blockCount dag)), Eq.{1} Nat (SizeOf.sizeOf.{1} (UnifiedIPLDMemory.BlockPacking dag) (UnifiedIPLDMemory.BlockPacking._sizeOf_inst dag) (UnifiedIPLDMemory.BlockPacking.mk dag unitCount assignment packing_efficiency)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} Nat instSizeOfNat unitCount)) (SizeOf.sizeOf.{0} (LE.le.{0} Nat instLENat unitCount (UnifiedIPLDMemory.IPLDDAG.blockCount dag)) (instSizeOfDefault.{0} (LE.le.{0} Nat instLENat unitCount (UnifiedIPLDMemory.IPLDDAG.blockCount dag))) packing_efficiency))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.BlockPacking.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
