import Split.Eq_mpr
import Split.MulOne_toOne
import Split.HMul_hMul
import Split.Ring_toNonAssocRing
import Split.congrArg
import Split.CauSeq_ring
import Split.CauSeq_instNeg
import Split.LinearOrder
import Split.IsStrictOrderedRing
import Split.neg_one_mul
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.id
import Split.MulOne_toMul
import Split.NonAssocSemiring_toMulZeroOneClass
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.MulZeroOneClass_toMulOneClass
import Split.NonUnitalNonAssocRing_toHasDistribNeg
import Split.MulOneClass_toMulOne
import Split.Semifield_toDivisionSemiring
import Split.CauSeq_mul_limZero_right
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.One_toOfNat1
import Split.HasDistribNeg_toInvolutiveNeg
import Split.InvolutiveNeg_toNeg
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Semiring_toNonAssocSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.CauSeq_LimZero
import Split.instDistribLatticeOfLinearOrder
import Split.Neg_neg
import Split.Lattice_toSemilatticeInf
import Split.instHMul

-- CauSeq.neg_limZero from environment
-- theorem CauSeq.neg_limZero : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.13) abv] {f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.13 abv}, (CauSeq.LimZero.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.13 abv f) -> (CauSeq.LimZero.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.13 abv (Neg.neg.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.13 abv) (CauSeq.instNeg.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1633202238._hygCtx._hyg.19) f))

-- Stub: this file represents the declaration `CauSeq.neg_limZero`.
-- In a full split, the body would be extracted from the environment.
