import Split.rel_iff_cov
import Split.instHAdd
import Split.Iff
import Split.AddLeftStrictMono
import Split.HAdd_hAdd
import Split.LT_lt
import Split.Add
import Split.LT
import Split.AddLeftReflectLT

-- add_lt_add_iff_left from environment
-- theorem add_lt_add_iff_left : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.4 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.7 : LT.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.10 : AddLeftStrictMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.7] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.13 : AddLeftReflectLT.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.7] (a : α) {b : α} {c : α}, Iff (LT.lt.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.7 (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.4) a b) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.4) a c)) (LT.lt.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.2965530553._hygCtx._hyg.7 b c)

-- Stub: this file represents the declaration `add_lt_add_iff_left`.
-- In a full split, the body would be extracted from the environment.
