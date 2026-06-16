import Split.CommGroupWithZero_toInv
import Split.Int
import Split.Nat_cast
import Split.Inv_inv
import Split.Nat
import Split.CommGroupWithZero
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq
import Split.CommGroupWithZero_zpow

-- CommGroupWithZero.zpow_neg' from environment
-- theorem CommGroupWithZero.zpow_neg' : forall {G₀ : Type.{u_2}} [self : CommGroupWithZero.{u_2} G₀] (n : Nat) (a : G₀), Eq.{succ u_2} G₀ (CommGroupWithZero.zpow.{u_2} G₀ self (Int.negSucc n) a) (Inv.inv.{u_2} G₀ (CommGroupWithZero.toInv.{u_2} G₀ self) (CommGroupWithZero.zpow.{u_2} G₀ self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a))

-- Stub: this file represents the declaration `CommGroupWithZero.zpow_neg'`.
-- In a full split, the body would be extracted from the environment.
