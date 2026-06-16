import Split.AddMonoid_toAddSemigroup
import Split.AddCommMonoid
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddCommMonoid_toAddMonoid
import Split.Eq

-- AddCommMonoid.add_comm from environment
-- theorem AddCommMonoid.add_comm : forall {M : Type.{u}} [self : AddCommMonoid.{u} M] (a : M) (b : M), Eq.{succ u} M (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M (AddMonoid.toAddSemigroup.{u} M (AddCommMonoid.toAddMonoid.{u} M self)))) a b) (HAdd.hAdd.{u, u, u} M M M (instHAdd.{u} M (AddSemigroup.toAdd.{u} M (AddMonoid.toAddSemigroup.{u} M (AddCommMonoid.toAddMonoid.{u} M self)))) b a)

-- Stub: this file represents the declaration `AddCommMonoid.add_comm`.
-- In a full split, the body would be extracted from the environment.
