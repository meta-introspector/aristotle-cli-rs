import Split.UnifiedIPLDMemory_UnifiedMemoryState_noConfusion
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.id
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMemoryState_mk
import Split.List
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.UnifiedMemoryState.mk.noConfusion from environment
-- def UnifiedIPLDMemory.UnifiedMemoryState.mk.noConfusion : forall {P : Sort.{u}} {dag : UnifiedIPLDMemory.IPLDDAG} {taggedBlocks : List.{0} UnifiedIPLDMemory.TaggedBlock} {tag_consistent : Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks) (UnifiedIPLDMemory.IPLDDAG.blockCount dag)} {basePoint : FiberedUniverse.S_ss} {dag' : UnifiedIPLDMemory.IPLDDAG} {taggedBlocks' : List.{0} UnifiedIPLDMemory.TaggedBlock} {tag_consistent' : Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks') (UnifiedIPLDMemory.IPLDDAG.blockCount dag')} {basePoint' : FiberedUniverse.S_ss}, (Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (UnifiedIPLDMemory.UnifiedMemoryState.mk dag taggedBlocks tag_consistent basePoint) (UnifiedIPLDMemory.UnifiedMemoryState.mk dag' taggedBlocks' tag_consistent' basePoint')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDDAG dag dag') -> (Eq.{1} (List.{0} UnifiedIPLDMemory.TaggedBlock) taggedBlocks taggedBlocks') -> (Eq.{1} FiberedUniverse.S_ss basePoint basePoint') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryState.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
