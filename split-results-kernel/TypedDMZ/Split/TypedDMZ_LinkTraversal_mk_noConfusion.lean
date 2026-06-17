import Split.GovernanceInvariant_CID
import Split.String
import Split.KernelGovernance_Dataset_contains
import Split.KernelGovernance_Dataset
import Split.GovernanceInvariant_Congruent
import Split.GovernanceInvariant_Block
import Split.id
import Split.TypedDMZ_LinkTraversal
import Split.TypedDMZ_LinkTraversal_noConfusion
import Split.Eq
import Split.TypedDMZ_LinkTraversal_mk

-- TypedDMZ.LinkTraversal.mk.noConfusion from environment
-- def TypedDMZ.LinkTraversal.mk.noConfusion : forall {P : Sort.{u}} {source : KernelGovernance.Dataset} {sourceBlock : GovernanceInvariant.Block} {linkField : String} {target : KernelGovernance.Dataset} {targetCid : GovernanceInvariant.CID} {targetBlock : GovernanceInvariant.Block} {sourceOk : KernelGovernance.Dataset.contains source sourceBlock} {targetCong : GovernanceInvariant.Congruent targetCid targetBlock} {targetOk : KernelGovernance.Dataset.contains target targetBlock} {source' : KernelGovernance.Dataset} {sourceBlock' : GovernanceInvariant.Block} {linkField' : String} {target' : KernelGovernance.Dataset} {targetCid' : GovernanceInvariant.CID} {targetBlock' : GovernanceInvariant.Block} {sourceOk' : KernelGovernance.Dataset.contains source' sourceBlock'} {targetCong' : GovernanceInvariant.Congruent targetCid' targetBlock'} {targetOk' : KernelGovernance.Dataset.contains target' targetBlock'}, (Eq.{1} TypedDMZ.LinkTraversal (TypedDMZ.LinkTraversal.mk source sourceBlock linkField target targetCid targetBlock sourceOk targetCong targetOk) (TypedDMZ.LinkTraversal.mk source' sourceBlock' linkField' target' targetCid' targetBlock' sourceOk' targetCong' targetOk')) -> ((Eq.{1} KernelGovernance.Dataset source source') -> (Eq.{1} GovernanceInvariant.Block sourceBlock sourceBlock') -> (Eq.{1} String linkField linkField') -> (Eq.{1} KernelGovernance.Dataset target target') -> (Eq.{1} GovernanceInvariant.CID targetCid targetCid') -> (Eq.{1} GovernanceInvariant.Block targetBlock targetBlock') -> P) -> P
-- (definition body omitted)

-- Stub: this file represents the declaration `TypedDMZ.LinkTraversal.mk.noConfusion`.
-- In a full split, the body would be extracted from the environment.
