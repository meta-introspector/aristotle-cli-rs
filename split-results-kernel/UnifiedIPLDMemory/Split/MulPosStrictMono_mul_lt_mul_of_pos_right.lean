import Split.Preorder_toLT
import Split.HMul_hMul
import Split.Mul
import Split.MulPosStrictMono
import Split.LT_lt
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Preorder
import Split.instHMul
import Split.Zero

-- MulPosStrictMono.mul_lt_mul_of_pos_right from environment
-- theorem MulPosStrictMono.mul_lt_mul_of_pos_right : forall {α : Type.{u_1}} {inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.13 : Mul.{u_1} α} {inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.16 : Zero.{u_1} α} {inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.19 : Preorder.{u_1} α} [self : MulPosStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.13 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.16 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.19] {{c : α}}, (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.19) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.16)) c) -> (forall {{a : α}} {{b : α}}, (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.19) a b) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.19) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.13) a c) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.54809005._hygCtx._hyg.13) b c)))

-- Stub: this file represents the declaration `MulPosStrictMono.mul_lt_mul_of_pos_right`.
-- In a full split, the body would be extracted from the environment.
