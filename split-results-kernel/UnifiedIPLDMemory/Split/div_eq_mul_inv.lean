import Split.DivInvMonoid_toInv
import Split.instHDiv
import Split.HMul_hMul
import Split.Monoid_toMulOneClass
import Split.MulOne_toMul
import Split.HDiv_hDiv
import Split.DivInvMonoid_toMonoid
import Split.DivInvMonoid
import Split.MulOneClass_toMulOne
import Split.Inv_inv
import Split.DivInvMonoid_div_eq_mul_inv
import Split.DivInvMonoid_toDiv
import Split.Eq
import Split.instHMul

-- div_eq_mul_inv from environment
-- theorem div_eq_mul_inv : forall {G : Type.{u_1}} [inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3 : DivInvMonoid.{u_1} G] (a : G) (b : G), Eq.{succ u_1} G (HDiv.hDiv.{u_1, u_1, u_1} G G G (instHDiv.{u_1} G (DivInvMonoid.toDiv.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3)) a b) (HMul.hMul.{u_1, u_1, u_1} G G G (instHMul.{u_1} G (MulOne.toMul.{u_1} G (MulOneClass.toMulOne.{u_1} G (Monoid.toMulOneClass.{u_1} G (DivInvMonoid.toMonoid.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3))))) a (Inv.inv.{u_1} G (DivInvMonoid.toInv.{u_1} G inst._@.Mathlib.Algebra.Group.Defs.1234330678._hygCtx._hyg.3) b))

-- Stub: this file represents the declaration `div_eq_mul_inv`.
-- In a full split, the body would be extracted from the environment.
