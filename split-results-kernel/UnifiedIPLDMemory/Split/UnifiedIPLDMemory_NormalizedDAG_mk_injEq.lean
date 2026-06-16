import Split.List_Pairwise
import Split.Eq_propIntro
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDBlock_cid
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_NormalizedDAG_mk
import Split.Ne
import Split.UnifiedIPLDMemory_NormalizedDAG
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.Eq_ndrec
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq_refl
import Split.UnifiedIPLDMemory_NormalizedDAG_mk_inj
import Split.Eq

-- UnifiedIPLDMemory.NormalizedDAG.mk.injEq from environment
-- theorem UnifiedIPLDMemory.NormalizedDAG.mk.injEq : forall (toIPLDDAG : UnifiedIPLDMemory.IPLDDAG) (no_dup : List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG)) (toIPLDDAG_1 : UnifiedIPLDMemory.IPLDDAG) (no_dup_1 : List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG_1)), Eq.{1} Prop (Eq.{1} UnifiedIPLDMemory.NormalizedDAG (UnifiedIPLDMemory.NormalizedDAG.mk toIPLDDAG no_dup) (UnifiedIPLDMemory.NormalizedDAG.mk toIPLDDAG_1 no_dup_1)) (Eq.{1} UnifiedIPLDMemory.IPLDDAG toIPLDDAG toIPLDDAG_1)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizedDAG.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
