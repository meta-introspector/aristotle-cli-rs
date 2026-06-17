import Split.HMul_hMul
import Split.Preorder_toLE
import Split.Mul
import Split.LE_le
import Split.PosMulMono
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Preorder
import Split.instHMul
import Split.Zero

-- PosMulMono.mul_le_mul_of_nonneg_left from environment
-- theorem PosMulMono.mul_le_mul_of_nonneg_left : forall {α : Type.{u_1}} {inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.13 : Mul.{u_1} α} {inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.16 : Zero.{u_1} α} {inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.19 : Preorder.{u_1} α} [self : PosMulMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.13 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.16 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.19] {{a : α}}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.19) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.16)) a) -> (forall {{b : α}} {{c : α}}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.19) b c) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.19) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.13) a b) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.788287715._hygCtx._hyg.13) a c)))

-- Stub: this file represents the declaration `PosMulMono.mul_le_mul_of_nonneg_left`.
-- In a full split, the body would be extracted from the environment.
