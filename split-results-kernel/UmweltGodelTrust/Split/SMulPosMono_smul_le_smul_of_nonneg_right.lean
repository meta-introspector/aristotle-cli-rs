import Split.instHSMul
import Split.SMul
import Split.Preorder_toLE
import Split.SMulPosMono
import Split.LE_le
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.OfNat_ofNat
import Split.Preorder
import Split.Zero

-- SMulPosMono.smul_le_smul_of_nonneg_right from environment
-- theorem SMulPosMono.smul_le_smul_of_nonneg_right : forall {α : Type.{u_1}} {β : Type.{u_2}} {inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.19 : SMul.{u_1, u_2} α β} {inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.23 : Preorder.{u_1} α} {inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.26 : Preorder.{u_2} β} {inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.29 : Zero.{u_2} β} [self : SMulPosMono.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.19 inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.23 inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.26 inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.29] {{b : β}}, (LE.le.{u_2} β (Preorder.toLE.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.26) (OfNat.ofNat.{u_2} β 0 (Zero.toOfNat0.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.29)) b) -> (forall {{a₁ : α}} {{a₂ : α}}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.23) a₁ a₂) -> (LE.le.{u_2} β (Preorder.toLE.{u_2} β inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.26) (HSMul.hSMul.{u_1, u_2, u_2} α β β (instHSMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.19) a₁ b) (HSMul.hSMul.{u_1, u_2, u_2} α β β (instHSMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.3324025341._hygCtx._hyg.19) a₂ b)))

-- Stub: this file represents the declaration `SMulPosMono.smul_le_smul_of_nonneg_right`.
-- In a full split, the body would be extracted from the environment.
