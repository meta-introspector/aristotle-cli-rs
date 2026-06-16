import Split.UnifiedIPLDMemory_DAGQuotient_mk
import Split.LE_le
import Split.instLENat
import Split.UnifiedIPLDMemory_DAGQuotient
import Split.Nat
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.UnifiedIPLDMemory_IPLDDAG_blockCount

-- UnifiedIPLDMemory.DAGQuotient.rec from environment
-- recursor UnifiedIPLDMemory.DAGQuotient.rec : forall {parent : UnifiedIPLDMemory.IPLDDAG} {quotient : UnifiedIPLDMemory.IPLDDAG} {motive : (UnifiedIPLDMemory.DAGQuotient parent quotient) -> Sort.{u}}, (forall (block_reduction : LE.le.{0} Nat instLENat (UnifiedIPLDMemory.IPLDDAG.blockCount quotient) (UnifiedIPLDMemory.IPLDDAG.blockCount parent)), motive (UnifiedIPLDMemory.DAGQuotient.mk parent quotient block_reduction)) -> (forall (t : UnifiedIPLDMemory.DAGQuotient parent quotient), motive t)

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGQuotient.rec`.
-- In a full split, the body would be extracted from the environment.
