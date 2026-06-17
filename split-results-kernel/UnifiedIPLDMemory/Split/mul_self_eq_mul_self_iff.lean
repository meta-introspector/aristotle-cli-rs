import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocCommSemiring
import Split.NegZeroClass_toNeg
import Split.Commute_mul_self_eq_mul_self_iff
import Split.HMul_hMul
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.NonUnitalNonAssocCommRing
import Split.Iff
import Split.NoZeroDivisors
import Split.Distrib_toMul
import Split.NonUnitalNonAssocCommSemiring_toCommMagma
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Or
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.Eq
import Split.Commute_all
import Split.Neg_neg
import Split.MulZeroClass_toZero
import Split.instHMul

-- mul_self_eq_mul_self_iff from environment
-- theorem mul_self_eq_mul_self_iff : forall {R : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Commute.2333815254._hygCtx._hyg.3 : NonUnitalNonAssocCommRing.{u} R] [inst._@.Mathlib.Algebra.Ring.Commute.2333815254._hygCtx._hyg.6 : NoZeroDivisors.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815254._hygCtx._hyg.3)))) (MulZeroClass.toZero.{u} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815254._hygCtx._hyg.3))))] {a : R} {b : R}, Iff (Eq.{succ u} R (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815254._hygCtx._hyg.3))))) a a) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815254._hygCtx._hyg.3))))) b b)) (Or (Eq.{succ u} R a b) (Eq.{succ u} R a (Neg.neg.{u} R (NegZeroClass.toNeg.{u} R (SubNegZeroMonoid.toNegZeroClass.{u} R (SubtractionMonoid.toSubNegZeroMonoid.{u} R (SubtractionCommMonoid.toSubtractionMonoid.{u} R (AddCommGroup.toDivisionAddCommMonoid.{u} R (NonUnitalNonAssocRing.toAddCommGroup.{u} R (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815254._hygCtx._hyg.3))))))) b)))

-- Stub: this file represents the declaration `mul_self_eq_mul_self_iff`.
-- In a full split, the body would be extracted from the environment.
