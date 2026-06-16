import Split.Eq_mpr
import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.instSubNat
import Split.instMulNat
import Split.Nat_mul_comm
import Split.Nat_mul_sub_right_distrib
import Split.instHSub
import Split.Nat
import Split.Eq_refl
import Split.Eq
import Split.instHMul

-- Nat.mul_sub_left_distrib from environment
-- theorem Nat.mul_sub_left_distrib : forall (n : Nat) (m : Nat) (k : Nat), Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m k)) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n m) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n k))

-- Stub: this file represents the declaration `Nat.mul_sub_left_distrib`.
-- In a full split, the body would be extracted from the environment.
