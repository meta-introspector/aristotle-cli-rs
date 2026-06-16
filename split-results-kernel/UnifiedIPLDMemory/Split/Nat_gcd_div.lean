import Split.Nat_gcd
import Split.Eq_mpr
import Split.Nat_gcd_mul_right
import Split.Nat_div_mul_cancel
import Split.Dvd_dvd
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.Nat_eq_of_mul_eq_mul_right
import Split.Nat_gcd_self
import Split.instMulNat
import Split.instOfNatNat
import Split.Nat_div_zero
import Split.GT_gt
import Split.Nat_dvd_gcd
import Split.Nat_instDvd
import Split.Nat
import Split.congr
import Split.True
import Split.eq_self
import Split.Nat_instDiv
import Split.of_eq_true
import Split.Eq_refl
import Split.Or
import Split.instLTNat
import Split.OfNat_ofNat
import Split.Eq_symm
import Split.Eq
import Split.Nat_eq_zero_or_pos
import Split.Eq_trans
import Split.instHMul

-- Nat.gcd_div from environment
-- theorem Nat.gcd_div : forall {m : Nat} {n : Nat} {k : Nat}, (Dvd.dvd.{0} Nat Nat.instDvd k m) -> (Dvd.dvd.{0} Nat Nat.instDvd k n) -> (Eq.{1} Nat (Nat.gcd (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) m k) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) n k)) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) (Nat.gcd m n) k))

-- Stub: this file represents the declaration `Nat.gcd_div`.
-- In a full split, the body would be extracted from the environment.
