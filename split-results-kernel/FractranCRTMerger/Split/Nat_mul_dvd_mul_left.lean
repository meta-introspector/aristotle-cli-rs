import Split.Dvd_dvd
import Split.HMul_hMul
import Split.Nat_mul_dvd_mul
import Split.instMulNat
import Split.Nat_instDvd
import Split.Nat
import Split.Nat_dvd_refl
import Split.instHMul

-- Nat.mul_dvd_mul_left from environment
-- theorem Nat.mul_dvd_mul_left : forall {b : Nat} {c : Nat} (a : Nat), (Dvd.dvd.{0} Nat Nat.instDvd b c) -> (Dvd.dvd.{0} Nat Nat.instDvd (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) a b) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) a c))

-- Stub: this file represents the declaration `Nat.mul_dvd_mul_left`.
-- In a full split, the body would be extracted from the environment.
