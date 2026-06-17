import Split.Preorder_toLT
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Function_comp
import Split.PartialOrder
import Split.LE_le
import Split.And
import Split.And_left
import Split.LT_lt
import Split.contravariant_le_iff_contravariant_lt_and_eq
import Split.Iff_mp
import Split.Contravariant
import Split.Eq

-- contravariant_lt_of_contravariant_le from environment
-- theorem contravariant_lt_of_contravariant_le : forall (M : Type.{u_1}) (N : Type.{u_2}) (μ : M -> N -> N) [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.14 : PartialOrder.{u_2} N], (Contravariant.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.24 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.24 : N) => LE.le.{u_2} N (Preorder.toLE.{u_2} N (PartialOrder.toPreorder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.14)) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.24 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.24)) -> (Contravariant.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.40 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.40 : N) => LT.lt.{u_2} N (Preorder.toLT.{u_2} N (PartialOrder.toPreorder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.14)) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.40 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.3663717495._hygCtx._hyg.40))

-- Stub: this file represents the declaration `contravariant_lt_of_contravariant_le`.
-- In a full split, the body would be extracted from the environment.
