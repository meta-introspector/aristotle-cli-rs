import Split.HMul_hMul
import Split.Preorder_toLE
import Split.Mul
import Split.LE_le
import Split.MulPosMono
import Split.mul_le_mul_of_nonneg_right
import Split.PosMulMono
import Split.Zero_toOfNat0
import Split.LE_le_trans
import Split.OfNat_ofNat
import Split.mul_le_mul_of_nonneg_left
import Split.Preorder
import Split.instHMul
import Split.Zero

-- mul_le_mul_of_nonneg' from environment
-- theorem mul_le_mul_of_nonneg' : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.3 : Mul.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.6 : Zero.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9 : Preorder.{u_1} α] {a : α} {b : α} {c : α} {d : α} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.16 : PosMulMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.19 : MulPosMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9], (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9) a b) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9) c d) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.6)) c) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.6)) b) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.9) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.3) a c) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.1249795918._hygCtx._hyg.3) b d))

-- Stub: this file represents the declaration `mul_le_mul_of_nonneg'`.
-- In a full split, the body would be extracted from the environment.
