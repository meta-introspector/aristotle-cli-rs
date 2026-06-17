import Split.Int_cast
import Split.ZMod_commRing
import Split.Int
import Split.AddGroupWithOne_toIntCast
import Split.Nat_cast
import Split.ZMod
import Split.CharP_intCast_eq_intCast
import Split.Iff
import Split.ZMod_charP
import Split.Nat
import Split.Int_ModEq
import Split.instNatCastInt
import Split.CommRing_toRing
import Split.Eq
import Split.Ring_toAddGroupWithOne

-- ZMod.intCast_eq_intCast_iff from environment
-- theorem ZMod.intCast_eq_intCast_iff : forall (a : Int) (b : Int) (c : Nat), Iff (Eq.{1} (ZMod c) (Int.cast.{0} (ZMod c) (AddGroupWithOne.toIntCast.{0} (ZMod c) (Ring.toAddGroupWithOne.{0} (ZMod c) (CommRing.toRing.{0} (ZMod c) (ZMod.commRing c)))) a) (Int.cast.{0} (ZMod c) (AddGroupWithOne.toIntCast.{0} (ZMod c) (Ring.toAddGroupWithOne.{0} (ZMod c) (CommRing.toRing.{0} (ZMod c) (ZMod.commRing c)))) b)) (Int.ModEq (Nat.cast.{0} Int instNatCastInt c) a b)

-- Stub: this file represents the declaration `ZMod.intCast_eq_intCast_iff`.
-- In a full split, the body would be extracted from the environment.
