import Split.GovernanceInvariant_CID
import Split.ZMod_commRing
import Split.congrArg
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.GovernanceInvariant_Congruent
import Split.GovernanceInvariant_Block
import Split.Prod_mk
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.Nat_cast
import Split.ZMod
import Split.Prod_fst
import Split.GovernanceInvariant_CID_digest
import Split.iff_self
import Split.And
import Split.Iff
import Split.Nat
import Split.True
import Split.of_eq_true
import Split.congrFun'
import Split.GovernanceInvariant_Block_contentHash
import Split.CommRing_toRing
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.Prod_snd
import Split.Ring_toAddGroupWithOne
import Split.Eq_trans

-- GovernanceInvariant.congruent_iff from environment
-- theorem GovernanceInvariant.congruent_iff : forall (c : GovernanceInvariant.CID) (b : GovernanceInvariant.Block), Iff (GovernanceInvariant.Congruent c b) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))))) (GovernanceInvariant.CID.digest c)) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))))) (GovernanceInvariant.Block.contentHash b))) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))) (GovernanceInvariant.CID.digest c)) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))) (GovernanceInvariant.Block.contentHash b))) (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))) (GovernanceInvariant.CID.digest c)) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))) (GovernanceInvariant.Block.contentHash b)))))

-- Stub: this file represents the declaration `GovernanceInvariant.congruent_iff`.
-- In a full split, the body would be extracted from the environment.
