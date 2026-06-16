import Split.Preorder_toLT
import Split.trivial
import Split.StrictMono
import Split.LinearOrder
import Split.Set_univ
import Split.PartialOrder_toPreorder
import Split.Ordering
import Split.Iff
import Split.Ordering_Compares
import Split.StrictMono_strictMonoOn
import Split.LinearOrder_toPartialOrder
import Split.StrictMonoOn_compares
import Split.Preorder

-- StrictMono.compares from environment
-- theorem StrictMono.compares : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Basic.2335192825._hygCtx._hyg.5 : LinearOrder.{u} α] [inst._@.Mathlib.Order.Monotone.Basic.2335192825._hygCtx._hyg.8 : Preorder.{v} β] {f : α -> β}, (StrictMono.{u, v} α β (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.2335192825._hygCtx._hyg.5)) inst._@.Mathlib.Order.Monotone.Basic.2335192825._hygCtx._hyg.8 f) -> (forall {a : α} {b : α} {o : Ordering}, Iff (Ordering.Compares.{v} β (Preorder.toLT.{v} β inst._@.Mathlib.Order.Monotone.Basic.2335192825._hygCtx._hyg.8) o (f a) (f b)) (Ordering.Compares.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.2335192825._hygCtx._hyg.5))) o a b))

-- Stub: this file represents the declaration `StrictMono.compares`.
-- In a full split, the body would be extracted from the environment.
