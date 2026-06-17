import Split.TypedDMZ_FieldInDMZ
import Split.KernelGovernance_no_cross_contamination
import Split.String
import Split.KernelGovernance_Dataset_contains
import Split.KernelGovernance_Dataset
import Split.GovernanceInvariant_Block
import Split.TypedDMZ_FiberSchemaMap_schemaOf
import Split.And_left
import Split.TypedDMZ_Schema_hasField
import Split.Eq
import Split.TypedDMZ_FiberSchemaMap

-- TypedDMZ.dmz_no_cross_fiber from environment
-- theorem TypedDMZ.dmz_no_cross_fiber : forall (ds₁ : KernelGovernance.Dataset) (ds₂ : KernelGovernance.Dataset) (b : GovernanceInvariant.Block) (fieldName : String) (fsm : TypedDMZ.FiberSchemaMap), (TypedDMZ.FieldInDMZ ds₁ b fieldName fsm) -> (TypedDMZ.FieldInDMZ ds₂ b fieldName fsm) -> (Eq.{1} KernelGovernance.Dataset ds₁ ds₂)

-- Stub: this file represents the declaration `TypedDMZ.dmz_no_cross_fiber`.
-- In a full split, the body would be extracted from the environment.
