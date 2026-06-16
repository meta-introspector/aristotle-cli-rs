import Split.CauSeq_mul_equiv_mul
import Split.Eq_mpr
import Split.MulOne_toOne
import Split.Nat_recAux
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.congrArg
import Split.CauSeq_ring
import Split.LinearOrder
import Split.IsStrictOrderedRing
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.id
import Split.MulOne_toMul
import Split.instOfNatNat
import Split.Field_toSemifield
import Split.pow_zero
import Split.Monoid_toPow
import Split.instHAdd
import Split.MulOneClass_toMulOne
import Split.Semifield_toDivisionSemiring
import Split.HPow_hPow
import Split.HAdd_hAdd
import Split.HasEquiv_Equiv
import Split.Nat
import Split.congr
import Split.True
import Split.instHasEquivOfSetoid
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.of_eq_true
import Split.One_toOfNat1
import Split.instAddNat
import Split.instHPow
import Split.CauSeq_instPowNat
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.instDistribLatticeOfLinearOrder
import Split.pow_succ'
import Split.MonoidWithZero_toMonoid
import Split.Eq_trans
import Split.Lattice_toSemilatticeInf
import Split.Semiring_toMonoidWithZero
import Split.instHMul

-- CauSeq.pow_equiv_pow from environment
-- theorem CauSeq.pow_equiv_pow : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13) abv] {f1 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv} {f2 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv}, (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.19)) f1 f2) -> (forall (n : Nat), HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.19)) (HPow.hPow.{u_2, 0, u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) Nat (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) (instHPow.{u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) Nat (CauSeq.instPowNat.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.19)) f1 n) (HPow.hPow.{u_2, 0, u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) Nat (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) (instHPow.{u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv) Nat (CauSeq.instPowNat.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2901898154._hygCtx._hyg.19)) f2 n))

-- Stub: this file represents the declaration `CauSeq.pow_equiv_pow`.
-- In a full split, the body would be extracted from the environment.
