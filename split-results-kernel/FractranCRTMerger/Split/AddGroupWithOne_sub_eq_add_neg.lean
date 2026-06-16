import Split.AddMonoid_toAddSemigroup
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.HSub_hSub
import Split.AddGroupWithOne_toNeg
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.AddGroupWithOne
import Split.AddGroupWithOne_toSub
import Split.AddMonoidWithOne_toAddMonoid
import Split.Eq
import Split.Neg_neg

-- AddGroupWithOne.sub_eq_add_neg from environment
-- theorem AddGroupWithOne.sub_eq_add_neg : forall {R : Type.{u}} [self : AddGroupWithOne.{u} R] (a : R) (b : R), Eq.{succ u} R (HSub.hSub.{u, u, u} R R R (instHSub.{u} R (AddGroupWithOne.toSub.{u} R self)) a b) (HAdd.hAdd.{u, u, u} R R R (instHAdd.{u} R (AddSemigroup.toAdd.{u} R (AddMonoid.toAddSemigroup.{u} R (AddMonoidWithOne.toAddMonoid.{u} R (AddGroupWithOne.toAddMonoidWithOne.{u} R self))))) a (Neg.neg.{u} R (AddGroupWithOne.toNeg.{u} R self) b))

-- Stub: this file represents the declaration `AddGroupWithOne.sub_eq_add_neg`.
-- In a full split, the body would be extracted from the environment.
