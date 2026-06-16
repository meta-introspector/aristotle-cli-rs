import Split.le_refl
import Split.AddLeftMono
import Split.Preorder_toLE
import Split.AddRightMono
import Split.add_le_add_left
import Split.add_le_add_right
import Split.LE_le
import Split.le_imp_le_of_le_of_le
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Add
import Split.Preorder

-- add_le_add from environment
-- theorem add_le_add : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.4 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.7 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.10 : AddLeftMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.4 (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.7)] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.13 : AddRightMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.4 (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.7)] {a : α} {b : α} {c : α} {d : α}, (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.7) a b) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.7) c d) -> (LE.le.{u_1} α (Preorder.toLE.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.7) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.4) a c) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3142851106._hygCtx._hyg.4) b d))

-- Stub: this file represents the declaration `add_le_add`.
-- In a full split, the body would be extracted from the environment.
