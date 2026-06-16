import Split.GroupWithZero_toMonoidWithZero
import Split.GroupWithZero_zpow
import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.GroupWithZero
import Split.Int
import Split.Nat_cast
import Split.Nat
import Split.Monoid_toSemigroup
import Split.instNatCastInt
import Split.Nat_succ
import Split.Eq
import Split.MonoidWithZero_toMonoid
import Split.instHMul

-- GroupWithZero.zpow_succ' from environment
-- theorem GroupWithZero.zpow_succ' : forall {G₀ : Type.{u}} [self : GroupWithZero.{u} G₀] (n : Nat) (a : G₀), Eq.{succ u} G₀ (GroupWithZero.zpow.{u} G₀ self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u, u, u} G₀ G₀ G₀ (instHMul.{u} G₀ (Semigroup.toMul.{u} G₀ (Monoid.toSemigroup.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self))))) (GroupWithZero.zpow.{u} G₀ self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `GroupWithZero.zpow_succ'`.
-- In a full split, the body would be extracted from the environment.
