import Split.Preorder_toLT
import Split.HMul_hMul
import Split.Mul
import Split.MulPosStrictMono_mul_lt_mul_of_pos_right
import Split.MulPosStrictMono
import Split.LT_lt
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Preorder
import Split.instHMul
import Split.Zero

-- mul_lt_mul_of_pos_right from environment
-- theorem mul_lt_mul_of_pos_right : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.3 : Mul.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.6 : Zero.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.9 : Preorder.{u_1} α] {a : α} {b : α} {c : α} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.16 : MulPosStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.9], (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.9) b c) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.9) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.6)) a) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.9) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.3) b a) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.895361643._hygCtx._hyg.3) c a))

-- Stub: this file represents the declaration `mul_lt_mul_of_pos_right`.
-- In a full split, the body would be extracted from the environment.
