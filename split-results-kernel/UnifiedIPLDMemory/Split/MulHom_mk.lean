import Split.MulHom
import Split.HMul_hMul
import Split.Mul
import Split.Eq
import Split.instHMul

-- MulHom.mk from environment
-- constructor MulHom.mk : forall {M : Type.{u_10}} {N : Type.{u_11}} [inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34 : Mul.{u_10} M] [inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37 : Mul.{u_11} N] (toFun : M -> N), (forall (x : M) (y : M), Eq.{succ u_11} N (toFun (HMul.hMul.{u_10, u_10, u_10} M M M (instHMul.{u_10} M inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34) x y)) (HMul.hMul.{u_11, u_11, u_11} N N N (instHMul.{u_11} N inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37) (toFun x) (toFun y))) -> (MulHom.{u_10, u_11} M N inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34 inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37)

-- Stub: this file represents the declaration `MulHom.mk`.
-- In a full split, the body would be extracted from the environment.
