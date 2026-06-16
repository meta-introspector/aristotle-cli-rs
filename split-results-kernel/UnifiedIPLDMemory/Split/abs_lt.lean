import Split.IsRightCancelAdd_addRightStrictMono_of_addRightMono
import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.NegZeroClass_toNeg
import Split.AddGroup_covconv
import Split.Preorder_toLT
import Split.Lattice_toSemilatticeSup
import Split.abs
import Split.congrArg
import Split.instIsLeftCancelAddOfAddLeftReflectLE
import Split.LinearOrder
import Split.Iff_rfl
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.instIsRightCancelAddOfAddRightReflectLE
import Split.AddLeftMono
import Split.Preorder_toLE
import Split.SemilatticeInf_toPartialOrder
import Split.AddRightMono
import Split.AddZeroClass_toAddZero
import Split.SemilatticeSup_toMax
import Split.DistribLattice_toLattice
import Split.id
import Split.IsLeftCancelAdd_addLeftStrictMono_of_addLeftMono
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.max_lt_iff
import Split.LE_le
import Split.and_comm
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.AddGroup_covconv_swap
import Split.And
import Split.AddGroup
import Split.Iff
import Split.AddGroup_toSubNegMonoid
import Split.Max_max
import Split.LT_lt
import Split.propext
import Split.Iff_trans
import Split.AddZero_toAdd
import Split.neg_lt
import Split.SemilatticeSup_toPartialOrder
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.instDistribLatticeOfLinearOrder
import Split.Neg_neg
import Split.Lattice_toSemilatticeInf

-- abs_lt from environment
-- theorem abs_lt : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.3 : AddGroup.{u_1} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.6 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.11 : AddLeftMono.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.3))))) (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.6))))))] {a : α} {b : α} [inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.16 : AddRightMono.{u_1} α (AddZero.toAdd.{u_1} α (AddZeroClass.toAddZero.{u_1} α (AddMonoid.toAddZeroClass.{u_1} α (SubNegMonoid.toAddMonoid.{u_1} α (AddGroup.toSubNegMonoid.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.3))))) (Preorder.toLE.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.6))))))], Iff (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.6)))))) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.6)) inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.3 a) b) (And (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.6)))))) (Neg.neg.{u_1} α (NegZeroClass.toNeg.{u_1} α (SubNegZeroMonoid.toNegZeroClass.{u_1} α (SubtractionMonoid.toSubNegZeroMonoid.{u_1} α (AddGroup.toSubtractionMonoid.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.3)))) b) a) (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.Group.Unbundled.Abs.3792287944._hygCtx._hyg.6)))))) a b))

-- Stub: this file represents the declaration `abs_lt`.
-- In a full split, the body would be extracted from the environment.
