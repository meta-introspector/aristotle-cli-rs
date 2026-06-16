import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.PartialOrder
import Split.Distrib_toAdd
import Split.LE_le
import Split.instHAdd
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.IsAbsoluteValue
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Semiring_toNonAssocSemiring

-- IsAbsoluteValue.abv_add' from environment
-- theorem IsAbsoluteValue.abv_add' : forall {S : Type.{u_5}} {inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11 : Semiring.{u_5} S} {inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14 : PartialOrder.{u_5} S} {R : Type.{u_6}} {inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18 : Semiring.{u_6} R} {f : R -> S} [self : IsAbsoluteValue.{u_5, u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14 R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18 f] (x : R) (y : R), LE.le.{u_5} S (Preorder.toLE.{u_5} S (PartialOrder.toPreorder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14)) (f (HAdd.hAdd.{u_6, u_6, u_6} R R R (instHAdd.{u_6} R (Distrib.toAdd.{u_6} R (NonUnitalNonAssocSemiring.toDistrib.{u_6} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} R (Semiring.toNonAssocSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18))))) x y)) (HAdd.hAdd.{u_5, u_5, u_5} S S S (instHAdd.{u_5} S (Distrib.toAdd.{u_5} S (NonUnitalNonAssocSemiring.toDistrib.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11))))) (f x) (f y))

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_add'`.
-- In a full split, the body would be extracted from the environment.
