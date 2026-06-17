import Split.Eq_mpr
import Split.AddMonoid_toAddSemigroup
import Split.congrArg
import Split.add_assoc
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.id
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.AddGroup
import Split.AddGroup_toSubNegMonoid
import Split.neg_add_cancel
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.add_zero
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- neg_add_cancel_right from environment
-- theorem neg_add_cancel_right : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.3833900851._hygCtx._hyg.3 : AddGroup.{u_1} G] (a : G) (b : G), Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.3833900851._hygCtx._hyg.3)))))) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.3833900851._hygCtx._hyg.3)))))) a (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.3833900851._hygCtx._hyg.3)) b)) b) a

-- Stub: this file represents the declaration `neg_add_cancel_right`.
-- In a full split, the body would be extracted from the environment.
