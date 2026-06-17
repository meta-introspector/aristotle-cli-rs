import Split.CommMonoidWithZero_toCommMonoid
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.CommGroupWithZero_toInv
import Split.Ne
import Split.Inv_inv
import Split.CommMonoid_toMonoid
import Split.CommMonoidWithZero_toZero
import Split.CommGroupWithZero
import Split.Monoid_toSemigroup
import Split.One_toOfNat1
import Split.Zero_toOfNat0
import Split.Monoid_toOne
import Split.CommGroupWithZero_toCommMonoidWithZero
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- CommGroupWithZero.mul_inv_cancel from environment
-- theorem CommGroupWithZero.mul_inv_cancel : forall {G₀ : Type.{u_2}} [self : CommGroupWithZero.{u_2} G₀] (a : G₀), (Ne.{succ u_2} G₀ a (OfNat.ofNat.{u_2} G₀ 0 (Zero.toOfNat0.{u_2} G₀ (CommMonoidWithZero.toZero.{u_2} G₀ (CommGroupWithZero.toCommMonoidWithZero.{u_2} G₀ self))))) -> (Eq.{succ u_2} G₀ (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (Semigroup.toMul.{u_2} G₀ (Monoid.toSemigroup.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ (CommGroupWithZero.toCommMonoidWithZero.{u_2} G₀ self)))))) a (Inv.inv.{u_2} G₀ (CommGroupWithZero.toInv.{u_2} G₀ self) a)) (OfNat.ofNat.{u_2} G₀ 1 (One.toOfNat1.{u_2} G₀ (Monoid.toOne.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ (CommGroupWithZero.toCommMonoidWithZero.{u_2} G₀ self)))))))

-- Stub: this file represents the declaration `CommGroupWithZero.mul_inv_cancel`.
-- In a full split, the body would be extracted from the environment.
