import Split.add_mul
import Split.Eq_mpr
import Split.DivInvMonoid_toInv
import Split.instHDiv
import Split.HMul_hMul
import Split.GroupWithZero_toDivInvMonoid
import Split.Monoid_toMulOneClass
import Split.congrArg
import Split.DivisionSemiring_toGroupWithZero
import Split.Distrib_rightDistribClass
import Split.id
import Split.MulOne_toMul
import Split.Distrib_toAdd
import Split.HDiv_hDiv
import Split.DivInvMonoid_toMonoid
import Split.div_eq_mul_inv
import Split.DivisionSemiring
import Split.instHAdd
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.HAdd_hAdd
import Split.NonAssocSemiring_toNonUnitalNonAssocSemiring
import Split.congr
import Split.True
import Split.eq_self
import Split.DivInvMonoid_toDiv
import Split.DivisionSemiring_toSemiring
import Split.of_eq_true
import Split.NonUnitalNonAssocSemiring_toDistrib
import Split.congrFun'
import Split.Semiring_toNonAssocSemiring
import Split.Eq
import Split.Eq_trans
import Split.instHMul

-- add_div from environment
-- theorem add_div : forall {K : Type.{u_1}} [inst._@.Mathlib.Algebra.Field.Basic.2560131580._hygCtx._hyg.4 : DivisionSemiring.{u_1} K] (a : K) (b : K) (c : K), Eq.{succ u_1} K (HDiv.hDiv.{u_1, u_1, u_1} K K K (instHDiv.{u_1} K (DivInvMonoid.toDiv.{u_1} K (GroupWithZero.toDivInvMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2560131580._hygCtx._hyg.4)))) (HAdd.hAdd.{u_1, u_1, u_1} K K K (instHAdd.{u_1} K (Distrib.toAdd.{u_1} K (NonUnitalNonAssocSemiring.toDistrib.{u_1} K (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} K (Semiring.toNonAssocSemiring.{u_1} K (DivisionSemiring.toSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2560131580._hygCtx._hyg.4)))))) a b) c) (HAdd.hAdd.{u_1, u_1, u_1} K K K (instHAdd.{u_1} K (Distrib.toAdd.{u_1} K (NonUnitalNonAssocSemiring.toDistrib.{u_1} K (NonAssocSemiring.toNonUnitalNonAssocSemiring.{u_1} K (Semiring.toNonAssocSemiring.{u_1} K (DivisionSemiring.toSemiring.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2560131580._hygCtx._hyg.4)))))) (HDiv.hDiv.{u_1, u_1, u_1} K K K (instHDiv.{u_1} K (DivInvMonoid.toDiv.{u_1} K (GroupWithZero.toDivInvMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2560131580._hygCtx._hyg.4)))) a c) (HDiv.hDiv.{u_1, u_1, u_1} K K K (instHDiv.{u_1} K (DivInvMonoid.toDiv.{u_1} K (GroupWithZero.toDivInvMonoid.{u_1} K (DivisionSemiring.toGroupWithZero.{u_1} K inst._@.Mathlib.Algebra.Field.Basic.2560131580._hygCtx._hyg.4)))) b c))

-- Stub: this file represents the declaration `add_div`.
-- In a full split, the body would be extracted from the environment.
