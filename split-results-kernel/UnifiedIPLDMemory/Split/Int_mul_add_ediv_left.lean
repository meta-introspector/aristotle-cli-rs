import Split.Eq_mpr
import Split.Int_instDiv
import Split.instHDiv
import Split.HMul_hMul
import Split.congrArg
import Split.id
import Split.HDiv_hDiv
import Split.Ne
import Split.Int
import Split.Int_add_comm
import Split.Int_add_mul_ediv_left
import Split.Int_instMul
import Split.instHAdd
import Split.instOfNat
import Split.HAdd_hAdd
import Split.Int_instAdd
import Split.Eq_refl
import Split.OfNat_ofNat
import Split.Eq
import Split.instHMul

-- Int.mul_add_ediv_left from environment
-- theorem Int.mul_add_ediv_left : forall (b : Int) {a : Int} (c : Int), (Ne.{1} Int a (OfNat.ofNat.{0} Int 0 (instOfNat 0))) -> (Eq.{1} Int (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) (HMul.hMul.{0, 0, 0} Int Int Int (instHMul.{0} Int Int.instMul) a b) c) a) (HAdd.hAdd.{0, 0, 0} Int Int Int (instHAdd.{0} Int Int.instAdd) b (HDiv.hDiv.{0, 0, 0} Int Int Int (instHDiv.{0} Int Int.instDiv) c a)))

-- Stub: this file represents the declaration `Int.mul_add_ediv_left`.
-- In a full split, the body would be extracted from the environment.
