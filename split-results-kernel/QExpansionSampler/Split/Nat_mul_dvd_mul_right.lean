import Split.Dvd_dvd
import Split.HMul_hMul
import Split.Nat_mul_dvd_mul
import Split.instMulNat
import Split.Nat_instDvd
import Split.Nat
import Split.Nat_dvd_refl
import Split.instHMul

-- Nat.mul_dvd_mul_right from environment
-- theorem Nat.mul_dvd_mul_right : forall {a : Nat} {b : Nat}, (Dvd.dvd.{0} Nat Nat.instDvd a b) -> (forall (c : Nat), Dvd.dvd.{0} Nat Nat.instDvd (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) a c) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) b c))

-- Stub: this file represents the declaration `Nat.mul_dvd_mul_right`.
-- In a full split, the body would be extracted from the environment.
