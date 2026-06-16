import Split.AddSemigroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.AddCommSemigroup
import Split.Eq

-- AddCommSemigroup.mk from environment
-- constructor AddCommSemigroup.mk : forall {G : Type.{u}} [toAddSemigroup : AddSemigroup.{u} G], (forall (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G toAddSemigroup)) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G toAddSemigroup)) b a)) -> (AddCommSemigroup.{u} G)

-- Stub: this file represents the declaration `AddCommSemigroup.mk`.
-- In a full split, the body would be extracted from the environment.
