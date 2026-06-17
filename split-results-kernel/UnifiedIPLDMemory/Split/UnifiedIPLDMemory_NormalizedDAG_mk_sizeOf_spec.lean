import Split.List_Pairwise
import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDBlock_cid
import Split.UnifiedIPLDMemory_IPLDCID
import Split.UnifiedIPLDMemory_NormalizedDAG_mk
import Split.Ne
import Split.instOfNatNat
import Split.UnifiedIPLDMemory_NormalizedDAG
import Split.UnifiedIPLDMemory_IPLDDAG_blocks
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.NormalizedDAG.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.NormalizedDAG.mk.sizeOf_spec : forall (toIPLDDAG : UnifiedIPLDMemory.IPLDDAG) (no_dup : List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG)), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.NormalizedDAG UnifiedIPLDMemory.NormalizedDAG._sizeOf_inst (UnifiedIPLDMemory.NormalizedDAG.mk toIPLDDAG no_dup)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDDAG UnifiedIPLDMemory.IPLDDAG._sizeOf_inst toIPLDDAG)) (SizeOf.sizeOf.{0} (List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG)) (instSizeOfDefault.{0} (List.Pairwise.{0} UnifiedIPLDMemory.IPLDBlock (fun (b₁ : UnifiedIPLDMemory.IPLDBlock) (b₂ : UnifiedIPLDMemory.IPLDBlock) => Ne.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDBlock.cid b₁) (UnifiedIPLDMemory.IPLDBlock.cid b₂)) (UnifiedIPLDMemory.IPLDDAG.blocks toIPLDDAG))) no_dup))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.NormalizedDAG.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
