import Split.AddMonoid_toAddSemigroup
import Split.AddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddMonoid
import Split.Eq

-- AddCommMonoid.mk from environment
-- constructor AddCommMonoid.mk : forall {M : Type.{u}} [toAddMonoid : AddMonoid.{u} M], (forall (a : M) (b : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M (AddMonoid.toAddSemigroup.{u} M toAddMonoid))) a b) (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M (AddMonoid.toAddSemigroup.{u} M toAddMonoid))) b a)) -> (AddCommMonoid.{u} M)

-- Stub: this file represents the declaration `AddCommMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
