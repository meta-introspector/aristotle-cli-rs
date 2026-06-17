import Split.Eq_mpr
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.SubNegMonoid
import Split.AddZeroClass_toAddZero
import Split.id
import Split.zero_add
import Split.SubNegMonoid_toSub
import Split.AddZero_toZero
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.Eq
import Split.Neg_neg

-- neg_eq_zero_sub from environment
-- theorem neg_eq_zero_sub : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2284685214._hygCtx._hyg.3 : SubNegMonoid.{u_1} G] (x : G), Eq.{succ u_1} G (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2284685214._hygCtx._hyg.3) x) (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2284685214._hygCtx._hyg.3)) (OfNat.ofNat.{u_1} G 0 (Zero.toOfNat0.{u_1} G (AddZero.toZero.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2284685214._hygCtx._hyg.3)))))) x)

-- Stub: this file represents the declaration `neg_eq_zero_sub`.
-- In a full split, the body would be extracted from the environment.
