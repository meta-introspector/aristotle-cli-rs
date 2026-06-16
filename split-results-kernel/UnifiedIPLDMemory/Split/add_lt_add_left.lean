import Split.Function_swap
import Split.AddRightStrictMono
import Split.CovariantClass_elim
import Split.instHAdd
import Split.HAdd_hAdd
import Split.LT_lt
import Split.Add
import Split.LT

-- add_lt_add_left from environment
-- theorem add_lt_add_left : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.4 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.7 : LT.{u_1} α] [i : AddRightStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.7] {b : α} {c : α}, (LT.lt.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.7 b c) -> (forall (a : α), LT.lt.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.7 (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.4) b a) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.3783702422._hygCtx._hyg.4) c a))

-- Stub: this file represents the declaration `add_lt_add_left`.
-- In a full split, the body would be extracted from the environment.
