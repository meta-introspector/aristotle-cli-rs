import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.eq_neg_of_add_eq_zero_left
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.AddZero_toZero
import Split.instHAdd
import Split.AddGroup
import Split.Iff
import Split.AddGroup_toSubNegMonoid
import Split.neg_add_cancel
import Split.HAdd_hAdd
import Split.Iff_intro
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.NegZeroClass_toZero
import Split.Eq
import Split.Neg_neg

-- add_eq_zero_iff_eq_neg from environment
-- theorem add_eq_zero_iff_eq_neg : forall {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Group.Basic.3637055137._hygCtx._hyg.6 : AddGroup.{u_3} G] {a : G} {b : G}, Iff (Eq.{succ u_3} G (HAdd.hAdd.{u_3, u_3, u_3} G G G (instHAdd.{u_3} G (AddZero.toAdd.{u_3} G (AddZeroClass.toAddZero.{u_3} G (AddMonoid.toAddZeroClass.{u_3} G (SubNegMonoid.toAddMonoid.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.3637055137._hygCtx._hyg.6)))))) a b) (OfNat.ofNat.{u_3} G 0 (Zero.toOfNat0.{u_3} G (NegZeroClass.toZero.{u_3} G (SubNegZeroMonoid.toNegZeroClass.{u_3} G (SubtractionMonoid.toSubNegZeroMonoid.{u_3} G (AddGroup.toSubtractionMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.3637055137._hygCtx._hyg.6))))))) (Eq.{succ u_3} G a (Neg.neg.{u_3} G (NegZeroClass.toNeg.{u_3} G (SubNegZeroMonoid.toNegZeroClass.{u_3} G (SubtractionMonoid.toSubNegZeroMonoid.{u_3} G (AddGroup.toSubtractionMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.3637055137._hygCtx._hyg.6)))) b))

-- Stub: this file represents the declaration `add_eq_zero_iff_eq_neg`.
-- In a full split, the body would be extracted from the environment.
