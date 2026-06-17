import Split.False
import Split.Eq_ge
import Split.Preorder_toLT
import Split.lt_irrefl
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.LE_le_antisymm
import Split.LE_le_lt_or_eq
import Split.PartialOrder
import Split.LT_lt_le
import Split.Eq_le
import Split.LE_le
import Split.LE_le_lt_of_ne
import Split.And
import Split.Iff
import Split.And_right
import Split.And_left
import Split.And_intro
import Split.LT_lt
import Split.Iff_intro
import Split.Eq_ndrec
import Split.Contravariant
import Split.Or_elim
import Split.Eq

-- contravariant_le_iff_contravariant_lt_and_eq from environment
-- theorem contravariant_le_iff_contravariant_lt_and_eq : forall (M : Type.{u_1}) (N : Type.{u_2}) (μ : M -> N -> N) [inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.14 : PartialOrder.{u_2} N], Iff (Contravariant.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.26 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.26 : N) => LE.le.{u_2} N (Preorder.toLE.{u_2} N (PartialOrder.toPreorder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.14)) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.26 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.26)) (And (Contravariant.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.45 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.45 : N) => LT.lt.{u_2} N (Preorder.toLT.{u_2} N (PartialOrder.toPreorder.{u_2} N inst._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.14)) x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.45 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.45)) (Contravariant.{u_1, u_2} M N μ (fun (x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.61 : N) (x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.61 : N) => Eq.{succ u_2} N x1._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.61 x2._@.Mathlib.Algebra.Order.Monoid.Unbundled.Defs.1337878955._hygCtx._hyg.61)))

-- Stub: this file represents the declaration `contravariant_le_iff_contravariant_lt_and_eq`.
-- In a full split, the body would be extracted from the environment.
