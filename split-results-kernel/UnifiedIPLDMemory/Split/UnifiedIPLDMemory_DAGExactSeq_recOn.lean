import Split.UnifiedIPLDMemory_DAGInclusion
import Split.UnifiedIPLDMemory_DAGExactSeq
import Split.UnifiedIPLDMemory_DAGExactSeq_mk
import Split.UnifiedIPLDMemory_DAGExactSeq_rec
import Split.UnifiedIPLDMemory_DAGQuotient
import Split.UnifiedIPLDMemory_IPLDDAG

-- UnifiedIPLDMemory.DAGExactSeq.recOn from environment
-- def UnifiedIPLDMemory.DAGExactSeq.recOn : forall {motive : UnifiedIPLDMemory.DAGExactSeq -> Sort.{u}} (t : UnifiedIPLDMemory.DAGExactSeq), (forall (sub : UnifiedIPLDMemory.IPLDDAG) (middle : UnifiedIPLDMemory.IPLDDAG) (quotient : UnifiedIPLDMemory.IPLDDAG) (inclusion : UnifiedIPLDMemory.DAGInclusion sub middle) (projection : UnifiedIPLDMemory.DAGQuotient middle quotient), motive (UnifiedIPLDMemory.DAGExactSeq.mk sub middle quotient inclusion projection)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGExactSeq.recOn`.
-- In a full split, the body would be extracted from the environment.
