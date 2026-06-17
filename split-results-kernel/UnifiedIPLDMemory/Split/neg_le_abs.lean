import Split.AddGroup_toSubtractionMonoid
import Split.Lattice
import Split.NegZeroClass_toNeg
import Split.Lattice_toSemilatticeSup
import Split.abs
import Split.PartialOrder_toPreorder
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.le_sup_right
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.LE_le
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.AddGroup
import Split.Neg_neg
import Split.Lattice_toSemilatticeInf

-- neg_le_abs from environment
-- theorem neg_le_abs : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.114736854._hygCtx._hyg.3 : Lattice.{u_1} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.114736854._hygCtx._hyg.6 : AddGroup.{u_1} α] (a : α), LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.114736854._hygCtx._hyg.3)))) (Neg.neg.{u_1} α (NegZeroClass.toNeg.{u_1} α (SubNegZeroMonoid.toNegZeroClass.{u_1} α (SubtractionMonoid.toSubNegZeroMonoid.{u_1} α (AddGroup.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.114736854._hygCtx._hyg.6)))) a) (abs.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.114736854._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.114736854._hygCtx._hyg.6 a)

-- Stub: this file represents the declaration `neg_le_abs`.
-- In a full split, the body would be extracted from the environment.
