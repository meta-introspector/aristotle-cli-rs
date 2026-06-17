import Split.Eq_mpr
import Split.SubtractionMonoid_toInvolutiveNeg
import Split.congrArg
import Split.AddMonoid_toAddZeroClass
import Split.neg_injective
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubNegMonoid_toSub
import Split.AddZero_toZero
import Split.instHAdd
import Split.instHSub
import Split.HAdd_hAdd
import Split.SubtractionMonoid
import Split.SubNegMonoid_toNeg
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.InvolutiveNeg_toNeg
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg
import Split.neg_eq_of_add_eq_zero_right

-- eq_of_sub_eq_zero from environment
-- theorem eq_of_sub_eq_zero : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Basic.1198309347._hygCtx._hyg.6 : SubtractionMonoid.{u_1} α] {a : α} {b : α}, (Eq.{succ u_1} α (HSub.hSub.{u_1, u_1, u_1} α α α (instHSub.{u_1} α (SubNegMonoid.toSub.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.1198309347._hygCtx._hyg.6))) a b) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (AddZero.toZero.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (SubtractionMonoid.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Group.Basic.1198309347._hygCtx._hyg.6)))))))) -> (Eq.{succ u_1} α a b)

-- Stub: this file represents the declaration `eq_of_sub_eq_zero`.
-- In a full split, the body would be extracted from the environment.
