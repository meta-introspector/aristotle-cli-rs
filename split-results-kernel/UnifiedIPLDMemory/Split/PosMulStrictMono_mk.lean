import Split.Preorder_toLT
import Split.HMul_hMul
import Split.Mul
import Split.LT_lt
import Split.PosMulStrictMono
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Preorder
import Split.instHMul
import Split.Zero

-- PosMulStrictMono.mk from environment
-- constructor PosMulStrictMono.mk : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.13 : Mul.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.16 : Zero.{u_1} α] [inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.19 : Preorder.{u_1} α], (forall {{a : α}}, (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.19) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.16)) a) -> (forall {{b : α}} {{c : α}}, (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.19) b c) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.19) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.13) a b) (HMul.hMul.{u_1, u_1, u_1} α α α (instHMul.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.13) a c)))) -> (PosMulStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.13 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.16 inst._@.Mathlib.Algebra.Order.GroupWithZero.Unbundled.Defs.3658309288._hygCtx._hyg.19)

-- Stub: this file represents the declaration `PosMulStrictMono.mk`.
-- In a full split, the body would be extracted from the environment.
