import Split.AddCommMagma
import Split.AddCommMagma_add_comm
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Eq
import Split.AddCommMagma_toAdd

-- add_comm from environment
-- theorem add_comm : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.544328808._hygCtx._hyg.3 : AddCommMagma.{u_1} G] (a : G) (b : G), Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddCommMagma.toAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.544328808._hygCtx._hyg.3)) a b) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddCommMagma.toAdd.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.544328808._hygCtx._hyg.3)) b a)

-- Stub: this file represents the declaration `add_comm`.
-- In a full split, the body would be extracted from the environment.
