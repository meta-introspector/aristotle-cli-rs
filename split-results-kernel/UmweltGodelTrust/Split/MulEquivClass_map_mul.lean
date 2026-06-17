import Split.HMul_hMul
import Split.outParam
import Split.Mul
import Split.MulEquivClass
import Split.EquivLike
import Split.Eq
import Split.DFunLike_coe
import Split.EquivLike_toFunLike
import Split.instHMul

-- MulEquivClass.map_mul from environment
-- theorem MulEquivClass.map_mul : forall {F : Type.{u_9}} {A : outParam.{succ (succ u_10)} Type.{u_10}} {B : outParam.{succ (succ u_11)} Type.{u_11}} {inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.23 : Mul.{u_10} A} {inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.26 : Mul.{u_11} B} {inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.29 : EquivLike.{succ u_9, succ u_10, succ u_11} F A B} [self : MulEquivClass.{u_9, u_10, u_11} F A B inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.23 inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.26 inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.29] (f : F) (a : A) (b : A), Eq.{succ u_11} B (DFunLike.coe.{succ u_9, succ u_10, succ u_11} F A (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : A) => B) (EquivLike.toFunLike.{succ u_9, succ u_10, succ u_11} F A B inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.29) f (HMul.hMul.{u_10, u_10, u_10} A A A (instHMul.{u_10} A inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.23) a b)) (HMul.hMul.{u_11, u_11, u_11} B B B (instHMul.{u_11} B inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.26) (DFunLike.coe.{succ u_9, succ u_10, succ u_11} F A (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : A) => B) (EquivLike.toFunLike.{succ u_9, succ u_10, succ u_11} F A B inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.29) f a) (DFunLike.coe.{succ u_9, succ u_10, succ u_11} F A (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : A) => B) (EquivLike.toFunLike.{succ u_9, succ u_10, succ u_11} F A B inst._@.Mathlib.Algebra.Group.Equiv.Defs.4015965252._hygCtx._hyg.29) f b))

-- Stub: this file represents the declaration `MulEquivClass.map_mul`.
-- In a full split, the body would be extracted from the environment.
