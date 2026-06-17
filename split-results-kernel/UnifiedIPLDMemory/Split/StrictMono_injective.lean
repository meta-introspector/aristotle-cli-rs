import Split.Preorder_toLT
import Split.StrictMono
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Ordering_eq
import Split.Ordering_Compares
import Split.Iff_mp
import Split.Function_Injective
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.StrictMono_compares
import Split.Preorder

-- StrictMono.injective from environment
-- theorem StrictMono.injective : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Basic.1646558139._hygCtx._hyg.5 : LinearOrder.{u} α] [inst._@.Mathlib.Order.Monotone.Basic.1646558139._hygCtx._hyg.8 : Preorder.{v} β] {f : α -> β}, (StrictMono.{u, v} α β (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.1646558139._hygCtx._hyg.5)) inst._@.Mathlib.Order.Monotone.Basic.1646558139._hygCtx._hyg.8 f) -> (Function.Injective.{succ u, succ v} α β f)

-- Stub: this file represents the declaration `StrictMono.injective`.
-- In a full split, the body would be extracted from the environment.
