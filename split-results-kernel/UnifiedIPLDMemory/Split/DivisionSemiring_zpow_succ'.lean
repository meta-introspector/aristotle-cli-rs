import Split.HMul_hMul
import Split.DivisionSemiring_zpow
import Split.NonUnitalNonAssocSemiring_toMul
import Split.NonUnitalSemiring_toNonUnitalNonAssocSemiring
import Split.Int
import Split.Nat_cast
import Split.DivisionSemiring
import Split.Nat
import Split.DivisionSemiring_toSemiring
import Split.Semiring_toNonUnitalSemiring
import Split.instNatCastInt
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- DivisionSemiring.zpow_succ' from environment
-- theorem DivisionSemiring.zpow_succ' : forall {K : Type.{u_2}} [self : DivisionSemiring.{u_2} K] (n : Nat) (a : K), Eq.{succ u_2} K (DivisionSemiring.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt (Nat.succ n)) a) (HMul.hMul.{u_2, u_2, u_2} K K K (instHMul.{u_2} K (NonUnitalNonAssocSemiring.toMul.{u_2} K (NonUnitalSemiring.toNonUnitalNonAssocSemiring.{u_2} K (Semiring.toNonUnitalSemiring.{u_2} K (DivisionSemiring.toSemiring.{u_2} K self))))) (DivisionSemiring.zpow.{u_2} K self (Nat.cast.{0} Int instNatCastInt n) a) a)

-- Stub: this file represents the declaration `DivisionSemiring.zpow_succ'`.
-- In a full split, the body would be extracted from the environment.
