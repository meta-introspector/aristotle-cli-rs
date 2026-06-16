import Split.TypedDMZ_FieldInDMZ
import Split.GovernanceInvariant_CID
import Split.String
import Split.KernelGovernance_Dataset
import Split.KernelGovernance_Principal
import Split.GovernanceInvariant_Block
import Split.KernelGovernance_CommitteeApproved
import Split.TypedDMZ_ThreeLayerAdmitted
import Split.And
import Split.And_left
import Split.TypedDMZ_Capability
import Split.KernelGovernance_SenateApproved
import Split.KernelGovernance_ACLPolicy
import Split.Not
import Split.TypedDMZ_DMZPolicy_allows
import Split.TypedDMZ_FiberSchemaMap
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.committee_veto_absolute from environment
-- theorem TypedDMZ.committee_veto_absolute : forall (ds : KernelGovernance.Dataset) (principal : KernelGovernance.Principal) (c : GovernanceInvariant.CID) (b : GovernanceInvariant.Block) (pol : KernelGovernance.ACLPolicy) (dmzPol : TypedDMZ.DMZPolicy) (fieldName : String) (cap : TypedDMZ.Capability) (fsm : TypedDMZ.FiberSchemaMap), (Not (KernelGovernance.CommitteeApproved ds c b)) -> (Not (TypedDMZ.ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm))

-- Stub: this file represents the declaration `TypedDMZ.committee_veto_absolute`.
-- In a full split, the body would be extracted from the environment.
