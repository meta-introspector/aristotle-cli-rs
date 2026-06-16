import Split.Eq_mpr
import Split.MulOne_toOne
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Ring_toNonAssocRing
import Split.mul_sub
import Split.AddGroupWithOne_toAddGroup
import Split.congrArg
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.mul_assoc
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.HSub_hSub
import Split.Invertible_invOf
import Split.AddCommGroup_toAddGroup
import Split.SemigroupWithZero_toSemigroup
import Split.invOf_mul_self
import Split.id
import Split.MulOne_toMul
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.mul_invOf_self
import Split.NonAssocSemiring_toMulZeroOneClass
import Split.NonUnitalSemiring_toSemigroupWithZero
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.MulZeroOneClass_toMulOneClass
import Split.SubNegMonoid_toSub
import Split.sub_mul
import Split.AddMonoidWithOne_toOne
import Split.MulOneClass_toMulOne
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Distrib_toMul
import Split.Invertible
import Split.One_toOfNat1
import Split.Semiring_toNonUnitalSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Eq_refl
import Split.mul_one
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.one_mul
import Split.instHMul

-- invOf_sub_invOf from environment
-- theorem invOf_sub_invOf : forall {R : Type.{u_1}} [inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3 : Ring.{u_1} R] (a : R) (b : R) [inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.8 : Invertible.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))) a] [inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.11 : Invertible.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))) b], Eq.{succ u_1} R (HSub.hSub.{u_1, u_1, u_1} R R R (instHSub.{u_1} R (SubNegMonoid.toSub.{u_1} R (AddGroup.toSubNegMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) (Invertible.invOf.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))) a inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.8) (Invertible.invOf.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))) b inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.11)) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3)))))) (HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3)))))) (Invertible.invOf.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))) a inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.8) (HSub.hSub.{u_1, u_1, u_1} R R R (instHSub.{u_1} R (SubNegMonoid.toSub.{u_1} R (AddGroup.toSubNegMonoid.{u_1} R (AddGroupWithOne.toAddGroup.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) b a)) (Invertible.invOf.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} R (NonAssocRing.toNonUnitalNonAssocRing.{u_1} R (Ring.toNonAssocRing.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))))) (AddMonoidWithOne.toOne.{u_1} R (AddGroupWithOne.toAddMonoidWithOne.{u_1} R (Ring.toAddGroupWithOne.{u_1} R inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.3))) b inst._@.Mathlib.Algebra.Ring.Invertible.3231183872._hygCtx._hyg.11))

-- Stub: this file represents the declaration `invOf_sub_invOf`.
-- In a full split, the body would be extracted from the environment.
