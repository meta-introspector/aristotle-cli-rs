import Split.Dvd_dvd
import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_mul_assoc
import Split.Nat_instDvd
import Split.Nat
import Split.LT_lt
import Split.Exists_intro
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_eq_of_mul_eq_mul_left
import Split.Eq
import Split.instHMul

-- Nat.dvd_of_mul_dvd_mul_left from environment
-- theorem Nat.dvd_of_mul_dvd_mul_left : forall {k : Nat} {m : Nat} {n : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) k) -> (Dvd.dvd.{0} Nat Nat.instDvd (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k m) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k n)) -> (Dvd.dvd.{0} Nat Nat.instDvd m n)

-- Stub: this file represents the declaration `Nat.dvd_of_mul_dvd_mul_left`.
-- In a full split, the body would be extracted from the environment.
