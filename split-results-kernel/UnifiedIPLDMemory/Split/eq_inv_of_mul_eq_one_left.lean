import Split.MulOne_toOne
import Split.DivInvMonoid_toInv
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.DivisionMonoid
import Split.MulOne_toMul
import Split.DivInvMonoid_toMonoid
import Split.DivisionMonoid_toDivInvMonoid
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.One_toOfNat1
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.instHMul
import Split.inv_eq_of_mul_eq_one_left

-- eq_inv_of_mul_eq_one_left from environment
-- theorem eq_inv_of_mul_eq_one_left : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.2841301240._hygCtx._hyg.3 : DivisionMonoid.{u_1} G] {a : G} {b : G}, (Eq.{succ u_1} G (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (MulOne.toMul.{u_1} G (MulOneClass.toMulOne.{u_1} G (Monoid.toMulOneClass.{u_1} G (DivInvMonoid.toMonoid.{u_1} G (DivisionMonoid.toDivInvMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2841301240._hygCtx._hyg.3)))))) a b) (OfNat.ofNat.{u_1} G 1 (One.toOfNat1.{u_1} G (MulOne.toOne.{u_1} G (MulOneClass.toMulOne.{u_1} G (Monoid.toMulOneClass.{u_1} G (DivInvMonoid.toMonoid.{u_1} G (DivisionMonoid.toDivInvMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2841301240._hygCtx._hyg.3)))))))) -> (Eq.{succ u_1} G a (Inv.inv.{u_1} G (DivInvMonoid.toInv.{u_1} G (DivisionMonoid.toDivInvMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.2841301240._hygCtx._hyg.3)) b))

-- Stub: this file represents the declaration `eq_inv_of_mul_eq_one_left`.
-- In a full split, the body would be extracted from the environment.
