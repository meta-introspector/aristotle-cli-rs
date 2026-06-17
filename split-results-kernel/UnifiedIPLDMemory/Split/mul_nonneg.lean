import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.Preorder_toLE
import Split.MulZeroClass
import Split.LE_le
import Split.Left_mul_nonneg
import Split.PosMulMono
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Preorder
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_nonneg from environment
-- theorem mul_nonneg : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.5 : MulZeroClass.{u_1} α] {a : α} {b : α} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.12 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.15 : PosMulMono.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.5) (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.5) inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.12], (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.5))) a) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.5))) b) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.5))) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.658516604._hygCtx._hyg.5)) a b))

-- Stub: this file represents the declaration `mul_nonneg`.
-- In a full split, the body would be extracted from the environment.
