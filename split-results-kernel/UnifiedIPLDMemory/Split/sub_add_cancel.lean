import Split.Eq_mpr
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddGroup
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.neg_add_cancel_right
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg

-- sub_add_cancel from environment
-- theorem sub_add_cancel : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.4159268353._hygCtx._hyg.3 : AddGroup.{u_1} G] (a : G) (b : G), Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.4159268353._hygCtx._hyg.3)))))) (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.4159268353._hygCtx._hyg.3))) a b) b) a

-- Stub: this file represents the declaration `sub_add_cancel`.
-- In a full split, the body would be extracted from the environment.
