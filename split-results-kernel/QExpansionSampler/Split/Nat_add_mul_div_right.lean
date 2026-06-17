import Split.Eq_mpr
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_mul_comm
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Nat
import Split.LT_lt
import Split.Nat_instDiv
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_add_mul_div_left
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Nat.add_mul_div_right from environment
-- theorem Nat.add_mul_div_right : forall (x : Nat) (y : Nat) {z : Nat}, (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) z) -> (Eq.{1} Nat (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) x (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) y z)) z) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x z) y))

-- Stub: this file represents the declaration `Nat.add_mul_div_right`.
-- In a full split, the body would be extracted from the environment.
