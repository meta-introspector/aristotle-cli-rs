import Split.Preorder_toLT
import Split.congrArg
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Std_instReflLeOfIsPreorder
import Split.Preorder_toLE
import Split.LinearOrder_toDecidableLE
import Split.LE_le
import Split.ite_cond_eq_true
import Split.Or_casesOn
import Split.LinearOrder_toMax
import Split.Max_max
import Split.congr
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.instIsPreorder_mathlib
import Split.of_eq_true
import Split.congrFun'
import Split.Or
import Split.ite_cond_eq_false
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.max_def
import Split.Eq_trans
import Split.lt_trichotomy
import Split.ite

-- max_def' from environment
-- theorem max_def' : forall {α : Type.{u_1}} [inst._@.Mathlib.Order.Defs.LinearOrder.4254753237._hygCtx._hyg.3 : LinearOrder.{u_1} α] (a : α) (b : α), Eq.{succ u_1} α (Max.max.{u_1} α (LinearOrder.toMax.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.4254753237._hygCtx._hyg.3) a b) (ite.{succ u_1} α (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (LinearOrder.toPartialOrder.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.4254753237._hygCtx._hyg.3))) b a) (LinearOrder.toDecidableLE.{u_1} α inst._@.Mathlib.Order.Defs.LinearOrder.4254753237._hygCtx._hyg.3 b a) a b)

-- Stub: this file represents the declaration `max_def'`.
-- In a full split, the body would be extracted from the environment.
