import Split.AddMonoid_toAddSemigroup
import Split.AddCommMonoidWithOne
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddMonoidWithOne_toAddMonoid
import Split.Eq
import Split.AddMonoidWithOne

-- AddCommMonoidWithOne.mk from environment
-- constructor AddCommMonoidWithOne.mk : forall {R : Type.{u_2}} [toAddMonoidWithOne : AddMonoidWithOne.{u_2} R], (forall (a : R) (b : R), Eq.{succ u_2} R (HAdd.hAdd.{u_2, u_2, u_2} R R R (instHAdd.{u_2} R (AddSemigroup.toAdd.{u_2} R (AddMonoid.toAddSemigroup.{u_2} R (AddMonoidWithOne.toAddMonoid.{u_2} R toAddMonoidWithOne)))) a b) (HAdd.hAdd.{u_2, u_2, u_2} R R R (instHAdd.{u_2} R (AddSemigroup.toAdd.{u_2} R (AddMonoid.toAddSemigroup.{u_2} R (AddMonoidWithOne.toAddMonoid.{u_2} R toAddMonoidWithOne)))) b a)) -> (AddCommMonoidWithOne.{u_2} R)

-- Stub: this file represents the declaration `AddCommMonoidWithOne.mk`.
-- In a full split, the body would be extracted from the environment.
