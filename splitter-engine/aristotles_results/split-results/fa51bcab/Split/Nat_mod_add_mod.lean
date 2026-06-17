import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instMulNat
import Split.Nat_mod_add_div
import Split.instHAdd
import Split.HMod_hMod
import Split.HAdd_hAdd
import Split.Nat
import Split.Nat_instDiv
import Split.instAddNat
import Split.Eq_symm
import Split.Eq
import Split.Nat_add_mul_mod_self_left
import Split.Nat_add_right_comm
import Split.instHMul

-- Nat.mod_add_mod from environment
-- theorem Nat.mod_add_mod : forall (m : Nat) (n : Nat) (k : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) m n) k) n) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m k) n)

-- Stub: this file represents the declaration `Nat.mod_add_mod`.
-- In a full split, the body would be extracted from the environment.
