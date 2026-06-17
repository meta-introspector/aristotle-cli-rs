import Split.Eq_mpr
import Split.congrArg
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.sub_eq_add_neg
import Split.HSub_hSub
import Split.AddRightMono
import Split.AddZeroClass_toAddZero
import Split.id
import Split.LE_le
import Split.LE
import Split.SubNegMonoid_toSub
import Split.AddGroup_covconv_swap
import Split.instHAdd
import Split.AddGroup
import Split.Iff
import Split.add_le_add_iff_right
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.neg_add_cancel_right
import Split.SubNegMonoid_toNeg
import Split.propext
import Split.AddZero_toAdd
import Split.SubNegMonoid_toAddMonoid
import Split.Eq_symm
import Split.Eq
import Split.Neg_neg

-- le_sub_iff_add_le from environment
-- theorem le_sub_iff_add_le : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.3 : AddGroup.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.6 : LE.{u} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.9 : AddRightMono.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.3))))) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.6] {a : α} {b : α} {c : α}, Iff (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.6 a (HSub.hSub.{u, u, u} α α α (instHSub.{u} α (SubNegMonoid.toSub.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.3))) c b)) (LE.le.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.6 (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (AddZero.toAdd.{u} α (AddZeroClass.toAddZero.{u} α (AddMonoid.toAddZeroClass.{u} α (SubNegMonoid.toAddMonoid.{u} α (AddGroup.toSubNegMonoid.{u} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Basic.3419424502._hygCtx._hyg.3)))))) a b) c)

-- Stub: this file represents the declaration `le_sub_iff_add_le`.
-- In a full split, the body would be extracted from the environment.
