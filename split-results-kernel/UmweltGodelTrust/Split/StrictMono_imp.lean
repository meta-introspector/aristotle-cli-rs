import Split.Preorder_toLT
import Split.StrictMono
import Split.LT_lt
import Split.Preorder

-- StrictMono.imp from environment
-- theorem StrictMono.imp : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Defs.2817005663._hygCtx._hyg.10 : Preorder.{u} α] [inst._@.Mathlib.Order.Monotone.Defs.2817005663._hygCtx._hyg.13 : Preorder.{v} β] {f : α -> β} {a : α} {b : α}, (StrictMono.{u, v} α β inst._@.Mathlib.Order.Monotone.Defs.2817005663._hygCtx._hyg.10 inst._@.Mathlib.Order.Monotone.Defs.2817005663._hygCtx._hyg.13 f) -> (LT.lt.{u} α (Preorder.toLT.{u} α inst._@.Mathlib.Order.Monotone.Defs.2817005663._hygCtx._hyg.10) a b) -> (LT.lt.{v} β (Preorder.toLT.{v} β inst._@.Mathlib.Order.Monotone.Defs.2817005663._hygCtx._hyg.13) (f a) (f b))

-- Stub: this file represents the declaration `StrictMono.imp`.
-- In a full split, the body would be extracted from the environment.
