import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Nat_zero_div
import Split.Eq_mp
import Split.HDiv_hDiv
import Split.instMulNat
import Split.instOfNatNat
import Split.instHAdd
import Split.Nat_add_mul_div_right
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.instAddNat
import Split.instLTNat
import Split.Nat_zero_add
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Nat.mul_div_cancel from environment
-- theorem Nat.mul_div_cancel : forall (m : Nat) {n : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) n) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m n) n) m)

-- Stub: this file represents the declaration `Nat.mul_div_cancel`.
-- In a full split, the body would be extracted from the environment.
