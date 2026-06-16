import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.SubNegMonoid
import Split.neg_eq_zero_sub
import Split.AddZeroClass_toAddZero
import Split.SubNegMonoid_toSub
import Split.AddZero_toZero
import Split.instHSub
import Split.SubNegMonoid_toNeg
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg

-- zero_sub from environment
-- theorem zero_sub : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.931820224._hygCtx._hyg.3 : SubNegMonoid.{u_1} G] (a : G), Eq.{succ u_1} G (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.931820224._hygCtx._hyg.3)) (OfNat.ofNat.{u_1} G 0 (Zero.toOfNat0.{u_1} G (AddZero.toZero.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.931820224._hygCtx._hyg.3)))))) a) (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.931820224._hygCtx._hyg.3) a)

-- Stub: this file represents the declaration `zero_sub`.
-- In a full split, the body would be extracted from the environment.
