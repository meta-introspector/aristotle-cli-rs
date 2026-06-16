import Split.Eq_mpr
import Split.MulOne_toOne
import Split.instHSMul
import Split.instSMulOfMul
import Split.HMul_hMul
import Split.congrArg
import Split.IsScalarTower
import Split.SMul
import Split.id
import Split.MulOne_toMul
import Split.smul_mul_assoc
import Split.MulOneClass_toMulOne
import Split.One_toOfNat1
import Split.Eq_refl
import Split.HSMul_hSMul
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.one_mul
import Split.instHMul

-- smul_one_mul from environment
-- theorem smul_one_mul : forall {M : Type.{u_9}} {N : Type.{u_10}} [inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.12 : MulOneClass.{u_10} N] [inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.15 : SMul.{u_9, u_10} M N] [inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.19 : IsScalarTower.{u_9, u_10, u_10} M N N inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.15 (instSMulOfMul.{u_10} N (MulOne.toMul.{u_10} N (MulOneClass.toMulOne.{u_10} N inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.12))) inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.15] (x : M) (y : N), Eq.{succ u_10} N (HMul.hMul.{u_10, u_10, u_10} N N N (instHMul.{u_10} N (MulOne.toMul.{u_10} N (MulOneClass.toMulOne.{u_10} N inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.12))) (HSMul.hSMul.{u_9, u_10, u_10} M N N (instHSMul.{u_9, u_10} M N inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.15) x (OfNat.ofNat.{u_10} N 1 (One.toOfNat1.{u_10} N (MulOne.toOne.{u_10} N (MulOneClass.toMulOne.{u_10} N inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.12))))) y) (HSMul.hSMul.{u_9, u_10, u_10} M N N (instHSMul.{u_9, u_10} M N inst._@.Mathlib.Algebra.Group.Action.Defs.3239016326._hygCtx._hyg.15) x y)

-- Stub: this file represents the declaration `smul_one_mul`.
-- In a full split, the body would be extracted from the environment.
