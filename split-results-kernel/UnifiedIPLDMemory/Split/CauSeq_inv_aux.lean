import Split.Preorder_toLT
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.CauSeq_abv_pos_of_not_limZero
import Split.GroupWithZero_toDivisionMonoid
import Split.le_rfl
import Split.CommRing_toNonUnitalCommRing
import Split.DivInvOneMonoid_toInvOneClass
import Split.AddGroupWithOne_toAddGroup
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.HSub_hSub
import Split.IsStrictOrderedRing
import Split.DivisionSemiring_toGroupWithZero
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Preorder_toLE
import Split.DivisionMonoid_toDivInvOneMonoid
import Split.Exists
import Split.SemilatticeInf_toPartialOrder
import Split.DivisionRing_toDivisionSemiring
import Split.GE_ge
import Split.DistribLattice_toLattice
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.DivisionRing_toRing
import Split.LE_le
import Split.instLENat
import Split.Field_toSemifield
import Split.Field_toCommRing
import Split.SubNegMonoid_toSub
import Split.GT_gt
import Split.And
import Split.instHSub
import Split.Inv_inv
import Split.Semifield_toDivisionSemiring
import Split.AddGroup_toSubNegMonoid
import Split.And_left
import Split.Nat_instPreorder
import Split.Nat
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.LT_lt
import Split.IsAbsoluteValue
import Split.CauSeq
import Split.Exists_intro
import Split.DivisionSemiring_toSemiring
import Split.Zero_toOfNat0
import Split.DivisionRing
import Split.InvOneClass_toInv
import Split.exists_forall_ge_and
import Split.OfNat_ofNat
import Split.Subtype_val
import Split.LinearOrder_toPartialOrder
import Split.IsCauSeq
import Split.Field
import Split.CauSeq_LimZero
import Split.Ring_toAddGroupWithOne
import Split.Not
import Split.instDistribLatticeOfLinearOrder
import Split.rat_inv_continuous_lemma
import Split.MulZeroClass_toZero
import Split.Lattice_toSemilatticeInf
import Split.CauSeq_cauchy₃
import Split.Nat_instLinearOrder

-- CauSeq.inv_aux from environment
-- theorem CauSeq.inv_aux : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13 : DivisionRing.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7)))) β (DivisionSemiring.toSemiring.{u_2} β (DivisionRing.toDivisionSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13)) abv] {f : CauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.10 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13) abv}, (Not (CauSeq.LimZero.{u_1, u_2} α β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.10 (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13) abv f)) -> (forall (ε : α), (GT.gt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7)))))) ε (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} α (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u_1} α (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u_1} α (CommRing.toNonUnitalCommRing.{u_1} α (Field.toCommRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4)))))))))) -> (Exists.{1} Nat (fun (i : Nat) => forall (j : Nat), (GE.ge.{0} Nat instLENat j i) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7)))))) (abv (HSub.hSub.{u_2, u_2, u_2} β β β (instHSub.{u_2} β (SubNegMonoid.toSub.{u_2} β (AddGroup.toSubNegMonoid.{u_2} β (AddGroupWithOne.toAddGroup.{u_2} β (Ring.toAddGroupWithOne.{u_2} β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13)))))) (Inv.inv.{u_2} β (InvOneClass.toInv.{u_2} β (DivInvOneMonoid.toInvOneClass.{u_2} β (DivisionMonoid.toDivInvOneMonoid.{u_2} β (GroupWithZero.toDivisionMonoid.{u_2} β (DivisionSemiring.toGroupWithZero.{u_2} β (DivisionRing.toDivisionSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13)))))) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.10 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13) abv f) f j)) (Inv.inv.{u_2} β (InvOneClass.toInv.{u_2} β (DivInvOneMonoid.toInvOneClass.{u_2} β (DivisionMonoid.toDivInvOneMonoid.{u_2} β (GroupWithZero.toDivisionMonoid.{u_2} β (DivisionSemiring.toGroupWithZero.{u_2} β (DivisionRing.toDivisionSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13)))))) (Subtype.val.{succ u_2} (Nat -> β) (fun (f : Nat -> β) => IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.10 β (DivisionRing.toRing.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.350765176._hygCtx._hyg.13) abv f) f i)))) ε))))

-- Stub: this file represents the declaration `CauSeq.inv_aux`.
-- In a full split, the body would be extracted from the environment.
