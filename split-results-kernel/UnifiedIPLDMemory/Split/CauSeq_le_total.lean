import Split.Iff_mpr
import Split.CauSeq_instLTAbs
import Split.AddGroupWithOne_toAddGroup
import Split.abs
import Split.LinearOrder
import Split.IsAbsoluteValue_abs_isAbsoluteValue
import Split.IsStrictOrderedRing
import Split.Field_toDivisionRing
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.CauSeq_instLEAbs
import Split.DivisionRing_toRing
import Split.LE_le
import Split.Field_toSemifield
import Split.Semifield_toDivisionSemiring
import Split.HasEquiv_Equiv
import Split.LT_lt
import Split.instHasEquivOfSetoid
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.Or_inl
import Split.Or
import Split.CauSeq_lt_total
import Split.Or_imp_right
import Split.Field
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.or_assoc
import Split.Lattice_toSemilatticeInf

-- CauSeq.le_total from environment
-- theorem CauSeq.le_total : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7))))] (f : CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)))))) (g : CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)))))), Or (LE.le.{u_1} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)))))) (CauSeq.instLEAbs.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.10) f g) (LE.le.{u_1} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4)))))) (CauSeq.instLEAbs.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.477940745._hygCtx._hyg.10) g f)

-- Stub: this file represents the declaration `CauSeq.le_total`.
-- In a full split, the body would be extracted from the environment.
