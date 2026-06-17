import Split.Function_swap
import Split.AddRightMono
import Split.LE_le
import Split.CovariantClass_elim
import Split.LE
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Add

-- add_le_add_left from environment
-- theorem add_le_add_left : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.4 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.7 : LE.{u_1} α] [i : AddRightMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.7] {b : α} {c : α}, (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.7 b c) -> (forall (a : α), LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.7 (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.4) b a) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.478317756._hygCtx._hyg.4) c a))

-- Stub: this file represents the declaration `add_le_add_left`.
-- In a full split, the body would be extracted from the environment.
