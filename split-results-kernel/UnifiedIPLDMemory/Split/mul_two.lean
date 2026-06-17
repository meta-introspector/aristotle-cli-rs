import Split.Distrib_leftDistribClass
import Split.Eq_mpr
import Split.NonAssocSemiring_toAddCommMonoidWithOne
import Split.MulOne_toOne
import Split.HMul_hMul
import Split.AddMonoid_toAddSemigroup
import Split.congrArg
import Split.Nat_instAtLeastTwoHAddOfNat
import Split.id
import Split.MulOne_toMul
import Split.Distrib_toAdd
import Split.AddMonoidWithOne_toNatCast
import Split.NonAssocSemiring_toMulZeroOneClass
import Split.instOfNatNat
import Split.AddCommMonoidWithOne_toAddMonoidWithOne
import Split.one_add_one_eq_two
import Split.MulZeroOneClass_toMulOneClass
import Split.AddMonoidWithOne_toOne
import Split.instHAdd
import Split.AddSemigroup_toAdd
import Split.MulOneClass_toMulOne
import Split.NonAssocSemiring
import Split.congrArg₂
import Split.Distrib_toMul
import Split.HAdd_hAdd
import Split.Nat_instNeZeroSucc
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.Nat
import Split.One_toOfNat1
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.Eq_refl
import Split.AddMonoidWithOne_toAddMonoid
import Split.mul_one
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.instOfNatAtLeastTwo
import Split.rfl
import Split.Eq_trans
import Split.left_distrib
import Split.instHMul

-- mul_two from environment
-- theorem mul_two : forall {α : Type.{u}} [inst._@.Mathlib.Algebra.Ring.Defs.2556340985._hygCtx._hyg.4 : NonAssocSemiring.{u} α] (n : α), Eq.{succ u} α (HMul.hMul.{u, u, u} α α α (instHMul.{u} α (Distrib.toMul.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2556340985._hygCtx._hyg.4)))) n (OfNat.ofNat.{u} α 2 (instOfNatAtLeastTwo.{u} α 2 (AddMonoidWithOne.toNatCast.{u} α (AddCommMonoidWithOne.toAddMonoidWithOne.{u} α (NonAssocSemiring.toAddCommMonoidWithOne.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2556340985._hygCtx._hyg.4))) (Nat.instAtLeastTwoHAddOfNat (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) (Nat.instNeZeroSucc (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))))))) (HAdd.hAdd.{u, u, u} α α α (instHAdd.{u} α (Distrib.toAdd.{u} α (NonUnitalNonAssocSemiring.toDistrib.{u} α (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u} α inst._@.Mathlib.Algebra.Ring.Defs.2556340985._hygCtx._hyg.4)))) n n)

-- Stub: this file represents the declaration `mul_two`.
-- In a full split, the body would be extracted from the environment.
