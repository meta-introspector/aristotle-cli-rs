import Split.HMul_hMul
import Split.instMulNat
import Split.instOfNatNat
import Split.instHAdd
import Split.Nat_succ_mul
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Nat.add_one_mul from environment
-- theorem Nat.add_one_mul : forall (n : Nat) (m : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) m) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) m)

-- Stub: this file represents the declaration `Nat.add_one_mul`.
-- In a full split, the body would be extracted from the environment.
