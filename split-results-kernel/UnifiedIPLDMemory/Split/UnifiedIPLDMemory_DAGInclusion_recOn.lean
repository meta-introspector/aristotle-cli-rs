import Split.UnifiedIPLDMemory_DAGInclusion
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_DAGInclusion_mk
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.UnifiedIPLDMemory_DAGInclusion_rec
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_IPLDDAG

-- UnifiedIPLDMemory.DAGInclusion.recOn from environment
-- def UnifiedIPLDMemory.DAGInclusion.recOn : forall {sub : UnifiedIPLDMemory.IPLDDAG} {parent : UnifiedIPLDMemory.IPLDDAG} {motive : (UnifiedIPLDMemory.DAGInclusion sub parent) -> Sort.{u}} (t : UnifiedIPLDMemory.DAGInclusion sub parent), (forall (block_inclusion : forall (b : UnifiedIPLDMemory.IPLDBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks sub) b) -> (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks parent) b)), motive (UnifiedIPLDMemory.DAGInclusion.mk sub parent block_inclusion)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGInclusion.recOn`.
-- In a full split, the body would be extracted from the environment.
