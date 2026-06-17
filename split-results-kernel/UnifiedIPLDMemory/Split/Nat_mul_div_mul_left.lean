import Split.Eq_mpr
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Nat_mul_div_cancel_left
import Split.id
import Split.HDiv_hDiv
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.Eq_refl
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Nat_div_div_eq_div_mul
import Split.instHMul

-- Nat.mul_div_mul_left from environment
-- theorem Nat.mul_div_mul_left : forall {m : Nat} (n : Nat) (k : Nat), (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) m) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m n) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m k)) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) n k))

-- Stub: this file represents the declaration `Nat.mul_div_mul_left`.
-- In a full split, the body would be extracted from the environment.
