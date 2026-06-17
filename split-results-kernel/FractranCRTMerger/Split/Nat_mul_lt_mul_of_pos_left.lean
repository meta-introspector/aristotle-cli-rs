import Split.Nat_mul_succ
import Split.HMul_hMul
import Split.Nat_succ_le_of_lt
import Split.Eq_rec
import Split.Nat_mul_le_mul_left
import Split.instMulNat
import Split.instOfNatNat
import Split.LE_le
import Split.instLENat
import Split.GT_gt
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_add_lt_add_left
import Split.instAddNat
import Split.Nat_mul
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.Nat_lt_of_lt_of_le
import Split.instHMul

-- Nat.mul_lt_mul_of_pos_left from environment
-- theorem Nat.mul_lt_mul_of_pos_left : forall {n : Nat} {m : Nat} {k : Nat}, (LT.lt.{0} Nat instLTNat n m) -> (GT.gt.{0} Nat instLTNat k (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (LT.lt.{0} Nat instLTNat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k n) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k m))

-- Stub: this file represents the declaration `Nat.mul_lt_mul_of_pos_left`.
-- In a full split, the body would be extracted from the environment.
