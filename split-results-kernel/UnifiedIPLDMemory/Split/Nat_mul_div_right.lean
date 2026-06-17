import Split.Nat_recAux
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Nat_zero_div
import Split.HDiv_hDiv
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_add_div_right
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.instAddNat
import Split.congrFun'
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.Eq_trans
import Split.instHMul

-- Nat.mul_div_right from environment
-- theorem Nat.mul_div_right : forall (n : Nat) {m : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) m) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) m n) m) n)

-- Stub: this file represents the declaration `Nat.mul_div_right`.
-- In a full split, the body would be extracted from the environment.
