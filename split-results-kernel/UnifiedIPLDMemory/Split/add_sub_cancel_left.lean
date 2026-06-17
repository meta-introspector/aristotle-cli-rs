import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_neg_add
import Split.HSub_hSub
import Split.AddCommGroup_toAddGroup
import Split.AddZeroClass_toAddZero
import Split.AddCommGroup
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.Eq
import Split.neg_add_cancel_left
import Split.Neg_neg

-- add_sub_cancel_left from environment
-- theorem add_sub_cancel_left : forall {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Group.Basic.2194584398._hygCtx._hyg.6 : AddCommGroup.{u_3} G] (a : G) (b : G), Eq.{succ u_3} G (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G (AddCommGroup.toAddGroup.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.2194584398._hygCtx._hyg.6)))) (HAdd.hAdd.{u_3, u_3, u_3} G G G (instHAdd.{u_3} G (AddZero.toAdd.{u_3} G (AddZeroClass.toAddZero.{u_3} G (AddMonoid.toAddZeroClass.{u_3} G (SubNegMonoid.toAddMonoid.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G (AddCommGroup.toAddGroup.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.2194584398._hygCtx._hyg.6))))))) a b) a) b

-- Stub: this file represents the declaration `add_sub_cancel_left`.
-- In a full split, the body would be extracted from the environment.
