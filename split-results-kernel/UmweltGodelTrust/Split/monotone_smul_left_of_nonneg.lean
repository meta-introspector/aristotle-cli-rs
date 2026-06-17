import Split.instHSMul
import Split.SMul
import Split.Monotone
import Split.Preorder_toLE
import Split.PosSMulMono_smul_le_smul_of_nonneg_left
import Split.PosSMulMono
import Split.LE_le
import Split.Zero_toOfNat0
import Split.HSMul_hSMul
import Split.OfNat_ofNat
import Split.Preorder
import Split.Zero

-- monotone_smul_left_of_nonneg from environment
-- theorem monotone_smul_left_of_nonneg : forall {α : Type.{u_1}} {β : Type.{u_2}} {a : α} [inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.10 : SMul.{u_1, u_2} α β] [inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.14 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.17 : Preorder.{u_2} β] [inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.20 : Zero.{u_1} α] [inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.23 : PosSMulMono.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.14 inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.17 inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.20], (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.14) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.20)) a) -> (Monotone.{u_2, u_2} β β inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.17 inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.17 (fun (x._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.40 : β) => HSMul.hSMul.{u_1, u_2, u_2} α β β (instHSMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.10) a x._@.Mathlib.Algebra.Order.Module.Defs.1462556564._hygCtx._hyg.40))

-- Stub: this file represents the declaration `monotone_smul_left_of_nonneg`.
-- In a full split, the body would be extracted from the environment.
