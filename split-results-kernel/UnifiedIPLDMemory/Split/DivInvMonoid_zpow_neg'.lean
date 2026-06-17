import Split.DivInvMonoid_toInv
import Split.Int
import Split.DivInvMonoid_zpow
import Split.Nat_cast
import Split.DivInvMonoid
import Split.Inv_inv
import Split.Nat
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq

-- DivInvMonoid.zpow_neg' from environment
-- theorem DivInvMonoid.zpow_neg' : forall {G : Type.{u}} [self : DivInvMonoid.{u} G] (n : Nat) (a : G), Eq.{succ u} G (DivInvMonoid.zpow.{u} G self (Int.negSucc n) a) (Inv.inv.{u} G (DivInvMonoid.toInv.{u} G self) (DivInvMonoid.zpow.{u} G self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `DivInvMonoid.zpow_neg'`.
-- In a full split, the body would be extracted from the environment.
