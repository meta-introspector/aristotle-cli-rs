import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.Lattice
import Split.NegZeroClass_toNeg
import Split.Lattice_toSemilatticeSup
import Split.le_abs_self
import Split.abs
import Split.congrArg
import Split.AddCommGroup_toAddCommMonoid
import Split.covariant_swap_add_of_covariant_add
import Split.AddMonoid_toAddZeroClass
import Split.add_le_add
import Split.PartialOrder_toPreorder
import Split.AddLeftMono
import Split.Preorder_toLE
import Split.AddCommGroup_toAddGroup
import Split.SemilatticeInf_toPartialOrder
import Split.neg_add
import Split.AddZeroClass_toAddZero
import Split.AddCommGroup
import Split.id
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubtractionMonoid_toSubNegMonoid
import Split.LE_le
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.instHAdd
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.neg_le_abs
import Split.AddZero_toAdd
import Split.sup_le
import Split.SemilatticeSup_toPartialOrder
import Split.SubNegMonoid_toAddMonoid
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.AddCommMonoid_toAddCommSemigroup
import Split.Eq
import Split.Neg_neg
import Split.Lattice_toSemilatticeInf

-- abs_add_le from environment
-- theorem abs_add_le : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.3 : Lattice.{u_1} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.6 : AddCommGroup.{u_1} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.9 : AddLeftMono.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α (AddCommGroup.toAddGroup.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.6)))))) (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.3))))] (a : α) (b : α), LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.3)))) (abs.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.3 (AddCommGroup.toAddGroup.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.6) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α (AddCommGroup.toAddGroup.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.6))))))) a b)) (HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α (AddCommGroup.toAddGroup.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.6))))))) (abs.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.3 (AddCommGroup.toAddGroup.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.6) a) (abs.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.3 (AddCommGroup.toAddGroup.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.2026507646._hygCtx._hyg.6) b))

-- Stub: this file represents the declaration `abs_add_le`.
-- In a full split, the body would be extracted from the environment.
