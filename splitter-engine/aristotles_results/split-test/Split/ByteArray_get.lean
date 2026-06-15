import Split.ByteArray_mk
import Split.autoParam
import Split.Array
import Split.GetElem_getElem
import Split.Array_instGetElemNatLtSize
import Split.ByteArray_get_match_1
import Split.Nat
import Split.LT_lt
import Split.instLTNat
import Split.ByteArray
import Split.UInt8
import Split.Array_size
import Split.ByteArray_size

-- ByteArray.get from environment
-- def ByteArray.get : forall (a : [mdata borrowed:1 ByteArray]) (i : [mdata borrowed:1 Nat]), (autoParam.{0} (LT.lt.{0} ([mdata borrowed:1 Nat]) instLTNat i (ByteArray.size a)) ByteArray.get._auto_1) -> UInt8
-- (definition body omitted)

-- Stub: this file represents the declaration `ByteArray.get`.
-- In a full split, the body would be extracted from the environment.
