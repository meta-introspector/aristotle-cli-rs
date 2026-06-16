import Split.UnifiedIPLDMemory_NormalizedDAG_noConfusion
import Split.List_Pairwise
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDBlock_cid
import Split.UnifiedIPLDMemory_IPLDCID
import Split.id
import Split.UnifiedIPLDMemory_NormalizedDAG_mk
import Split.Ne
import Split.UnifiedIPLDMemory_NormalizedDAG
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq

-- UnifiedIPLDMemory.NormalizedDAG.mk.noConfusion from environment
-- def UnifiedIPLDMemory.NormalizedDAG.mk.noConfusion : forall {P : Sort.{u}} {toIPLDDAG : UnifiedIPLDMemory.IPLDDAG} {no_dup : List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG)} {toIPLDDAG' : UnifiedIPLDMemory.IPLDDAG} {no_dup' : List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG')}, (Eq.{1} UnifiedIPLDMemory.NormalizedDAG (UnifiedIPLDMemory.NormalizedDAG.mk toIPLDDAG no_dup) (UnifiedIPLDMemory.NormalizedDAG.mk toIPLDDAG' no_dup')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDDAG toIPLDDAG toIPLDDAG') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizedDAG.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
