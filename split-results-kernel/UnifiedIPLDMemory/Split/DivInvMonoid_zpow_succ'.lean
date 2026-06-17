import Split.Semigroup_toMul
import Split.HMul_hMul
import Split.DivInvMonoid_toMonoid
import Split.Int
import Split.DivInvMonoid_zpow
import Split.Nat_cast
import Split.DivInvMonoid
import Split.Nat
import Split.Monoid_toSemigroup
import Split.instNatCastInt
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- DivInvMonoid.zpow_succ' from environment
-- theorem DivInvMonoid.zpow_succ' : forall {G : Type.{u}} [self : DivInvMonoid.{u} G] (n : Nat) (a : G), Eq.{succ u} G (DivInvMonoid.zpow.{u} G self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u, u, u} G G G (instHMul.{u} G (Semigroup.toMul.{u} G (Monoid.toSemigroup.{u} G (DivInvMonoid.toMonoid.{u} G self)))) (DivInvMonoid.zpow.{u} G self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `DivInvMonoid.zpow_succ'`.
-- In a full split, the body would be extracted from the environment.
