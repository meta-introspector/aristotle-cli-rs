import Split.GovernanceInvariant_CID
import Split.ZMod_commRing
import Split.KernelGovernance_two_layer_implies_congruent
import Split.GovernanceInvariant_base_card
import Split.KernelGovernance_TwoLayerAdmitted
import Split.String
import Split.GovernanceInvariant_Base
import Split.ZMod_fintype
import Split.KernelGovernance_Dataset_contains
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.KernelGovernance_Dataset
import Split.TypedDMZ_three_layer_implies_two
import Split.GovernanceInvariant_Congruent
import Split.KernelGovernance_Principal
import Split.GovernanceInvariant_Block
import Split.Fintype_card
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.KernelGovernance_CommitteeApproved
import Split.TypedDMZ_ThreeLayerAdmitted
import Split.Nat_cast
import Split.ZMod
import Split.GovernanceInvariant_CID_digest
import Split.And
import Split.TypedDMZ_committee_veto_absolute
import Split.Iff
import Split.GovernanceInvariant_congruent_iff
import Split.Nat_instNeZeroSucc
import Split.ExistsUnique
import Split.Nat
import Split.And_intro
import Split.TypedDMZ_Capability
import Split.instFintypeProd
import Split.GovernanceInvariant_Block_contentHash
import Split.KernelGovernance_block_unique_dataset
import Split.CommRing_toRing
import Split.Prod
import Split.OfNat_ofNat
import Split.KernelGovernance_ACLPolicy
import Split.Eq
import Split.Ring_toAddGroupWithOne
import Split.Not
import Split.TypedDMZ_FiberSchemaMap
import Split.TypedDMZ_DMZPolicy

-- TypedDMZ.complete_governance from environment
-- theorem TypedDMZ.complete_governance : forall (ds : KernelGovernance.Dataset) (principal : KernelGovernance.Principal) (c : GovernanceInvariant.CID) (b : GovernanceInvariant.Block) (pol : KernelGovernance.ACLPolicy) (dmzPol : TypedDMZ.DMZPolicy) (fieldName : String) (cap : TypedDMZ.Capability) (fsm : TypedDMZ.FiberSchemaMap), And (Eq.{1} Nat (Fintype.card.{0} GovernanceInvariant.Base (instFintypeProd.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)))) (ZMod.fintype (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 70 (instOfNatNat 70)))) (instFintypeProd.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.fintype (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 58 (instOfNatNat 58)))) (ZMod.fintype (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 46 (instOfNatNat 46))))))) (OfNat.ofNat.{0} Nat 196883 (instOfNatNat 196883))) (And (ExistsUnique.{1} KernelGovernance.Dataset (fun (ds' : KernelGovernance.Dataset) => KernelGovernance.Dataset.contains ds' b)) (And ((Not (KernelGovernance.CommitteeApproved ds c b)) -> (Not (TypedDMZ.ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm))) (And ((TypedDMZ.ThreeLayerAdmitted ds principal c b pol dmzPol fieldName cap fsm) -> (KernelGovernance.TwoLayerAdmitted ds principal c b pol)) (And ((KernelGovernance.TwoLayerAdmitted ds principal c b pol) -> (GovernanceInvariant.Congruent c b)) (Iff (GovernanceInvariant.Congruent c b) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))))) (GovernanceInvariant.CID.digest c)) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))))) (GovernanceInvariant.Block.contentHash b))) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))) (GovernanceInvariant.CID.digest c)) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))) (GovernanceInvariant.Block.contentHash b))) (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))) (GovernanceInvariant.CID.digest c)) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))) (GovernanceInvariant.Block.contentHash b))))))))))

-- Stub: this file represents the declaration `TypedDMZ.complete_governance`.
-- In a full split, the body would be extracted from the environment.
