import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Membership_mem
import Split.Ordering
import Split.LE_le_antisymm
import Split.Ordering_eq
import Split.Eq_le
import Split.LE_le
import Split.congr_arg
import Split.Unit
import Split.Iff
import Split.Ordering_Compares
import Split.Iff_intro
import Split.Iff_mp
import Split.StrictMonoOn_le_iff_le
import Split.StrictMonoOn
import Split.Eq_symm
import Split.LinearOrder_toPartialOrder
import Split.Set_instMembership
import Split.Preorder
import Split.StrictMonoOn_lt_iff_lt
import Split.Set

-- StrictMonoOn.compares from environment
-- theorem StrictMonoOn.compares : forall {α : Type.{u}} {β : Type.{v}} [inst._@.Mathlib.Order.Monotone.Basic.2335192823._hygCtx._hyg.5 : LinearOrder.{u} α] [inst._@.Mathlib.Order.Monotone.Basic.2335192823._hygCtx._hyg.8 : Preorder.{v} β] {f : α -> β} {s : Set.{u} α}, (StrictMonoOn.{u, v} α β (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.2335192823._hygCtx._hyg.5)) inst._@.Mathlib.Order.Monotone.Basic.2335192823._hygCtx._hyg.8 f s) -> (forall {a : α} {b : α}, (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s a) -> (Membership.mem.{u, u} α (Set.{u} α) (Set.instMembership.{u} α) s b) -> (forall {o : Ordering}, Iff (Ordering.Compares.{v} β (Preorder.toLT.{v} β inst._@.Mathlib.Order.Monotone.Basic.2335192823._hygCtx._hyg.8) o (f a) (f b)) (Ordering.Compares.{u} α (Preorder.toLT.{u} α (PartialOrder.toPreorder.{u} α (LinearOrder.toPartialOrder.{u} α inst._@.Mathlib.Order.Monotone.Basic.2335192823._hygCtx._hyg.5))) o a b)))

-- Stub: this file represents the declaration `StrictMonoOn.compares`.
-- In a full split, the body would be extracted from the environment.
