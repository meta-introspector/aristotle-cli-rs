import Split.Preorder_toLT
import Split.AddMonoid_toAddSemigroup
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.StrictMono_lt_iff_lt
import Split.AddLeftMono
import Split.Preorder_toLE
import Split.AddZeroClass_toAddZero
import Split.PartialOrder
import Split.ZeroLEOneClass
import Split.AddMonoidWithOne_toNatCast
import Split.Nat_cast
import Split.CharZero
import Split.AddMonoidWithOne_toOne
import Split.AddZero_toZero
import Split.AddSemigroup_toAdd
import Split.Iff
import Split.Nat
import Split.LT_lt
import Split.Nat_strictMono_cast
import Split.AddMonoidWithOne_toAddMonoid
import Split.instLTNat
import Split.AddMonoidWithOne
import Split.Nat_instLinearOrder

-- Nat.cast_lt from environment
-- theorem Nat.cast_lt : forall {α : Type.{u_1}} [inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.3 : AddMonoidWithOne.{u_1} α] [inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.6 : PartialOrder.{u_1} α] [inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.9 : AddLeftMono.{u_1} α (AddSemigroup.toAdd.{u_1} α (AddMonoid.toAddSemigroup.{u_1} α (AddMonoidWithOne.toAddMonoid.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.3))) (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.6))] [inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.12 : ZeroLEOneClass.{u_1} α (AddZero.toZero.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (AddMonoidWithOne.toAddMonoid.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.3)))) (AddMonoidWithOne.toOne.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.3) (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.6))] [inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.15 : CharZero.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.3] {m : Nat} {n : Nat}, Iff (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.6)) (Nat.cast.{u_1} α (AddMonoidWithOne.toNatCast.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.3) m) (Nat.cast.{u_1} α (AddMonoidWithOne.toNatCast.{u_1} α inst._@.Mathlib.Data.Nat.Cast.Order.Basic.1927569359._hygCtx._hyg.3) n)) (LT.lt.{0} Nat instLTNat m n)

-- Stub: this file represents the declaration `Nat.cast_lt`.
-- In a full split, the body would be extracted from the environment.
