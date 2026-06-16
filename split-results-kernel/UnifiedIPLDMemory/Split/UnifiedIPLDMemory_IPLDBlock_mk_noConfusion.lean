import Split.UnifiedIPLDMemory_IPLDBlock
import Split.UnifiedIPLDMemory_IPLDCID
import Split.id
import Split.UnifiedIPLDMemory_IPLDBlock_mk
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDBlock_noConfusion
import Split.Eq

-- UnifiedIPLDMemory.IPLDBlock.mk.noConfusion from environment
-- def UnifiedIPLDMemory.IPLDBlock.mk.noConfusion : forall {P : Sort.{u}} {cid : UnifiedIPLDMemory.IPLDCID} {payloadSize : Nat} {linkCount : Nat} {cid' : UnifiedIPLDMemory.IPLDCID} {payloadSize' : Nat} {linkCount' : Nat}, (Eq.{1} UnifiedIPLDMemory.IPLDBlock (UnifiedIPLDMemory.IPLDBlock.mk cid payloadSize linkCount) (UnifiedIPLDMemory.IPLDBlock.mk cid' payloadSize' linkCount')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDCID cid cid') -> (Eq.{1} Nat payloadSize payloadSize') -> (Eq.{1} Nat linkCount linkCount') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDBlock.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
