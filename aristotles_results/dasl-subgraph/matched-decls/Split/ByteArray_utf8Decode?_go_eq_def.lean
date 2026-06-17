import Split.Array_push
import Split.ByteArray_utf8Decode?_go
import Split.Option_some
import Split.id
import Split.LE_le
import Split.instLENat
import Split.Array
import Split.Option_none
import Split.instHAdd
import Split.HAdd_hAdd
import Split.ByteArray_le_size_of_utf8DecodeChar?_eq_some
import Split.Nat
import Split.LT_lt
import Split.PSigma_mk
import Split.Nat_decLt
import Split.instAddNat
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.PSigma
import Split.Eq
import Split.Char_utf8Size
import Split.ByteArray_size
import Split.ByteArray_utf8Decode?_go_match_1
import Split.ByteArray_utf8DecodeChar?
import Split.Option
import Split.ite

-- ByteArray.utf8Decode?.go.eq_def from environment
-- theorem ByteArray.utf8Decode?.go.eq_def : forall (b : ByteArray) (i : Nat) (acc : Array.{0} Char) (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)), Eq.{1} (Option.{0} (Array.{0} Char)) (ByteArray.utf8Decode?.go b i acc hi) (ite.{1} (Option.{0} (Array.{0} Char)) (LT.lt.{0} Nat instLTNat i (ByteArray.size b)) (Nat.decLt i (ByteArray.size b)) (ByteArray.utf8Decode?.go.match_1.{1} (fun (x._@.Init.Data.String.Basic.3210316694._hygCtx._hyg.42 : Option.{0} Char) => Option.{0} (Array.{0} Char)) (ByteArray.utf8DecodeChar? b i) (fun (h : Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? b i) (Option.none.{0} Char)) => Option.none.{0} (Array.{0} Char)) (fun (c : Char) (h : Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? b i) (Option.some.{0} Char c)) => ByteArray.utf8Decode?.go b (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (Char.utf8Size c)) (Array.push.{0} Char acc c) (ByteArray.le_size_of_utf8DecodeChar?_eq_some b i c h))) (Option.some.{0} (Array.{0} Char) acc))

-- Stub: this file represents the declaration `ByteArray.utf8Decode?.go.eq_def`.
-- In a full split, the body would be extracted from the environment.
