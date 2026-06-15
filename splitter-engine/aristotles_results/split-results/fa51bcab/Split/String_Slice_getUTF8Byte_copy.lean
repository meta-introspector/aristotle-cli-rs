import Split.Eq_mpr
import Split.String_instLTRaw
import Split.congrArg
import Split.String_Slice_getUTF8Byte_eq_getUTF8Byte_copy
import Split.String_Slice
import Split.id
import Split.String_getUTF8Byte
import Split.String_Pos_Raw
import Split.String_rawEndPos
import Split.String_Slice_copy
import Split.LT_lt
import Split.Eq_refl
import Split.String_Slice_getUTF8Byte
import Split.UInt8
import Split.Eq

-- String.Slice.getUTF8Byte_copy from environment
-- theorem String.Slice.getUTF8Byte_copy : forall {s : String.Slice} {p : String.Pos.Raw} {h : LT.lt.{0} String.Pos.Raw String.instLTRaw p (String.rawEndPos (String.Slice.copy s))}, Eq.{1} UInt8 (String.getUTF8Byte (String.Slice.copy s) p h) (String.Slice.getUTF8Byte s p (String.Slice.getUTF8Byte_copy._proof_1 s p h))

-- Stub: this file represents the declaration `String.Slice.getUTF8Byte_copy`.
-- In a full split, the body would be extracted from the environment.
