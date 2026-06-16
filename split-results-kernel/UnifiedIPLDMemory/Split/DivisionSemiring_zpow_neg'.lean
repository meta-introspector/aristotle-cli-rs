import Split.DivisionSemiring_zpow
import Split.DivisionSemiring_toInv
import Split.Int
import Split.Nat_cast
import Split.DivisionSemiring
import Split.Inv_inv
import Split.Nat
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq

-- DivisionSemiring.zpow_neg' from environment
-- theorem DivisionSemiring.zpow_neg' : forall {K : Type.{u_2}} [self : DivisionSemiring.{u_2} K] (n : Nat) (a : K), Eq.{succ u_2} K (DivisionSemiring.zpow.{u_2} K self (Int.negSucc n) a) (Inv.inv.{u_2} K (DivisionSemiring.toInv.{u_2} K self) (DivisionSemiring.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `DivisionSemiring.zpow_neg'`.
-- In a full split, the body would be extracted from the environment.
