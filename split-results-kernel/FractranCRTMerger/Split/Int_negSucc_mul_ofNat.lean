import Split.HMul_hMul
import Split.Int_instNegInt
import Split.instMulNat
import Split.Int
import Split.Nat_cast
import Split.Int_instMul
import Split.Nat
import Split.instNatCastInt
import Split.Int_negSucc
import Split.Nat_succ
import Split.Eq
import Split.Neg_neg
import Split.rfl
import Split.instHMul

-- Int.negSucc_mul_ofNat from environment
-- theorem Int.negSucc_mul_ofNat : forall (m : Nat) (n : Nat), Eq.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (Int.negSucc m) (Nat.cast.{0} Int instNatCastInt n)) (Neg.neg.{0} Int Int.instNegInt (Nat.cast.{0} Int instNatCastInt (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Nat.succ m) n)))

-- Stub: this file represents the declaration `Int.negSucc_mul_ofNat`.
-- In a full split, the body would be extracted from the environment.
