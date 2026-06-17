import Split.NegZeroClass_toNeg
import Split.congrArg
import Split.CauSeq_ring
import Split.CauSeq_instNeg
import Split.LinearOrder
import Split.HSub_hSub
import Split.IsStrictOrderedRing
import Split.SemilatticeInf_toPartialOrder
import Split.Eq_mp
import Split.DistribLattice_toLattice
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.Field_toSemifield
import Split.SubNegMonoid_toSub
import Split.neg_sub'
import Split.instHSub
import Split.Semifield_toDivisionSemiring
import Split.HasEquiv_Equiv
import Split.CauSeq_instSub
import Split.Ring_toAddCommGroup
import Split.instHasEquivOfSetoid
import Split.CauSeq_neg_limZero
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.CauSeq_LimZero
import Split.instDistribLatticeOfLinearOrder
import Split.Neg_neg
import Split.Lattice_toSemilatticeInf

-- CauSeq.neg_equiv_neg from environment
-- theorem CauSeq.neg_equiv_neg : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13) abv] {f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv} {g : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv}, (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.19)) f g) -> (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.19)) (Neg.neg.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv) (CauSeq.instNeg.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.19) f) (Neg.neg.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv) (CauSeq.instNeg.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1260660991._hygCtx._hyg.19) g))

-- Stub: this file represents the declaration `CauSeq.neg_equiv_neg`.
-- In a full split, the body would be extracted from the environment.
