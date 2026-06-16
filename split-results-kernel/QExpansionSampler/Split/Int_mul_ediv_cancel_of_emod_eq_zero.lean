import Split.Int_instDiv
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.Eq_mp
import Split.HDiv_hDiv
import Split.instHMod
import Split.Int
import Split.Int_instMul
import Split.instHAdd
import Split.HMod_hMod
import Split.Int_emod_add_mul_ediv
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_instMod
import Split.OfNat_ofNat
import Split.Int_zero_add
import Split.Eq
import Split.instHMul

-- Int.mul_ediv_cancel_of_emod_eq_zero from environment
-- theorem Int.mul_ediv_cancel_of_emod_eq_zero : forall {a : Int} {b : Int}, (Eq.{1} Int (HMod.hMod.{0, 0, 0} Int Int Int (instHMod.{0} Int Int.instMod) a b) (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (Eq.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b)) a)

-- Stub: this file represents the declaration `Int.mul_ediv_cancel_of_emod_eq_zero`.
-- In a full split, the body would be extracted from the environment.
