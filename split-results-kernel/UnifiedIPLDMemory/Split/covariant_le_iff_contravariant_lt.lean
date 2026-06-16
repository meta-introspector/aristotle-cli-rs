import Split.not_le
import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le
import Split.Covariant
import Split.Iff
import Split.not_lt
import Split.LE_le_not_gt
import Split.LT_lt
import Split.Iff_intro
import Split.Iff_mp
import Split.Contravariant
import Split.LT_lt_not_ge
import Split.LinearOrder_toPartialOrder
import Split.Not

-- covariant_le_iff_contravariant_lt from environment
-- theorem covariant_le_iff_contravariant_lt : forall (M : Type.{u_1}) (N : Type.{u_2}) (μ : M -> N -> N) [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.14 : LinearOrder.{u_2} N], Iff (Covariant.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.26 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.26 : N) => LE.le.{u_2} N (Preorder.toLE.{u_2} N (PartialOrder.toPreorder.{u_2} N (LinearOrder.toPartialOrder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.14))) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.26 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.26)) (Contravariant.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.42 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.42 : N) => LT.lt.{u_2} N (Preorder.toLT.{u_2} N (PartialOrder.toPreorder.{u_2} N (LinearOrder.toPartialOrder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.14))) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.42 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1199364884._hygCtx._hyg.42))

-- Stub: this file represents the declaration `covariant_le_iff_contravariant_lt`.
-- In a full split, the body would be extracted from the environment.
