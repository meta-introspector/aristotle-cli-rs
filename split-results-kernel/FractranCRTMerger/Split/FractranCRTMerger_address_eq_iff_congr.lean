import Split.ZMod_commRing
import Split.FractranCRTMerger_addressOfState
import Split.congrArg
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.Prod_mk
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.Nat_cast
import Split.ZMod
import Split.Prod_fst
import Split.iff_self
import Split.And
import Split.Iff
import Split.Nat
import Split.True
import Split.of_eq_true
import Split.congrFun'
import Split.CommRing_toRing
import Split.Prod
import Split.OfNat_ofNat
import Split.Eq
import Split.Prod_snd
import Split.Ring_toAddGroupWithOne
import Split.Eq_trans

-- FractranCRTMerger.address_eq_iff_congr from environment
-- theorem FractranCRTMerger.address_eq_iff_congr : forall (a : Nat) (b : Nat), Iff (Eq.{1} (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Prod.{0, 0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))) (FractranCRTMerger.addressOfState a) (FractranCRTMerger.addressOfState b)) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))) a) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))) (ZMod.commRing (OfNat.ofNat.{0} Nat 47 (instOfNatNat 47))))))) b)) (And (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))) a) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))) (ZMod.commRing (OfNat.ofNat.{0} Nat 59 (instOfNatNat 59))))))) b)) (Eq.{1} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))))) a) (Nat.cast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddMonoidWithOne.toNatCast.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (Ring.toAddGroupWithOne.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (CommRing.toRing.{0} (ZMod (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))) (ZMod.commRing (OfNat.ofNat.{0} Nat 71 (instOfNatNat 71))))))) b))))

-- Stub: this file represents the declaration `FractranCRTMerger.address_eq_iff_congr`.
-- In a full split, the body would be extracted from the environment.
