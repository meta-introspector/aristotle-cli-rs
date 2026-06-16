import Split.Eq_mpr
import Split.SubtractionMonoid_toInvolutiveNeg
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.neg_neg
import Split.id
import Split.SubtractionMonoid_toSubNegMonoid
import Split.AddZero_toZero
import Split.instHAdd
import Split.HAdd_hAdd
import Split.SubtractionMonoid
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.SubNegMonoid_toAddMonoid
import Split.InvolutiveNeg_toNeg
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg
import Split.neg_eq_of_add_eq_zero_right

-- neg_eq_of_add_eq_zero_left from environment
-- theorem neg_eq_of_add_eq_zero_left : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.549748986._hygCtx._hyg.3 : SubtractionMonoid.{u_1} G] {a : G} {b : G}, (Eq.{succ u_1} G (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.549748986._hygCtx._hyg.3)))))) a b) (OfNat.ofNat.{u_1} G 0 (Zero.toOfNat0.{u_1} G (AddZero.toZero.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.549748986._hygCtx._hyg.3)))))))) -> (Eq.{succ u_1} G (Neg.neg.{u_1} G (SubNegMonoid.toNeg.{u_1} G (SubtractionMonoid.toSubNegMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.549748986._hygCtx._hyg.3)) b) a)

-- Stub: this file represents the declaration `neg_eq_of_add_eq_zero_left`.
-- In a full split, the body would be extracted from the environment.
