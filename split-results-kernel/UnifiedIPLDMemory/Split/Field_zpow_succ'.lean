import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Int
import Split.Nat_cast
import Split.Field_toCommRing
import Split.Field_zpow
import Split.Nat
import Split.Semiring_toNonUnitalSemiring
import Split.instNatCastInt
import Split.CommRing_toRing
import Split.Ring_toSemiring
import Split.Nat_succ
import Split.Eq
import Split.Field
import Split.instHMul

-- Field.zpow_succ' from environment
-- theorem Field.zpow_succ' : forall {K : Type.{u}} [self : Field.{u} K] (n : Nat) (a : K), Eq.{succ u} K (Field.zpow.{u} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u, u, u} K K K (instHMul.{u} K (NonUnitalNonAssocSemiring.toMul.{u} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u} K (Semiring.toNonUnitalSemiring.{u} K (Ring.toSemiring.{u} K (CommRing.toRing.{u} K (Field.toCommRing.{u} K self))))))) (Field.zpow.{u} K self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `Field.zpow_succ'`.
-- In a full split, the body would be extracted from the environment.
