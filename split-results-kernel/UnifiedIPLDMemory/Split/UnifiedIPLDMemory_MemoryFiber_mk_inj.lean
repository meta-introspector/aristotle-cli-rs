import Split.FiberedUniverse_S_ss
import Split.UnifiedIPLDMemory_TaggedBlock_fiberPoint
import Split.UnifiedIPLDMemory_TaggedBlock
import Split.UnifiedIPLDMemory_MemoryFiber_mk_noConfusion
import Split.Membership_mem
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_MemoryFiber
import Split.Eq
import Split.UnifiedIPLDMemory_MemoryFiber_mk

-- UnifiedIPLDMemory.MemoryFiber.mk.inj from environment
-- theorem UnifiedIPLDMemory.MemoryFiber.mk.inj : forall {x : FiberedUniverse.S_ss} {blocks : List.{0} UnifiedIPLDMemory.TaggedBlock} {all_at_base : forall (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) blocks tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)} {blocks_1 : List.{0} UnifiedIPLDMemory.TaggedBlock} {all_at_base_1 : forall (tb : UnifiedIPLDMemory.TaggedBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.TaggedBlock (List.{0} UnifiedIPLDMemory.TaggedBlock) (List.instMembership.{0} UnifiedIPLDMemory.TaggedBlock) blocks_1 tb) -> (Eq.{1} FiberedUniverse.S_ss (UnifiedIPLDMemory.TaggedBlock.fiberPoint tb) x)}, (Eq.{1} (UnifiedIPLDMemory.MemoryFiber x) (UnifiedIPLDMemory.MemoryFiber.mk x blocks all_at_base) (UnifiedIPLDMemory.MemoryFiber.mk x blocks_1 all_at_base_1)) -> (Eq.{1} (List.{0} UnifiedIPLDMemory.TaggedBlock) blocks blocks_1)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.MemoryFiber.mk.inj`.
-- In a full split, the body would be extracted from the environment.
