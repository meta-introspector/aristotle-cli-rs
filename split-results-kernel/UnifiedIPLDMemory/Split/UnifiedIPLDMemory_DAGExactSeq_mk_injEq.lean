import Split.UnifiedIPLDMemory_DAGInclusion
import Split.Eq_propIntro
import Split.UnifiedIPLDMemory_DAGExactSeq_mk_inj
import Split.Lean_injEq_helper
import Split.UnifiedIPLDMemory_DAGExactSeq
import Split.UnifiedIPLDMemory_DAGExactSeq_mk
import Split.UnifiedIPLDMemory_DAGQuotient
import Split.And
import Split.Eq_ndrec
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq_refl
import Split.Eq

-- UnifiedIPLDMemory.DAGExactSeq.mk.injEq from environment
-- theorem UnifiedIPLDMemory.DAGExactSeq.mk.injEq : forall (sub : UnifiedIPLDMemory.IPLDDAG) (middle : UnifiedIPLDMemory.IPLDDAG) (quotient : UnifiedIPLDMemory.IPLDDAG) (inclusion : UnifiedIPLDMemory.DAGInclusion sub middle) (projection : UnifiedIPLDMemory.DAGQuotient middle quotient) (sub_1 : UnifiedIPLDMemory.IPLDDAG) (middle_1 : UnifiedIPLDMemory.IPLDDAG) (quotient_1 : UnifiedIPLDMemory.IPLDDAG) (inclusion_1 : UnifiedIPLDMemory.DAGInclusion sub_1 middle_1) (projection_1 : UnifiedIPLDMemory.DAGQuotient middle_1 quotient_1), Eq.{1} Prop (Eq.{1} UnifiedIPLDMemory.DAGExactSeq (UnifiedIPLDMemory.DAGExactSeq.mk sub middle quotient inclusion projection) (UnifiedIPLDMemory.DAGExactSeq.mk sub_1 middle_1 quotient_1 inclusion_1 projection_1)) (And (Eq.{1} UnifiedIPLDMemory.IPLDDAG sub sub_1) (And (Eq.{1} UnifiedIPLDMemory.IPLDDAG middle middle_1) (Eq.{1} UnifiedIPLDMemory.IPLDDAG quotient quotient_1)))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGExactSeq.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
