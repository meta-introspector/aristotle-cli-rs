import Split.Int_instDiv
import Split.Dvd_dvd
import Split.instHDiv
import Split.HMul_hMul
import Split.Int_ediv_mul_cancel_of_emod_eq_zero
import Split.HDiv_hDiv
import Split.Int
import Split.Int_instDvd
import Split.Int_instMul
import Split.Int_emod_eq_zero_of_dvd
import Split.Eq
import Split.instHMul

-- Int.ediv_mul_cancel from environment
-- theorem Int.ediv_mul_cancel : forall {a : Int} {b : Int}, (Dvd.dvd.{0} Int Int.instDvd b a) -> (Eq.{1} Int (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b) b) a)

-- Stub: this file represents the declaration `Int.ediv_mul_cancel`.
-- In a full split, the body would be extracted from the environment.
