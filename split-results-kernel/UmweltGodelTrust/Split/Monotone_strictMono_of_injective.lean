import Split.Preorder_toLT
import Split.StrictMono
import Split.PartialOrder_toPreorder
import Split.Monotone
import Split.PartialOrder
import Split.LT_lt_le
import Split.LE_le_lt_of_ne
import Split.LT_lt
import Split.Function_Injective
import Split.Eq
import Split.Preorder
import Split.LT_lt_ne

-- Monotone.strictMono_of_injective from environment
-- theorem Monotone.strictMono_of_injective : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Defs.4163016512._hygCtx._hyg.10 : Preorder.{u} α] [inst._@.Mathlib.Order.Monotone.Defs.4163016512._hygCtx._hyg.13 : PartialOrder.{v} β] {f : α -> β}, (Monotone.{u, v} α β inst._@.Mathlib.Order.Monotone.Defs.4163016512._hygCtx._hyg.10 (PartialOrder.toPreorder.{v} β inst._@.Mathlib.Order.Monotone.Defs.4163016512._hygCtx._hyg.13) f) -> (Function.Injective.{succ u, succ v} α β f) -> (StrictMono.{u, v} α β inst._@.Mathlib.Order.Monotone.Defs.4163016512._hygCtx._hyg.10 (PartialOrder.toPreorder.{v} β inst._@.Mathlib.Order.Monotone.Defs.4163016512._hygCtx._hyg.13) f)

-- Stub: this file represents the declaration `Monotone.strictMono_of_injective`.
-- In a full split, the body would be extracted from the environment.
