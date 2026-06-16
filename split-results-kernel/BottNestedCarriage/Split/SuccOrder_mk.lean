import Split.Preorder_toLT
import Split.Preorder_toLE
import Split.LE_le
import Split.LT_lt
import Split.SuccOrder
import Split.Preorder
import Split.IsMax

-- SuccOrder.mk from environment
-- constructor SuccOrder.mk : forall {α : Type.{u_3}} [inst._@.Mathlib.Order.SuccPred.Basic.4010253410._hygCtx._hyg.7 : Preorder.{u_3} α] (succ : α -> α), (forall (a : α), LE.le.{u_3} α (Preorder.toLE.{u_3} α inst._@.Mathlib.Order.SuccPred.Basic.4010253410._hygCtx._hyg.7) a (succ a)) -> (forall {a : α}, (LE.le.{u_3} α (Preorder.toLE.{u_3} α inst._@.Mathlib.Order.SuccPred.Basic.4010253410._hygCtx._hyg.7) (succ a) a) -> (IsMax.{u_3} α (Preorder.toLE.{u_3} α inst._@.Mathlib.Order.SuccPred.Basic.4010253410._hygCtx._hyg.7) a)) -> (forall {a : α} {b : α}, (LT.lt.{u_3} α (Preorder.toLT.{u_3} α inst._@.Mathlib.Order.SuccPred.Basic.4010253410._hygCtx._hyg.7) a b) -> (LE.le.{u_3} α (Preorder.toLE.{u_3} α inst._@.Mathlib.Order.SuccPred.Basic.4010253410._hygCtx._hyg.7) (succ a) b)) -> (SuccOrder.{u_3} α inst._@.Mathlib.Order.SuccPred.Basic.4010253410._hygCtx._hyg.7)

-- Stub: this file represents the declaration `SuccOrder.mk`.
-- In a full split, the body would be extracted from the environment.
