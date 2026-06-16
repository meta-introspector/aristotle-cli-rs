import Split.Eq_mpr
import Split.AddMonoid_toAddSemigroup
import Split.Ring_toNonAssocRing
import Split.AddGroupWithOne_toAddGroup
import Split.congrArg
import Split.add_assoc
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.Preorder_toLE
import Split.AddZeroClass_toAddZero
import Split.PartialOrder
import Split.Eq_mp
import Split.id
import Split.Distrib_toAdd
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.LE_le
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.congr
import Split.IsAbsoluteValue
import Split.SubNegMonoid_toNeg
import Split.IsAbsoluteValue_abv_add
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.AddZero_toAdd
import Split.AddMonoidWithOne_toAddMonoid
import Split.SubNegMonoid_toAddMonoid
import Split.Semiring_toNonAssocSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.Ring
import Split.neg_add_cancel_left
import Split.Ring_toAddGroupWithOne
import Split.Neg_neg
import Split.Eq_trans

-- IsAbsoluteValue.abv_sub_le from environment
-- theorem IsAbsoluteValue.abv_sub_le : forall {S : Type.{u_5}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.7 : Ring.{u_5} S] [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.10 : PartialOrder.{u_5} S] {R : Type.{u_6}} [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.14 : Ring.{u_6} R] (abv : R -> S) [inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.20 : IsAbsoluteValue.{u_5, u_6} S (Ring.toSemiring.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.7) inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.10 R (Ring.toSemiring.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.14) abv] (a : R) (b : R) (c : R), LE.le.{u_5} S (Preorder.toLE.{u_5} S (PartialOrder.toPreorder.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.10)) (abv (HSub.hSub.{u_6, u_6, u_6} R R R (instHSub.{u_6} R (SubNegMonoid.toSub.{u_6} R (AddGroup.toSubNegMonoid.{u_6} R (AddGroupWithOne.toAddGroup.{u_6} R (Ring.toAddGroupWithOne.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.14))))) a c)) (HAdd.hAdd.{u_5, u_5, u_5} S S S (instHAdd.{u_5} S (Distrib.toAdd.{u_5} S (NonUnitalNonAssocSemiring.toDistrib.{u_5} S (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_5} S (NonAssocRing.toNonUnitalNonAssocRing.{u_5} S (Ring.toNonAssocRing.{u_5} S inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.7)))))) (abv (HSub.hSub.{u_6, u_6, u_6} R R R (instHSub.{u_6} R (SubNegMonoid.toSub.{u_6} R (AddGroup.toSubNegMonoid.{u_6} R (AddGroupWithOne.toAddGroup.{u_6} R (Ring.toAddGroupWithOne.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.14))))) a b)) (abv (HSub.hSub.{u_6, u_6, u_6} R R R (instHSub.{u_6} R (SubNegMonoid.toSub.{u_6} R (AddGroup.toSubNegMonoid.{u_6} R (AddGroupWithOne.toAddGroup.{u_6} R (Ring.toAddGroupWithOne.{u_6} R inst._@.Mathlib.Algebra.Order.AbsoluteValue.Basic.3505191226._hygCtx._hyg.14))))) b c)))

-- Stub: this file represents the declaration `IsAbsoluteValue.abv_sub_le`.
-- In a full split, the body would be extracted from the environment.
