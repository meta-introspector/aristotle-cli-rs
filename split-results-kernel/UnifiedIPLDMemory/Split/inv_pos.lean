import Split.Eq_mpr
import Split.GroupWithZero_toMonoidWithZero
import Split.MulOne_toOne
import Split.False
import Split.Preorder_toLT
import Split.GroupWithZero_toDivisionMonoid
import Split.HMul_hMul
import Split.lt_of_mul_lt_mul_left
import Split.DivInvOneMonoid_toInvOneClass
import Split.eq_false
import Split.mul_inv_cancel₀
import Split.MulZeroClass_toMul
import Split.congrArg
import Split.InvolutiveInv_toInv
import Split.PartialOrder_toPreorder
import Split.GroupWithZero
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.Eq_rec
import Split.PartialOrder
import Split.id
import Split.LT_lt_le
import Split.DivisionMonoid_toInvolutiveInv
import Split.MulZeroClass_mul_zero
import Split.MulZeroOneClass_toMulOneClass
import Split.LT_lt_ne'
import Split.MulOneClass_toMulOne
import Split.Iff
import Split.Inv_inv
import Split.MonoidWithZero_toMulZeroOneClass
import Split.PosMulReflectLT
import Split.inv_inv
import Split.congr
import Split.LT_lt
import Split.True
import Split.Iff_intro
import Split.of_eq_true
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.InvOneClass_toInv
import Split.MulZeroOneClass_toMulZeroClass
import Split.mul_one
import Split.OfNat_ofNat
import Split.not_false_eq_true
import Split.Eq
import Split.Not
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul

-- inv_pos from environment
-- theorem inv_pos : forall {G₀ : Type.{u_3}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.5 : GroupWithZero.{u_3} G₀] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.8 : PartialOrder.{u_3} G₀] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.11 : PosMulReflectLT.{u_3} G₀ (MulZeroClass.toMul.{u_3} G₀ (MulZeroOneClass.toMulZeroClass.{u_3} G₀ (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.5)))) (MulZeroClass.toZero.{u_3} G₀ (MulZeroOneClass.toMulZeroClass.{u_3} G₀ (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.5)))) (PartialOrder.toPreorder.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.8)] {a : G₀}, Iff (LT.lt.{u_3} G₀ (Preorder.toLT.{u_3} G₀ (PartialOrder.toPreorder.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.8)) (OfNat.ofNat.{u_3} G₀ 0 (Zero.toOfNat0.{u_3} G₀ (MulZeroClass.toZero.{u_3} G₀ (MulZeroOneClass.toMulZeroClass.{u_3} G₀ (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.5)))))) (Inv.inv.{u_3} G₀ (InvOneClass.toInv.{u_3} G₀ (DivInvOneMonoid.toInvOneClass.{u_3} G₀ (DivisionMonoid.toDivInvOneMonoid.{u_3} G₀ (GroupWithZero.toDivisionMonoid.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.5)))) a)) (LT.lt.{u_3} G₀ (Preorder.toLT.{u_3} G₀ (PartialOrder.toPreorder.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.8)) (OfNat.ofNat.{u_3} G₀ 0 (Zero.toOfNat0.{u_3} G₀ (MulZeroClass.toZero.{u_3} G₀ (MulZeroOneClass.toMulZeroClass.{u_3} G₀ (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.3871353733._hygCtx._hyg.5)))))) a)

-- Stub: this file represents the declaration `inv_pos`.
-- In a full split, the body would be extracted from the environment.
