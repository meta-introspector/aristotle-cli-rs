import Split.Semifield_toInv
import Split.Semifield
import Split.Int
import Split.Nat_cast
import Split.Inv_inv
import Split.Nat
import Split.Semifield_zpow
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq

-- Semifield.zpow_neg' from environment
-- theorem Semifield.zpow_neg' : forall {K : Type.{u_2}} [self : Semifield.{u_2} K] (n : Nat) (a : K), Eq.{succ u_2} K (Semifield.zpow.{u_2} K self (Int.negSucc n) a) (Inv.inv.{u_2} K (Semifield.toInv.{u_2} K self) (Semifield.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `Semifield.zpow_neg'`.
-- In a full split, the body would be extracted from the environment.
