import Split.Int_instDiv
import Split.instHDiv
import Split.HMul_hMul
import Split.Eq_rec
import Split.HDiv_hDiv
import Split.Ne
import Split.Int
import Split.Int_instMul
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Int_mul_comm
import Split.OfNat_ofNat
import Split.Eq
import Split.Int_add_mul_ediv_right
import Split.instHMul

-- Int.add_mul_ediv_left from environment
-- theorem Int.add_mul_ediv_left : forall (a : Int) {b : Int} (c : Int), (Ne.{1} Int b (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (Eq.{1} Int (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) a (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) b c)) b) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) a b) c))

-- Stub: this file represents the declaration `Int.add_mul_ediv_left`.
-- In a full split, the body would be extracted from the environment.
