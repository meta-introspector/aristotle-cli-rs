import Split.HMul_hMul
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.Membership_mem
import Split.Exists
import Split.PartialOrder
import Split.Distrib_toAdd
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.AddSubmonoid
import Split.LE_le
import Split.StarAddMonoid_toInvolutiveStar
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.StarRing_toStarAddMonoid
import Split.instHAdd
import Split.And
import Split.Iff
import Split.StarOrderedRing
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.NonUnitalSemiring
import Split.StarRing
import Split.AddSubmonoid_closure
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.InvolutiveStar_toStar
import Split.AddCommMonoid_toAddMonoid
import Split.Set_range
import Split.AddSubmonoid_instSetLike
import Split.Eq
import Split.SetLike_instMembership
import Split.instHMul
import Split.Star_star

-- StarOrderedRing.mk from environment
-- constructor StarOrderedRing.mk : forall {R : Type.{u_3}} [inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7 : NonUnitalSemiring.{u_3} R] [inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.10 : PartialOrder.{u_3} R] [inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.13 : StarRing.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7)], (forall (x : R) (y : R), Iff (LE.le.{u_3} R (Preorder.toLE.{u_3} R (PartialOrder.toPreorder.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.10)) x y) (Exists.{succ u_3} R (fun (p : R) => And (Membership.mem.{u_3, u_3} R (AddSubmonoid.{u_3} R (AddMonoid.toAddZeroClass.{u_3} R (AddCommMonoid.toAddMonoid.{u_3} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7))))) (SetLike.instMembership.{u_3, u_3} (AddSubmonoid.{u_3} R (AddMonoid.toAddZeroClass.{u_3} R (AddCommMonoid.toAddMonoid.{u_3} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7))))) R (AddSubmonoid.instSetLike.{u_3} R (AddMonoid.toAddZeroClass.{u_3} R (AddCommMonoid.toAddMonoid.{u_3} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7)))))) (AddSubmonoid.closure.{u_3} R (AddMonoid.toAddZeroClass.{u_3} R (AddCommMonoid.toAddMonoid.{u_3} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7)))) (Set.range.{u_3, succ u_3} R R (fun (s : R) => HMul.hMul.{u_3, u_3, u_3} R R R (instHMul.{u_3} R (Distrib.toMul.{u_3} R (NonUnitalNonAssocSemiring.toDistrib.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7)))) (Star.star.{u_3} R (InvolutiveStar.toStar.{u_3} R (StarAddMonoid.toInvolutiveStar.{u_3} R (AddCommMonoid.toAddMonoid.{u_3} R (NonUnitalNonAssocSemiring.toAddCommMonoid.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7))) (StarRing.toStarAddMonoid.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7) inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.13))) s) s))) p) (Eq.{succ u_3} R y (HAdd.hAdd.{u_3, u_3, u_3} R R R (instHAdd.{u_3} R (Distrib.toAdd.{u_3} R (NonUnitalNonAssocSemiring.toDistrib.{u_3} R (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7)))) x p))))) -> (StarOrderedRing.{u_3} R inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.Star.Basic.1310779620._hygCtx._hyg.13)

-- Stub: this file represents the declaration `StarOrderedRing.mk`.
-- In a full split, the body would be extracted from the environment.
