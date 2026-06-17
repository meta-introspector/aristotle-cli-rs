import Split.String_instLTRaw
import Split.String
import Split.String_toByteArray
import Split.String_getUTF8Byte
import Split.ByteArray_instGetElemNatUInt8LtSize
import Split.String_Pos_Raw
import Split.GetElem_getElem
import Split.String_rawEndPos
import Split.Nat
import Split.LT_lt
import Split.Eq_refl
import Split.instLTNat
import Split.ByteArray
import Split.String_Pos_Raw_byteIdx
import Split.UInt8
import Split.Eq
import Split.ByteArray_size

-- String.getUTF8Byte.eq_1 from environment
-- theorem String.getUTF8Byte.eq_1 : forall (s : String) (p : String.Pos.Raw) (h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos s)), Eq.{1} UInt8 (String.getUTF8Byte s p h) (GetElem.getElem.{0, 0, 0} ByteArray Nat UInt8 (fun (xs : ByteArray) (i : Nat) => LT.lt.{0} Nat instLTNat i (ByteArray.size xs)) ByteArray.instGetElemNatUInt8LtSize (String.toByteArray s) (String.Pos.Raw.byteIdx p) h)

-- Stub: this file represents the declaration `String.getUTF8Byte.eq_1`.
-- In a full split, the body would be extracted from the environment.
