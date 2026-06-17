import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMemoryState_mk
import Split.UnifiedIPLDMemory_UnifiedMemoryState_mk_noConfusion
import Split.List
import Split.And
import Split.Nat
import Split.And_intro
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.UnifiedMemoryState.mk.inj from environment
-- theorem UnifiedIPLDMemory.UnifiedMemoryState.mk.inj : forall {dag : UnifiedIPLDMemory.IPLDDAG} {taggedBlocks : List.{0} UnifiedIPLDMemory.TaggedBlock} {tag_consistent : Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks) (UnifiedIPLDMemory.IPLDDAG.blockCount dag)} {basePoint : FiberedUniverse.S_ss} {dag_1 : UnifiedIPLDMemory.IPLDDAG} {taggedBlocks_1 : List.{0} UnifiedIPLDMemory.TaggedBlock} {tag_consistent_1 : Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks_1) (UnifiedIPLDMemory.IPLDDAG.blockCount dag_1)} {basePoint_1 : FiberedUniverse.S_ss}, (Eq.{1} UnifiedIPLDMemory.UnifiedMemoryState (UnifiedIPLDMemory.UnifiedMemoryState.mk dag taggedBlocks tag_consistent basePoint) (UnifiedIPLDMemory.UnifiedMemoryState.mk dag_1 taggedBlocks_1 tag_consistent_1 basePoint_1)) -> (And (Eq.{1} UnifiedIPLDMemory.IPLDDAG dag dag_1) (And (Eq.{1} (List.{0} UnifiedIPLDMemory.TaggedBlock) taggedBlocks taggedBlocks_1) (Eq.{1} FiberedUniverse.S_ss basePoint basePoint_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryState.mk.inj`.
-- In a full split, the body would be extracted from the environment.
