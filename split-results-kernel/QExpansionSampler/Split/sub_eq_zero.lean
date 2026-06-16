import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.sub_self
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.eq_of_sub_eq_zero
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubNegMonoid_toSub
import Split.AddZero_toZero
import Split.AddGroup
import Split.Iff
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.Iff_intro
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.NegZeroClass_toZero
import Split.Eq

-- sub_eq_zero from environment
-- theorem sub_eq_zero : forall {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Group.Basic.1964277017._hygCtx._hyg.6 : AddGroup.{u_3} G] {a : G} {b : G}, Iff (Eq.{succ u_3} G (HSub.hSub.{u_3, u_3, u_3} G G G (instHSub.{u_3} G (SubNegMonoid.toSub.{u_3} G (AddGroup.toSubNegMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.1964277017._hygCtx._hyg.6))) a b) (OfNat.ofNat.{u_3} G 0 (Zero.toOfNat0.{u_3} G (NegZeroClass.toZero.{u_3} G (SubNegZeroMonoid.toNegZeroClass.{u_3} G (SubtractionMonoid.toSubNegZeroMonoid.{u_3} G (AddGroup.toSubtractionMonoid.{u_3} G inst._@.Mathlib.Algebra.Group.Basic.1964277017._hygCtx._hyg.6))))))) (Eq.{succ u_3} G a b)

-- Stub: this file represents the declaration `sub_eq_zero`.
-- In a full split, the body would be extracted from the environment.
