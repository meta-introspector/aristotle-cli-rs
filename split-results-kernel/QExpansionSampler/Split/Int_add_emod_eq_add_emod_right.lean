import Split.Eq_mpr
import Split.congrArg
import Split.id
import Split.instHMod
import Split.Int
import Split.Int_emod_add_emod
import Split.instHAdd
import Split.HMod_hMod
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instMod
import Split.Eq_refl
import Split.Eq_symm
import Split.Eq

-- Int.add_emod_eq_add_emod_right from environment
-- theorem Int.add_emod_eq_add_emod_right : forall {m : Int} {n : Int} {k : Int} (i : Int), (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) m n) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) k n)) -> (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) m i) n) (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) k i) n))

-- Stub: this file represents the declaration `Int.add_emod_eq_add_emod_right`.
-- In a full split, the body would be extracted from the environment.
