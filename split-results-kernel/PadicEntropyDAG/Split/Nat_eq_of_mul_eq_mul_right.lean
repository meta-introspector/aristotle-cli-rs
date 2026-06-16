import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_mul_comm
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_eq_of_mul_eq_mul_left
import Split.Eq
import Split.instHMul

-- Nat.eq_of_mul_eq_mul_right from environment
-- theorem Nat.eq_of_mul_eq_mul_right : forall {n : Nat} {m : Nat} {k : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) m) -> (Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k m)) -> (Eq.{1} Nat n k)

-- Stub: this file represents the declaration `Nat.eq_of_mul_eq_mul_right`.
-- In a full split, the body would be extracted from the environment.
