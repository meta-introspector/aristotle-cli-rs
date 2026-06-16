import Split.UnifiedIPLDMemory_DAGQuotient_mk
import Split.LE_le
import Split.instLENat
import Split.UnifiedIPLDMemory_DAGQuotient
import Split.UnifiedIPLDMemory_DAGQuotient_rec
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.DAGQuotient.recOn from environment
-- def UnifiedIPLDMemory.DAGQuotient.recOn : forall {parent : UnifiedIPLDMemory.IPLDDAG} {quotient : UnifiedIPLDMemory.IPLDDAG} {motive : (UnifiedIPLDMemory.DAGQuotient parent quotient) -> Sort.{u}} (t : UnifiedIPLDMemory.DAGQuotient parent quotient), (forall (block_reduction : LE.le.{0} Nat instLENat (UnifiedIPLDMemory.IPLDDAG.blockCount quotient) (UnifiedIPLDMemory.IPLDDAG.blockCount parent)), motive (UnifiedIPLDMemory.DAGQuotient.mk parent quotient block_reduction)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGQuotient.recOn`.
-- In a full split, the body would be extracted from the environment.
