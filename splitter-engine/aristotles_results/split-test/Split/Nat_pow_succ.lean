import Split.instPowNat
import Split.HMul_hMul
import Split.instMulNat
import Split.instNatPowNat
import Split.HPow_hPow
import Split.Nat
import Split.instHPow
import Split.Nat_succ
import Split.Eq
import Split.rfl
import Split.instHMul

-- Nat.pow_succ from environment
-- theorem Nat.pow_succ : forall (n : Nat) (m : Nat), Eq.{1} Nat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n (Nat.succ m)) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) n m) n)

-- Stub: this file represents the declaration `Nat.pow_succ`.
-- In a full split, the body would be extracted from the environment.
