import Split.Semigroup_toMul
import Split.DivInvMonoid_toInv
import Split.instHDiv
import Split.HMul_hMul
import Split.HDiv_hDiv
import Split.DivInvMonoid_toMonoid
import Split.DivInvMonoid
import Split.Inv_inv
import Split.Monoid_toSemigroup
import Split.DivInvMonoid_toDiv
import Split.Eq
import Split.instHMul

-- DivInvMonoid.div_eq_mul_inv from environment
-- theorem DivInvMonoid.div_eq_mul_inv : forall {G : Type.{u}} [self : DivInvMonoid.{u} G] (a : G) (b : G), Eq.{succ u} G (HDiv.hDiv.{u, u, u} G G G (instHDiv.{u} G (DivInvMonoid.toDiv.{u} G self)) a b) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G self)))) a (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G self) b))

-- Stub: this file represents the declaration `DivInvMonoid.div_eq_mul_inv`.
-- In a full split, the body would be extracted from the environment.
