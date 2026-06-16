import Split.Eq_mpr
import Split.Dvd_dvd
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.instMulNat
import Split.Nat_mul_comm
import Split.Nat_instDvd
import Split.Nat
import Split.Nat_instDiv
import Split.Eq_refl
import Split.Eq
import Split.Nat_mul_div_cancel'
import Split.instHMul

-- Nat.div_mul_cancel from environment
-- theorem Nat.div_mul_cancel : forall {n : Nat} {m : Nat}, (Dvd.dvd.{0} Nat Nat.instDvd n m) -> (Eq.{1} Nat (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) m n) n) m)

-- Stub: this file represents the declaration `Nat.div_mul_cancel`.
-- In a full split, the body would be extracted from the environment.
