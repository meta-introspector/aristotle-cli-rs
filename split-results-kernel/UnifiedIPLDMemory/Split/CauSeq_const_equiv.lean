import Split.AddGroup_toSubtractionMonoid
import Split.Eq_mpr
import Split.Ring_toNonAssocRing
import Split.AddGroupWithOne_toAddGroup
import Split.congrArg
import Split.sub_eq_zero
import Split.LinearOrder
import Split.Iff_rfl
import Split.HSub_hSub
import Split.IsStrictOrderedRing
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.CauSeq_const_limZero
import Split.id
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.SubtractionMonoid_toSubNegZeroMonoid
import Split.SubNegZeroMonoid_toNegZeroClass
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.SubNegMonoid_toSub
import Split.CauSeq_const_sub
import Split.Iff
import Split.instHSub
import Split.Semifield_toDivisionSemiring
import Split.AddGroup_toSubNegMonoid
import Split.HasEquiv_Equiv
import Split.CauSeq_instSub
import Split.instHasEquivOfSetoid
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.propext
import Split.CauSeq_equiv
import Split.DivisionSemiring_toSemiring
import Split.Zero_toOfNat0
import Split.CauSeq_const
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.NegZeroClass_toZero
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.CauSeq_LimZero
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.MulZeroClass_toZero
import Split.Lattice_toSemilatticeInf

-- CauSeq.const_equiv from environment
-- theorem CauSeq.const_equiv : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.13) abv] {x : β} {y : β}, Iff (HasEquiv.Equiv.{succ u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.13 abv) (instHasEquivOfSetoid.{succ u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.13 abv) (CauSeq.equiv.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.19)) (CauSeq.const.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.19 x) (CauSeq.const.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.3533540084._hygCtx._hyg.19 y)) (Eq.{succ u_2} β x y)

-- Stub: this file represents the declaration `CauSeq.const_equiv`.
-- In a full split, the body would be extracted from the environment.
