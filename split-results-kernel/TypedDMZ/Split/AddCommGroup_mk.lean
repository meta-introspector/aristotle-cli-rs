import Split.AddMonoid_toAddSemigroup
import Split.AddCommGroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq

-- AddCommGroup.mk from environment
-- constructor AddCommGroup.mk : forall {G : Type.{u}} [toAddGroup : AddGroup.{u} G], (forall (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (AddGroup.toSubNegMonoid.{u} G toAddGroup))))) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddMonoid.toAddSemigroup.{u} G (SubNegMonoid.toAddMonoid.{u} G (AddGroup.toSubNegMonoid.{u} G toAddGroup))))) b a)) -> (AddCommGroup.{u} G)

-- Stub: this file represents the declaration `AddCommGroup.mk`.
-- In a full split, the body would be extracted from the environment.
