import Split.HMul_hMul
import Split.Mul
import Split.instHAdd
import Split.HAdd_hAdd
import Split.LeftDistribClass
import Split.LeftDistribClass_left_distrib
import Split.Eq
import Split.Add
import Split.instHMul

-- left_distrib from environment
-- theorem left_distrib : forall {R : Type.{v}} [inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.4 : Mul.{v} R] [inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.7 : Add.{v} R] [inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.10 : LeftDistribClass.{v} R inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.7] (a : R) (b : R) (c : R), Eq.{succ v} R (HMul.hMul.{v, v, v} R R R (instHMul.{v} R inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.4) a (HAdd.hAdd.{v, v, v} R R R (instHAdd.{v} R inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.7) b c)) (HAdd.hAdd.{v, v, v} R R R (instHAdd.{v} R inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.7) (HMul.hMul.{v, v, v} R R R (instHMul.{v} R inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.4) a b) (HMul.hMul.{v, v, v} R R R (instHMul.{v} R inst._@.Mathlib.Algebra.Ring.Defs.4099273676._hygCtx._hyg.4) a c))

-- Stub: this file represents the declaration `left_distrib`.
-- In a full split, the body would be extracted from the environment.
