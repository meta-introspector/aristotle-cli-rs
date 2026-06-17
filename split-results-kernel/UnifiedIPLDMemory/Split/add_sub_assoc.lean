import Split.Eq_mpr
import Split.AddMonoid_toAddSemigroup
import Split.congrArg
import Split.add_assoc
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.SubNegMonoid
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg

-- add_sub_assoc from environment
-- theorem add_sub_assoc : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2458317242._hygCtx._hyg.3 : SubNegMonoid.{u_1} G] (a : G) (b : G) (c : G), Eq.{succ u_1} G (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2458317242._hygCtx._hyg.3)) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2458317242._hygCtx._hyg.3))))) a b) c) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2458317242._hygCtx._hyg.3))))) a (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2458317242._hygCtx._hyg.3)) b c))

-- Stub: this file represents the declaration `add_sub_assoc`.
-- In a full split, the body would be extracted from the environment.
