import Split.Preorder_toLT
import Split.Preorder_toLE
import Split.LE_le
import Split.Iff
import Split.LT_lt
import Split.SuccOrder
import Split.SuccOrder_mk
import Split.Preorder

-- SuccOrder.ofSuccLeIff from environment
-- def SuccOrder.ofSuccLeIff : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.SuccPred.Basic.534145700._hygCtx._hyg.4 : Preorder.{u_1} α] (succ : α -> α), (forall {a : α} {b : α}, Iff (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Order.SuccPred.Basic.534145700._hygCtx._hyg.4) (succ a) b) (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Order.SuccPred.Basic.534145700._hygCtx._hyg.4) a b)) -> (SuccOrder.{u_1} α inst._@.Mathlib.Order.SuccPred.Basic.534145700._hygCtx._hyg.4)
-- (definition body omitted)

-- Stub: this file represents the declaration `SuccOrder.ofSuccLeIff`.
-- In a full split, the body would be extracted from the environment.
