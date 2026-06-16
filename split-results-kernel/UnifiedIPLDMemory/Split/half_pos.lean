import Split.NonAssocSemiring_toAddCommMonoidWithOne
import Split.Preorder_toLT
import Split.instHDiv
import Split.GroupWithZero_toDivInvMonoid
import Split.NeZero_charZero_one
import Split.PartialOrder_toPreorder
import Split.Nat_instAtLeastTwoHAddOfNat
import Split.IsStrictOrderedRing
import Split.DivisionSemiring_toGroupWithZero
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.PartialOrder
import Split.Semifield
import Split.HDiv_hDiv
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.AddCommMonoidWithOne_toAddMonoidWithOne
import Split.NonUnitalNonAssocSemiring_toAddCommMonoid
import Split.Semifield_toDivisionSemiring
import Split.Distrib_toMul
import Split.PosMulReflectLT
import Split.IsStrictOrderedRing_toIsOrderedRing
import Split.Nat_instNeZeroSucc
import Split.IsStrictOrderedRing_toCharZero
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.LT_lt
import Split.DivInvMonoid_toDiv
import Split.DivisionSemiring_toSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Zero_toOfNat0
import Split.IsOrderedRing_toIsOrderedAddMonoid
import Split.div_pos
import Split.zero_lt_two
import Split.OfNat_ofNat
import Split.IsStrictOrderedRing_toZeroLEOneClass
import Split.Semiring_toNonAssocSemiring
import Split.instOfNatAtLeastTwo
import Split.MulZeroClass_toZero
import Split.IsOrderedAddMonoid_toAddLeftMono

-- half_pos from environment
-- theorem half_pos : forall {α : Type.{u_2}} [inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5 : Semifield.{u_2} α] [inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.8 : PartialOrder.{u_2} α] [inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.11 : PosMulReflectLT.{u_2} α (Distrib.toMul.{u_2} α (NonUnitalNonAssocSemiring.toDistrib.{u_2} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_2} α (Semiring.toNonAssocSemiring.{u_2} α (DivisionSemiring.toSemiring.{u_2} α (Semifield.toDivisionSemiring.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5)))))) (MulZeroClass.toZero.{u_2} α (NonUnitalNonAssocSemiring.toMulZeroClass.{u_2} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_2} α (Semiring.toNonAssocSemiring.{u_2} α (DivisionSemiring.toSemiring.{u_2} α (Semifield.toDivisionSemiring.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5)))))) (PartialOrder.toPreorder.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.8)] {a : α} [inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.25 : IsStrictOrderedRing.{u_2} α (DivisionSemiring.toSemiring.{u_2} α (Semifield.toDivisionSemiring.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5)) inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.8], (LT.lt.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.8)) (OfNat.ofNat.{u_2} α 0 (Zero.toOfNat0.{u_2} α (MulZeroClass.toZero.{u_2} α (NonUnitalNonAssocSemiring.toMulZeroClass.{u_2} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_2} α (Semiring.toNonAssocSemiring.{u_2} α (DivisionSemiring.toSemiring.{u_2} α (Semifield.toDivisionSemiring.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5)))))))) a) -> (LT.lt.{u_2} α (Preorder.toLT.{u_2} α (PartialOrder.toPreorder.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.8)) (OfNat.ofNat.{u_2} α 0 (Zero.toOfNat0.{u_2} α (MulZeroClass.toZero.{u_2} α (NonUnitalNonAssocSemiring.toMulZeroClass.{u_2} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_2} α (Semiring.toNonAssocSemiring.{u_2} α (DivisionSemiring.toSemiring.{u_2} α (Semifield.toDivisionSemiring.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5)))))))) (HDiv.hDiv.{u_2, u_2, u_2} α α α (instHDiv.{u_2} α (DivInvMonoid.toDiv.{u_2} α (GroupWithZero.toDivInvMonoid.{u_2} α (DivisionSemiring.toGroupWithZero.{u_2} α (Semifield.toDivisionSemiring.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5))))) a (OfNat.ofNat.{u_2} α 2 (instOfNatAtLeastTwo.{u_2} α 2 (AddMonoidWithOne.toNatCast.{u_2} α (AddCommMonoidWithOne.toAddMonoidWithOne.{u_2} α (NonAssocSemiring.toAddCommMonoidWithOne.{u_2} α (Semiring.toNonAssocSemiring.{u_2} α (DivisionSemiring.toSemiring.{u_2} α (Semifield.toDivisionSemiring.{u_2} α inst._@.Mathlib.Algebra.Order.Field.Basic.3672462783._hygCtx._hyg.5)))))) (Nat.instAtLeastTwoHAddOfNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))))))

-- Stub: this file represents the declaration `half_pos`.
-- In a full split, the body would be extracted from the environment.
