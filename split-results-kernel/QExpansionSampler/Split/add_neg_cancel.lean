import Split.Eq_mpr
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.id
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddGroup
import Split.AddGroup_toSubNegMonoid
import Split.neg_add_cancel
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg

-- add_neg_cancel from environment
-- theorem add_neg_cancel : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2232975342._hygCtx._hyg.3 : AddGroup.{u_1} G] (a : G), Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2232975342._hygCtx._hyg.3)))))) a (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2232975342._hygCtx._hyg.3)) a)) (OfNat.ofNat.{u_1} G 0 (Zero.toOfNat0.{u_1} G (AddZero.toZero.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2232975342._hygCtx._hyg.3)))))))

-- Stub: this file represents the declaration `add_neg_cancel`.
-- In a full split, the body would be extracted from the environment.
