import Split.Preorder_toLT
import Split.HMul_hMul
import Split.MulPosReflectLE_toContravariantClass
import Split.Preorder_toLE
import Split.Mul
import Split.Subtype
import Split.LE_le
import Split.Subtype_mk
import Split.MulPosReflectLE
import Split.LT_lt
import Split.ContravariantClass_elim
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Subtype_val
import Split.Preorder
import Split.instHMul
import Split.Zero

-- le_of_mul_le_mul_right from environment
-- theorem le_of_mul_le_mul_right : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.3 : Mul.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.6 : Zero.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.9 : Preorder.{u_1} α] {a : α} {b : α} {c : α} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.16 : MulPosReflectLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.9], (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.9) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.3) b a) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.3) c a)) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.9) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.6)) a) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.606472721._hygCtx._hyg.9) b c)

-- Stub: this file represents the declaration `le_of_mul_le_mul_right`.
-- In a full split, the body would be extracted from the environment.
