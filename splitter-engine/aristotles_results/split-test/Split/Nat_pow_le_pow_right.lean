import Split.instPowNat
import Split.HMul_hMul
import Split.Nat_le_refl
import Split.Nat_mul_one
import Split.Eq_rec
import Split.Nat_brecOn
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_le_or_eq_of_le_succ
import Split.LE_le
import Split.instLENat
import Split.Nat_below
import Split.instNatPowNat
import Split.GT_gt
import Split.HPow_hPow
import Split.Nat_mul_le_mul
import Split.Nat
import Split.Or
import Split.instHPow
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Nat_succ
import Split.Eq
import Split.Nat_eq_zero_of_le_zero
import Split.instHMul

-- Nat.pow_le_pow_right from environment
-- theorem Nat.pow_le_pow_right : forall {n : Nat}, (GT.gt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (forall {i : Nat} {j : Nat}, (LE.le.{0} Nat instLENat i j) -> (LE.le.{0} Nat instLENat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n i) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n j)))

-- Stub: this file represents the declaration `Nat.pow_le_pow_right`.
-- In a full split, the body would be extracted from the environment.
