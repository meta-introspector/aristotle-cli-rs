import Split.Array_instAppend
import Split.Eq_mpr
import Split.Array_getElem_append_left
import Split.congrArg
import Split.GetElem_getElem_congr_simp
import Split.id
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.Array
import Split.GetElem_getElem
import Split.instHAppendOfAppend
import Split.Array_instGetElemNatLtSize
import Split.ByteArray_data_append
import Split.Nat
import Split.ByteArray_data
import Split.LT_lt
import Split.Eq_ndrec
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

-- ByteArray.getElem_append_left from environment
-- theorem ByteArray.getElem_append_left : forall {i : Nat} {a : ByteArray} {b : ByteArray} {h : LT.lt.{0} Nat instLTNat i (ByteArray.size (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a b))} (hlt : LT.lt.{0} Nat instLTNat i (ByteArray.size a)), Eq.{1} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) a b) i h) (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize a i hlt)

-- Stub: this file represents the declaration `ByteArray.getElem_append_left`.
-- In a full split, the body would be extracted from the environment.
