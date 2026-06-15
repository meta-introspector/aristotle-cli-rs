import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.LE_le
import Split.String_Slice_startInclusive
import Split.String_Pos_Raw
import Split.String_Slice_str
import Split.String_Pos_Raw_offsetBy
import Split.String_instLERaw
import Split.Bool
import Split.String_Slice_Pattern_Internal_memcmpStr
import Split.String_Pos_offset

-- String.Slice.Pattern.Internal.memcmpSlice from environment
-- def String.Slice.Pattern.Internal.memcmpSlice : forall (lhs : String.Slice) (rhs : String.Slice) (lstart : String.Pos.Raw) (rstart : String.Pos.Raw) (len : String.Pos.Raw), (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.Raw.offsetBy len lstart) (String.Slice.rawEndPos lhs)) -> (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.Raw.offsetBy len rstart) (String.Slice.rawEndPos rhs)) -> Bool
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pattern.Internal.memcmpSlice`.
-- In a full split, the body would be extracted from the environment.
