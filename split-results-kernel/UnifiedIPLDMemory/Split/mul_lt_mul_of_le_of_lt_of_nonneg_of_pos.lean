import Split.Preorder_toLT
import Split.HMul_hMul
import Split.Preorder_toLE
import Split.Mul
import Split.mul_lt_mul_of_pos_left
import Split.LE_le
import Split.MulPosMono
import Split.mul_le_mul_of_nonneg_right
import Split.LT_lt
import Split.PosMulStrictMono
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.LE_le_trans_lt
import Split.Preorder
import Split.instHMul
import Split.Zero

-- mul_lt_mul_of_le_of_lt_of_nonneg_of_pos from environment
-- theorem mul_lt_mul_of_le_of_lt_of_nonneg_of_pos : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.3 : Mul.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.6 : Zero.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9 : Preorder.{u_1} α] {a : α} {b : α} {c : α} {d : α} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.16 : PosMulStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.19 : MulPosMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9], (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9) a b) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9) c d) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.6)) c) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.6)) b) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.9) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.3) a c) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.271115007._hygCtx._hyg.3) b d))

-- Stub: this file represents the declaration `mul_lt_mul_of_le_of_lt_of_nonneg_of_pos`.
-- In a full split, the body would be extracted from the environment.
