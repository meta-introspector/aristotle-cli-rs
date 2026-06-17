import Split.CauSeq_Completion_instInvCauchy
import Split.Eq_mpr
import Split.CauSeq_inv
import Split.Ring_toNonAssocRing
import Split.congrArg
import Split.LinearOrder
import Split.CauSeq_Completion_Cauchy
import Split.IsStrictOrderedRing
import Split.Classical_propDecidable
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.SemilatticeInf_toPartialOrder
import Split.DivisionRing_toDivisionSemiring
import Split.DistribLattice_toLattice
import Split.dif_pos
import Split.id
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DivisionRing_toRing
import Split.CauSeq_Completion_mk
import Split.CauSeq_Completion_instZeroCauchy
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.dite
import Split.congr_arg
import Split.Inv_inv
import Split.Semifield_toDivisionSemiring
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.Zero_toOfNat0
import Split.Eq_refl
import Split.DivisionRing
import Split.CauSeq_const
import Split.OfNat_ofNat
import Split.Eq
import Split.Field
import Split.CauSeq_LimZero
import Split.Not
import Split.instDistribLatticeOfLinearOrder
import Split.CauSeq_zero_limZero
import Split.MulZeroClass_toZero
import Split.Lattice_toSemilatticeInf
import Split.CauSeq_instZero

-- CauSeq.Completion.inv_zero from environment
-- theorem CauSeq.Completion.inv_zero : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6))))] {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13 : DivisionRing.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6)))) β (DivisionSemiring.toSemiring.{u_2} β (DivisionRing.toDivisionSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13)) abv], Eq.{succ u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19) (Inv.inv.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19) (CauSeq.Completion.instInvCauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19) (OfNat.ofNat.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19) 0 (Zero.toOfNat0.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19) (CauSeq.Completion.instZeroCauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19)))) (OfNat.ofNat.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19) 0 (Zero.toOfNat0.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19) (CauSeq.Completion.instZeroCauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.4032076535._hygCtx._hyg.19)))

-- Stub: this file represents the declaration `CauSeq.Completion.inv_zero`.
-- In a full split, the body would be extracted from the environment.
