import Split.UnifiedIPLDMemory_MemoryFiber_blocks
import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.Membership_mem
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.Eq

-- UnifiedIPLDMemory.MemoryFiber.all_at_base from environment
-- theorem UnifiedIPLDMemory.MemoryFiber.all_at_base : forall {x : FiberedUniverse.S_ss} (self : UnifiedIPLDMemory.MemoryFiber x) (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) (UnifiedIPLDMemory.MemoryFiber.blocks x self) tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MemoryFiber.all_at_base`.
-- In a full split, the body would be extracted from the environment.
