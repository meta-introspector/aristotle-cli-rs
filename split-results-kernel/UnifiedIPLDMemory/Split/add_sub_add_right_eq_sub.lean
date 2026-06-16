import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddGroup
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.AddZero_toAdd
import Split.congrFun'
import Split.add_sub_cancel_right
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Eq_trans
import Split.sub_add_eq_sub_sub_swap

-- add_sub_add_right_eq_sub from environment
-- theorem add_sub_add_right_eq_sub : forall {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Group.Basic.3543682158._hygCtx._hyg.6 : AddGroup.{u_3} G] (a : G) (b : G) (c : G), Eq.{succ u_3} G (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.3543682158._hygCtx._hyg.6))) (HAdd.hAdd.{u_3, u_3, u_3} G G G (instHAdd.{u_3} G (AddZero.toAdd.{u_3} G (AddZeroClass.toAddZero.{u_3} G (AddMonoid.toAddZeroClass.{u_3} G (SubNegMonoid.toAddMonoid.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.3543682158._hygCtx._hyg.6)))))) a c) (HAdd.hAdd.{u_3, u_3, u_3} G G G (instHAdd.{u_3} G (AddZero.toAdd.{u_3} G (AddZeroClass.toAddZero.{u_3} G (AddMonoid.toAddZeroClass.{u_3} G (SubNegMonoid.toAddMonoid.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.3543682158._hygCtx._hyg.6)))))) b c)) (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.3543682158._hygCtx._hyg.6))) a b)

-- Stub: this file represents the declaration `add_sub_add_right_eq_sub`.
-- In a full split, the body would be extracted from the environment.
