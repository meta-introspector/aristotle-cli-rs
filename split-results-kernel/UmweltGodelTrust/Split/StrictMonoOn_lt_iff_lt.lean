import Split.Eq_mpr
import Split.Preorder_toLT
import Split.congrArg
import Split.lt_iff_le_not_ge
import Split.LinearOrder
import Split.Iff_rfl
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Membership_mem
import Split.id
import Split.LE_le
import Split.And
import Split.Iff
import Split.LT_lt
import Split.propext
import Split.StrictMonoOn_le_iff_le
import Split.StrictMonoOn
import Split.LinearOrder_toPartialOrder
import Split.Eq
import Split.Set_instMembership
import Split.Not
import Split.Preorder
import Split.Set

-- StrictMonoOn.lt_iff_lt from environment
-- theorem StrictMonoOn.lt_iff_lt : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Basic.1731869921._hygCtx._hyg.5 : LinearOrder.{u} α] [inst._@.Mathlib.Order.Monotone.Basic.1731869921._hygCtx._hyg.8 : Preorder.{v} β] {f : α -> β} {s : Set.{u} α}, (StrictMonoOn.{u, v} α β (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.1731869921._hygCtx._hyg.5)) inst._@.Mathlib.Order.Monotone.Basic.1731869921._hygCtx._hyg.8 f s) -> (forall {a : α} {b : α}, (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s a) -> (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s b) -> (Iff (LT.lt.{v} β (Preorder.toLT.{v} β inst._@.Mathlib.Order.Monotone.Basic.1731869921._hygCtx._hyg.8) (f a) (f b)) (LT.lt.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.1731869921._hygCtx._hyg.5))) a b)))

-- Stub: this file represents the declaration `StrictMonoOn.lt_iff_lt`.
-- In a full split, the body would be extracted from the environment.
