import Split.instHSMul
import Split.monotone_smul_right_of_nonneg
import Split.SMul
import Split.Preorder_toLE
import Split.SMulPosMono
import Split.LE_le
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.OfNat_ofNat
import Split.Preorder
import Split.Zero

-- smul_le_smul_of_nonneg_right from environment
-- theorem smul_le_smul_of_nonneg_right : forall {α : Type.{u_1}} {β : Type.{u_2}} {a₁ : α} {a₂ : α} {b : β} [inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.10 : SMul.{u_1, u_2} α β] [inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.14 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.17 : Preorder.{u_2} β] [inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.20 : Zero.{u_2} β] [inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.23 : SMulPosMono.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.14 inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.17 inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.20], (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.14) a₁ a₂) -> (LE.le.{u_2} β (Preorder.toLE.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.17) (OfNat.ofNat.{u_2} β 0 (Zero.toOfNat0.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.20)) b) -> (LE.le.{u_2} β (Preorder.toLE.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.17) (HSMul.hSMul.{u_1, u_2, u_2} α β β (instHSMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.10) a₁ b) (HSMul.hSMul.{u_1, u_2, u_2} α β β (instHSMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.2967760086._hygCtx._hyg.10) a₂ b))

-- Stub: this file represents the declaration `smul_le_smul_of_nonneg_right`.
-- In a full split, the body would be extracted from the environment.
