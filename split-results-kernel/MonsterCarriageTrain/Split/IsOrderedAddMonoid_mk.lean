import Split.Preorder_toLE
import Split.LE_le
import Split.AddCommMonoid
import Split.instHAdd
import Split.HAdd_hAdd
import Split.AddCommSemigroup_toAddCommMagma
import Split.AddCommMonoid_toAddCommSemigroup
import Split.IsOrderedAddMonoid
import Split.Preorder
import Split.AddCommMagma_toAdd

-- IsOrderedAddMonoid.mk from environment
-- constructor IsOrderedAddMonoid.mk : forall {α : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.5 : AddCommMonoid.{u_2} α] [inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.8 : Preorder.{u_2} α], (forall (a : α) (b : α), (LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.8) a b) -> (forall (c : α), LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.8) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.5)))) a c) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.5)))) b c))) -> (forall (a : α) (b : α), (LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.8) a b) -> (forall (c : α), LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.8) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.5)))) c a) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.5)))) c b))) -> (IsOrderedAddMonoid.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.5 inst._@.Mathlib.Algebra.Order.Monoid.Defs.4095980663._hygCtx._hyg.8)

-- Stub: this file represents the declaration `IsOrderedAddMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
