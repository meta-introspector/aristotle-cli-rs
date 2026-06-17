import Split.GovernanceInvariant_CID
import Split.String
import Split.KernelGovernance_Dataset_contains
import Split.instSizeOfDefault
import Split.KernelGovernance_Dataset
import Split.GovernanceInvariant_Congruent
import Split.GovernanceInvariant_Block
import Split.instOfNatNat
import Split.TypedDMZ_LinkTraversal
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.SizeOf_sizeOf
import Split.instAddNat
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.TypedDMZ_LinkTraversal_mk

-- TypedDMZ.LinkTraversal.mk.sizeOf_spec from environment
-- theorem TypedDMZ.LinkTraversal.mk.sizeOf_spec : forall (source : KernelGovernance.Dataset) (sourceBlock : GovernanceInvariant.Block) (linkField : String) (target : KernelGovernance.Dataset) (targetCid : GovernanceInvariant.CID) (targetBlock : GovernanceInvariant.Block) (sourceOk : KernelGovernance.Dataset.contains source sourceBlock) (targetCong : GovernanceInvariant.Congruent targetCid targetBlock) (targetOk : KernelGovernance.Dataset.contains target targetBlock), Eq.{1} Nat (SizeOf.sizeOf.{1} TypedDMZ.LinkTraversal TypedDMZ.LinkTraversal._sizeOf_inst (TypedDMZ.LinkTraversal.mk source sourceBlock linkField target targetCid targetBlock sourceOk targetCong targetOk)) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (SizeOf.sizeOf.{1} KernelGovernance.Dataset KernelGovernance.Dataset._sizeOf_inst source)) (SizeOf.sizeOf.{1} GovernanceInvariant.Block GovernanceInvariant.Block._sizeOf_inst sourceBlock)) (SizeOf.sizeOf.{1} String String._sizeOf_inst linkField)) (SizeOf.sizeOf.{1} KernelGovernance.Dataset KernelGovernance.Dataset._sizeOf_inst target)) (SizeOf.sizeOf.{1} GovernanceInvariant.CID GovernanceInvariant.CID._sizeOf_inst targetCid)) (SizeOf.sizeOf.{1} GovernanceInvariant.Block GovernanceInvariant.Block._sizeOf_inst targetBlock)) (SizeOf.sizeOf.{0} (KernelGovernance.Dataset.contains source sourceBlock) (instSizeOfDefault.{0} (KernelGovernance.Dataset.contains source sourceBlock)) sourceOk)) (SizeOf.sizeOf.{0} (GovernanceInvariant.Congruent targetCid targetBlock) (instSizeOfDefault.{0} (GovernanceInvariant.Congruent targetCid targetBlock)) targetCong)) (SizeOf.sizeOf.{0} (KernelGovernance.Dataset.contains target targetBlock) (instSizeOfDefault.{0} (KernelGovernance.Dataset.contains target targetBlock)) targetOk))

-- Stub: this file represents the declaration `TypedDMZ.LinkTraversal.mk.sizeOf_spec`.
-- In a full split, the body would be extracted from the environment.
