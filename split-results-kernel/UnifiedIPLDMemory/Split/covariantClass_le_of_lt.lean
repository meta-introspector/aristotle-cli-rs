import Split.CovariantClass_mk
import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.CovariantClass_elim
import Split.covariant_le_of_covariant_lt
import Split.LT_lt
import Split.CovariantClass

-- covariantClass_le_of_lt from environment
-- theorem covariantClass_le_of_lt : forall (M : Type.{u_1}) (N : Type.{u_2}) (μ : M -> N -> N) [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.14 : PartialOrder.{u_2} N] [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.17 : CovariantClass.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.24 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.24 : N) => LT.lt.{u_2} N (Preorder.toLT.{u_2} N (PartialOrder.toPreorder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.14)) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.24 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.24)], CovariantClass.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.40 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.40 : N) => LE.le.{u_2} N (Preorder.toLE.{u_2} N (PartialOrder.toPreorder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.14)) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.40 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1117845204._hygCtx._hyg.40)

-- Stub: this file represents the declaration `covariantClass_le_of_lt`.
-- In a full split, the body would be extracted from the environment.
