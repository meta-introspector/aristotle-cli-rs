import Split.Eq_mpr
import Split.Trans_trans
import Split.sub_add_sub_cancel
import Split.abs
import Split.congrArg
import Split.AddCommGroup_toAddCommMonoid
import Split.LinearOrder
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.HSub_hSub
import Split.Preorder_toLE
import Split.AddCommGroup_toAddGroup
import Split.SemilatticeInf_toPartialOrder
import Split.AddZeroClass_toAddZero
import Split.AddCommGroup
import Split.DistribLattice_toLattice
import Split.id
import Split.LE_le
import Split.instTransEq
import Split.SubNegMonoid_toSub
import Split.instHAdd
import Split.instHSub
import Split.AddGroup_toSubNegMonoid
import Split.HAdd_hAdd
import Split.AddZero_toAdd
import Split.Eq_refl
import Split.abs_add_le
import Split.SubNegMonoid_toAddMonoid
import Split.Eq
import Split.instDistribLatticeOfLinearOrder
import Split.IsOrderedAddMonoid
import Split.Lattice_toSemilatticeInf
import Split.IsOrderedAddMonoid_toAddLeftMono

-- abs_sub_le from environment
-- theorem abs_sub_le : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3 : AddCommGroup.{u_1} G] [inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.6 : LinearOrder.{u_1} G] [inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.9 : IsOrderedAddMonoid.{u_1} G (AddCommGroup.toAddCommMonoid.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3) (PartialOrder.toPreorder.{u_1} G (SemilatticeInf.toPartialOrder.{u_1} G (Lattice.toSemilatticeInf.{u_1} G (DistribLattice.toLattice.{u_1} G (instDistribLatticeOfLinearOrder.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.6)))))] (a : G) (b : G) (c : G), LE.le.{u_1} G (Preorder.toLE.{u_1} G (PartialOrder.toPreorder.{u_1} G (SemilatticeInf.toPartialOrder.{u_1} G (Lattice.toSemilatticeInf.{u_1} G (DistribLattice.toLattice.{u_1} G (instDistribLatticeOfLinearOrder.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.6)))))) (abs.{u_1} G (DistribLattice.toLattice.{u_1} G (instDistribLatticeOfLinearOrder.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.6)) (AddCommGroup.toAddGroup.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3) (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G (AddCommGroup.toAddGroup.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3)))) a c)) (HAdd.hAdd.{u_1, u_1, u_1} G G G (instHAdd.{u_1} G (AddZero.toAdd.{u_1} G (AddZeroClass.toAddZero.{u_1} G (AddMonoid.toAddZeroClass.{u_1} G (SubNegMonoid.toAddMonoid.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G (AddCommGroup.toAddGroup.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3))))))) (abs.{u_1} G (DistribLattice.toLattice.{u_1} G (instDistribLatticeOfLinearOrder.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.6)) (AddCommGroup.toAddGroup.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3) (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G (AddCommGroup.toAddGroup.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3)))) a b)) (abs.{u_1} G (DistribLattice.toLattice.{u_1} G (instDistribLatticeOfLinearOrder.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.6)) (AddCommGroup.toAddGroup.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3) (HSub.hSub.{u_1, u_1, u_1} G G G (instHSub.{u_1} G (SubNegMonoid.toSub.{u_1} G (AddGroup.toSubNegMonoid.{u_1} G (AddCommGroup.toAddGroup.{u_1} G inst._@.Mathlib.Algebra.Order.Group.Abs.1807998173._hygCtx._hyg.3)))) b c)))

-- Stub: this file represents the declaration `abs_sub_le`.
-- In a full split, the body would be extracted from the environment.
