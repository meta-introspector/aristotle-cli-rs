import Split.HMul_hMul
import Split.CommSemiring_toSemiring
import Split.NonUnitalNonAssocSemiring_toMul
import Split.Semifield
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Int
import Split.Nat_cast
import Split.Nat
import Split.Semiring_toNonUnitalSemiring
import Split.Semifield_zpow
import Split.Semifield_toCommSemiring
import Split.instNatCastInt
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- Semifield.zpow_succ' from environment
-- theorem Semifield.zpow_succ' : forall {K : Type.{u_2}} [self : Semifield.{u_2} K] (n : Nat) (a : K), Eq.{succ u_2} K (Semifield.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (CommSemiring.toSemiring.{u_2} K (Semifield.toCommSemiring.{u_2} K self)))))) (Semifield.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `Semifield.zpow_succ'`.
-- In a full split, the body would be extracted from the environment.
