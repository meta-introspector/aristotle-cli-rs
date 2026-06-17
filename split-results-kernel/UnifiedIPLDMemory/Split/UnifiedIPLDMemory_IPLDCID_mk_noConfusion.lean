import Split.UnifiedIPLDMemory_IPLDCID_noConfusion
import Split.UnifiedIPLDMemory_IPLDCID_mk
import Split.UnifiedIPLDMemory_IPLDCodec
import Split.UnifiedIPLDMemory_IPLDCID
import Split.id
import Split.Nat
import Split.Eq

-- UnifiedIPLDMemory.IPLDCID.mk.noConfusion from environment
-- def UnifiedIPLDMemory.IPLDCID.mk.noConfusion : forall {P : Sort.{u}} {version : Nat} {codec : UnifiedIPLDMemory.IPLDCodec} {digest : Nat} {version' : Nat} {codec' : UnifiedIPLDMemory.IPLDCodec} {digest' : Nat}, (Eq.{1} UnifiedIPLDMemory.IPLDCID (UnifiedIPLDMemory.IPLDCID.mk version codec digest) (UnifiedIPLDMemory.IPLDCID.mk version' codec' digest')) -> ((Eq.{1} Nat version version') -> (Eq.{1} UnifiedIPLDMemory.IPLDCodec codec codec') -> (Eq.{1} Nat digest digest') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.IPLDCID.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
