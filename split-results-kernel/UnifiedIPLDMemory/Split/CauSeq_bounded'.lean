import Split.IsCauSeq_bounded'
import Split.Preorder_toLT
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.IsStrictOrderedRing
import Split.Exists
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.Field_toSemifield
import Split.GT_gt
import Split.And
import Split.Semifield_toDivisionSemiring
import Split.Nat
import Split.LT_lt
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.Subtype_val
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.instDistribLatticeOfLinearOrder
import Split.Lattice_toSemilatticeInf
import Split.Subtype_property

-- CauSeq.bounded' from environment
-- theorem CauSeq.bounded' : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.13) abv] (f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.13 abv) (x : α), Exists.{succ u_1} α (fun (r : α) => And (GT.gt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.7)))))) r x) (forall (i : Nat), LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.7)))))) (abv (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1881131147._hygCtx._hyg.13 abv f) f i)) r))

-- Stub: this file represents the declaration `CauSeq.bounded'`.
-- In a full split, the body would be extracted from the environment.
