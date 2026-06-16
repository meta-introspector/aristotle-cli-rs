import Split.CauSeq_mul_equiv_mul
import Split.Iff_mpr
import Split.instHSMul
import Split.instSMulOfMul
import Split.HMul_hMul
import Split.Ring_toNonAssocRing
import Split.congrArg
import Split.CauSeq_ring
import Split.IsScalarTower
import Split.LinearOrder
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IsStrictOrderedRing
import Split.NonUnitalNonAssocSemiring_toDistribSMul
import Split.SemilatticeInf_toPartialOrder
import Split.AddZeroClass_toAddZero
import Split.Eq_mp
import Split.DistribLattice_toLattice
import Split.MulOne_toMul
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DistribSMul_toSMulZeroClass
import Split.NonAssocSemiring_toMulZeroOneClass
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.CauSeq_instMul
import Split.MulZeroOneClass_toMulOneClass
import Split.CauSeq_const_equiv
import Split.AddMonoidWithOne_toOne
import Split.AddZero_toZero
import Split.MulOneClass_toMulOne
import Split.Semifield_toDivisionSemiring
import Split.HasEquiv_Equiv
import Split.congr
import Split.smul_one_mul
import Split.instHasEquivOfSetoid
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.CauSeq_instSMul
import Split.One_toOfNat1
import Split.Eq_refl
import Split.HSMul_hSMul
import Split.SMulZeroClass_toSMul
import Split.CauSeq_instIsScalarTower
import Split.AddMonoidWithOne_toAddMonoid
import Split.CauSeq_const
import Split.MulOneClass
import Split.OfNat_ofNat
import Split.Semiring_toNonAssocSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.Lattice_toSemilatticeInf
import Split.instHMul

-- CauSeq.smul_equiv_smul from environment
-- theorem CauSeq.smul_equiv_smul : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13) abv] {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.23 : SMul.{u_3, u_2} G β] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.27 : IsScalarTower.{u_3, u_2, u_2} G β β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.23 (SMulZeroClass.toSMul.{u_2, u_2} β β (AddZero.toZero.{u_2} β (AddZeroClass.toAddZero.{u_2} β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13)))))) (DistribSMul.toSMulZeroClass.{u_2, u_2} β β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13)))) (NonUnitalNonAssocSemiring.toDistribSMul.{u_2} β (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_2} β (NonAssocRing.toNonUnitalNonAssocRing.{u_2} β (Ring.toNonAssocRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13)))))) inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.23] {f1 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv} {f2 : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv} (c : G), (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.19)) f1 f2) -> (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.19)) (HSMul.hSMul.{u_3, u_2, u_2} G (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (instHSMul.{u_3, u_2} G (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (CauSeq.instSMul.{u_1, u_2, u_3} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.19 G inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.23 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.27)) c f1) (HSMul.hSMul.{u_3, u_2, u_2} G (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (instHSMul.{u_3, u_2} G (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv) (CauSeq.instSMul.{u_1, u_2, u_3} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.19 G inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.23 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1548299519._hygCtx._hyg.27)) c f2))

-- Stub: this file represents the declaration `CauSeq.smul_equiv_smul`.
-- In a full split, the body would be extracted from the environment.
