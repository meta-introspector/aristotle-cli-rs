import Split.ByteArray_utf8Decode?_go
import Split.Eq_rec
import Split.LE_le
import Split.instLENat
import Split.Array
import Split.Nat
import Split.Eq_ndrec
import Split.Eq_refl
import Split.Char
import Split.ByteArray
import Split.Eq
import Split.ByteArray_size
import Split.Option

-- ByteArray.utf8Decode?.go.congr_simp from environment
-- theorem ByteArray.utf8Decode?.go.congr_simp : forall (b : ByteArray) (b_1 : ByteArray) (e_b : Eq.{1} ByteArray b b_1) (i : Nat) (i_1 : Nat) (e_i : Eq.{1} Nat i i_1) (acc : Array.{0} Char) (acc_1 : Array.{0} Char), (Eq.{1} (Array.{0} Char) acc acc_1) -> (forall (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)), Eq.{1} (Option.{0} (Array.{0} Char)) (ByteArray.utf8Decode?.go b i acc hi) (ByteArray.utf8Decode?.go b_1 i_1 acc_1 (Eq.ndrec.{0, 1} ByteArray b (fun (b : ByteArray) => LE.le.{0} Nat instLENat i_1 (ByteArray.size b)) (Eq.ndrec.{0, 1} Nat i (fun (i : Nat) => LE.le.{0} Nat instLENat i (ByteArray.size b)) hi i_1 e_i) b_1 e_b)))

-- Stub: this file represents the declaration `ByteArray.utf8Decode?.go.congr_simp`.
-- In a full split, the body would be extracted from the environment.
