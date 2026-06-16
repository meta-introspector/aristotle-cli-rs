import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.Eq
import Split.Preorder

-- PartialOrder.mk from environment
-- constructor PartialOrder.mk : forall {α : Type.{u_2}} [toPreorder : Preorder.{u_2} α], (forall (a : α) (b : α), (LE.le.{u_2} α (Preorder.toLE.{u_2} α toPreorder) a b) -> (LE.le.{u_2} α (Preorder.toLE.{u_2} α toPreorder) b a) -> (Eq.{succ u_2} α a b)) -> (PartialOrder.{u_2} α)

-- Stub: this file represents the declaration `PartialOrder.mk`.
-- In a full split, the body would be extracted from the environment.
