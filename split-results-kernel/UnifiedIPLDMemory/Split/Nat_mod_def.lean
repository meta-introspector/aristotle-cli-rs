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
import Split.Nat_mod_add_div
import Split.instHAdd
import Split.HMod_hMod
import Split.instHSub
import Split.HAdd_hAdd
import Split.Nat
import Split.Nat_instDiv
import Split.instAddNat
import Split.Eq_refl
import Split.Nat_sub_eq_of_eq_add
import Split.Eq_symm
import Split.Eq
import Split.instHMul

-- Nat.mod_def from environment
-- theorem Nat.mod_def : forall (m : Nat) (k : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) m k) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) m (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) k (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) m k)))

-- Stub: this file represents the declaration `Nat.mod_def`.
-- In a full split, the body would be extracted from the environment.
