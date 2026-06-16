import Split.HMul_hMul
import Split.ZeroHom_toFun
import Split.MonoidWithZeroHom_toZeroHom
import Split.MulOne_toMul
import Split.MulZeroOneClass
import Split.MulZeroOneClass_toMulOneClass
import Split.MulOneClass_toMulOne
import Split.MonoidWithZeroHom
import Split.MulZeroOneClass_toMulZeroClass
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- MonoidWithZeroHom.map_mul' from environment
-- theorem MonoidWithZeroHom.map_mul' : forall {α : Type.{u_7}} {β : Type.{u_8}} [inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40 : MulZeroOneClass.{u_7} α] [inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43 : MulZeroOneClass.{u_8} β] (self : MonoidWithZeroHom.{u_7, u_8} α β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40 inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43) (x : α) (y : α), Eq.{succ u_8} β (ZeroHom.toFun.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)) (MonoidWithZeroHom.toZeroHom.{u_7, u_8} α β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40 inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43 self) (HMul.hMul.{u_7, u_7, u_7} α α α (instHMul.{u_7} α (MulOne.toMul.{u_7} α (MulOneClass.toMulOne.{u_7} α (MulZeroOneClass.toMulOneClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)))) x y)) (HMul.hMul.{u_8, u_8, u_8} β β β (instHMul.{u_8} β (MulOne.toMul.{u_8} β (MulOneClass.toMulOne.{u_8} β (MulZeroOneClass.toMulOneClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)))) (ZeroHom.toFun.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)) (MonoidWithZeroHom.toZeroHom.{u_7, u_8} α β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40 inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43 self) x) (ZeroHom.toFun.{u_7, u_8} α β (MulZeroClass.toZero.{u_7} α (MulZeroOneClass.toMulZeroClass.{u_7} α inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40)) (MulZeroClass.toZero.{u_8} β (MulZeroOneClass.toMulZeroClass.{u_8} β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43)) (MonoidWithZeroHom.toZeroHom.{u_7, u_8} α β inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.40 inst._@.Mathlib.Algebra.GroupWithZero.Hom.425065115._hygCtx._hyg.43 self) y))

-- Stub: this file represents the declaration `MonoidWithZeroHom.map_mul'`.
-- In a full split, the body would be extracted from the environment.
