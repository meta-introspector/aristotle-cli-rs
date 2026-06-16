import Split.UnifiedIPLDMemory_DAGInclusion
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_IPLDDAG

-- UnifiedIPLDMemory.DAGInclusion.block_inclusion from environment
-- theorem UnifiedIPLDMemory.DAGInclusion.block_inclusion : forall {sub : UnifiedIPLDMemory.IPLDDAG} {parent : UnifiedIPLDMemory.IPLDDAG}, (UnifiedIPLDMemory.DAGInclusion sub parent) -> (forall (b : UnifiedIPLDMemory.IPLDBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks sub) b) -> (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks parent) b))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGInclusion.block_inclusion`.
-- In a full split, the body would be extracted from the environment.
