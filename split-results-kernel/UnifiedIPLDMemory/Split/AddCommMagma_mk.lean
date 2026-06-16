import Split.AddCommMagma
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Eq
import Split.Add

-- AddCommMagma.mk from environment
-- constructor AddCommMagma.mk : forall {G : Type.{u}} [toAdd : Add.{u} G], (forall (a : G) (b : G), Eq.{succ u} G (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G toAdd) a b) (HAdd.hAdd.{u, u, u} G G G (instHAdd.{u} G toAdd) b a)) -> (AddCommMagma.{u} G)

-- Stub: this file represents the declaration `AddCommMagma.mk`.
-- In a full split, the body would be extracted from the environment.
