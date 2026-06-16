import Split.HMul_hMul
import Split.Mul
import Split.instHAdd
import Split.HAdd_hAdd
import Split.LeftDistribClass
import Split.Eq
import Split.Add
import Split.instHMul

-- LeftDistribClass.left_distrib from environment
-- theorem LeftDistribClass.left_distrib : forall {R : Type.{u_1}} {inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.7 : Mul.{u_1} R} {inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.10 : Add.{u_1} R} [self : LeftDistribClass.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.10] (a : R) (b : R) (c : R), Eq.{succ u_1} R (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.7) a (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.10) b c)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.10) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.7) a b) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.2994790824._hygCtx._hyg.7) a c))

-- Stub: this file represents the declaration `LeftDistribClass.left_distrib`.
-- In a full split, the body would be extracted from the environment.
