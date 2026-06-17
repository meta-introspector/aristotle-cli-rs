import Split.Nat_mod_eq_sub_mul_div
import Split.Eq_mpr
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.HSub_hSub
import Split.id
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instSubNat
import Split.instMulNat
import Split.Nat_mul_comm
import Split.HMod_hMod
import Split.instHSub
import Split.Nat
import Split.Nat_instDiv
import Split.Eq_refl
import Split.Eq
import Split.instHMul

-- Nat.mod_eq_sub_div_mul from environment
-- theorem Nat.mod_eq_sub_div_mul : forall {x : Nat} {k : Nat}, Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) x k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) x (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) x k) k))

-- Stub: this file represents the declaration `Nat.mod_eq_sub_div_mul`.
-- In a full split, the body would be extracted from the environment.
