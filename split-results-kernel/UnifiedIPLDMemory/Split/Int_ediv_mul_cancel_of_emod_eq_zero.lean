import Split.Eq_mpr
import Split.Int_instDiv
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.instHMod
import Split.Int
import Split.Int_instMul
import Split.HMod_hMod
import Split.Int_mul_ediv_cancel_of_emod_eq_zero
import Split.instOfNat
import Split.Int_instMod
import Split.Eq_refl
import Split.Int_mul_comm
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Int.ediv_mul_cancel_of_emod_eq_zero from environment
-- theorem Int.ediv_mul_cancel_of_emod_eq_zero : forall {a : Int} {b : Int}, (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) a b) (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (Eq.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b) b) a)

-- Stub: this file represents the declaration `Int.ediv_mul_cancel_of_emod_eq_zero`.
-- In a full split, the body would be extracted from the environment.
