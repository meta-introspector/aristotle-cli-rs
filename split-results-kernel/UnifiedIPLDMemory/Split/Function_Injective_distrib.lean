import Split.HMul_hMul
import Split.Mul
import Split.Distrib_toAdd
import Split.instHAdd
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.LeftDistribClass
import Split.Distrib
import Split.Distrib_mk
import Split.Function_Injective
import Split.LeftDistribClass_left_distrib
import Split.RightDistribClass_right_distrib
import Split.Eq
import Split.Add
import Split.instHMul
import Split.RightDistribClass

-- Function.Injective.distrib from environment
-- def Function.Injective.distrib : forall {R : Type.{u_1}} {S : Type.{u_2}} (f : S -> R), (Function.Injective.{succ u_2, succ u_1} S R f) -> (forall [inst._@.Mathlib.Algebra.Ring.InjSurj.2070230163._hygCtx._hyg.9 : Add.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.2070230163._hygCtx._hyg.12 : Mul.{u_2} S] [inst._@.Mathlib.Algebra.Ring.InjSurj.2070230163._hygCtx._hyg.51 : Distrib.{u_1} R], (forall (x : S) (y : S), Eq.{succ u_1} R (f (HAdd.hAdd.{u_2, u_2, u_2} S S S (instHAdd.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.2070230163._hygCtx._hyg.9) x y)) (HAdd.hAdd.{u_1, u_1, u_1} R R R (instHAdd.{u_1} R (Distrib.toAdd.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.2070230163._hygCtx._hyg.51)) (f x) (f y))) -> (forall (x : S) (y : S), Eq.{succ u_1} R (f (HMul.hMul.{u_2, u_2, u_2} S S S (instHMul.{u_2} S inst._@.Mathlib.Algebra.Ring.InjSurj.2070230163._hygCtx._hyg.12) x y)) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R inst._@.Mathlib.Algebra.Ring.InjSurj.2070230163._hygCtx._hyg.51)) (f x) (f y))) -> (Distrib.{u_2} S))
-- (definition body omitted)

-- Stub: this file represents the declaration `Function.Injective.distrib`.
-- In a full split, the body would be extracted from the environment.
