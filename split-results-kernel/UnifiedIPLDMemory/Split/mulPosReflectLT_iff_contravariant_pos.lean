import Split.LE_le_eq_or_lt
import Split.False
import Split.Preorder_toLT
import Split.MulPosReflectLT
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.congrArg
import Split.False_elim
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.MulZeroClass
import Split.PartialOrder
import Split.Eq_mp
import Split.Subtype
import Split.LE_le
import Split.Or_casesOn
import Split.MulZeroClass_mul_zero
import Split.Subtype_mk
import Split.ContravariantClass_mk
import Split.Iff
import Split.MulPosReflectLT_mk
import Split.Subtype_prop
import Split.congr
import Split.LT_lt
import Split.Iff_intro
import Split.ContravariantClass_elim
import Split.Zero_toOfNat0
import Split.Or
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Subtype_val
import Split.Eq
import Split.MulPosReflectLT_to_contravariantClass_pos_mul_lt
import Split.ContravariantClass
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul

-- mulPosReflectLT_iff_contravariant_pos from environment
-- theorem mulPosReflectLT_iff_contravariant_pos : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.5 : MulZeroClass.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.12 : PartialOrder.{u_1} α], Iff (MulPosReflectLT.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.5) (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.5) (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.12)) (ContravariantClass.{u_1, u_1} (Subtype.{succ u_1} α (fun (x._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.22 : α) => LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.12)) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.5))) x._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.22)) α (fun (x : Subtype.{succ u_1} α (fun (x._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.22 : α) => LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.12)) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.5))) x._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.22)) (y : α) => HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.5)) y (Subtype.val.{succ u_1} α (fun (x._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.22 : α) => LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.12)) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.5))) x._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.22) x)) (fun (x1._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.50 : α) (x2._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.50 : α) => LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.12)) x1._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.50 x2._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.4258439159._hygCtx._hyg.50))

-- Stub: this file represents the declaration `mulPosReflectLT_iff_contravariant_pos`.
-- In a full split, the body would be extracted from the environment.
