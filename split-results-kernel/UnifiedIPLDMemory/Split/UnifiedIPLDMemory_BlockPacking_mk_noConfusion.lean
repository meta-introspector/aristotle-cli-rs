import Split.UnifiedIPLDMemory_BlockPacking_mk
import Split.UnifiedIPLDMemory_BlockPacking_noConfusion
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.id
import Split.LE_le
import Split.instLENat
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.heq_of_eq
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq_refl
import Split.HEq
import Split.UnifiedIPLDMemory_BlockPacking
import Split.Fin
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.BlockPacking.mk.noConfusion from environment
-- def UnifiedIPLDMemory.BlockPacking.mk.noConfusion : forall {dag : UnifiedIPLDMemory.IPLDDAG} {P : Sort.{u}} {unitCount : Nat} {assignment : (Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount)} {packing_efficiency : LE.le.{0} Nat instLENat unitCount (UnifiedIPLDMemory.IPLDDAG.blockCount dag)} {unitCount' : Nat} {assignment' : (Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount')} {packing_efficiency' : LE.le.{0} Nat instLENat unitCount' (UnifiedIPLDMemory.IPLDDAG.blockCount dag)}, (Eq.{1} (UnifiedIPLDMemory.BlockPacking dag) (UnifiedIPLDMemory.BlockPacking.mk dag unitCount assignment packing_efficiency) (UnifiedIPLDMemory.BlockPacking.mk dag unitCount' assignment' packing_efficiency')) -> ((Eq.{1} Nat unitCount unitCount') -> (HEq.{1} ((Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount)) assignment ((Fin (List.length.{0} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDDAG.blocks dag))) -> (Fin unitCount')) assignment') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.BlockPacking.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
