import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toZero
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.AddGroupWithOne_toNeg
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Zero_toOfNat0
import Split.AddGroupWithOne
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- AddGroupWithOne.neg_add_cancel from environment
-- theorem AddGroupWithOne.neg_add_cancel : forall {R : Type.{u}} [self : AddGroupWithOne.{u} R] (a : R), Eq.{succ u} R (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddMonoidWithOne.toAddMonoid.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R self))))) (Neg.neg.{u} R (AddGroupWithOne.toNeg.{u} R self) a) a) (OfNat.ofNat.{u} R 0 (Zero.toOfNat0.{u} R (AddMonoid.toZero.{u} R (AddMonoidWithOne.toAddMonoid.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R self)))))

-- Stub: this file represents the declaration `AddGroupWithOne.neg_add_cancel`.
-- In a full split, the body would be extracted from the environment.
