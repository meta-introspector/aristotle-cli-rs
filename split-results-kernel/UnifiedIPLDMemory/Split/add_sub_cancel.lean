import Split.add_sub_assoc
import Split.Eq_mpr
import Split.congrArg
import Split.add_sub_cancel_left
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.AddCommGroup_toAddGroup
import Split.AddZeroClass_toAddZero
import Split.AddCommGroup
import Split.id
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.Eq_symm
import Split.Eq

-- add_sub_cancel from environment
-- theorem add_sub_cancel : forall {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Group.Basic.745717625._hygCtx._hyg.6 : AddCommGroup.{u_3} G] (a : G) (b : G), Eq.{succ u_3} G (HAdd.hAdd.{u_3, u_3, u_3} G G G (instHAdd.{u_3} G (AddZero.toAdd.{u_3} G (AddZeroClass.toAddZero.{u_3} G (AddMonoid.toAddZeroClass.{u_3} G (SubNegMonoid.toAddMonoid.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G (AddCommGroup.toAddGroup.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.745717625._hygCtx._hyg.6))))))) a (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G (AddCommGroup.toAddGroup.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.745717625._hygCtx._hyg.6)))) b a)) b

-- Stub: this file represents the declaration `add_sub_cancel`.
-- In a full split, the body would be extracted from the environment.
