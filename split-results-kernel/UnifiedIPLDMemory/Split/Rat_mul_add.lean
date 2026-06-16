import Split.Eq_mpr
import Split.Rat_instMul
import Split.HMul_hMul
import Split.Rat_add_mul
import Split.congrArg
import Split.Rat
import Split.Rat_mul_comm
import Split.id
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Rat_instAdd
import Split.Eq_refl
import Split.Eq
import Split.instHMul

-- Rat.mul_add from environment
-- theorem Rat.mul_add : forall (a : Rat) (b : Rat) (c : Rat), Eq.{1} Rat (HMul.hMul.{0, 0, 0} Rat Rat Rat (instHMul.{0} Rat Rat.instMul) a (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) b c)) (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) (HMul.hMul.{0, 0, 0} Rat Rat Rat (instHMul.{0} Rat Rat.instMul) a b) (HMul.hMul.{0, 0, 0} Rat Rat Rat (instHMul.{0} Rat Rat.instMul) a c))

-- Stub: this file represents the declaration `Rat.mul_add`.
-- In a full split, the body would be extracted from the environment.
