import Split.instHSMul
import Split.Ring_toNonAssocRing
import Split.IsScalarTower
import Split.LinearOrder
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.CauSeq_Completion_Cauchy
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IsStrictOrderedRing
import Split.Quotient_map
import Split.NonUnitalNonAssocSemiring_toDistribSMul
import Split.SemilatticeInf_toPartialOrder
import Split.AddZeroClass_toAddZero
import Split.DistribLattice_toLattice
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DistribSMul_toSMulZeroClass
import Split.SMul_mk
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.AddZero_toZero
import Split.Semifield_toDivisionSemiring
import Split.HasEquiv_Equiv
import Split.instHasEquivOfSetoid
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.CauSeq_instSMul
import Split.HSMul_hSMul
import Split.SMulZeroClass_toSMul
import Split.CauSeq_smul_equiv_smul
import Split.AddMonoidWithOne_toAddMonoid
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.Lattice_toSemilatticeInf

-- CauSeq.Completion.instSMulCauchyOfIsScalarTower from environment
-- def CauSeq.Completion.instSMulCauchyOfIsScalarTower : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.3 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.6 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.9 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.3))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.6))))] {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.3))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.6)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.13) abv] {γ : Type.{u_3}} [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.23 : SMul.{u_3, u_2} γ β] [inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.27 : IsScalarTower.{u_3, u_2, u_2} γ β β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.23 (SMulZeroClass.toSMul.{u_2, u_2} β β (AddZero.toZero.{u_2} β (AddZeroClass.toAddZero.{u_2} β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.13)))))) (DistribSMul.toSMulZeroClass.{u_2, u_2} β β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.13)))) (NonUnitalNonAssocSemiring.toDistribSMul.{u_2} β (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_2} β (NonAssocRing.toNonUnitalNonAssocRing.{u_2} β (Ring.toNonAssocRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.13)))))) inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.23], SMul.{u_3, u_2} γ (CauSeq.Completion.Cauchy.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.3 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.6 inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.9 β inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Completion.2867387005._hygCtx._hyg.19)
-- (definition body omitted)

-- Stub: this file represents the declaration `CauSeq.Completion.instSMulCauchyOfIsScalarTower`.
-- In a full split, the body would be extracted from the environment.
