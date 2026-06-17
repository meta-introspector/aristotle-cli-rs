import Split.KernelGovernance_no_cross_contamination
import Split.TypedDMZ_LinkTraversal_target
import Split.KernelGovernance_Dataset_contains
import Split.TypedDMZ_LinkTraversal_source
import Split.KernelGovernance_Dataset
import Split.Ne
import Split.TypedDMZ_LinkTraversal_targetOk
import Split.TypedDMZ_LinkTraversal
import Split.TypedDMZ_LinkTraversal_targetBlock
import Split.Not

-- TypedDMZ.link_no_contamination from environment
-- theorem TypedDMZ.link_no_contamination : forall (lt : TypedDMZ.LinkTraversal), (Ne.{1} KernelGovernance.Dataset (TypedDMZ.LinkTraversal.source lt) (TypedDMZ.LinkTraversal.target lt)) -> (Not (KernelGovernance.Dataset.contains (TypedDMZ.LinkTraversal.source lt) (TypedDMZ.LinkTraversal.targetBlock lt)))

-- Stub: this file represents the declaration `TypedDMZ.link_no_contamination`.
-- In a full split, the body would be extracted from the environment.
