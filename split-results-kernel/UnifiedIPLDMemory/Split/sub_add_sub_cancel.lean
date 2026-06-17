import Split.add_sub_assoc
import Split.Eq_mpr
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddGroup
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.Eq_symm
import Split.Eq
import Split.sub_add_cancel

-- sub_add_sub_cancel from environment
-- theorem sub_add_sub_cancel : forall {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Group.Basic.2155370948._hygCtx._hyg.6 : AddGroup.{u_3} G] (a : G) (b : G) (c : G), Eq.{succ u_3} G (HAdd.hAdd.{u_3, u_3, u_3} G G G (instHAdd.{u_3} G (AddZero.toAdd.{u_3} G (AddZeroClass.toAddZero.{u_3} G (AddMonoid.toAddZeroClass.{u_3} G (SubNegMonoid.toAddMonoid.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.2155370948._hygCtx._hyg.6)))))) (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.2155370948._hygCtx._hyg.6))) a b) (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.2155370948._hygCtx._hyg.6))) b c)) (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.2155370948._hygCtx._hyg.6))) a c)

-- Stub: this file represents the declaration `sub_add_sub_cancel`.
-- In a full split, the body would be extracted from the environment.
