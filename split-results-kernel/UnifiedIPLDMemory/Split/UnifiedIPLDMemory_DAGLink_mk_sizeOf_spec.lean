import Split.UnifiedIPLDMemory_DAGLink
import Split.UnifiedIPLDMemory_DAGLink_mk
import Split.String
import Split.UnifiedIPLDMemory_IPLDCID
import Split.instOfNatNat
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq

-- UnifiedIPLDMemory.DAGLink.mk.sizeOf_spec from environment
-- theorem UnifiedIPLDMemory.DAGLink.mk.sizeOf_spec : forall (source : UnifiedIPLDMemory.IPLDCID) (target : UnifiedIPLDMemory.IPLDCID) (label : String), Eq.{1} Nat (SizeOf.sizeOf.{1} UnifiedIPLDMemory.DAGLink UnifiedIPLDMemory.DAGLink._sizeOf_inst (UnifiedIPLDMemory.DAGLink.mk source target label)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCID UnifiedIPLDMemory.IPLDCID._sizeOf_inst source)) (SizeOf.sizeOf.{1} UnifiedIPLDMemory.IPLDCID UnifiedIPLDMemory.IPLDCID._sizeOf_inst target)) (SizeOf.sizeOf.{1} String String._sizeOf_inst label))

-- Stub: this file represents the declaration `UnifiedIPLDMemory.DAGLink.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
