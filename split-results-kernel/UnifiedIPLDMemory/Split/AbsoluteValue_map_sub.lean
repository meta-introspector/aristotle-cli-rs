import Split.AbsoluteValue_map_neg
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.CommRing
import Split.neg_sub
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.CommRing_toNonUnitalCommRing
import Split.IsOrderedRing
import Split.AddGroupWithOne_toAddGroup
import Split.congrArg
import Split.CommSemiring_toSemiring
import Split.HSub_hSub
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.PartialOrder
import Split.id
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.SubNegMonoid_toSub
import Split.CommRing_toCommSemiring
import Split.NoZeroDivisors
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Distrib_toMul
import Split.Ring_toAddCommGroup
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.AbsoluteValue_funLike
import Split.SubNegMonoid_toNeg
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Eq_refl
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.Eq_symm
import Split.Ring_toSemiring
import Split.Eq
import Split.DFunLike_coe
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.Neg_neg
import Split.MulZeroClass_toZero
import Split.AbsoluteValue

-- AbsoluteValue.map_sub from environment
-- theorem AbsoluteValue.map_sub : forall {R : Type.{u_3}} {S : Type.{u_4}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6 : CommRing.{u_4} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.9 : PartialOrder.{u_4} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.12 : IsOrderedRing.{u_4} S (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.9] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15 : Ring.{u_3} R] (abv : AbsoluteValue.{u_3, u_4} R S (Ring.toSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15) (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.9) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.21 : NoZeroDivisors.{u_4} S (Distrib.toMul.{u_4} S (NonUnitalNonAssocSemiring.toDistrib.{u_4} S (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_4} S (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u_4} S (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u_4} S (CommRing.toNonUnitalCommRing.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6)))))) (MulZeroClass.toZero.{u_4} S (NonUnitalNonAssocSemiring.toMulZeroClass.{u_4} S (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_4} S (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u_4} S (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u_4} S (CommRing.toNonUnitalCommRing.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6))))))] (a : R) (b : R), Eq.{succ u_4} S (DFunLike.coe.{max (succ u_3) (succ u_4), succ u_3, succ u_4} (AbsoluteValue.{u_3, u_4} R S (Ring.toSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15) (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.9) R (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : R) => S) (AbsoluteValue.funLike.{u_3, u_4} R S (Ring.toSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15) (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.9) abv (HSub.hSub.{u_3, u_3, u_3} R R R (instHSub.{u_3} R (SubNegMonoid.toSub.{u_3} R (AddGroup.toSubNegMonoid.{u_3} R (AddGroupWithOne.toAddGroup.{u_3} R (Ring.toAddGroupWithOne.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15))))) a b)) (DFunLike.coe.{max (succ u_3) (succ u_4), succ u_3, succ u_4} (AbsoluteValue.{u_3, u_4} R S (Ring.toSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15) (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.9) R (fun (x._@.Mathlib.Data.FunLike.Basic.2582841819._hygCtx._hyg.11 : R) => S) (AbsoluteValue.funLike.{u_3, u_4} R S (Ring.toSemiring.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15) (CommSemiring.toSemiring.{u_4} S (CommRing.toCommSemiring.{u_4} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.9) abv (HSub.hSub.{u_3, u_3, u_3} R R R (instHSub.{u_3} R (SubNegMonoid.toSub.{u_3} R (AddGroup.toSubNegMonoid.{u_3} R (AddGroupWithOne.toAddGroup.{u_3} R (Ring.toAddGroupWithOne.{u_3} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.2996033385._hygCtx._hyg.15))))) b a))

-- Stub: this file represents the declaration `AbsoluteValue.map_sub`.
-- In a full split, the body would be extracted from the environment.
