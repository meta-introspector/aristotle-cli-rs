import Split.Semiring_toOne
import Split.DivisionRing_toRing
import Split.Int
import Split.DivisionRing_zpow
import Split.instOfNat
import Split.One_toOfNat1
import Split.DivisionRing
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq

-- DivisionRing.zpow_zero' from environment
-- theorem DivisionRing.zpow_zero' : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (a : K), Eq.{succ u_2} K (DivisionRing.zpow.{u_2} K self (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u_2} K 1 (One.toOfNat1.{u_2} K (Semiring.toOne.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self)))))

-- Stub: this file represents the declaration `DivisionRing.zpow_zero'`.
-- In a full split, the body would be extracted from the environment.
