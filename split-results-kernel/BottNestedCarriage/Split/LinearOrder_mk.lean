import Split.Preorder_toLT
import Split.Ord
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Ordering
import Split.Max
import Split.PartialOrder
import Split.compareOfLessAndEq
import Split.LE_le
import Split.Ord_compare
import Split.autoParam
import Split.Min
import Split.DecidableLE
import Split.Max_max
import Split.Or
import Split.Eq
import Split.DecidableLT
import Split.Min_min
import Split.DecidableEq
import Split.ite

-- LinearOrder.mk from environment
-- constructor LinearOrder.mk : forall {α : Type.{u_2}} [toPartialOrder : PartialOrder.{u_2} α] [toMin : Min.{u_2} α] [toMax : Max.{u_2} α] [toOrd : Ord.{u_2} α], (forall (a : α) (b : α), Or (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α toPartialOrder)) a b) (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α toPartialOrder)) b a)) -> (forall (toDecidableLE : DecidableLE.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α toPartialOrder))) (toDecidableEq : DecidableEq.{succ u_2} α) (toDecidableLT : DecidableLT.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α toPartialOrder))), (autoParam.{0} (forall (a : α) (b : α), Eq.{succ u_2} α (Min.min.{u_2} α toMin a b) (ite.{succ u_2} α (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α toPartialOrder)) a b) (toDecidableLE a b) a b)) LinearOrder.min_def._autoParam) -> (autoParam.{0} (forall (a : α) (b : α), Eq.{succ u_2} α (Max.max.{u_2} α toMax a b) (ite.{succ u_2} α (LE.le.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α toPartialOrder)) a b) (toDecidableLE a b) b a)) LinearOrder.max_def._autoParam) -> (autoParam.{0} (forall (a : α) (b : α), Eq.{1} Ordering (Ord.compare.{u_2} α toOrd a b) (compareOfLessAndEq.{u_2} α a b (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α toPartialOrder)) (toDecidableLT a b) toDecidableEq)) LinearOrder.compare_eq_compareOfLessAndEq._autoParam) -> (LinearOrder.{u_2} α))

-- Stub: this file represents the declaration `LinearOrder.mk`.
-- In a full split, the body would be extracted from the environment.
