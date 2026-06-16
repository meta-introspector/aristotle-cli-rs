import Split.Iff_mpr
import Split.AddGroup_toSubtractionMonoid
import Split.Lattice
import Split.NegZeroClass_toNeg
import Split.Lattice_toSemilatticeSup
import Split.abs
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.AddLeftMono
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.AddZeroClass_toAddZero
import Split.SemilatticeSup_toMax
import Split.neg_nonpos
import Split.sup_eq_left
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.LE_le
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.AddGroup
import Split.AddGroup_toSubNegMonoid
import Split.Max_max
import Split.AddZero_toAdd
import Split.Zero_toOfNat0
import Split.SemilatticeSup_toPartialOrder
import Split.LE_le_trans
import Split.SubNegMonoid_toAddMonoid
import Split.OfNat_ofNat
import Split.NegZeroClass_toZero
import Split.Eq
import Split.Neg_neg
import Split.Lattice_toSemilatticeInf

-- abs_of_nonneg from environment
-- theorem abs_of_nonneg : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.3 : Lattice.{u_1} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.6 : AddGroup.{u_1} α] {a : α} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.11 : AddLeftMono.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.6))))) (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.3))))], (LE.le.{u_1} α (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.3)))) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (NegZeroClass.toZero.{u_1} α (SubNegZeroMonoid.toNegZeroClass.{u_1} α (SubtractionMonoid.toSubNegZeroMonoid.{u_1} α (AddGroup.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.6)))))) a) -> (Eq.{succ u_1} α (abs.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.291361427._hygCtx._hyg.6 a) a)

-- Stub: this file represents the declaration `abs_of_nonneg`.
-- In a full split, the body would be extracted from the environment.
