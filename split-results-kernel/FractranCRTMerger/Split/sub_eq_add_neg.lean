import Split.SubNegMonoid_sub_eq_add_neg
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.SubNegMonoid
import Split.AddZeroClass_toAddZero
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg

-- sub_eq_add_neg from environment
-- theorem sub_eq_add_neg : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3 : SubNegMonoid.{u_1} G] (a : G) (b : G), Eq.{succ u_1} G (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3)) a b) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3))))) a (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3) b))

-- Stub: this file represents the declaration `sub_eq_add_neg`.
-- In a full split, the body would be extracted from the environment.
