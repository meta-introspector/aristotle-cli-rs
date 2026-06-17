import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.SubtractionMonoid_toInvolutiveNeg
import Split.neg_lt_neg_iff
import Split.congrArg
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.AddRightStrictMono
import Split.AddZeroClass_toAddZero
import Split.neg_neg
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.AddGroup
import Split.Iff
import Split.AddLeftStrictMono
import Split.AddGroup_toSubNegMonoid
import Split.LT_lt
import Split.propext
import Split.AddZero_toAdd
import Split.SubNegMonoid_toAddMonoid
import Split.InvolutiveNeg_toNeg
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg
import Split.LT

-- neg_lt from environment
-- theorem neg_lt : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.3 : AddGroup.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.6 : LT.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.9 : AddLeftStrictMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.3))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.6] {a : α} {b : α} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.16 : AddRightStrictMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.3))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.6], Iff (LT.lt.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.6 (Neg.neg.{u} α (NegZeroClass.toNeg.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.3)))) a) b) (LT.lt.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.6 (Neg.neg.{u} α (NegZeroClass.toNeg.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1494747286._hygCtx._hyg.3)))) b) a)

-- Stub: this file represents the declaration `neg_lt`.
-- In a full split, the body would be extracted from the environment.
