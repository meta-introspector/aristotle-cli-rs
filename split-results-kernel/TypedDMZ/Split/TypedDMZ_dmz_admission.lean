import Split.TypedDMZ_FieldInDMZ
import Split.GovernanceInvariant_CID
import Split.GovernanceInvariant_blockToBase
import Split.String
import Split.GovernanceInvariant_Base
import Split.KernelGovernance_Dataset_contains
import Split.KernelGovernance_Dataset
import Split.GovernanceInvariant_Congruent
import Split.GovernanceInvariant_Block
import Split.KernelGovernance_CommitteeApproved
import Split.TypedDMZ_FiberSchemaMap_schemaOf
import Split.KernelGovernance_Dataset_fiber
import Split.And_right
import Split.And_intro
import Split.TypedDMZ_Schema_hasField
import Split.Eq
import Split.TypedDMZ_FiberSchemaMap

-- TypedDMZ.dmz_admission from environment
-- theorem TypedDMZ.dmz_admission : forall (ds : KernelGovernance.Dataset) (c : GovernanceInvariant.CID) (b : GovernanceInvariant.Block) (fsm : TypedDMZ.FiberSchemaMap), (KernelGovernance.CommitteeApproved ds c b) -> (forall (fieldName : String), (TypedDMZ.Schema.hasField (TypedDMZ.FiberSchemaMap.schemaOf fsm ds) fieldName) -> (TypedDMZ.FieldInDMZ ds b fieldName fsm))

-- Stub: this file represents the declaration `TypedDMZ.dmz_admission`.
-- In a full split, the body would be extracted from the environment.
