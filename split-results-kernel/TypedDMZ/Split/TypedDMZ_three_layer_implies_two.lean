import Split.TypedDMZ_FieldInDMZ
import Split.GovernanceInvariant_CID
import Split.KernelGovernance_TwoLayerAdmitted
import Split.String
import Split.KernelGovernance_Dataset
import Split.KernelGovernance_Principal
import Split.GovernanceInvariant_Block
import Split.KernelGovernance_CommitteeApproved
import Split.TypedDMZ_ThreeLayerAdmitted
import Split.And
import Split.And_right
import Split.And_left
import Split.And_intro
import Split.TypedDMZ_Capability
import Split.KernelGovernance_SenateApproved
import Split.KernelGovernance_ACLPolicy
import Split.TypedDMZ_DMZPolicy_allows
import Split.TypedDMZ_FiberSchemaMap
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.three_layer_implies_two from environment
-- theorem TypedDMZ.three_layer_implies_two : forall (ds : KernelGovernance.Dataset) (principal : KernelGovernance.Principal) (c : GovernanceInvariant.CID) (b : GovernanceInvariant.Block) (pol : KernelGovernance.ACLPolicy) (dmzPol : TypedDMZ.DMZPolicy) (fieldName : String) (cap : TypedDMZ.Capability) (fsm : TypedDMZ.FiberSchemaMap), (TypedDMZ.ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm) -> (KernelGovernance.TwoLayerAdmitted ds principal c b pol)

-- Stub: this file represents the declaration `TypedDMZ.three_layer_implies_two`.
-- In a full split, the body would be extracted from the environment.
