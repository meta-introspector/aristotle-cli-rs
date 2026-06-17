import Split.Eq_mpr
import Split.Nat_recAux
import Split.Nat_mul_succ
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_add_div_right
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_mul_zero
import Split.Nat_instDiv
import Split.Nat_add_assoc
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_add_zero
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- Nat.add_mul_div_left from environment
-- theorem Nat.add_mul_div_left : forall (x : Nat) (z : Nat) {y : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) y) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) x (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) y z)) y) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x y) z))

-- Stub: this file represents the declaration `Nat.add_mul_div_left`.
-- In a full split, the body would be extracted from the environment.
