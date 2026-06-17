import Split.HMul_hMul
import Split.PartialOrder_toPreorder
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.PartialOrder
import Split.Distrib_toAdd
import Split.LE_le
import Split.instHAdd
import Split.Iff
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.IsAbsoluteValue
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.MulZeroClass_toZero
import Split.instHMul

-- IsAbsoluteValue.mk from environment
-- constructor IsAbsoluteValue.mk : forall {S : Type.{u_5}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11 : Semiring.{u_5} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14 : PartialOrder.{u_5} S] {R : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18 : Semiring.{u_6} R] {f : R -> S}, (forall (x : R), LE.le.{u_5} S (Preorder.toLE.{u_5} S (PartialOrder.toPreorder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14)) (OfNat.ofNat.{u_5} S 0 (Zero.toOfNat0.{u_5} S (MulZeroClass.toZero.{u_5} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11)))))) (f x)) -> (forall {x : R}, Iff (Eq.{succ u_5} S (f x) (OfNat.ofNat.{u_5} S 0 (Zero.toOfNat0.{u_5} S (MulZeroClass.toZero.{u_5} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11))))))) (Eq.{succ u_6} R x (OfNat.ofNat.{u_6} R 0 (Zero.toOfNat0.{u_6} R (MulZeroClass.toZero.{u_6} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_6} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} R (Semiring.toNonAssocSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18)))))))) -> (forall (x : R) (y : R), LE.le.{u_5} S (Preorder.toLE.{u_5} S (PartialOrder.toPreorder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14)) (f (HAdd.hAdd.{u_6, u_6, u_6} R R R (instHAdd.{u_6} R (Distrib.toAdd.{u_6} R (NonUnitalNonAssocSemiring.toDistrib.{u_6} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} R (Semiring.toNonAssocSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18))))) x y)) (HAdd.hAdd.{u_5, u_5, u_5} S S S (instHAdd.{u_5} S (Distrib.toAdd.{u_5} S (NonUnitalNonAssocSemiring.toDistrib.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11))))) (f x) (f y))) -> (forall (x : R) (y : R), Eq.{succ u_5} S (f (HMul.hMul.{u_6, u_6, u_6} R R R (instHMul.{u_6} R (Distrib.toMul.{u_6} R (NonUnitalNonAssocSemiring.toDistrib.{u_6} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} R (Semiring.toNonAssocSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18))))) x y)) (HMul.hMul.{u_5, u_5, u_5} S S S (instHMul.{u_5} S (Distrib.toMul.{u_5} S (NonUnitalNonAssocSemiring.toDistrib.{u_5} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} S (Semiring.toNonAssocSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11))))) (f x) (f y))) -> (IsAbsoluteValue.{u_5, u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.11 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.14 R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2503809937._hygCtx._hyg.18 f)

-- Stub: this file represents the declaration `IsAbsoluteValue.mk`.
-- In a full split, the body would be extracted from the environment.
