import Split.HMul_hMul
import Split.outParam
import Split.Mul
import Split.MulHomClass
import Split.Eq
import Split.DFunLike_coe
import Split.FunLike
import Split.instHMul

-- MulHomClass.map_mul from environment
-- theorem MulHomClass.map_mul : forall {F : Type.{u_10}} {M : outParam.{succ (succ u_11)} Type.{u_11}} {N : outParam.{succ (succ u_12)} Type.{u_12}} {inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.37 : Mul.{u_11} M} {inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.40 : Mul.{u_12} N} {inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.43 : FunLike.{succ u_10, succ u_11, succ u_12} F M N} [self : MulHomClass.{u_10, u_11, u_12} F M N inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.37 inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.40 inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.43] (f : F) (x : M) (y : M), Eq.{succ u_12} N (DFunLike.coe.{succ u_10, succ u_11, succ u_12} F M (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : M) => N) inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.43 f (HMul.hMul.{u_11, u_11, u_11} M M M (instHMul.{u_11} M inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.37) x y)) (HMul.hMul.{u_12, u_12, u_12} N N N (instHMul.{u_12} N inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.40) (DFunLike.coe.{succ u_10, succ u_11, succ u_12} F M (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : M) => N) inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.43 f x) (DFunLike.coe.{succ u_10, succ u_11, succ u_12} F M (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : M) => N) inst._@.Mathlib.Algebra.Group.Hom.Defs.2517103329._hygCtx._hyg.43 f y))

-- Stub: this file represents the declaration `MulHomClass.map_mul`.
-- In a full split, the body would be extracted from the environment.
