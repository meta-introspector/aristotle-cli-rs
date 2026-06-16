import Split.MulOne_toOne
import Split.HMul_hMul
import Split.ZeroHom_toFun
import Split.MulOne_toMul
import Split.MulZeroOneClass
import Split.ZeroHom
import Split.MulZeroOneClass_toMulOneClass
import Split.MulOneClass_toMulOne
import Split.MonoidWithZeroHom
import Split.One_toOfNat1
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- MonoidWithZeroHom.mk from environment
-- constructor MonoidWithZeroHom.mk : forall {α : Type.{u_7}} {β : Type.{u_8}} [inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40 : MulZeroOneClass.{u_7} α] [inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43 : MulZeroOneClass.{u_8} β] (toZeroHom : ZeroHom.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43))), (Eq.{succ u_8} β (ZeroHom.toFun.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)) toZeroHom (OfNat.ofNat.{u_7} α 1 (One.toOfNat1.{u_7} α (MulOne.toOne.{u_7} α (MulOneClass.toMulOne.{u_7} α (MulZeroOneClass.toMulOneClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)))))) (OfNat.ofNat.{u_8} β 1 (One.toOfNat1.{u_8} β (MulOne.toOne.{u_8} β (MulOneClass.toMulOne.{u_8} β (MulZeroOneClass.toMulOneClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)))))) -> (forall (x : α) (y : α), Eq.{succ u_8} β (ZeroHom.toFun.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)) toZeroHom (HMul.hMul.{u_7, u_7, u_7} α α α (instHMul.{u_7} α (MulOne.toMul.{u_7} α (MulOneClass.toMulOne.{u_7} α (MulZeroOneClass.toMulOneClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)))) x y)) (HMul.hMul.{u_8, u_8, u_8} β β β (instHMul.{u_8} β (MulOne.toMul.{u_8} β (MulOneClass.toMulOne.{u_8} β (MulZeroOneClass.toMulOneClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)))) (ZeroHom.toFun.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)) toZeroHom x) (ZeroHom.toFun.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)) toZeroHom y))) -> (MonoidWithZeroHom.{u_7, u_8} α β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40 inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)

-- Stub: this file represents the declaration `MonoidWithZeroHom.mk`.
-- In a full split, the body would be extracted from the environment.
