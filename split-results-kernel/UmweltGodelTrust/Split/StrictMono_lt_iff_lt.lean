import Split.Preorder_toLT
import Split.trivial
import Split.StrictMono
import Split.LinearOrder
import Split.Set_univ
import Split.PartialOrder_toPreorder
import Split.Iff
import Split.StrictMono_strictMonoOn
import Split.LT_lt
import Split.LinearOrder_toPartialOrder
import Split.Preorder
import Split.StrictMonoOn_lt_iff_lt

-- StrictMono.lt_iff_lt from environment
-- theorem StrictMono.lt_iff_lt : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Basic.1731869922._hygCtx._hyg.5 : LinearOrder.{u} α] [inst._@.Mathlib.Order.Monotone.Basic.1731869922._hygCtx._hyg.8 : Preorder.{v} β] {f : α -> β}, (StrictMono.{u, v} α β (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.1731869922._hygCtx._hyg.5)) inst._@.Mathlib.Order.Monotone.Basic.1731869922._hygCtx._hyg.8 f) -> (forall {a : α} {b : α}, Iff (LT.lt.{v} β (Preorder.toLT.{v} β inst._@.Mathlib.Order.Monotone.Basic.1731869922._hygCtx._hyg.8) (f a) (f b)) (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.1731869922._hygCtx._hyg.5))) a b))

-- Stub: this file represents the declaration `StrictMono.lt_iff_lt`.
-- In a full split, the body would be extracted from the environment.
