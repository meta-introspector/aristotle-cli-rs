import Split.Eq_mpr
import Split.add_neg_cancel
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubNegMonoid_toSub
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddGroup
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- sub_self from environment
-- theorem sub_self : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.3843423595._hygCtx._hyg.3 : AddGroup.{u_1} G] (a : G), Eq.{succ u_1} G (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.3843423595._hygCtx._hyg.3))) a a) (OfNat.ofNat.{u_1} G 0 (Zero.toOfNat0.{u_1} G (AddZero.toZero.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.3843423595._hygCtx._hyg.3)))))))

-- Stub: this file represents the declaration `sub_self`.
-- In a full split, the body would be extracted from the environment.
