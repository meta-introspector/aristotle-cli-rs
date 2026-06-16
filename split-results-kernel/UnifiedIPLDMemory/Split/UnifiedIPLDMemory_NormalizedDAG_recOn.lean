import Split.List_Pairwise
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDBlock_cid
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_NormalizedDAG_mk
import Split.Ne
import Split.UnifiedIPLDMemory_NormalizedDAG
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.UnifiedIPLDMemory_NormalizedDAG_rec

-- UnifiedIPLDMemory.NormalizedDAG.recOn from environment
-- def UnifiedIPLDMemory.NormalizedDAG.recOn : forall {motive : UnifiedIPLDMemory.NormalizedDAG -> Sort.{u}} (t : UnifiedIPLDMemory.NormalizedDAG), (forall (toIPLDDAG : UnifiedIPLDMemory.IPLDDAG) (no_dup : List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG)), motive (UnifiedIPLDMemory.NormalizedDAG.mk toIPLDDAG no_dup)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizedDAG.recOn`.
-- In a full split, the body would be extracted from the environment.
