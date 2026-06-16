import Split.HMul_hMul
import Split.CommMagma_toMul
import Split.CommMagma
import Split.CommMagma_mul_comm
import Split.Eq
import Split.instHMul

-- mul_comm from environment
-- theorem mul_comm : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.544328808._hygCtx._hyg.3 : CommMagma.{u_1} G] (a : G) (b : G), Eq.{succ u_1} G (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (CommMagma.toMul.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.544328808._hygCtx._hyg.3)) a b) (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (CommMagma.toMul.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.544328808._hygCtx._hyg.3)) b a)

-- Stub: this file represents the declaration `mul_comm`.
-- In a full split, the body would be extracted from the environment.
