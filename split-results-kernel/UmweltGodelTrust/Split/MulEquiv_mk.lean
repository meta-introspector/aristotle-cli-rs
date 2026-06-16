import Split.HMul_hMul
import Split.Mul
import Split.Equiv
import Split.Equiv_toFun
import Split.MulEquiv
import Split.Eq
import Split.instHMul

-- MulEquiv.mk from environment
-- constructor MulEquiv.mk : forall {M : Type.{u_9}} {N : Type.{u_10}} [inst._@.Mathlib.Algebra.Group.Equiv.Defs.3650376682._hygCtx._hyg.20 : Mul.{u_9} M] [inst._@.Mathlib.Algebra.Group.Equiv.Defs.3650376682._hygCtx._hyg.23 : Mul.{u_10} N] (toEquiv : Equiv.{succ u_9, succ u_10} M N), (forall (x : M) (y : M), Eq.{succ u_10} N (Equiv.toFun.{succ u_9, succ u_10} M N toEquiv (HMul.hMul.{u_9, u_9, u_9} M M M (instHMul.{u_9} M inst._@.Mathlib.Algebra.Group.Equiv.Defs.3650376682._hygCtx._hyg.20) x y)) (HMul.hMul.{u_10, u_10, u_10} N N N (instHMul.{u_10} N inst._@.Mathlib.Algebra.Group.Equiv.Defs.3650376682._hygCtx._hyg.23) (Equiv.toFun.{succ u_9, succ u_10} M N toEquiv x) (Equiv.toFun.{succ u_9, succ u_10} M N toEquiv y))) -> (MulEquiv.{u_9, u_10} M N inst._@.Mathlib.Algebra.Group.Equiv.Defs.3650376682._hygCtx._hyg.20 inst._@.Mathlib.Algebra.Group.Equiv.Defs.3650376682._hygCtx._hyg.23)

-- Stub: this file represents the declaration `MulEquiv.mk`.
-- In a full split, the body would be extracted from the environment.
