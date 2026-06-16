import Split.GroupWithZero_zpow
import Split.GroupWithZero_toInv
import Split.GroupWithZero
import Split.Int
import Split.Nat_cast
import Split.Inv_inv
import Split.Nat
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq

-- GroupWithZero.zpow_neg' from environment
-- theorem GroupWithZero.zpow_neg' : forall {G₀ : Type.{u}} [self : GroupWithZero.{u} G₀] (n : Nat) (a : G₀), Eq.{succ u} G₀ (GroupWithZero.zpow.{u} G₀ self (Int.negSucc n) a) (Inv.inv.{u} G₀ (GroupWithZero.toInv.{u} G₀ self) (GroupWithZero.zpow.{u} G₀ self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `GroupWithZero.zpow_neg'`.
-- In a full split, the body would be extracted from the environment.
