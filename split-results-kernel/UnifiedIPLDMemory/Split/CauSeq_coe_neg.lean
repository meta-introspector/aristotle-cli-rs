import Split.NegZeroClass_toNeg
import Split.Pi_instNeg
import Split.CauSeq_instNeg
import Split.LinearOrder
import Split.IsStrictOrderedRing
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.Field_toSemifield
import Split.Semifield_toDivisionSemiring
import Split.Ring_toAddCommGroup
import Split.Nat
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.Subtype_val
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.instDistribLatticeOfLinearOrder
import Split.Neg_neg
import Split.rfl
import Split.Lattice_toSemilatticeInf

-- CauSeq.coe_neg from environment
-- theorem CauSeq.coe_neg : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13) abv] (f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13 abv), Eq.{succ u_2} (Nat -> β) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13 abv f) (Neg.neg.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13 abv) (CauSeq.instNeg.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.19) f)) (Neg.neg.{u_2} (Nat -> β) (Pi.instNeg.{0, u_2} Nat (fun (a._@._internal._hyg.0 : Nat) => β) (fun (i : Nat) => NegZeroClass.toNeg.{u_2} β (SubNegZeroMonoid.toNegZeroClass.{u_2} β (SubtractionMonoid.toSubNegZeroMonoid.{u_2} β (SubtractionCommMonoid.toSubtractionMonoid.{u_2} β (AddCommGroup.toDivisionAddCommMonoid.{u_2} β (Ring.toAddCommGroup.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13))))))) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2490041572._hygCtx._hyg.13 abv f) f))

-- Stub: this file represents the declaration `CauSeq.coe_neg`.
-- In a full split, the body would be extracted from the environment.
