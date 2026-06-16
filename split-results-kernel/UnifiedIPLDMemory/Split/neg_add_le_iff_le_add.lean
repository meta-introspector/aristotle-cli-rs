import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.AddGroup_covconv
import Split.add_neg_cancel_left
import Split.congrArg
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.add_le_add_iff_left
import Split.AddLeftMono
import Split.AddZeroClass_toAddZero
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.LE_le
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.LE
import Split.instHAdd
import Split.AddGroup
import Split.Iff
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.SubNegMonoid_toNeg
import Split.propext
import Split.AddZero_toAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg

-- neg_add_le_iff_le_add from environment
-- theorem neg_add_le_iff_le_add : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.3 : AddGroup.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.6 : LE.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.9 : AddLeftMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.3))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.6] {a : α} {b : α} {c : α}, Iff (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.6 (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.3)))))) (Neg.neg.{u} α (NegZeroClass.toNeg.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (AddGroup.toSubtractionMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.3)))) b) a) c) (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.6 a (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.2430740669._hygCtx._hyg.3)))))) b c))

-- Stub: this file represents the declaration `neg_add_le_iff_le_add`.
-- In a full split, the body would be extracted from the environment.
