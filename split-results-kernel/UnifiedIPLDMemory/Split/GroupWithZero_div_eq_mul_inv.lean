import Split.GroupWithZero_toMonoidWithZero
import Split.Semigroup_toMul
import Split.instHDiv
import Split.GroupWithZero_toInv
import Split.HMul_hMul
import Split.GroupWithZero
import Split.GroupWithZero_toDiv
import Split.HDiv_hDiv
import Split.Inv_inv
import Split.Monoid_toSemigroup
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.instHMul

-- GroupWithZero.div_eq_mul_inv from environment
-- theorem GroupWithZero.div_eq_mul_inv : forall {G₀ : Type.{u}} [self : GroupWithZero.{u} G₀] (a : G₀) (b : G₀), Eq.{succ u} G₀ (HDiv.hDiv.{u, u, u} G₀ G₀ G₀ (instHDiv.{u} G₀ (GroupWithZero.toDiv.{u} G₀ self)) a b) (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (Semigroup.toMul.{u} G₀ (Monoid.toSemigroup.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self))))) a (Inv.inv.{u} G₀ (GroupWithZero.toInv.{u} G₀ self) b))

-- Stub: this file represents the declaration `GroupWithZero.div_eq_mul_inv`.
-- In a full split, the body would be extracted from the environment.
