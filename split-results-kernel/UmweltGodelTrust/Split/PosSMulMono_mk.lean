import Split.instHSMul
import Split.SMul
import Split.Preorder_toLE
import Split.PosSMulMono
import Split.LE_le
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.OfNat_ofNat
import Split.Preorder
import Split.Zero

-- PosSMulMono.mk from environment
-- constructor PosSMulMono.mk : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.19 : SMul.{u_1, u_2} α β] [inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.23 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.26 : Preorder.{u_2} β] [inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.29 : Zero.{u_1} α], (forall {{a : α}}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.23) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.29)) a) -> (forall {{b₁ : β}} {{b₂ : β}}, (LE.le.{u_2} β (Preorder.toLE.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.26) b₁ b₂) -> (LE.le.{u_2} β (Preorder.toLE.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.26) (HSMul.hSMul.{u_1, u_2, u_2} α β β (instHSMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.19) a b₁) (HSMul.hSMul.{u_1, u_2, u_2} α β β (instHSMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.19) a b₂)))) -> (PosSMulMono.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.19 inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.23 inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.26 inst._@.Mathlib.Algebra.Order.Module.Defs.773133277._hygCtx._hyg.29)

-- Stub: this file represents the declaration `PosSMulMono.mk`.
-- In a full split, the body would be extracted from the environment.
