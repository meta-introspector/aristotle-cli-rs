import Split.UnifiedIPLDMemory_IPLDBlock_mk_noConfusion
import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.And
import Split.UnifiedIPLDMemory_IPLDBlock_mk
import Split.Nat
import Split.And_intro
import Split.Eq

-- UnifiedIPLDMemory.IPLDBlock.mk.inj from environment
-- theorem UnifiedIPLDMemory.IPLDBlock.mk.inj : forall {cid : UnifiedIPLDMemory.IPLDCID} {payloadSize : Nat} {linkCount : Nat} {cid_1 : UnifiedIPLDMemory.IPLDCID} {payloadSize_1 : Nat} {linkCount_1 : Nat}, (Eq.{1} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDBlock.mk cid payloadSize linkCount) (UnifiedIPLDMemory.IPLDBlock.mk cid_1 payloadSize_1 linkCount_1)) -> (And (Eq.{1} UnifiedIPLDMemory.IPLDCID cid cid_1) (And (Eq.{1} Nat payloadSize payloadSize_1) (Eq.{1} Nat linkCount linkCount_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDBlock.mk.inj`.
-- In a full split, the body would be extracted from the environment.
