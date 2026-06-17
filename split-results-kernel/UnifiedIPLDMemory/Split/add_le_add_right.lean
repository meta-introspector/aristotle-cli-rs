import Split.AddLeftMono
import Split.LE_le
import Split.CovariantClass_elim
import Split.LE
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Add

-- add_le_add_right from environment
-- theorem add_le_add_right : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.4 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.7 : LE.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.10 : AddLeftMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.7] {b : α} {c : α}, (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.7 b c) -> (forall (a : α), LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.7 (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.4) a b) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.1108292250._hygCtx._hyg.4) a c))

-- Stub: this file represents the declaration `add_le_add_right`.
-- In a full split, the body would be extracted from the environment.
