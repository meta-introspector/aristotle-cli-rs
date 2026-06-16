import Split.Eq_mpr
import Split.Preorder_toLT
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.CommRing_toNonUnitalCommRing
import Split.congrArg
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.IsStrictOrderedRing
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Exists
import Split.SemilatticeInf_toPartialOrder
import Split.GE_ge
import Split.Eq_mp
import Split.DistribLattice_toLattice
import Split.id
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.IsAbsoluteValue_abv_zero
import Split.instOfNatNat
import Split.instLENat
import Split.Field_toSemifield
import Split.Field_toCommRing
import Split.GT_gt
import Split.Semifield_toDivisionSemiring
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.LT_lt
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.Exists_intro
import Split.DivisionSemiring_toSemiring
import Split.Zero_toOfNat0
import Split.congrFun'
import Split.OfNat_ofNat
import Split.Subtype_val
import Split.IsCauSeq
import Split.Semiring_toNonAssocSemiring
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.CauSeq_LimZero
import Split.instDistribLatticeOfLinearOrder
import Split.MulZeroClass_toZero
import Split.Lattice_toSemilatticeInf
import Split.CauSeq_instZero

-- CauSeq.zero_limZero from environment
-- theorem CauSeq.zero_limZero : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.13) abv], CauSeq.LimZero.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.13 abv (OfNat.ofNat.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.13 abv) 0 (Zero.toOfNat0.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.13 abv) (CauSeq.instZero.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1579211631._hygCtx._hyg.19)))

-- Stub: this file represents the declaration `CauSeq.zero_limZero`.
-- In a full split, the body would be extracted from the environment.
