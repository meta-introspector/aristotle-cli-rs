import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.DecidableLE
import Split.LinearOrder_toPartialOrder

-- LinearOrder.toDecidableLE from environment
-- def LinearOrder.toDecidableLE : forall {α : Type.{u_2}} [self : LinearOrder.{u_2} α], DecidableLE.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α self)))
-- (definition body omitted)

-- Stub: this file represents the declaration `LinearOrder.toDecidableLE`.
-- In a full split, the body would be extracted from the environment.
