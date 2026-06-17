import Split.instHSMul
import Split.HMul_hMul
import Split.Ring_toNonAssocRing
import Split.IsScalarTower
import Split.LinearOrder
import Split.SMul
import Split.AddMonoid_toAddZeroClass
import Split.AddGroupWithOne_toAddMonoidWithOne
import Split.IsStrictOrderedRing
import Split.NonUnitalNonAssocSemiring_toDistribSMul
import Split.SemilatticeInf_toPartialOrder
import Split.AddZeroClass_toAddZero
import Split.DistribLattice_toLattice
import Split.Function_hasSMul
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DistribSMul_toSMulZeroClass
import Split.SMul_mk
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.CauSeq_instMul
import Split.AddMonoidWithOne_toOne
import Split.AddZero_toZero
import Split.Semifield_toDivisionSemiring
import Split.Nat
import Split.CauSeq_ofEq
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.One_toOfNat1
import Split.HSMul_hSMul
import Split.SMulZeroClass_toSMul
import Split.AddMonoidWithOne_toAddMonoid
import Split.CauSeq_const
import Split.OfNat_ofNat
import Split.Subtype_val
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.Lattice_toSemilatticeInf
import Split.instHMul

-- CauSeq.instSMul from environment
-- def CauSeq.instSMul : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.13) abv] {G : Type.{u_3}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.23 : SMul.{u_3, u_2} G β] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.27 : IsScalarTower.{u_3, u_2, u_2} G β β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.23 (SMulZeroClass.toSMul.{u_2, u_2} β β (AddZero.toZero.{u_2} β (AddZeroClass.toAddZero.{u_2} β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.13)))))) (DistribSMul.toSMulZeroClass.{u_2, u_2} β β (AddMonoid.toAddZeroClass.{u_2} β (AddMonoidWithOne.toAddMonoid.{u_2} β (AddGroupWithOne.toAddMonoidWithOne.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.13)))) (NonUnitalNonAssocSemiring.toDistribSMul.{u_2} β (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_2} β (NonAssocRing.toNonUnitalNonAssocRing.{u_2} β (Ring.toNonAssocRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.13)))))) inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.23], SMul.{u_3, u_2} G (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1097252691._hygCtx._hyg.13 abv)
-- (definition body omitted)

-- Stub: this file represents the declaration `CauSeq.instSMul`.
-- In a full split, the body would be extracted from the environment.
