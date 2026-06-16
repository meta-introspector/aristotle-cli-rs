import Split.AddCommSemigroup_toAddSemigroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddCommSemigroup
import Split.Eq

-- AddCommSemigroup.add_comm from environment
-- theorem AddCommSemigroup.add_comm : forall {G : Type.{u}} [self : AddCommSemigroup.{u} G] (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddCommSemigroup.toAddSemigroup.{u} G self))) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G (AddCommSemigroup.toAddSemigroup.{u} G self))) b a)

-- Stub: this file represents the declaration `AddCommSemigroup.add_comm`.
-- In a full split, the body would be extracted from the environment.
