import Split.Eq_mpr
import Split.NonAssocSemiring_toAddCommMonoidWithOne
import Split.instHDiv
import Split.GroupWithZero_toDivInvMonoid
import Split.congrArg
import Split.Nat_instAtLeastTwoHAddOfNat
import Split.DivisionSemiring_toGroupWithZero
import Split.NonUnitalNonAssocSemiring_toMulZeroClass
import Split.id
import Split.Distrib_toAdd
import Split.HDiv_hDiv
import Split.AddMonoidWithOne_toNatCast
import Split.instOfNatNat
import Split.AddCommMonoidWithOne_toAddMonoidWithOne
import Split.DivisionSemiring
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat_instNeZeroSucc
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.DivInvMonoid_toDiv
import Split.DivisionSemiring_toSemiring
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Eq_refl
import Split.NeZero
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.instOfNatAtLeastTwo
import Split.MulZeroClass_toZero
import Split.add_div
import Split.add_self_div_two

-- add_halves from environment
-- theorem add_halves : forall {K : Type.{u_1}} [inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4 : DivisionSemiring.{u_1} K] [inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.11 : NeZero.{u_1} K (MulZeroClass.toZero.{u_1} K (NonUnitalNonAssocSemiring.toMulZeroClass.{u_1} K (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} K (Semiring.toNonAssocSemiring.{u_1} K (DivisionSemiring.toSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4))))) (OfNat.ofNat.{u_1} K 2 (instOfNatAtLeastTwo.{u_1} K 2 (AddMonoidWithOne.toNatCast.{u_1} K (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} K (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} K (Semiring.toNonAssocSemiring.{u_1} K (DivisionSemiring.toSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4))))) (Nat.instAtLeastTwoHAddOfNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))))] (a : K), Eq.{succ u_1} K (HAdd.hAdd.{u_1, u_1, u_1} K K K (instHAdd.{u_1} K (Distrib.toAdd.{u_1} K (NonUnitalNonAssocSemiring.toDistrib.{u_1} K (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} K (Semiring.toNonAssocSemiring.{u_1} K (DivisionSemiring.toSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4)))))) (HDiv.hDiv.{u_1, u_1, u_1} K K K (instHDiv.{u_1} K (DivInvMonoid.toDiv.{u_1} K (GroupWithZero.toDivInvMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4)))) a (OfNat.ofNat.{u_1} K 2 (instOfNatAtLeastTwo.{u_1} K 2 (AddMonoidWithOne.toNatCast.{u_1} K (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} K (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} K (Semiring.toNonAssocSemiring.{u_1} K (DivisionSemiring.toSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4))))) (Nat.instAtLeastTwoHAddOfNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))))) (HDiv.hDiv.{u_1, u_1, u_1} K K K (instHDiv.{u_1} K (DivInvMonoid.toDiv.{u_1} K (GroupWithZero.toDivInvMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4)))) a (OfNat.ofNat.{u_1} K 2 (instOfNatAtLeastTwo.{u_1} K 2 (AddMonoidWithOne.toNatCast.{u_1} K (AddCommMonoidWithOne.toAddMonoidWithOne.{u_1} K (NonAssocSemiring.toAddCommMonoidWithOne.{u_1} K (Semiring.toNonAssocSemiring.{u_1} K (DivisionSemiring.toSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2520004._hygCtx._hyg.4))))) (Nat.instAtLeastTwoHAddOfNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)))))))) a

-- Stub: this file represents the declaration `add_halves`.
-- In a full split, the body would be extracted from the environment.
