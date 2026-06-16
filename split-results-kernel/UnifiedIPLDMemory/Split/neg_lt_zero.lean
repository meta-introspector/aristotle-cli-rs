import Split.AddGroup_toSubtractionMonoid
import Split.NegZeroClass_toNeg
import Split.Left_neg_neg_iff
import Split.AddMonoid_toAddZeroClass
import Split.AddZeroClass_toAddZero
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.AddGroup
import Split.Iff
import Split.AddLeftStrictMono
import Split.AddGroup_toSubNegMonoid
import Split.LT_lt
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.NegZeroClass_toZero
import Split.Neg_neg
import Split.LT

-- neg_lt_zero from environment
-- theorem neg_lt_zero : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.3 : AddGroup.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.6 : LT.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.9 : AddLeftStrictMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.3))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.6] {a : α}, Iff (LT.lt.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.6 (Neg.neg.{u} α (NegZeroClass.toNeg.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.3)))) a) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (NegZeroClass.toZero.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.3))))))) (LT.lt.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.6 (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (NegZeroClass.toZero.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2732858074._hygCtx._hyg.3)))))) a)

-- Stub: this file represents the declaration `neg_lt_zero`.
-- In a full split, the body would be extracted from the environment.
