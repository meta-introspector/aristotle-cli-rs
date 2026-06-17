import Split.HMul_hMul
import Split.Ring_toNonAssocRing
import Split.LinearOrder
import Split.IsStrictOrderedRing
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.Field_toSemifield
import Split.NonAssocRing_toNonUnitalNonAssocRing
import Split.CauSeq_instMul
import Split.Semifield_toDivisionSemiring
import Split.Distrib_toMul
import Split.Nat
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Pi_instMul
import Split.Subtype_val
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.instDistribLatticeOfLinearOrder
import Split.rfl
import Split.Lattice_toSemilatticeInf
import Split.instHMul

-- CauSeq.coe_mul from environment
-- theorem CauSeq.coe_mul : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13) abv] (f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv) (g : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv), Eq.{succ u_2} (Nat -> β) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv f) (HMul.hMul.{u_2, u_2, u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv) (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv) (instHMul.{u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv) (CauSeq.instMul.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.19)) f g)) (HMul.hMul.{u_2, u_2, u_2} (Nat -> β) (Nat -> β) (Nat -> β) (instHMul.{u_2} (Nat -> β) (Pi.instMul.{0, u_2} Nat (fun (a._@._internal._hyg.0 : Nat) => β) (fun (i : Nat) => Distrib.toMul.{u_2} β (NonUnitalNonAssocSemiring.toDistrib.{u_2} β (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_2} β (NonAssocRing.toNonUnitalNonAssocRing.{u_2} β (Ring.toNonAssocRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13))))))) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv f) f) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.2598518698._hygCtx._hyg.13 abv f) g))

-- Stub: this file represents the declaration `CauSeq.coe_mul`.
-- In a full split, the body would be extracted from the environment.
