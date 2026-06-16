import Split.AddSemigroup
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Eq
import Split.Add

-- AddSemigroup.mk from environment
-- constructor AddSemigroup.mk : forall {G : Type.{u}} [toAdd : Add.{u} G], (forall (a : G) (b : G) (c : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G toAdd) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G toAdd) a b) c) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G toAdd) a (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G toAdd) b c))) -> (AddSemigroup.{u} G)

-- Stub: this file represents the declaration `AddSemigroup.mk`.
-- In a full split, the body would be extracted from the environment.
