import Split.AddCommMagma
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Eq
import Split.AddCommMagma_toAdd

-- AddCommMagma.add_comm from environment
-- theorem AddCommMagma.add_comm : forall {G : Type.{u}} [self : AddCommMagma.{u} G] (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddCommMagma.toAdd.{u} G self)) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G (AddCommMagma.toAdd.{u} G self)) b a)

-- Stub: this file represents the declaration `AddCommMagma.add_comm`.
-- In a full split, the body would be extracted from the environment.
