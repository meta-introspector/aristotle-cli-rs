import Split.LinearOrder
import Split.IsStrictOrderedRing
import Split.SemilatticeInf_toPartialOrder
import Split.DistribLattice_toLattice
import Split.Pi_instPow
import Split.Field_toSemifield
import Split.Monoid_toPow
import Split.Semifield_toDivisionSemiring
import Split.HPow_hPow
import Split.Nat
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.DivisionSemiring_toSemiring
import Split.instHPow
import Split.CauSeq_instPowNat
import Split.Subtype_val
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Eq
import Split.Field
import Split.Ring
import Split.instDistribLatticeOfLinearOrder
import Split.MonoidWithZero_toMonoid
import Split.rfl
import Split.Lattice_toSemilatticeInf
import Split.Semiring_toMonoidWithZero

-- CauSeq.coe_pow from environment
-- theorem CauSeq.coe_pow : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13) abv] (f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 abv) (n : Nat), Eq.{succ u_2} (Nat -> β) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 abv f) (HPow.hPow.{u_2, 0, u_2} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 abv) Nat (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 abv) (instHPow.{u_2, 0} (CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 abv) Nat (CauSeq.instPowNat.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 abv inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.19)) f n)) (HPow.hPow.{u_2, 0, u_2} (Nat -> β) Nat (Nat -> β) (instHPow.{u_2, 0} (Nat -> β) Nat (Pi.instPow.{0, 0, u_2} Nat Nat (fun (a._@._internal._hyg.0 : Nat) => β) (fun (i : Nat) => Monoid.toPow.{u_2} β (MonoidWithZero.toMonoid.{u_2} β (Semiring.toMonoidWithZero.{u_2} β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13)))))) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.1047833717._hygCtx._hyg.13 abv f) f) n)

-- Stub: this file represents the declaration `CauSeq.coe_pow`.
-- In a full split, the body would be extracted from the environment.
