import Split.HMul_hMul
import Split.Mul
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Eq
import Split.Add
import Split.instHMul
import Split.RightDistribClass

-- RightDistribClass.right_distrib from environment
-- theorem RightDistribClass.right_distrib : forall {R : Type.{u_1}} {inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.7 : Mul.{u_1} R} {inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.10 : Add.{u_1} R} [self : RightDistribClass.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.10] (a : R) (b : R) (c : R), Eq.{succ u_1} R (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.7) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.10) a b) c) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.10) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.7) a c) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R inst._@.Mathlib.Algebra.Ring.Defs.690769108._hygCtx._hyg.7) b c))

-- Stub: this file represents the declaration `RightDistribClass.right_distrib`.
-- In a full split, the body would be extracted from the environment.
