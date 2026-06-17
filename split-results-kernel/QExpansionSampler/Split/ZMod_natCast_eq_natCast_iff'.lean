import Split.ZMod_commRing
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.Nat_instMod
import Split.instHMod
import Split.AddMonoidWithOne_toNatCast
import Split.Nat_cast
import Split.ZMod
import Split.HMod_hMod
import Split.Iff
import Split.Nat
import Split.ZMod_natCast_eq_natCast_iff
import Split.CommRing_toRing
import Split.Eq
import Split.Ring_toAddGroupWithOne

-- ZMod.natCast_eq_natCast_iff' from environment
-- theorem ZMod.natCast_eq_natCast_iff' : forall (a : Nat) (b : Nat) (c : Nat), Iff (Eq.{1} (ZMod c) (Nat.cast.{0} (ZMod c) (AddMonoidWithOne.toNatCast.{0} (ZMod c) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod c) (Ring.toAddGroupWithOne.{0} (ZMod c) (CommRing.toRing.{0} (ZMod c) (ZMod.commRing c))))) a) (Nat.cast.{0} (ZMod c) (AddMonoidWithOne.toNatCast.{0} (ZMod c) (AddGroupWithOne.toAddMonoidWithOne.{0} (ZMod c) (Ring.toAddGroupWithOne.{0} (ZMod c) (CommRing.toRing.{0} (ZMod c) (ZMod.commRing c))))) b)) (Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) a c) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) b c))

-- Stub: this file represents the declaration `ZMod.natCast_eq_natCast_iff'`.
-- In a full split, the body would be extracted from the environment.
