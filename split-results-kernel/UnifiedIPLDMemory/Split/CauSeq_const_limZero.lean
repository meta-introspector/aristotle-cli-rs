import Split.Preorder_toLT
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.le_rfl
import Split.CommRing_toNonUnitalCommRing
import Split.Ring_toNonAssocRing
import Split.MulZeroClass_toMul
import Split.IsAbsoluteValue_abv_nonneg
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.IsStrictOrderedRing
import Split.le_of_lt
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.Exists
import Split.SemilatticeInf_toPartialOrder
import Split.Eq_rec
import Split.GE_ge
import Split.DistribLattice_toLattice
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.LE_le
import Split.instLENat
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.Field_toCommRing
import Split.eq_of_le_of_forall_lt_imp_le_of_dense
import Split.Iff
import Split.Semifield_toDivisionSemiring
import Split.Nat_instPreorder
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.LT_lt
import Split.Iff_intro
import Split.IsAbsoluteValue
import Split.Iff_mp
import Split.DivisionSemiring_toSemiring
import Split.Zero_toOfNat0
import Split.PosMulStrictMono_toPosMulReflectLE
import Split.CauSeq_const
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Subtype_val
import Split.LinearOrder_toPartialOrder
import Split.IsCauSeq
import Split.Semiring_toNonAssocSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.IsStrictOrderedRing_toPosMulStrictMono
import Split.CauSeq_LimZero
import Split.instDistribLatticeOfLinearOrder
import Split.CauSeq_zero_limZero
import Split.MulZeroClass_toZero
import Split.Lattice_toSemilatticeInf
import Split.IsAbsoluteValue_abv_eq_zero
import Split.PosMulReflectLE_toPosMulReflectLT
import Split.LinearOrderedSemiField_toDenselyOrdered

-- CauSeq.const_limZero from environment
-- theorem CauSeq.const_limZero : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.13) abv] {x : β}, Iff (CauSeq.LimZero.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.13 abv (CauSeq.const.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.19 x)) (Eq.{succ u_2} β x (OfNat.ofNat.{u_2} β 0 (Zero.toOfNat0.{u_2} β (MulZeroClass.toZero.{u_2} β (NonUnitalNonAssocSemiring.toMulZeroClass.{u_2} β (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_2} β (NonAssocRing.toNonUnitalNonAssocRing.{u_2} β (Ring.toNonAssocRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1121765883._hygCtx._hyg.13))))))))

-- Stub: this file represents the declaration `CauSeq.const_limZero`.
-- In a full split, the body would be extracted from the environment.
