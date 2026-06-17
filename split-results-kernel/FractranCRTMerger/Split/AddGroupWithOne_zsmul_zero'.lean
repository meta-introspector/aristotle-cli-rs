import Split.AddGroupWithOne_zsmul
import Split.AddMonoid_toZero
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.Int
import Split.instOfNat
import Split.Zero_toOfNat0
import Split.AddGroupWithOne
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq

-- AddGroupWithOne.zsmul_zero' from environment
-- theorem AddGroupWithOne.zsmul_zero' : forall {R : Type.{u}} [self : AddGroupWithOne.{u} R] (a : R), Eq.{succ u} R (AddGroupWithOne.zsmul.{u} R self (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddMonoidWithOne.toAddMonoid.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R self)))))

-- Stub: this file represents the declaration `AddGroupWithOne.zsmul_zero'`.
-- In a full split, the body would be extracted from the environment.
