import Split.instHDiv
import Split.Nat_mod_def
import Split.HMul_hMul
import Split.HSub_hSub
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instSubNat
import Split.instMulNat
import Split.HMod_hMod
import Split.instHSub
import Split.Nat
import Split.Nat_instDiv
import Split.Eq
import Split.instHMul

-- Nat.mod_eq_sub_mul_div from environment
-- theorem Nat.mod_eq_sub_mul_div : forall {x : Nat} {k : Nat}, Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) x k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x k)))

-- Stub: this file represents the declaration `Nat.mod_eq_sub_mul_div`.
-- In a full split, the body would be extracted from the environment.
