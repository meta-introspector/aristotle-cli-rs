import Split.List_data_toByteArray
import Split.congrArg
import Split.GetElem_getElem_congr_simp
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.List_toByteArray
import Split.List_toArray
import Split.Array
import Split.GetElem_getElem
import Split.List
import Split.Array_instGetElemNatLtSize
import Split.Nat
import Split.ByteArray_data
import Split.LT_lt
import Split.True
import Split.eq_self
import Split.of_eq_true
import Split.Eq_ndrec
import Split.Eq_refl
import Split.congrFun'
import Split.instLTNat
import Split.ByteArray
import Split.List_instGetElemNatLtLength
import Split.UInt8
import Split.Eq
import Split.List_length
import Split.Array_size
import Split.ByteArray_size
import Split.Eq_trans

-- List.getElem_toByteArray from environment
-- theorem List.getElem_toByteArray : forall {l : List.{0} UInt8} {i : Nat} {h : LT.lt.{0} Nat instLTNat i (ByteArray.size (List.toByteArray l))}, Eq.{1} UInt8 (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (List.toByteArray l) i h) (GetElem.getElem.{0, 0, 0} (List.{0} UInt8) Nat UInt8 (fun (as : List.{0} UInt8) (i : Nat) => LT.lt.{0} Nat instLTNat i (List.length.{0} UInt8 as)) (List.instGetElemNatLtLength.{0} UInt8) l i (List.getElem_toByteArray._proof_1 l i h))

-- Stub: this file represents the declaration `List.getElem_toByteArray`.
-- In a full split, the body would be extracted from the environment.
