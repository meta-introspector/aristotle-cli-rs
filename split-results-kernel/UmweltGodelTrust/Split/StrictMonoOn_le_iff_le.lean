import Split.Preorder_toLT
import Split.le_rfl
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Membership_mem
import Split.le_of_not_gt
import Split.Eq_rec
import Split.LinearOrder_toDecidableLE
import Split.LT_lt_le
import Split.LE_le
import Split.Iff
import Split.LT_lt
import Split.Iff_intro
import Split.LE_le_lt_or_eq_dec
import Split.StrictMonoOn
import Split.LT_lt_not_ge
import Split.Or_elim
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.Set_instMembership
import Split.Preorder
import Split.Set

-- StrictMonoOn.le_iff_le from environment
-- theorem StrictMonoOn.le_iff_le : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Basic.492666019._hygCtx._hyg.5 : LinearOrder.{u} α] [inst._@.Mathlib.Order.Monotone.Basic.492666019._hygCtx._hyg.8 : Preorder.{v} β] {f : α -> β} {s : Set.{u} α}, (StrictMonoOn.{u, v} α β (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.492666019._hygCtx._hyg.5)) inst._@.Mathlib.Order.Monotone.Basic.492666019._hygCtx._hyg.8 f s) -> (forall {a : α} {b : α}, (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s a) -> (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s b) -> (Iff (LE.le.{v} β (Preorder.toLE.{v} β inst._@.Mathlib.Order.Monotone.Basic.492666019._hygCtx._hyg.8) (f a) (f b)) (LE.le.{u} α (Preorder.toLE.{u} α (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.492666019._hygCtx._hyg.5))) a b)))

-- Stub: this file represents the declaration `StrictMonoOn.le_iff_le`.
-- In a full split, the body would be extracted from the environment.
