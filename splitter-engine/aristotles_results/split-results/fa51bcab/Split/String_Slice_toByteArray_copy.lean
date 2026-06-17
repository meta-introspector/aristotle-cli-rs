import Split.ByteArray_extract
import Split.String_toByteArray
import Split.String_Slice
import Split.String_Slice_startInclusive
import Split.String_Slice_str
import Split.String_Slice_copy
import Split.String_Slice_endExclusive
import Split.ByteArray
import Split.String_Pos_Raw_byteIdx
import Split.Eq
import Split.String_Pos_offset
import Split.rfl

-- String.Slice.toByteArray_copy from environment
-- theorem String.Slice.toByteArray_copy : forall {s : String.Slice}, Eq.{1} ByteArray (String.toByteArray (String.Slice.copy s)) (ByteArray.extract (String.toByteArray (String.Slice.str s)) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))) (String.Pos.Raw.byteIdx (String.Pos.offset (String.Slice.str s) (String.Slice.endExclusive s))))

-- Stub: this file represents the declaration `String.Slice.toByteArray_copy`.
-- In a full split, the body would be extracted from the environment.
