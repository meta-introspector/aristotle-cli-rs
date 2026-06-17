import Split.AbsoluteValue_toMulHom
import Split.PartialOrder_toPreorder
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.PartialOrder
import Split.LE_le
import Split.MulHom_toFun
import Split.Distrib_toMul
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.MulZeroClass_toZero
import Split.AbsoluteValue

-- AbsoluteValue.nonneg' from environment
-- theorem AbsoluteValue.nonneg' : forall {R : Type.{u_5}} {S : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12 : Semiring.{u_5} R] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15 : Semiring.{u_6} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.18 : PartialOrder.{u_6} S] (self : AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.18) (x : R), LE.le.{u_6} S (Preorder.toLE.{u_6} S (PartialOrder.toPreorder.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.18)) (OfNat.ofNat.{u_6} S 0 (Zero.toOfNat0.{u_6} S (MulZeroClass.toZero.{u_6} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_6} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15)))))) (MulHom.toFun.{u_5, u_6} R S (Distrib.toMul.{u_5} R (NonUnitalNonAssocSemiring.toDistrib.{u_5} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} R (Semiring.toNonAssocSemiring.{u_5} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12)))) (Distrib.toMul.{u_6} S (NonUnitalNonAssocSemiring.toDistrib.{u_6} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15)))) (AbsoluteValue.toMulHom.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.18 self) x)

-- Stub: this file represents the declaration `AbsoluteValue.nonneg'`.
-- In a full split, the body would be extracted from the environment.
