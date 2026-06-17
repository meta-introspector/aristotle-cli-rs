import Split.GovernanceInvariant_CID
import Split.Eq_propIntro
import Split.String
import Split.TypedDMZ_LinkTraversal_mk_inj
import Split.KernelGovernance_Dataset_contains
import Split.Lean_injEq_helper
import Split.KernelGovernance_Dataset
import Split.GovernanceInvariant_Congruent
import Split.GovernanceInvariant_Block
import Split.TypedDMZ_LinkTraversal
import Split.And
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Eq
import Split.TypedDMZ_LinkTraversal_mk

-- TypedDMZ.LinkTraversal.mk.injEq from environment
-- theorem TypedDMZ.LinkTraversal.mk.injEq : forall (source : KernelGovernance.Dataset) (sourceBlock : GovernanceInvariant.Block) (linkField : String) (target : KernelGovernance.Dataset) (targetCid : GovernanceInvariant.CID) (targetBlock : GovernanceInvariant.Block) (sourceOk : KernelGovernance.Dataset.contains source sourceBlock) (targetCong : GovernanceInvariant.Congruent targetCid targetBlock) (targetOk : KernelGovernance.Dataset.contains target targetBlock) (source_1 : KernelGovernance.Dataset) (sourceBlock_1 : GovernanceInvariant.Block) (linkField_1 : String) (target_1 : KernelGovernance.Dataset) (targetCid_1 : GovernanceInvariant.CID) (targetBlock_1 : GovernanceInvariant.Block) (sourceOk_1 : KernelGovernance.Dataset.contains source_1 sourceBlock_1) (targetCong_1 : GovernanceInvariant.Congruent targetCid_1 targetBlock_1) (targetOk_1 : KernelGovernance.Dataset.contains target_1 targetBlock_1), Eq.{1} Prop (Eq.{1} TypedDMZ.LinkTraversal (TypedDMZ.LinkTraversal.mk source sourceBlock linkField target targetCid targetBlock sourceOk targetCong targetOk) (TypedDMZ.LinkTraversal.mk source_1 sourceBlock_1 linkField_1 target_1 targetCid_1 targetBlock_1 sourceOk_1 targetCong_1 targetOk_1)) (And (Eq.{1} KernelGovernance.Dataset source source_1) (And (Eq.{1} GovernanceInvariant.Block sourceBlock sourceBlock_1) (And (Eq.{1} String linkField linkField_1) (And (Eq.{1} KernelGovernance.Dataset target target_1) (And (Eq.{1} GovernanceInvariant.CID targetCid targetCid_1) (Eq.{1} GovernanceInvariant.Block targetBlock targetBlock_1))))))

-- Stub: this file represents the declaration `TypedDMZ.LinkTraversal.mk.injEq`.
-- In a full split, the body would be extracted from the environment.
