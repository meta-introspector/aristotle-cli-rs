import Split.Iff_mpr
import Split.Eq_mpr
import Split.GroupWithZero_toMonoidWithZero
import Split.DivInvMonoid_toInv
import Split.Preorder_toLT
import Split.instHDiv
import Split.GroupWithZero_toDivisionMonoid
import Split.MulPosReflectLT
import Split.HMul_hMul
import Split.GroupWithZero_toDivInvMonoid
import Split.DivInvOneMonoid_toInvOneClass
import Split.MulZeroClass_toMul
import Split.Monoid_toMulOneClass
import Split.congrArg
import Split.PartialOrder_toPreorder
import Split.GroupWithZero
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.PartialOrder
import Split.id
import Split.MulOne_toMul
import Split.HDiv_hDiv
import Split.DivInvMonoid_toMonoid
import Split.MulPosReflectLT_toMulPosStrictMono
import Split.mul_lt_mul_of_pos_right
import Split.div_eq_mul_inv
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.MonoidWithZero_toMulZeroOneClass
import Split.LT_lt
import Split.Right_inv_pos
import Split.DivInvMonoid_toDiv
import Split.Zero_toOfNat0
import Split.InvOneClass_toInv
import Split.MulZeroOneClass_toMulZeroClass
import Split.OfNat_ofNat
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- div_lt_div_of_pos_right from environment
-- theorem div_lt_div_of_pos_right : forall {G₀ : Type.{u_3}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.5 : GroupWithZero.{u_3} G₀] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.8 : PartialOrder.{u_3} G₀] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.11 : MulPosReflectLT.{u_3} G₀ (MulZeroClass.toMul.{u_3} G₀ (MulZeroOneClass.toMulZeroClass.{u_3} G₀ (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.5)))) (MulZeroClass.toZero.{u_3} G₀ (MulZeroOneClass.toMulZeroClass.{u_3} G₀ (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.5)))) (PartialOrder.toPreorder.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.8)] {a : G₀} {b : G₀} {c : G₀}, (LT.lt.{u_3} G₀ (Preorder.toLT.{u_3} G₀ (PartialOrder.toPreorder.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.8)) a b) -> (LT.lt.{u_3} G₀ (Preorder.toLT.{u_3} G₀ (PartialOrder.toPreorder.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.8)) (OfNat.ofNat.{u_3} G₀ 0 (Zero.toOfNat0.{u_3} G₀ (MulZeroClass.toZero.{u_3} G₀ (MulZeroOneClass.toMulZeroClass.{u_3} G₀ (MonoidWithZero.toMulZeroOneClass.{u_3} G₀ (GroupWithZero.toMonoidWithZero.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.5)))))) c) -> (LT.lt.{u_3} G₀ (Preorder.toLT.{u_3} G₀ (PartialOrder.toPreorder.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.8)) (HDiv.hDiv.{u_3, u_3, u_3} G₀ G₀ G₀ (instHDiv.{u_3} G₀ (DivInvMonoid.toDiv.{u_3} G₀ (GroupWithZero.toDivInvMonoid.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.5))) a c) (HDiv.hDiv.{u_3, u_3, u_3} G₀ G₀ G₀ (instHDiv.{u_3} G₀ (DivInvMonoid.toDiv.{u_3} G₀ (GroupWithZero.toDivInvMonoid.{u_3} G₀ inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.603976656._hygCtx._hyg.5))) b c))

-- Stub: this file represents the declaration `div_lt_div_of_pos_right`.
-- In a full split, the body would be extracted from the environment.
