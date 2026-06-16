import Split.Preorder_toLT
import Split.AddRightStrictMono
import Split.instHAdd
import Split.AddLeftStrictMono
import Split.add_lt_add_of_lt_of_lt
import Split.HAdd_hAdd
import Split.LT_lt
import Split.Add
import Split.Preorder

-- add_lt_add from environment
-- theorem add_lt_add : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.4 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.7 : Preorder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.10 : AddLeftStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.4 (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.7)] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.13 : AddRightStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.4 (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.7)] {a : α} {b : α} {c : α} {d : α}, (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.7) a b) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.7) c d) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.7) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.4) a c) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2446301502._hygCtx._hyg.4) b d))

-- Stub: this file represents the declaration `add_lt_add`.
-- In a full split, the body would be extracted from the environment.
