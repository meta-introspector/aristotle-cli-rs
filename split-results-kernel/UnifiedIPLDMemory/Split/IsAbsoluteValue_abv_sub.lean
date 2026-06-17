import Split.CommRing
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.CommRing_toNonUnitalCommRing
import Split.IsOrderedRing
import Split.AddGroupWithOne_toAddGroup
import Split.CommSemiring_toSemiring
import Split.HSub_hSub
import Split.IsAbsoluteValue_toAbsoluteValue
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.PartialOrder
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.SubNegMonoid_toSub
import Split.CommRing_toCommSemiring
import Split.NoZeroDivisors
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Distrib_toMul
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.IsAbsoluteValue
import Split.AbsoluteValue_map_sub
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.MulZeroClass_toZero

-- IsAbsoluteValue.abv_sub from environment
-- theorem IsAbsoluteValue.abv_sub : forall {R : Type.{u_3}} {S : Type.{u_4}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.6 : CommRing.{u_4} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.9 : PartialOrder.{u_4} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.12 : IsOrderedRing.{u_4} S (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.9] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.15 : NoZeroDivisors.{u_4} S (Distrib.toMul.{u_4} S (NonUnitalNonAssocSemiring.toDistrib.{u_4} S (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_4} S (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u_4} S (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u_4} S (CommRing.toNonUnitalCommRing.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.6)))))) (MulZeroClass.toZero.{u_4} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_4} S (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_4} S (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u_4} S (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u_4} S (CommRing.toNonUnitalCommRing.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.6))))))] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.18 : Ring.{u_3} R] (abv : R -> S) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.24 : IsAbsoluteValue.{u_4, u_3} S (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.9 R (Ring.toSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.18) abv] (a : R) (b : R), Eq.{succ u_4} S (abv (HSub.hSub.{u_3, u_3, u_3} R R R (instHSub.{u_3} R (SubNegMonoid.toSub.{u_3} R (AddGroup.toSubNegMonoid.{u_3} R (AddGroupWithOne.toAddGroup.{u_3} R (Ring.toAddGroupWithOne.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.18))))) a b)) (abv (HSub.hSub.{u_3, u_3, u_3} R R R (instHSub.{u_3} R (SubNegMonoid.toSub.{u_3} R (AddGroup.toSubNegMonoid.{u_3} R (AddGroupWithOne.toAddGroup.{u_3} R (Ring.toAddGroupWithOne.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2616079255._hygCtx._hyg.18))))) b a))

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_sub`.
-- In a full split, the body would be extracted from the environment.
