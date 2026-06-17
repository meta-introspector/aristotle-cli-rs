import Split.UnifiedIPLDMemory_DAGLink
import Split.UnifiedIPLDMemory_DAGLink_mk
import Split.Eq_propIntro
import Split.String
import Split.Lean_injEq_helper
import Split.UnifiedIPLDMemory_IPLDCID
import Split.And
import Split.Eq_ndrec
import Split.Eq_refl
import Split.UnifiedIPLDMemory_DAGLink_mk_inj
import Split.Eq

-- UnifiedIPLDMemory.DAGLink.mk.injEq from environment
-- theorem UnifiedIPLDMemory.DAGLink.mk.injEq : forall (source : UnifiedIPLDMemory.IPLDCID) (target : UnifiedIPLDMemory.IPLDCID) (label : String) (source_1 : UnifiedIPLDMemory.IPLDCID) (target_1 : UnifiedIPLDMemory.IPLDCID) (label_1 : String), Eq.{1} Prop (Eq.{1} UnifiedIPLDMemory.DAGLink (UnifiedIPLDMemory.DAGLink.mk source target label) (UnifiedIPLDMemory.DAGLink.mk source_1 target_1 label_1)) (And (Eq.{1} UnifiedIPLDMemory.IPLDCID source source_1) (And (Eq.{1} UnifiedIPLDMemory.IPLDCID target target_1) (Eq.{1} String label label_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGLink.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
