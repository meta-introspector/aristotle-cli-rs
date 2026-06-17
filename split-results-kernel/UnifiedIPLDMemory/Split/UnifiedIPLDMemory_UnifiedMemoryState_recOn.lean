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
import Split.UnifiedIPLDMemory_UnifiedMemoryState_rec

-- UnifiedIPLDMemory.UnifiedMemoryState.recOn from environment
-- def UnifiedIPLDMemory.UnifiedMemoryState.recOn : forall {motive : UnifiedIPLDMemory.UnifiedMemoryState -> Sort.{u}} (t : UnifiedIPLDMemory.UnifiedMemoryState), (forall (dag : UnifiedIPLDMemory.IPLDDAG) (taggedBlocks : List.{0} UnifiedIPLDMemory.TaggedBlock) (tag_consistent : Eq.{1} Nat (List.length.{0} UnifiedIPLDMemory.TaggedBlock taggedBlocks) (UnifiedIPLDMemory.IPLDDAG.blockCount dag)) (basePoint : FiberedUniverse.S_ss), motive (UnifiedIPLDMemory.UnifiedMemoryState.mk dag taggedBlocks tag_consistent basePoint)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.UnifiedMemoryState.recOn`.
-- In a full split, the body would be extracted from the environment.
