import Split.HMul_hMul
import Split.Mul
import Split.instHAdd
import Split.HAdd_hAdd
import Split.RightDistribClass_right_distrib
import Split.Eq
import Split.Add
import Split.instHMul
import Split.RightDistribClass

-- right_distrib from environment
-- theorem right_distrib : forall {R : Type.{v}} [inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.4 : Mul.{v} R] [inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.7 : Add.{v} R] [inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.10 : RightDistribClass.{v} R inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.7] (a : R) (b : R) (c : R), Eq.{succ v} R (HMul.hMul.{v, v, v} R R R (instHMul.{v} R inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.4) (HAdd.hAdd.{v, v, v} R R R (instHAdd.{v} R inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.7) a b) c) (HAdd.hAdd.{v, v, v} R R R (instHAdd.{v} R inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.7) (HMul.hMul.{v, v, v} R R R (instHMul.{v} R inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.4) a c) (HMul.hMul.{v, v, v} R R R (instHMul.{v} R inst._@.Mathlib.Algebra.Ring.Defs.3376666137._hygCtx._hyg.4) b c))

-- Stub: this file represents the declaration `right_distrib`.
-- In a full split, the body would be extracted from the environment.
