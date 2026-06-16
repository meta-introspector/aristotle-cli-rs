import Split.CauSeq_Completion_instInvCauchy
import Split.Eq_mpr
import Split.False
import Split.HMul_hMul
import Split.eq_false
import Split.CauSeq_inv
import Split.congrArg
import Split.LinearOrder
import Split.CauSeq_Completion_Cauchy
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IsStrictOrderedRing
import Split.SemilatticeInf_toPartialOrder
import Split.DivisionRing_toDivisionSemiring
import Split.CauSeq_Completion_instMulCauchy
import Split.Eq_mp
import Split.DistribLattice_toLattice
import Split.id
import Split.Ne
import Split.DivisionRing_toRing
import Split.CauSeq_Completion_mk
import Split.CauSeq_Completion_instZeroCauchy
import Split.Field_toSemifield
import Split.CauSeq_Completion_inv_mk
import Split.Quotient_inductionOn
import Split.CauSeq_instMul
import Split.Quotient_mk
import Split.AddMonoidWithOne_toOne
import Split.CauSeq_mul_inv_cancel
import Split.Inv_inv
import Split.Semifield_toDivisionSemiring
import Split.CauSeq_Completion_instOneCauchy
import Split.True
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.of_eq_true
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.DivisionRing
import Split.congrFun'
import Split.CauSeq_const
import Split.Quotient_sound
import Split.OfNat_ofNat
import Split.not_false_eq_true
import Split.Eq
import Split.Field
import Split.CauSeq_LimZero
import Split.Ring_toAddGroupWithOne
import Split.Not
import Split.instDistribLatticeOfLinearOrder
import Split.Eq_trans
import Split.Lattice_toSemilatticeInf
import Split.instHMul

-- CauSeq.Completion.mul_inv_cancel from environment
-- theorem CauSeq.Completion.mul_inv_cancel : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6))))] {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13 : DivisionRing.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6)))) β (DivisionSemiring.toSemiring.{u_2} β (DivisionRing.toDivisionSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13)) abv] {x : CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19}, (Ne.{succ u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) x (OfNat.ofNat.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) 0 (Zero.toOfNat0.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (CauSeq.Completion.instZeroCauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19)))) -> (Eq.{succ u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (HMul.hMul.{u_2, u_2, u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (instHMul.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (CauSeq.Completion.instMulCauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19)) x (Inv.inv.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (CauSeq.Completion.instInvCauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) x)) (OfNat.ofNat.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) 1 (One.toOfNat1.{u_2} (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19) (CauSeq.Completion.instOneCauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.9 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.13) abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2232975342._hygCtx._hyg.19))))

-- Stub: this file represents the declaration `CauSeq.Completion.mul_inv_cancel`.
-- In a full split, the body would be extracted from the environment.
