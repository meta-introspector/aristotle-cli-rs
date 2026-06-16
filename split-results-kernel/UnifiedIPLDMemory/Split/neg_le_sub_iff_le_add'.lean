import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.congrArg
import Split.AddCommGroup_toAddCommMonoid
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.HSub_hSub
import Split.AddLeftMono
import Split.AddCommGroup_toAddGroup
import Split.AddZeroClass_toAddZero
import Split.AddCommGroup
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.LE_le
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.add_comm
import Split.LE
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.Iff
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.propext
import Split.AddZero_toAdd
import Split.AddCommSemigroup_toAddCommMagma
import Split.SubNegMonoid_toAddMonoid
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.AddCommMonoid_toAddCommSemigroup
import Split.neg_le_sub_iff_le_add
import Split.Eq
import Split.Neg_neg
import Split.AddCommMagma_toAdd

-- neg_le_sub_iff_le_add' from environment
-- theorem neg_le_sub_iff_le_add' : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.3 : AddCommGroup.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.6 : LE.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.9 : AddLeftMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.3)))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.6] {a : α} {b : α} {c : α}, Iff (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.6 (Neg.neg.{u} α (NegZeroClass.toNeg.{u} α (SubNegZeroMonoid.toNegZeroClass.{u} α (SubtractionMonoid.toSubNegZeroMonoid.{u} α (SubtractionCommMonoid.toSubtractionMonoid.{u} α (AddCommGroup.toDivisionAddCommMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.3))))) a) (HSub.hSub.{u, u, u} α α α (instHSub.{u} α (SubNegMonoid.toSub.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.3)))) b c)) (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.6 c (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α (AddCommGroup.toAddGroup.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.1435793435._hygCtx._hyg.3))))))) a b))

-- Stub: this file represents the declaration `neg_le_sub_iff_le_add'`.
-- In a full split, the body would be extracted from the environment.
