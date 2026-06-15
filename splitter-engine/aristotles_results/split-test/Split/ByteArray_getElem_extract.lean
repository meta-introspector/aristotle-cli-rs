import Split.Eq_mpr
import Split.congrArg
import Split.ByteArray_extract
import Split.Array_getElem_extract
import Split.GetElem_getElem_congr_simp
import Split.id
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.Array_extract
import Split.Array
import Split.GetElem_getElem
import Split.instHAdd
import Split.Array_instGetElemNatLtSize
import Split.HAdd_hAdd
import Split.Nat
import Split.ByteArray_data
import Split.Array_getElem_extract_aux
import Split.LT_lt
import Split.ByteArray_getElem_extract_aux
import Split.ByteArray_data_extract
import Split.Eq_ndrec
import Split.instAddNat
import Split.Eq_refl
import Split.congrFun'
import Split.instLTNat
import Split.ByteArray
import Split.UInt8
import Split.Eq
import Split.Array_size
import Split.ByteArray_size
import Split.Eq_trans

-- ByteArray.getElem_extract from environment
-- theorem ByteArray.getElem_extract : forall {i : Nat} {b : ByteArray} {start : Nat} {stop : Nat} (h : LT.lt.{0} Nat instLTNat i (ByteArray.size (ByteArray.extract b start stop))), Eq.{1} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (ByteArray.extract b start stop) i h) (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize b (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) start i) (ByteArray.getElem_extract_aux i b start stop h))

-- Stub: this file represents the declaration `ByteArray.getElem_extract`.
-- In a full split, the body would be extracted from the environment.
