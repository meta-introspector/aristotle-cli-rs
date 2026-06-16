import Split.UnifiedIPLDMemory_DAGInclusion
import Split.instSizeOfDefault
import Split.UnifiedIPLDMemory_DAGExactSeq
import Split.UnifiedIPLDMemory_DAGExactSeq_mk
import Split.instOfNatNat
import Split.UnifiedIPLDMemory_DAGQuotient
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.UnifiedIPLDMemory_IPLDDAG
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.DAGExactSeq.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.DAGExactSeq.mk.sizeOf_spec : forall (sub : UnifiedIPLDMemory.IPLDDAG) (middle : UnifiedIPLDMemory.IPLDDAG) (quotient : UnifiedIPLDMemory.IPLDDAG) (inclusion : UnifiedIPLDMemory.DAGInclusion sub middle) (projection : UnifiedIPLDMemory.DAGQuotient middle quotient), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.DAGExactSeq UnifiedIPLDMemory.DAGExactSeq._sizeOf_inst (UnifiedIPLDMemory.DAGExactSeq.mk sub middle quotient inclusion projection)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDDAG UnifiedIPLDMemory.IPLDDAG._sizeOf_inst sub)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDDAG UnifiedIPLDMemory.IPLDDAG._sizeOf_inst middle)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDDAG UnifiedIPLDMemory.IPLDDAG._sizeOf_inst quotient)) (SizeOf.sizeOf.{0} (UnifiedIPLDMemory.DAGInclusion sub middle) (instSizeOfDefault.{0} (UnifiedIPLDMemory.DAGInclusion sub middle)) inclusion)) (SizeOf.sizeOf.{0} (UnifiedIPLDMemory.DAGQuotient middle quotient) (instSizeOfDefault.{0} (UnifiedIPLDMemory.DAGQuotient middle quotient)) projection))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGExactSeq.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
