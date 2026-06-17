import Split.AbsoluteValue_toMulHom
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.PartialOrder
import Split.MulHom_toFun
import Split.Iff
import Split.Distrib_toMul
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Semiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.MulZeroClass_toZero
import Split.AbsoluteValue

-- AbsoluteValue.eq_zero' from environment
-- theorem AbsoluteValue.eq_zero' : forall {R : Type.{u_5}} {S : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12 : Semiring.{u_5} R] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15 : Semiring.{u_6} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.18 : PartialOrder.{u_6} S] (self : AbsoluteValue.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.18) (x : R), Iff (Eq.{succ u_6} S (MulHom.toFun.{u_5, u_6} R S (Distrib.toMul.{u_5} R (NonUnitalNonAssocSemiring.toDistrib.{u_5} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} R (Semiring.toNonAssocSemiring.{u_5} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12)))) (Distrib.toMul.{u_6} S (NonUnitalNonAssocSemiring.toDistrib.{u_6} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15)))) (AbsoluteValue.toMulHom.{u_5, u_6} R S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15 inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.18 self) x) (OfNat.ofNat.{u_6} S 0 (Zero.toOfNat0.{u_6} S (MulZeroClass.toZero.{u_6} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_6} S (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_6} S (Semiring.toNonAssocSemiring.{u_6} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.15))))))) (Eq.{succ u_5} R x (OfNat.ofNat.{u_5} R 0 (Zero.toOfNat0.{u_5} R (MulZeroClass.toZero.{u_5} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_5} R (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_5} R (Semiring.toNonAssocSemiring.{u_5} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.541907590._hygCtx._hyg.12)))))))

-- Stub: this file represents the declaration `AbsoluteValue.eq_zero'`.
-- In a full split, the body would be extracted from the environment.
