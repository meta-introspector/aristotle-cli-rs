import Split.Eq_mpr
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.Nat_instMod
import Split.instHMod
import Split.instMulNat
import Split.instHAdd
import Split.HMod_hMod
import Split.HAdd_hAdd
import Split.Nat
import Split.instAddNat
import Split.Eq_refl
import Split.Eq
import Split.Nat_add_mul_mod_self_left
import Split.instHMul
import Split.Nat_add_comm

-- Nat.mul_add_mod_self_left from environment
-- theorem Nat.mul_add_mod_self_left : forall (a : Nat) (b : Nat) (c : Nat), Eq.{1} Nat (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) a b) c) a) (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) c a)

-- Stub: this file represents the declaration `Nat.mul_add_mod_self_left`.
-- In a full split, the body would be extracted from the environment.
