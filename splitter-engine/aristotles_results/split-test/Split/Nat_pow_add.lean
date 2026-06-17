import Split.instPowNat
import Split.Eq_mpr
import Split.Nat_recAux
import Split.HMul_hMul
import Split.Nat_mul_one
import Split.congrArg
import Split.Nat_pow_succ
import Split.id
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_mul_assoc
import Split.Nat_pow_zero
import Split.instNatPowNat
import Split.instHAdd
import Split.HPow_hPow
import Split.HAdd_hAdd
import Split.Nat_add_succ
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_add_zero
import Split.instHPow
import Split.OfNat_ofNat
import Split.Nat_succ
import Split.Eq
import Split.instHMul

-- Nat.pow_add from environment
-- theorem Nat.pow_add : forall (a : Nat) (m : Nat) (n : Nat), Eq.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) a (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) a m) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) a n))

-- Stub: this file represents the declaration `Nat.pow_add`.
-- In a full split, the body would be extracted from the environment.
