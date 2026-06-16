import Split.UnifiedIPLDMemory_NormalizedDAG_toIPLDDAG
import Split.List_Pairwise
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDBlock_cid
import Split.UnifiedIPLDMemory_IPLDCID
import Split.Ne
import Split.UnifiedIPLDMemory_NormalizedDAG
import Split.UnifiedIPLDMemory_IPLDDAG_blocks

-- UnifiedIPLDMemory.NormalizedDAG.no_dup from environment
-- theorem UnifiedIPLDMemory.NormalizedDAG.no_dup : forall (self : UnifiedIPLDMemory.NormalizedDAG), List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks (UnifiedIPLDMemory.NormalizedDAG.toIPLDDAG self))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizedDAG.no_dup`.
-- In a full split, the body would be extracted from the environment.
