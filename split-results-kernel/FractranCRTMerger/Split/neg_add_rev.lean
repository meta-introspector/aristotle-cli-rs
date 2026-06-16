import Split.SubtractionMonoid_neg_add_rev
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.SubtractionMonoid_toSubNegMonoid
import Split.instHAdd
import Split.HAdd_hAdd
import Split.SubtractionMonoid
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.Neg_neg

-- neg_add_rev from environment
-- theorem neg_add_rev : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2065109406._hygCtx._hyg.3 : SubtractionMonoid.{u_1} G] (a : G) (b : G), Eq.{succ u_1} G (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2065109406._hygCtx._hyg.3)) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2065109406._hygCtx._hyg.3)))))) a b)) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2065109406._hygCtx._hyg.3)))))) (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2065109406._hygCtx._hyg.3)) b) (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2065109406._hygCtx._hyg.3)) a))

-- Stub: this file represents the declaration `neg_add_rev`.
-- In a full split, the body would be extracted from the environment.
