import Split.Semiring_toOne
import Split.Int
import Split.Field_toCommRing
import Split.Field_zpow
import Split.instOfNat
import Split.One_toOfNat1
import Split.CommRing_toRing
import Split.OfNat_ofNat
import Split.Ring_toSemiring
import Split.Eq
import Split.Field

-- Field.zpow_zero' from environment
-- theorem Field.zpow_zero' : forall {K : Type.{u}} [self : Field.{u} K] (a : K), Eq.{succ u} K (Field.zpow.{u} K self (OfNat.ofNat.{0} Int 0 (instOfNat 0)) a) (OfNat.ofNat.{u} K 1 (One.toOfNat1.{u} K (Semiring.toOne.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))

-- Stub: this file represents the declaration `Field.zpow_zero'`.
-- In a full split, the body would be extracted from the environment.
