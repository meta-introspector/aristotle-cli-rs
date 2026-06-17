import Split.Preorder_toLT
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.MulZeroClass
import Split.Left_mul_pos
import Split.LT_lt
import Split.PosMulStrictMono
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Preorder
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_pos from environment
-- theorem mul_pos : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.5 : MulZeroClass.{u_1} α] {a : α} {b : α} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.12 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.15 : PosMulStrictMono.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.5) (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.5) inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.12], (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.5))) a) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.5))) b) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.5))) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2407755657._hygCtx._hyg.5)) a b))

-- Stub: this file represents the declaration `mul_pos`.
-- In a full split, the body would be extracted from the environment.
