import Split.GroupWithZero_toMonoidWithZero
import Split.GroupWithZero_zpow
import Split.GroupWithZero
import Split.Int
import Split.instOfNat
import Split.One_toOfNat1
import Split.Monoid_toOne
import Split.OfNat_ofNat
import Split.Eq
import Split.MonoidWithZero_toMonoid

-- GroupWithZero.zpow_zero' from environment
-- theorem GroupWithZero.zpow_zero' : forall {G₀ : Type.{u}} [self : GroupWithZero.{u} G₀] (a : G₀), Eq.{succ u} G₀ (GroupWithZero.zpow.{u} G₀ self (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} G₀ 1 (One.toOfNat1.{u} G₀ (Monoid.toOne.{u} G₀ (MonoidWithZero.toMonoid.{u} G₀ (GroupWithZero.toMonoidWithZero.{u} G₀ self)))))

-- Stub: this file represents the declaration `GroupWithZero.zpow_zero'`.
-- In a full split, the body would be extracted from the environment.
