import Split.mul_lt_mul_of_le_of_lt_of_nonneg_of_pos
import Split.Preorder_toLT
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.Preorder_toLE
import Split.MulZeroClass
import Split.LT_lt_le
import Split.LE_le
import Split.MulPosMono
import Split.LT_lt
import Split.PosMulStrictMono
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.LE_le_trans_lt
import Split.Preorder
import Split.MulZeroClass_toZero
import Split.instHMul

-- Left.mul_lt_mul_of_nonneg from environment
-- theorem Left.mul_lt_mul_of_nonneg : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5 : MulZeroClass.{u_1} α] {a : α} {b : α} {c : α} {d : α} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.15 : PosMulStrictMono.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5) (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5) inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.18 : MulPosMono.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5) (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5) inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12], (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12) a b) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12) c d) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5))) a) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5))) c) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.12) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5)) a c) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α (MulZeroClass.toMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Basic.2826226020._hygCtx._hyg.5)) b d))

-- Stub: this file represents the declaration `Left.mul_lt_mul_of_nonneg`.
-- In a full split, the body would be extracted from the environment.
