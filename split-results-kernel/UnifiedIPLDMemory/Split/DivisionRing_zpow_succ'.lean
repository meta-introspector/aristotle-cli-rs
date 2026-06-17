import Split.HMul_hMul
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.DivisionRing_toRing
import Split.Int
import Split.Nat_cast
import Split.DivisionRing_zpow
import Split.Nat
import Split.Semiring_toNonUnitalSemiring
import Split.DivisionRing
import Split.instNatCastInt
import Split.Ring_toSemiring
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- DivisionRing.zpow_succ' from environment
-- theorem DivisionRing.zpow_succ' : forall {K : Type.{u_2}} [self : DivisionRing.{u_2} K] (n : Nat) (a : K), Eq.{succ u_2} K (DivisionRing.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (Ring.toSemiring.{u_2} K (DivisionRing.toRing.{u_2} K self)))))) (DivisionRing.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `DivisionRing.zpow_succ'`.
-- In a full split, the body would be extracted from the environment.
