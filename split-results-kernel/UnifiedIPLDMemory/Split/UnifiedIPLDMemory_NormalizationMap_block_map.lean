import Split.UnifiedIPLDMemory_NormalizationMap
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.Membership_mem
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.List
import Split.List_instMembership
import Split.UnifiedIPLDMemory_IPLDDAG

-- UnifiedIPLDMemory.NormalizationMap.block_map from environment
-- theorem UnifiedIPLDMemory.NormalizationMap.block_map : forall {original : UnifiedIPLDMemory.IPLDDAG} {normalized : UnifiedIPLDMemory.IPLDDAG}, (UnifiedIPLDMemory.NormalizationMap original normalized) -> (forall (b : UnifiedIPLDMemory.IPLDBlock), (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks normalized) b) -> (Membership.mem.{0, 0} UnifiedIPLDMemory.IPLDBlock (List.{0} UnifiedIPLDMemory.IPLDBlock) (List.instMembership.{0} UnifiedIPLDMemory.IPLDBlock) (UnifiedIPLDMemory.IPLDDAG.blocks original) b))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizationMap.block_map`.
-- In a full split, the body would be extracted from the environment.
