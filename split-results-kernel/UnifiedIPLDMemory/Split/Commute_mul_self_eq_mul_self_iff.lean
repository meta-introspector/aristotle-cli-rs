import Split.AddGroup_toSubtractionMonoid
import Split.NonUnitalNonAssocRing
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.HMul_hMul
import Split.MulZeroClass_toMul
import Split.congrArg
import Split.sub_eq_zero
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.HSub_hSub
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Commute
import Split.AddCommGroup_toAddGroup
import Split.AddZeroClass_toAddZero
import Split.add_eq_zero_iff_eq_neg
import Split.id
import Split.Distrib_toAdd
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.mul_eq_zero
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.Iff
import Split.NoZeroDivisors
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.propext
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Commute_mul_self_sub_mul_self_eq
import Split.Or
import Split.SubNegMonoid_toAddMonoid
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.or_comm
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.NegZeroClass_toZero
import Split.Eq
import Split.Neg_neg
import Split.MulZeroClass_toZero
import Split.instHMul

-- Commute.mul_self_eq_mul_self_iff from environment
-- theorem Commute.mul_self_eq_mul_self_iff : forall {R : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.3 : NonUnitalNonAssocRing.{u} R] [inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.6 : NoZeroDivisors.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.3))) (MulZeroClass.toZero.{u} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.3)))] {a : R} {b : R}, (Commute.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.3))) a b) -> (Iff (Eq.{succ u} R (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.3)))) a a) (HMul.hMul.{u, u, u} R R R (instHMul.{u} R (Distrib.toMul.{u} R (NonUnitalNonAssocSemiring.toDistrib.{u} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.3)))) b b)) (Or (Eq.{succ u} R a b) (Eq.{succ u} R a (Neg.neg.{u} R (NegZeroClass.toNeg.{u} R (SubNegZeroMonoid.toNegZeroClass.{u} R (SubtractionMonoid.toSubNegZeroMonoid.{u} R (SubtractionCommMonoid.toSubtractionMonoid.{u} R (AddCommGroup.toDivisionAddCommMonoid.{u} R (NonUnitalNonAssocRing.toAddCommGroup.{u} R inst._@.Mathlib.Algebra.Ring.Commute.2333815253._hygCtx._hyg.3)))))) b))))

-- Stub: this file represents the declaration `Commute.mul_self_eq_mul_self_iff`.
-- In a full split, the body would be extracted from the environment.
