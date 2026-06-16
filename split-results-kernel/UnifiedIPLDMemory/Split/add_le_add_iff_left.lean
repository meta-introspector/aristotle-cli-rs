import Split.AddLeftMono
import Split.rel_iff_cov
import Split.LE_le
import Split.LE
import Split.instHAdd
import Split.Iff
import Split.HAdd_hAdd
import Split.AddLeftReflectLE
import Split.Add

-- add_le_add_iff_left from environment
-- theorem add_le_add_iff_left : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.4 : Add.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.7 : LE.{u_1} α] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.10 : AddLeftMono.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.7] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.13 : AddLeftReflectLE.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.7] (a : α) {b : α} {c : α}, Iff (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.7 (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.4) a b) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.4) a c)) (LE.le.{u_1} α inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Basic.4133279679._hygCtx._hyg.7 b c)

-- Stub: this file represents the declaration `add_le_add_iff_left`.
-- In a full split, the body would be extracted from the environment.
