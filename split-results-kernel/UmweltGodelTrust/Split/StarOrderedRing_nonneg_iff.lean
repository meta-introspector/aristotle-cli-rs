import Split.HMul_hMul
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.Membership_mem
import Split.Exists
import Split.PartialOrder
import Split.Distrib_toAdd
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.AddSubmonoid
import Split.LE_le
import Split.StarAddMonoid_toInvolutiveStar
import Split.zero_add
import Split.iff_self
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.StarRing_toStarAddMonoid
import Split.funext
import Split.instHAdd
import Split.And
import Split.Iff
import Split.StarOrderedRing
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.NonUnitalSemiring
import Split.StarRing
import Split.AddSubmonoid_closure
import Split.True
import Split.of_eq_true
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.InvolutiveStar_toStar
import Split.congrFun'
import Split.AddCommMonoid_toAddMonoid
import Split.Set_range
import Split.OfNat_ofNat
import Split.AddSubmonoid_instSetLike
import Split.Eq
import Split.SetLike_instMembership
import Split.Eq_trans
import Split.MulZeroClass_toZero
import Split.instHMul
import Split.Star_star

-- StarOrderedRing.nonneg_iff from environment
-- theorem StarOrderedRing.nonneg_iff : forall {R : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4 : NonUnitalSemiring.{u_1} R] [inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.7 : PartialOrder.{u_1} R] [inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.10 : StarRing.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4)] [inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.13 : StarOrderedRing.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.10] {x : R}, Iff (LE.le.{u_1} R (Preorder.toLE.{u_1} R (PartialOrder.toPreorder.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.7)) (OfNat.ofNat.{u_1} R 0 (Zero.toOfNat0.{u_1} R (MulZeroClass.toZero.{u_1} R (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4))))) x) (Membership.mem.{u_1, u_1} R (AddSubmonoid.{u_1} R (AddMonoid.toAddZeroClass.{u_1} R (AddCommMonoid.toAddMonoid.{u_1} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4))))) (SetLike.instMembership.{u_1, u_1} (AddSubmonoid.{u_1} R (AddMonoid.toAddZeroClass.{u_1} R (AddCommMonoid.toAddMonoid.{u_1} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4))))) R (AddSubmonoid.instSetLike.{u_1} R (AddMonoid.toAddZeroClass.{u_1} R (AddCommMonoid.toAddMonoid.{u_1} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4)))))) (AddSubmonoid.closure.{u_1} R (AddMonoid.toAddZeroClass.{u_1} R (AddCommMonoid.toAddMonoid.{u_1} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4)))) (Set.range.{u_1, succ u_1} R R (fun (s : R) => HMul.hMul.{u_1, u_1, u_1} R R R (instHMul.{u_1} R (Distrib.toMul.{u_1} R (NonUnitalNonAssocSemiring.toDistrib.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4)))) (Star.star.{u_1} R (InvolutiveStar.toStar.{u_1} R (StarAddMonoid.toInvolutiveStar.{u_1} R (AddCommMonoid.toAddMonoid.{u_1} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4))) (StarRing.toStarAddMonoid.{u_1} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_1} R inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.4) inst._@.Mathlib.Algebra.Order.Star.Basic.2024491149._hygCtx._hyg.10))) s) s))) x)

-- Stub: this file represents the declaration `StarOrderedRing.nonneg_iff`.
-- In a full split, the body would be extracted from the environment.
