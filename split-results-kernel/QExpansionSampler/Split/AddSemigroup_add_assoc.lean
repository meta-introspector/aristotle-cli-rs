import Split.AddSemigroup
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.HAdd_hAdd
import Split.Eq

-- AddSemigroup.add_assoc from environment
-- theorem AddSemigroup.add_assoc : forall {G : Type.{u}} [self : AddSemigroup.{u} G] (a : G) (b : G) (c : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G self)) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G self)) a b) c) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G self)) a (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddSemigroup.toAdd.{u} G self)) b c))

-- Stub: this file represents the declaration `AddSemigroup.add_assoc`.
-- In a full split, the body would be extracted from the environment.
