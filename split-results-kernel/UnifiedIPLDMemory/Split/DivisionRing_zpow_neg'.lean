import Split.Int
import Split.Nat_cast
import Split.DivisionRing_zpow
import Split.Inv_inv
import Split.Nat
import Split.DivisionRing
import Split.instNatCastInt
import Split.Int_negSucc
import Split.DivisionRing_toInv
import Split.Nat_succ
import Split.Eq

-- DivisionRing.zpow_neg' from environment
-- theorem DivisionRing.zpow_neg' : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (n : Nat) (a : K), Eq.{succ u_2} K (DivisionRing.zpow.{u_2} K self (Int.negSucc n) a) (Inv.inv.{u_2} K (DivisionRing.toInv.{u_2} K self) (DivisionRing.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `DivisionRing.zpow_neg'`.
-- In a full split, the body would be extracted from the environment.
