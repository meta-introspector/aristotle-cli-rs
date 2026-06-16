import Split.instHSMul
import Split.instSMulOfMul
import Split.smul_assoc
import Split.Ring_toNonAssocRing
import Split.IsScalarTower
import Split.LinearOrder
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.Pi_isScalarTower'
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IsStrictOrderedRing
import Split.NonUnitalNonAssocSemiring_toDistribSMul
import Split.SemilatticeInf_toPartialOrder
import Split.AddZeroClass_toAddZero
import Split.DistribLattice_toLattice
import Split.Function_hasSMul
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DistribSMul_toSMulZeroClass
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.CauSeq_instMul
import Split.AddZero_toZero
import Split.Semifield_toDivisionSemiring
import Split.Nat
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.CauSeq_instSMul
import Split.HSMul_hSMul
import Split.SMulZeroClass_toSMul
import Split.Pi_smul'
import Split.IsScalarTower_mk
import Split.AddMonoidWithOne_toAddMonoid
import Split.Subtype_val
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.Lattice_toSemilatticeInf
import Split.Subtype_ext

-- CauSeq.instIsScalarTower from environment
-- theorem CauSeq.instIsScalarTower : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13) abv] {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.23 : SMul.{u_3, u_2} G β] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.27 : IsScalarTower.{u_3, u_2, u_2} G β β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.23 (SMulZeroClass.toSMul.{u_2, u_2} β β (AddZero.toZero.{u_2} β (AddZeroClass.toAddZero.{u_2} β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13)))))) (DistribSMul.toSMulZeroClass.{u_2, u_2} β β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13)))) (NonUnitalNonAssocSemiring.toDistribSMul.{u_2} β (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_2} β (NonAssocRing.toNonUnitalNonAssocRing.{u_2} β (Ring.toNonAssocRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13)))))) inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.23], IsScalarTower.{u_3, u_2, u_2} G (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13 abv) (CauSeq.instSMul.{u_1, u_2, u_3} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.19 G inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.23 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.27) (instSMulOfMul.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13 abv) (CauSeq.instMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.19)) (CauSeq.instSMul.{u_1, u_2, u_3} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.19 G inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.23 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.772748180._hygCtx._hyg.27)

-- Stub: this file represents the declaration `CauSeq.instIsScalarTower`.
-- In a full split, the body would be extracted from the environment.
