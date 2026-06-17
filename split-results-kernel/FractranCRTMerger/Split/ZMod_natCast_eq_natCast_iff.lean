import Split.Int_cast
import Split.Int_cast_natCast
import Split.ZMod_commRing
import Split.congrArg
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.Eq_mp
import Split.AddMonoidWithOne_toNatCast
import Split.Int
import Split.AddGroupWithOne_toIntCast
import Split.Nat_cast
import Split.ZMod
import Split.ZMod_intCast_eq_intCast_iff
import Split.Iff
import Split.Nat_ModEq
import Split.Nat
import Split.Int_ModEq
import Split.congr
import Split.instNatCastInt
import Split.CommRing_toRing
import Split.Eq
import Split.Ring_toAddGroupWithOne

-- ZMod.natCast_eq_natCast_iff from environment
-- theorem ZMod.natCast_eq_natCast_iff : forall (a : Nat) (b : Nat) (c : Nat), Iff (Eq.{1} (ZMod c) (Nat.cast.{0} (ZMod c) (AddMonoidWithOne.toNatCast.{0} (ZMod c) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod c) (Ring.toAddGroupWithOne.{0} (ZMod c) (CommRing.toRing.{0} (ZMod c) (ZMod.commRing c))))) a) (Nat.cast.{0} (ZMod c) (AddMonoidWithOne.toNatCast.{0} (ZMod c) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod c) (Ring.toAddGroupWithOne.{0} (ZMod c) (CommRing.toRing.{0} (ZMod c) (ZMod.commRing c))))) b)) (Nat.ModEq c a b)

-- Stub: this file represents the declaration `ZMod.natCast_eq_natCast_iff`.
-- In a full split, the body would be extracted from the environment.
