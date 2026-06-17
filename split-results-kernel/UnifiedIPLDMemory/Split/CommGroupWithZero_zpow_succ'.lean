import Split.CommMonoidWithZero_toCommMonoid
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.Int
import Split.Nat_cast
import Split.CommMonoid_toMonoid
import Split.Nat
import Split.CommGroupWithZero
import Split.Monoid_toSemigroup
import Split.instNatCastInt
import Split.CommGroupWithZero_toCommMonoidWithZero
import Split.Nat_succ
import Split.Eq
import Split.CommGroupWithZero_zpow
import Split.instHMul

-- CommGroupWithZero.zpow_succ' from environment
-- theorem CommGroupWithZero.zpow_succ' : forall {G₀ : Type.{u_2}} [self : CommGroupWithZero.{u_2} G₀] (n : Nat) (a : G₀), Eq.{succ u_2} G₀ (CommGroupWithZero.zpow.{u_2} G₀ self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u_2, u_2, u_2} G₀ G₀ G₀ (instHMul.{u_2} G₀ (Semigroup.toMul.{u_2} G₀ (Monoid.toSemigroup.{u_2} G₀ (CommMonoid.toMonoid.{u_2} G₀ (CommMonoidWithZero.toCommMonoid.{u_2} G₀ (CommGroupWithZero.toCommMonoidWithZero.{u_2} G₀ self)))))) (CommGroupWithZero.zpow.{u_2} G₀ self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `CommGroupWithZero.zpow_succ'`.
-- In a full split, the body would be extracted from the environment.
