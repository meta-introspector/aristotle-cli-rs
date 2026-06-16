import Split.HMul_hMul
import Split.Mul
import Split.MulHomClass_map_mul
import Split.MulHomClass
import Split.Eq
import Split.DFunLike_coe
import Split.FunLike
import Split.instHMul

-- map_mul from environment
-- theorem map_mul : forall {M : Type.{u_4}} {N : Type.{u_5}} {F : Type.{u_9}} [inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.11 : Mul.{u_4} M] [inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.14 : Mul.{u_5} N] [inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.17 : FunLike.{succ u_9, succ u_4, succ u_5} F M N] [inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.22 : MulHomClass.{u_9, u_4, u_5} F M N inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.14 inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.17] (f : F) (x : M) (y : M), Eq.{succ u_5} N (DFunLike.coe.{succ u_9, succ u_4, succ u_5} F M (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : M) => N) inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.17 f (HMul.hMul.{u_4, u_4, u_4} M M M (instHMul.{u_4} M inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.11) x y)) (HMul.hMul.{u_5, u_5, u_5} N N N (instHMul.{u_5} N inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.14) (DFunLike.coe.{succ u_9, succ u_4, succ u_5} F M (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : M) => N) inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.17 f x) (DFunLike.coe.{succ u_9, succ u_4, succ u_5} F M (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : M) => N) inst._@.Mathlib.Algebra.Group.Hom.Defs.2143170598._hygCtx._hyg.17 f y))

-- Stub: this file represents the declaration `map_mul`.
-- In a full split, the body would be extracted from the environment.
