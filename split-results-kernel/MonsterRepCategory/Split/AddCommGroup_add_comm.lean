import Split.AddMonoid_toAddSemigroup
import Split.AddCommGroup_toAddGroup
import Split.AddCommGroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq

-- AddCommGroup.add_comm from environment
-- theorem AddCommGroup.add_comm : forall {G : Type.{u}} [self : AddCommGroup.{u} G] (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (AddGroup.toSubNegMonoid.{u} G (AddCommGroup.toAddGroup.{u} G self)))))) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (AddGroup.toSubNegMonoid.{u} G (AddCommGroup.toAddGroup.{u} G self)))))) b a)

-- Stub: this file represents the declaration `AddCommGroup.add_comm`.
-- In a full split, the body would be extracted from the environment.
