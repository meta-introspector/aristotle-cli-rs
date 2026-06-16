import Split.UnifiedIPLDMemory_DAGLink
import Split.UnifiedIPLDMemory_DAGLink_mk
import Split.String
import Split.UnifiedIPLDMemory_DAGLink_noConfusion
import Split.UnifiedIPLDMemory_IPLDCID
import Split.id
import Split.Eq

-- UnifiedIPLDMemory.DAGLink.mk.noConfusion from environment
-- def UnifiedIPLDMemory.DAGLink.mk.noConfusion : forall {P : Sort.{u}} {source : UnifiedIPLDMemory.IPLDCID} {target : UnifiedIPLDMemory.IPLDCID} {label : String} {source' : UnifiedIPLDMemory.IPLDCID} {target' : UnifiedIPLDMemory.IPLDCID} {label' : String}, (Eq.{1} UnifiedIPLDMemory.DAGLink (UnifiedIPLDMemory.DAGLink.mk source target label) (UnifiedIPLDMemory.DAGLink.mk source' target' label')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDCID source source') -> (Eq.{1} UnifiedIPLDMemory.IPLDCID target target') -> (Eq.{1} String label label') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGLink.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
