import Split.MulHom
import Split.HMul_hMul
import Split.Mul
import Split.MulHom_toFun
import Split.Eq
import Split.instHMul

-- MulHom.map_mul' from environment
-- theorem MulHom.map_mul' : forall {M : Type.{u_10}} {N : Type.{u_11}} [inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34 : Mul.{u_10} M] [inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37 : Mul.{u_11} N] (self : MulHom.{u_10, u_11} M N inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34 inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37) (x : M) (y : M), Eq.{succ u_11} N (MulHom.toFun.{u_10, u_11} M N inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34 inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37 self (HMul.hMul.{u_10, u_10, u_10} M M M (instHMul.{u_10} M inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34) x y)) (HMul.hMul.{u_11, u_11, u_11} N N N (instHMul.{u_11} N inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37) (MulHom.toFun.{u_10, u_11} M N inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34 inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37 self x) (MulHom.toFun.{u_10, u_11} M N inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.34 inst._@.Mathlib.Algebra.Group.Hom.Defs.1789691856._hygCtx._hyg.37 self y))

-- Stub: this file represents the declaration `MulHom.map_mul'`.
-- In a full split, the body would be extracted from the environment.
