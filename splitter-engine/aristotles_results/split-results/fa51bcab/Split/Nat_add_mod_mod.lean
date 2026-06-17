import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.Nat_instMod
import Split.instHMod
import Split.instHAdd
import Split.HMod_hMod
import Split.Nat_mod_add_mod
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.Eq
import Split.Nat_add_comm

-- Nat.add_mod_mod from environment
-- theorem Nat.add_mod_mod : forall (m : Nat) (n : Nat) (k : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) n k)) k) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) m n) k)

-- Stub: this file represents the declaration `Nat.add_mod_mod`.
-- In a full split, the body would be extracted from the environment.
