import Split.Preorder_toLE
import Split.LE_le
import Split.AddCommMonoid
import Split.instHAdd
import Split.HAdd_hAdd
import Split.AddCommSemigroup_toAddCommMagma
import Split.IsOrderedCancelAddMonoid
import Split.AddCommMonoid_toAddCommSemigroup
import Split.IsOrderedAddMonoid
import Split.Preorder
import Split.AddCommMagma_toAdd

-- IsOrderedCancelAddMonoid.mk from environment
-- constructor IsOrderedCancelAddMonoid.mk : forall {α : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.5 : AddCommMonoid.{u_2} α] [inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.8 : Preorder.{u_2} α] [toIsOrderedAddMonoid : IsOrderedAddMonoid.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.5 inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.8], (forall (a : α) (b : α) (c : α), (LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.8) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.5)))) a b) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.5)))) a c)) -> (LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.8) b c)) -> (forall (a : α) (b : α) (c : α), (LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.8) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.5)))) b a) (HAdd.hAdd.{u_2, u_2, u_2} α α α (instHAdd.{u_2} α (AddCommMagma.toAdd.{u_2} α (AddCommSemigroup.toAddCommMagma.{u_2} α (AddCommMonoid.toAddCommSemigroup.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.5)))) c a)) -> (LE.le.{u_2} α (Preorder.toLE.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.8) b c)) -> (IsOrderedCancelAddMonoid.{u_2} α inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.5 inst._@.Mathlib.Algebra.Order.Monoid.Defs.2043165421._hygCtx._hyg.8)

-- Stub: this file represents the declaration `IsOrderedCancelAddMonoid.mk`.
-- In a full split, the body would be extracted from the environment.
