import Split.Array_push
import Split.ByteArray_utf8Decode?_go
import Split.Option_some
import Split.PSigma_casesOn
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
import Split.instAddNat
import Split.Char
import Split.instLTNat
import Split.ByteArray
import Split.PSigma_fst
import Split.PSigma
import Split.Eq
import Split.Not
import Split.Char_utf8Size
import Split.ByteArray_size
import Split.ByteArray_utf8DecodeChar?
import Split.Option

-- ByteArray.utf8Decode?.go.induct_unfolding from environment
-- theorem ByteArray.utf8Decode?.go.induct_unfolding : forall (b : ByteArray) (motive : forall (i : Nat), (Array.{0} Char) -> (LE.le.{0} Nat instLENat i (ByteArray.size b)) -> (Option.{0} (Array.{0} Char)) -> Prop), (forall (i : Nat) (acc : Array.{0} Char) (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)), (LT.lt.{0} Nat instLTNat i (ByteArray.size b)) -> (Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? b i) (Option.none.{0} Char)) -> (motive i acc hi (Option.none.{0} (Array.{0} Char)))) -> (forall (i : Nat) (acc : Array.{0} Char) (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)), (LT.lt.{0} Nat instLTNat i (ByteArray.size b)) -> (forall (c : Char) (h : Eq.{1} (Option.{0} Char) (ByteArray.utf8DecodeChar? b i) (Option.some.{0} Char c)), (motive (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (Char.utf8Size c)) (Array.push.{0} Char acc c) (ByteArray.le_size_of_utf8DecodeChar?_eq_some b i c h) (ByteArray.utf8Decode?.go b (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (Char.utf8Size c)) (Array.push.{0} Char acc c) (ByteArray.le_size_of_utf8DecodeChar?_eq_some b i c h))) -> (motive i acc hi (ByteArray.utf8Decode?.go b (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) i (Char.utf8Size c)) (Array.push.{0} Char acc c) (ByteArray.le_size_of_utf8DecodeChar?_eq_some b i c h))))) -> (forall (i : Nat) (acc : Array.{0} Char) (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)), (Not (LT.lt.{0} Nat instLTNat i (ByteArray.size b))) -> (motive i acc hi (Option.some.{0} (Array.{0} Char) acc))) -> (forall (i : Nat) (acc : Array.{0} Char) (hi : LE.le.{0} Nat instLENat i (ByteArray.size b)), motive i acc hi (ByteArray.utf8Decode?.go b i acc hi))

-- Stub: this file represents the declaration `ByteArray.utf8Decode?.go.induct_unfolding`.
-- In a full split, the body would be extracted from the environment.
