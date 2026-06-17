import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Exists
import Split.GE_ge
import Split.LE_le
import Split.exists_ge_of_linear
import Split.And
import Split.And_intro
import Split.Exists_intro
import Split.LE_le_trans
import Split.LinearOrder_toPartialOrder

-- exists_forall_ge_and from environment
-- theorem exists_forall_ge_and : forall {α : Type.{u_2}} [inst._@.Mathlib.Order.Basic.808257110._hygCtx._hyg.8 : LinearOrder.{u_2} α] {p : α -> Prop} {q : α -> Prop}, (Exists.{succ u_2} α (fun (i : α) => forall (j : α), (GE.ge.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.808257110._hygCtx._hyg.8))) j i) -> (p j))) -> (Exists.{succ u_2} α (fun (i : α) => forall (j : α), (GE.ge.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.808257110._hygCtx._hyg.8))) j i) -> (q j))) -> (Exists.{succ u_2} α (fun (i : α) => forall (j : α), (GE.ge.{u_2} α (Preorder.toLE.{u_2} α (PartialOrder.toPreorder.{u_2} α (LinearOrder.toPartialOrder.{u_2} α inst._@.Mathlib.Order.Basic.808257110._hygCtx._hyg.8))) j i) -> (And (p j) (q j))))

-- Stub: this file represents the declaration `exists_forall_ge_and`.
-- In a full split, the body would be extracted from the environment.
