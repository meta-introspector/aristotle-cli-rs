import Split.Nat_ModEq_eq_1
import Split.Eq_mpr
import Split.ZMod_commRing
import Split.congrArg
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.id
import Split.Nat_instMod
import Split.instHMod
import Split.AddMonoidWithOne_toNatCast
import Split.ZMod_natCast_eq_natCast_iff'
import Split.Nat_cast
import Split.ZMod
import Split.HMod_hMod
import Split.Nat_ModEq
import Split.Nat
import Split.propext
import Split.CommRing_toRing
import Split.Eq_symm
import Split.Eq
import Split.Ring_toAddGroupWithOne

-- FractranCRTMerger.zmod_eq_of_natCast from environment
-- theorem FractranCRTMerger.zmod_eq_of_natCast : forall {n : Nat} (a : Nat) (b : Nat), (Eq.{1} (ZMod n) (Nat.cast.{0} (ZMod n) (AddMonoidWithOne.toNatCast.{0} (ZMod n) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod n) (Ring.toAddGroupWithOne.{0} (ZMod n) (CommRing.toRing.{0} (ZMod n) (ZMod.commRing n))))) a) (Nat.cast.{0} (ZMod n) (AddMonoidWithOne.toNatCast.{0} (ZMod n) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod n) (Ring.toAddGroupWithOne.{0} (ZMod n) (CommRing.toRing.{0} (ZMod n) (ZMod.commRing n))))) b)) -> (Nat.ModEq n a b)

-- Stub: this file represents the declaration `FractranCRTMerger.zmod_eq_of_natCast`.
-- In a full split, the body would be extracted from the environment.
