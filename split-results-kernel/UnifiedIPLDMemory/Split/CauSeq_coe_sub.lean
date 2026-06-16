import Split.AddGroupWithOne_toAddGroup
import Split.LinearOrder
import Split.HSub_hSub
import Split.IsStrictOrderedRing
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.Field_toSemifield
import Split.SubNegMonoid_toSub
import Split.instHSub
import Split.Semifield_toDivisionSemiring
import Split.AddGroup_toSubNegMonoid
import Split.CauSeq_instSub
import Split.Nat
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.Pi_instSub
import Split.Subtype_val
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.rfl
import Split.Lattice_toSemilatticeInf

-- CauSeq.coe_sub from environment
-- theorem CauSeq.coe_sub : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13) abv] (f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv) (g : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv), Eq.{succ u_2} (Nat -> β) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv f) (HSub.hSub.{u_2, u_2, u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv) (instHSub.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv) (CauSeq.instSub.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.19)) f g)) (HSub.hSub.{u_2, u_2, u_2} (Nat -> β) (Nat -> β) (Nat -> β) (instHSub.{u_2} (Nat -> β) (Pi.instSub.{0, u_2} Nat (fun (a._@._internal._hyg.0 : Nat) => β) (fun (i : Nat) => SubNegMonoid.toSub.{u_2} β (AddGroup.toSubNegMonoid.{u_2} β (AddGroupWithOne.toAddGroup.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13)))))) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv f) f) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1887138232._hygCtx._hyg.13 abv f) g))

-- Stub: this file represents the declaration `CauSeq.coe_sub`.
-- In a full split, the body would be extracted from the environment.
