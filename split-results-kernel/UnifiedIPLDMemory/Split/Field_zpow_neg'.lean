import Split.Int
import Split.Nat_cast
import Split.Inv_inv
import Split.Field_zpow
import Split.Nat
import Split.instNatCastInt
import Split.Field_toInv
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq
import Split.Field

-- Field.zpow_neg' from environment
-- theorem Field.zpow_neg' : forall {K : Type.{u}} [self : Field.{u} K] (n : Nat) (a : K), Eq.{succ u} K (Field.zpow.{u} K self (Int.negSucc n) a) (Inv.inv.{u} K (Field.toInv.{u} K self) (Field.zpow.{u} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `Field.zpow_neg'`.
-- In a full split, the body would be extracted from the environment.
