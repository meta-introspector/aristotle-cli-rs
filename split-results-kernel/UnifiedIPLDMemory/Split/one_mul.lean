import Split.MulOne_toOne
import Split.HMul_hMul
import Split.MulOneClass_one_mul
import Split.MulOne_toMul
import Split.MulOneClass_toMulOne
import Split.One_toOfNat1
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- one_mul from environment
-- theorem one_mul : forall {M : Type.{u}} [inst._@.Mathlib.Algebra.Group.Defs.1021016586._hygCtx._hyg.4 : MulOneClass.{u} M] (a : M), Eq.{succ u} M (HMul.hMul.{u, u, u} M M M (instHMul.{u} M (MulOne.toMul.{u} M (MulOneClass.toMulOne.{u} M inst._@.Mathlib.Algebra.Group.Defs.1021016586._hygCtx._hyg.4))) (OfNat.ofNat.{u} M 1 (One.toOfNat1.{u} M (MulOne.toOne.{u} M (MulOneClass.toMulOne.{u} M inst._@.Mathlib.Algebra.Group.Defs.1021016586._hygCtx._hyg.4)))) a) a

-- Stub: this file represents the declaration `one_mul`.
-- In a full split, the body would be extracted from the environment.
