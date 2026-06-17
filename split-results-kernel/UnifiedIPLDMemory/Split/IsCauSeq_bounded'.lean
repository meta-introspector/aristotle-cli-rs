import Split.le_max_right
import Split.Preorder_toLT
import Split.Lattice_toSemilatticeSup
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.CommRing_toNonUnitalCommRing
import Split.instIsLeftCancelAddOfAddLeftReflectLE
import Split.lt_add_one
import Split.NeZero_charZero_one
import Split.LinearOrder
import Split.AddMonoid_toAddZeroClass
import Split.PartialOrder_toPreorder
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IsStrictOrderedRing
import Split.Exists
import Split.Field_toDivisionRing
import Split.SemilatticeInf_toPartialOrder
import Split.AddZeroClass_toAddZero
import Split.SemilatticeSup_toMax
import Split.DistribLattice_toLattice
import Split.IsCauSeq_bounded
import Split.Distrib_toAdd
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.IsLeftCancelAdd_addLeftStrictMono_of_addLeftMono
import Split.IsStrictOrderedRing_toIsOrderedCancelAddMonoid
import Split.DivisionRing_toRing
import Split.Field_toSemifield
import Split.Field_toCommRing
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.AddMonoidWithOne_toOne
import Split.GT_gt
import Split.instHAdd
import Split.And
import Split.Semifield_toDivisionSemiring
import Split.IsOrderedCancelAddMonoid_toAddLeftReflectLE
import Split.HAdd_hAdd
import Split.IsStrictOrderedRing_toIsOrderedRing
import Split.Max_max
import Split.IsStrictOrderedRing_toCharZero
import Split.LT_lt_trans_le
import Split.Nat
import Split.And_intro
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.LT_lt
import Split.IsAbsoluteValue
import Split.Exists_intro
import Split.DivisionSemiring_toSemiring
import Split.One_toOfNat1
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.AddZero_toAdd
import Split.IsOrderedRing_toIsOrderedAddMonoid
import Split.AddMonoidWithOne_toAddMonoid
import Split.OfNat_ofNat
import Split.le_max_left
import Split.IsCauSeq
import Split.IsStrictOrderedRing_toZeroLEOneClass
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.Lattice_toSemilatticeInf
import Split.IsOrderedAddMonoid_toAddLeftMono

-- IsCauSeq.bounded' from environment
-- theorem IsCauSeq.bounded' : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.13) abv] {f : Nat -> β}, (IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.13 abv f) -> (forall (x : α), Exists.{succ u_1} α (fun (r : α) => And (GT.gt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.7)))))) r x) (forall (i : Nat), LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131146._hygCtx._hyg.7)))))) (abv (f i)) r)))

-- Stub: this file represents the declaration `IsCauSeq.bounded'`.
-- In a full split, the body would be extracted from the environment.
