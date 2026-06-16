import Split.AddGroup_toSubtractionMonoid
import Split.NegZeroClass_toNeg
import Split.AddMonoid_toAddZeroClass
import Split.AddLeftMono
import Split.Left_neg_nonpos_iff
import Split.AddZeroClass_toAddZero
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.LE_le
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.LE
import Split.AddGroup
import Split.Iff
import Split.AddGroup_toSubNegMonoid
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.NegZeroClass_toZero
import Split.Neg_neg

-- neg_nonpos from environment
-- theorem neg_nonpos : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.3 : AddGroup.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.6 : LE.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.9 : AddLeftMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.3))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.6] {a : α}, Iff (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.6 (Neg.neg.{u} α (NegZeroClass.toNeg.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.3)))) a) (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (NegZeroClass.toZero.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.3))))))) (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.6 (OfNat.ofNat.{u} α 0 (Zero.toOfNat0.{u} α (NegZeroClass.toZero.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2056940426._hygCtx._hyg.3)))))) a)

-- Stub: this file represents the declaration `neg_nonpos`.
-- In a full split, the body would be extracted from the environment.
