import Split.Semiring_toOne
import Split.CommSemiring_toSemiring
import Split.Semifield
import Split.Int
import Split.instOfNat
import Split.One_toOfNat1
import Split.Semifield_zpow
import Split.Semifield_toCommSemiring
import Split.OfNat_ofNat
import Split.Eq

-- Semifield.zpow_zero' from environment
-- theorem Semifield.zpow_zero' : forall {K : Type.{u_2}} [self : Semifield.{u_2} K] (a : K), Eq.{succ u_2} K (Semifield.zpow.{u_2} K self (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u_2} K 1 (One.toOfNat1.{u_2} K (Semiring.toOne.{u_2} K (CommSemiring.toSemiring.{u_2} K (Semifield.toCommSemiring.{u_2} K self)))))

-- Stub: this file represents the declaration `Semifield.zpow_zero'`.
-- In a full split, the body would be extracted from the environment.
