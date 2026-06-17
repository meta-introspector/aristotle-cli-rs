import Split.UnifiedIPLDMemory_DAGLink
import Split.UnifiedIPLDMemory_DAGLink_mk
import Split.String
import Split.UnifiedIPLDMemory_DAGLink_mk_noConfusion
import Split.UnifiedIPLDMemory_IPLDCID
import Split.And
import Split.And_intro
import Split.Eq

-- UnifiedIPLDMemory.DAGLink.mk.inj from environment
-- theorem UnifiedIPLDMemory.DAGLink.mk.inj : forall {source : UnifiedIPLDMemory.IPLDCID} {target : UnifiedIPLDMemory.IPLDCID} {label : String} {source_1 : UnifiedIPLDMemory.IPLDCID} {target_1 : UnifiedIPLDMemory.IPLDCID} {label_1 : String}, (Eq.{1} UnifiedIPLDMemory.DAGLink (UnifiedIPLDMemory.DAGLink.mk source target label) (UnifiedIPLDMemory.DAGLink.mk source_1 target_1 label_1)) -> (And (Eq.{1} UnifiedIPLDMemory.IPLDCID source source_1) (And (Eq.{1} UnifiedIPLDMemory.IPLDCID target target_1) (Eq.{1} String label label_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGLink.mk.inj`.
-- In a full split, the body would be extracted from the environment.
