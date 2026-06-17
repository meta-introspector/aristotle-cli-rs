import Split.UnifiedIPLDMemory_DAGInclusion
import Split.UnifiedIPLDMemory_DAGExactSeq
import Split.UnifiedIPLDMemory_DAGExactSeq_mk
import Split.id
import Split.UnifiedIPLDMemory_DAGQuotient
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.Eq
import Split.UnifiedIPLDMemory_DAGExactSeq_noConfusion

-- UnifiedIPLDMemory.DAGExactSeq.mk.noConfusion from environment
-- def UnifiedIPLDMemory.DAGExactSeq.mk.noConfusion : forall {P : Sort.{u}} {sub : UnifiedIPLDMemory.IPLDDAG} {middle : UnifiedIPLDMemory.IPLDDAG} {quotient : UnifiedIPLDMemory.IPLDDAG} {inclusion : UnifiedIPLDMemory.DAGInclusion sub middle} {projection : UnifiedIPLDMemory.DAGQuotient middle quotient} {sub' : UnifiedIPLDMemory.IPLDDAG} {middle' : UnifiedIPLDMemory.IPLDDAG} {quotient' : UnifiedIPLDMemory.IPLDDAG} {inclusion' : UnifiedIPLDMemory.DAGInclusion sub' middle'} {projection' : UnifiedIPLDMemory.DAGQuotient middle' quotient'}, (Eq.{1} UnifiedIPLDMemory.DAGExactSeq (UnifiedIPLDMemory.DAGExactSeq.mk sub middle quotient inclusion projection) (UnifiedIPLDMemory.DAGExactSeq.mk sub' middle' quotient' inclusion' projection')) -> ((Eq.{1} UnifiedIPLDMemory.IPLDDAG sub sub') -> (Eq.{1} UnifiedIPLDMemory.IPLDDAG middle middle') -> (Eq.{1} UnifiedIPLDMemory.IPLDDAG quotient quotient') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGExactSeq.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
