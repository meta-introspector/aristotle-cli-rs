import Split.Preorder_toLT
import Split.NonUnitalCommRing_toNonUnitalNonAssocCommRing
import Split.CommRing_toNonUnitalCommRing
import Split.AddGroupWithOne_toAddGroup
import Split.LinearOrder
import Split.PartialOrder_toPreorder
import Split.HSub_hSub
import Split.IsStrictOrderedRing
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.Exists
import Split.SemilatticeInf_toPartialOrder
import Split.GE_ge
import Split.DistribLattice_toLattice
import Split.NonUnitalNonAssocRing_toNonUnitalNonAssocSemiring
import Split.instLENat
import Split.Field_toSemifield
import Split.Field_toCommRing
import Split.SubNegMonoid_toSub
import Split.instHSub
import Split.Semifield_toDivisionSemiring
import Split.AddGroup_toSubNegMonoid
import Split.Nat_instPreorder
import Split.Nat
import Split.NonUnitalNonAssocCommRing_toNonUnitalNonAssocRing
import Split.LT_lt
import Split.IsCauSeq_cauchy₂
import Split.IsAbsoluteValue
import Split.Exists_intro
import Split.DivisionSemiring_toSemiring
import Split.Zero_toOfNat0
import Split.OfNat_ofNat
import Split.IsCauSeq
import Split.Ring_toSemiring
import Split.Field
import Split.Ring
import Split.Ring_toAddGroupWithOne
import Split.instDistribLatticeOfLinearOrder
import Split.MulZeroClass_toZero
import Split.Lattice_toSemilatticeInf
import Split.le_trans

-- IsCauSeq.cauchy₃ from environment
-- theorem IsCauSeq.cauchy₃ : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.4 : Field.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.7 : LinearOrder.{u_1} α] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.10 : IsStrictOrderedRing.{u_1} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.7))))] [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.13 : Ring.{u_2} β] {abv : β -> α} [inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.19 : IsAbsoluteValue.{u_1, u_2} α (DivisionSemiring.toSemiring.{u_1} α (Semifield.toDivisionSemiring.{u_1} α (Field.toSemifield.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.4))) (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.7)))) β (Ring.toSemiring.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.13) abv] {f : Nat -> β}, (IsCauSeq.{u_1, u_2} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.4 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.7 inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.10 β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.13 abv f) -> (forall {ε : α}, (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.7)))))) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α (MulZeroClass.toZero.{u_1} α (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} α (NonUnitalNonAssocRing.toNonUnitalNonAssocSemiring.{u_1} α (NonUnitalNonAssocCommRing.toNonUnitalNonAssocRing.{u_1} α (NonUnitalCommRing.toNonUnitalNonAssocCommRing.{u_1} α (CommRing.toNonUnitalCommRing.{u_1} α (Field.toCommRing.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.4))))))))) ε) -> (Exists.{1} Nat (fun (i : Nat) => forall (j : Nat), (GE.ge.{0} Nat instLENat j i) -> (forall (k : Nat), (GE.ge.{0} Nat instLENat k j) -> (LT.lt.{u_1} α (Preorder.toLT.{u_1} α (PartialOrder.toPreorder.{u_1} α (SemilatticeInf.toPartialOrder.{u_1} α (Lattice.toSemilatticeInf.{u_1} α (DistribLattice.toLattice.{u_1} α (instDistribLatticeOfLinearOrder.{u_1} α inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.7)))))) (abv (HSub.hSub.{u_2, u_2, u_2} β β β (instHSub.{u_2} β (SubNegMonoid.toSub.{u_2} β (AddGroup.toSubNegMonoid.{u_2} β (AddGroupWithOne.toAddGroup.{u_2} β (Ring.toAddGroupWithOne.{u_2} β inst._@.Mathlib.Algebra.Order.CauSeq.Basic.87657777._hygCtx._hyg.13))))) (f k) (f j))) ε)))))

-- Stub: this file represents the declaration `IsCauSeq.cauchy₃`.
-- In a full split, the body would be extracted from the environment.
