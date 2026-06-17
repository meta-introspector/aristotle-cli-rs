import Split.CommMonoidWithZero_toCommMonoid
import Split.Semigroup_toMul
import Split.instHDiv
import Split.HMul_hMul
import Split.CommGroupWithZero_toInv
import Split.HDiv_hDiv
import Split.Inv_inv
import Split.CommMonoid_toMonoid
import Split.CommGroupWithZero_toDiv
import Split.CommGroupWithZero
import Split.Monoid_toSemigroup
import Split.CommGroupWithZero_toCommMonoidWithZero
import Split.Eq
import Split.instHMul

-- CommGroupWithZero.div_eq_mul_inv from environment
-- theorem CommGroupWithZero.div_eq_mul_inv : forall {G₀ : Type.{u_2}} [self : CommGroupWithZero.{u_2} G₀] (a : G₀) (b : G₀), Eq.{succ u_2} G₀ (HDiv.hDiv.{u_2, u_2, u_2} G₀ G₀ G₀ (instHDiv.{u_2} G₀ (CommGroupWithZero.toDiv.{u_2} G₀ self)) a b) (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (Semigroup.toMul.{u_2} G₀ (Monoid.toSemigroup.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ (CommGroupWithZero.toCommMonoidWithZero.{u_2} G₀ self)))))) a (Inv.inv.{u_2} G₀ (CommGroupWithZero.toInv.{u_2} G₀ self) b))

-- Stub: this file represents the declaration `CommGroupWithZero.div_eq_mul_inv`.
-- In a full split, the body would be extracted from the environment.
