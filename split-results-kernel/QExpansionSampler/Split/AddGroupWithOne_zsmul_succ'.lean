import Split.AddMonoid_toAddSemigroup
import Split.AddGroupWithOne_zsmul
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.Int
import Split.Nat_cast
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.AddGroupWithOne
import Split.instNatCastInt
import Split.AddMonoidWithOne_toAddMonoid
import Split.Nat_succ
import Split.Eq

-- AddGroupWithOne.zsmul_succ' from environment
-- theorem AddGroupWithOne.zsmul_succ' : forall {R : Type.{u}} [self : AddGroupWithOne.{u} R] (n : Nat) (a : R), Eq.{succ u} R (AddGroupWithOne.zsmul.{u} R self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddMonoidWithOne.toAddMonoid.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R self))))) (AddGroupWithOne.zsmul.{u} R self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `AddGroupWithOne.zsmul_succ'`.
-- In a full split, the body would be extracted from the environment.
