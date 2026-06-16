import Split.CauSeq_Pos
import Split.Preorder_toLT
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.IsOrderedRing_toPosMulMono
import Split.HMul_hMul
import Split.CommRing_toNonUnitalCommRing
import Split.MulZeroClass_toMul
import Split.AddGroupWithOne_toAddGroup
import Split.abs
import Split.LinearOrder
import Split.IsAbsoluteValue_abs_isAbsoluteValue
import Split.PartialOrder_toPreorder
import Split.IsStrictOrderedRing
import Split.le_of_lt
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.Exists
import Split.Field_toDivisionRing
import Split.SemilatticeInf_toPartialOrder
import Split.GE_ge
import Split.DistribLattice_toLattice
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DivisionRing_toRing
import Split.LE_le
import Split.instLENat
import Split.Field_toSemifield
import Split.Field_toCommRing
import Split.CauSeq_instMul
import Split.GT_gt
import Split.mul_pos
import Split.And
import Split.Semifield_toDivisionSemiring
import Split.IsStrictOrderedRing_toIsOrderedRing
import Split.mul_le_mul
import Split.Nat
import Split.And_intro
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.CauSeq
import Split.Exists_intro
import Split.DivisionSemiring_toSemiring
import Split.Zero_toOfNat0
import Split.exists_forall_ge_and
import Split.OfNat_ofNat
import Split.Subtype_val
import Split.LinearOrder_toPartialOrder
import Split.IsCauSeq
import Split.Field
import Split.IsStrictOrderedRing_toPosMulStrictMono
import Split.Ring_toAddGroupWithOne
import Split.IsOrderedRing_toMulPosMono
import Split.instDistribLatticeOfLinearOrder
import Split.MulZeroClass_toZero
import Split.Lattice_toSemilatticeInf
import Split.instHMul
import Split.le_trans
import Split.Nat_instLinearOrder

-- CauSeq.mul_pos from environment
-- theorem CauSeq.mul_pos : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7))))] {f : CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)))))} {g : CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)))))}, (CauSeq.Pos.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 f) -> (CauSeq.Pos.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 g) -> (CauSeq.Pos.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 (HMul.hMul.{u_1, u_1, u_1} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)))))) (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)))))) (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)))))) (instHMul.{u_1} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)))))) (CauSeq.instMul.{u_1, u_1} α α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10 (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4))))) (IsAbsoluteValue.abs_isAbsoluteValue.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.4)) inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2407755657._hygCtx._hyg.10))) f g))

-- Stub: this file represents the declaration `CauSeq.mul_pos`.
-- In a full split, the body would be extracted from the environment.
