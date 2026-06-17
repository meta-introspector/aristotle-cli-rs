import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.UnifiedIPLDMemory_UnifiedMemoryState
import Split.UnifiedIPLDMemory_UnifiedMemoryState_mk
import Split.List
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq
import Split.List_length
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.UnifiedMemoryState.rec from environment
-- recursor UnifiedIPLDMemory.UnifiedMemoryState.rec : forall {motive : UnifiedIPLDMemory.UnifiedMemoryState -> Sort.{u}}, (forall (dag : UnifiedIPLDMemory.IPLDDAG) (taggedBlocks : List.{0} UnifiedIPLDMemory.TaggedBlock) (tag_consistent : Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks) (UnifiedIPLDMemory.IPLDDAG.blockCount dag)) (basePoint : FiberedUniverse.S_ss), motive (UnifiedIPLDMemory.UnifiedMemoryState.mk dag taggedBlocks tag_consistent basePoint)) -> (forall (t : UnifiedIPLDMemory.UnifiedMemoryState), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryState.rec`.
-- In a full split, the body would be extracted from the environment.
