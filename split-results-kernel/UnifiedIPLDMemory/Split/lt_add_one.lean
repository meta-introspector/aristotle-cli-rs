import Split.lt_add_of_pos_right
import Split.Preorder_toLT
import Split.One
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.AddZeroClass_toAddZero
import Split.PartialOrder
import Split.ZeroLEOneClass
import Split.AddZero_toZero
import Split.zero_lt_one
import Split.instHAdd
import Split.AddZeroClass
import Split.AddLeftStrictMono
import Split.HAdd_hAdd
import Split.LT_lt
import Split.One_toOfNat1
import Split.AddZero_toAdd
import Split.NeZero
import Split.OfNat_ofNat

-- lt_add_one from environment
-- theorem lt_add_one : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.3 : One.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.6 : AddZeroClass.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.9 : PartialOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.12 : ZeroLEOneClass.{u_1} α (AddZero.toZero.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.3 (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.9))] [inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.15 : NeZero.{u_1} α (AddZero.toZero.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.6)) (OfNat.ofNat.{u_1} α 1 (One.toOfNat1.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.3))] [inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.21 : AddLeftStrictMono.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.6)) (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.9))] (a : α), LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.9)) a (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.6))) a (OfNat.ofNat.{u_1} α 1 (One.toOfNat1.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.NatCast.1156345328._hygCtx._hyg.3)))

-- Stub: this file represents the declaration `lt_add_one`.
-- In a full split, the body would be extracted from the environment.
