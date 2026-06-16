import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IntCast_intCast
import Split.AddMonoidWithOne_toNatCast
import Split.Int
import Split.AddGroupWithOne_toIntCast
import Split.Nat_cast
import Split.Nat
import Split.AddGroupWithOne
import Split.instNatCastInt
import Split.Eq

-- AddGroupWithOne.intCast_ofNat from environment
-- theorem AddGroupWithOne.intCast_ofNat : forall {R : Type.{u}} [self : AddGroupWithOne.{u} R] (n : Nat), Eq.{succ u} R (IntCast.intCast.{u} R (AddGroupWithOne.toIntCast.{u} R self) (Nat.cast.{0} Int instNatCastInt n)) (Nat.cast.{u} R (AddMonoidWithOne.toNatCast.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R self)) n)

-- Stub: this file represents the declaration `AddGroupWithOne.intCast_ofNat`.
-- In a full split, the body would be extracted from the environment.
