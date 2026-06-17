import Split.HMul_hMul
import Split.Fin_pos
import Split.Fin_mk
import Split.Nat_instMod
import Split.instHMod
import Split.instMulNat
import Split.Fin_val
import Split.Nat_mod_lt
import Split.HMod_hMod
import Split.Fin_instMul
import Split.Nat
import Split.Fin
import Split.Eq
import Split.rfl
import Split.instHMul

-- Fin.mul_def from environment
-- theorem Fin.mul_def : forall {n : Nat} (a : Fin n) (b : Fin n), Eq.{1} (Fin n) (HMul.hMul.{0, 0, 0} (Fin n) (Fin n) (Fin n) (instHMul.{0} (Fin n) (Fin.instMul n)) a b) (Fin.mk n (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Fin.val n a) (Fin.val n b)) n) (Nat.mod_lt (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) (Fin.val n a) (Fin.val n b)) n (Fin.pos n a)))

-- Stub: this file represents the declaration `Fin.mul_def`.
-- In a full split, the body would be extracted from the environment.
