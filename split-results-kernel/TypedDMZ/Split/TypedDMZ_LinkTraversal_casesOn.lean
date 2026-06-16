import Split.GovernanceInvariant_CID
import Split.String
import Split.KernelGovernance_Dataset_contains
import Split.KernelGovernance_Dataset
import Split.GovernanceInvariant_Congruent
import Split.GovernanceInvariant_Block
import Split.TypedDMZ_LinkTraversal
import Split.TypedDMZ_LinkTraversal_rec
import Split.TypedDMZ_LinkTraversal_mk

-- TypedDMZ.LinkTraversal.casesOn from environment
-- def TypedDMZ.LinkTraversal.casesOn : forall {motive : TypedDMZ.LinkTraversal -> Sort.{u}} (t : TypedDMZ.LinkTraversal), (forall (source : KernelGovernance.Dataset) (sourceBlock : GovernanceInvariant.Block) (linkField : String) (target : KernelGovernance.Dataset) (targetCid : GovernanceInvariant.CID) (targetBlock : GovernanceInvariant.Block) (sourceOk : KernelGovernance.Dataset.contains source sourceBlock) (targetCong : GovernanceInvariant.Congruent targetCid targetBlock) (targetOk : KernelGovernance.Dataset.contains target targetBlock), motive (TypedDMZ.LinkTraversal.mk source sourceBlock linkField target targetCid targetBlock sourceOk targetCong targetOk)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `TypedDMZ.LinkTraversal.casesOn`.
-- In a full split, the body would be extracted from the environment.
