import Split.CauSeq_Pos
import Split.CauSeq_instLTAbs
import Split.neg_sub
import Split.AddGroupWithOne_toAddGroup
import Split.abs
import Split.congrArg
import Split.CauSeq_ring
import Split.CauSeq_instNeg
import Split.LinearOrder
import Split.IsAbsoluteValue_abs_isAbsoluteValue
import Split.HSub_hSub
import Split.IsStrictOrderedRing
import Split.Field_toDivisionRing
import Split.SemilatticeInf_toPartialOrder
import Split.Eq_mp
import Split.DistribLattice_toLattice
import Split.DivisionRing_toRing
import Split.SubtractionMonoid_toSubNegMonoid
import Split.SubtractionCommMonoid_toSubtractionMonoid
import Split.Field_toSemifield
import Split.SubNegMonoid_toSub
import Split.instHSub
import Split.Semifield_toDivisionSemiring
import Split.HasEquiv_Equiv
import Split.CauSeq_instSub
import Split.Ring_toAddCommGroup
import Split.Setoid_symm
import Split.LT_lt
import Split.instHasEquivOfSetoid
import Split.SubNegMonoid_toNeg
import Split.CauSeq
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.Or
import Split.AddCommGroup_toDivisionAddCommMonoid
import Split.Or_imp
import Split.CauSeq_trichotomy
import Split.Or_imp_right
import Split.Field
import Split.CauSeq_LimZero
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.Neg_neg
import Split.Lattice_toSemilatticeInf

-- CauSeq.lt_total from environment
-- theorem CauSeq.lt_total : forall {α : Type.{u_1}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7))))] (f : CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)))))) (g : CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)))))), Or (LT.lt.{u_1} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)))))) (CauSeq.instLTAbs.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10) f g) (Or (HasEquiv.Equiv.{succ u_1, 0} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)))))) (instHasEquivOfSetoid.{succ u_1} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)))))) (CauSeq.equiv.{u_1, u_1} α α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4))))) (IsAbsoluteValue.abs_isAbsoluteValue.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10))) f g) (LT.lt.{u_1} (CauSeq.{u_1, u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10 α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)) (abs.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7)) (AddGroupWithOne.toAddGroup.{u_1} α (Ring.toAddGroupWithOne.{u_1} α (DivisionRing.toRing.{u_1} α (Field.toDivisionRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4)))))) (CauSeq.instLTAbs.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.612044720._hygCtx._hyg.10) g f))

-- Stub: this file represents the declaration `CauSeq.lt_total`.
-- In a full split, the body would be extracted from the environment.
