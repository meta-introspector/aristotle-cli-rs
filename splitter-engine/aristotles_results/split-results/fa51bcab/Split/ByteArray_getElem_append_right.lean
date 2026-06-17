import Split.Array_instAppend
import Split.Eq_mpr
import Split.Array_size_append
import Split.congrArg
import Split.GetElem_getElem_congr_simp
import Split.HSub_hSub
import Split.Eq_rec
import Split.id
import Split.instSubNat
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.LE_le
import Split.instLENat
import Split.Array
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.instHAdd
import Split.instHSub
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.ByteArray_data_append
import Split.Nat
import Split.ByteArray_data
import Split.LT_lt
import Split.Array_getElem_append_right
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.ByteArray_instAppend
import Split.instLTNat
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.Array_size
import Split.HAppend_hAppend
import Split.ByteArray_size
import Split.Nat_sub_lt_left_of_lt_add

-- ByteArray.getElem_append_right from environment
-- theorem ByteArray.getElem_append_right : forall {i : Nat} {a : ByteArray} {b : ByteArray} {h : LT.lt.{0} Nat instLTNat i (ByteArray.size (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a b))} (hle : LE.le.{0} Nat instLENat (ByteArray.size a) i), Eq.{1} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a b) i h) (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize b (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) i (ByteArray.size a)) (ByteArray.getElem_append_right._proof_2 i a b h hle))

-- Stub: this file represents the declaration `ByteArray.getElem_append_right`.
-- In a full split, the body would be extracted from the environment.
