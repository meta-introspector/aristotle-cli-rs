import Split.CauSeq_addGroup
import Split.sub_add_sub_cancel
import Split.HMul_hMul
import Split.Ring_toNonAssocRing
import Split.mul_sub
import Split.congrArg
import Split.CauSeq_ring
import Split.LinearOrder
import Split.NonUnitalNonAssocRing_toAddCommGroup
import Split.HSub_hSub
import Split.IsStrictOrderedRing
import Split.AddCommGroup_toAddGroup
import Split.SemilatticeInf_toPartialOrder
import Split.Eq_mp
import Split.DistribLattice_toLattice
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.CauSeq_instMul
import Split.CauSeq_instAdd
import Split.SubNegMonoid_toSub
import Split.sub_mul
import Split.instHAdd
import Split.instHSub
import Split.Semifield_toDivisionSemiring
import Split.CauSeq_mul_limZero_right
import Split.AddGroup_toSubNegMonoid
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.HasEquiv_Equiv
import Split.CauSeq_instSub
import Split.congr
import Split.instHasEquivOfSetoid
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.CauSeq_mul_limZero_left
import Split.CauSeq_add_limZero
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.CauSeq_LimZero
import Split.instDistribLatticeOfLinearOrder
import Split.Eq_trans
import Split.Lattice_toSemilatticeInf
import Split.instHMul

-- CauSeq.mul_equiv_mul from environment
-- theorem CauSeq.mul_equiv_mul : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13) abv] {f1 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv} {f2 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv} {g1 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv} {g2 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv}, (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.19)) f1 f2) -> (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.19)) g1 g2) -> (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.19)) (HMul.hMul.{u_2, u_2, u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (instHMul.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.instMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.19)) f1 g1) (HMul.hMul.{u_2, u_2, u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (instHMul.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv) (CauSeq.instMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.484956367._hygCtx._hyg.19)) f2 g2))

-- Stub: this file represents the declaration `CauSeq.mul_equiv_mul`.
-- In a full split, the body would be extracted from the environment.
