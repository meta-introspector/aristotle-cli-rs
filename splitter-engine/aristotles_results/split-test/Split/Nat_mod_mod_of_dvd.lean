import Split.Eq_mpr
import Split.Dvd_dvd
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.Nat_instMod
import Split.instHMod
import Split.instMulNat
import Split.Nat_mul_assoc
import Split.Nat_mod_add_div
import Split.instHAdd
import Split.HMod_hMod
import Split.Nat_instDvd
import Split.HAdd_hAdd
import Split.Nat
import Split.Nat_instDiv
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq
import Split.Nat_add_mul_mod_self_left
import Split.instHMul

-- Nat.mod_mod_of_dvd from environment
-- theorem Nat.mod_mod_of_dvd : forall {c : Nat} {b : Nat} (a : Nat), (Dvd.dvd.{0} Nat Nat.instDvd c b) -> (Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) a b) c) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) a c))

-- Stub: this file represents the declaration `Nat.mod_mod_of_dvd`.
-- In a full split, the body would be extracted from the environment.
