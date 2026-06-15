import Split.instHDiv
import Split.HMul_hMul
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instMulNat
import Split.instHAdd
import Split.HMod_hMod
import Split.HAdd_hAdd
import Split.Nat
import Split.Nat_instDiv
import Split.instAddNat
import Split.Eq
import Split.instHMul

-- Nat.div_add_mod from environment
-- theorem Nat.div_add_mod : forall (m : Nat) (n : Nat), Eq.{1} Nat (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) n (HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) m n)) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) m n)) m

-- Stub: this file represents the declaration `Nat.div_add_mod`.
-- In a full split, the body would be extracted from the environment.
