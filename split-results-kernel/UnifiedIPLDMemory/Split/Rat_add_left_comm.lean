import Split.Eq_mpr
import Split.congrArg
import Split.Rat
import Split.id
import Split.Rat_add_comm
import Split.Rat_add_assoc
import Split.instHAdd
import Split.HAdd_hAdd
import Split.Rat_instAdd
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq

-- Rat.add_left_comm from environment
-- theorem Rat.add_left_comm : forall (a : Rat) (b : Rat) (c : Rat), Eq.{1} Rat (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) a (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) b c)) (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) b (HAdd.hAdd.{0, 0, 0} Rat Rat Rat (instHAdd.{0} Rat Rat.instAdd) a c))

-- Stub: this file represents the declaration `Rat.add_left_comm`.
-- In a full split, the body would be extracted from the environment.
