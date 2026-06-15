import Split.String
import Split.LE_le
import Split.String_Pos_Raw
import Split.String_rawEndPos
import Split.String_Pos_Raw_offsetBy
import Split.String_instLERaw
import Split.Bool
import Split.String_instOfNatRaw
import Split.OfNat_ofNat

-- String.Slice.Pattern.Internal.memcmpStr from environment
-- def String.Slice.Pattern.Internal.memcmpStr : forall (lhs : [mdata borrowed:1 String]) (rhs : [mdata borrowed:1 String]) (lstart : [mdata borrowed:1 String.Pos.Raw]) (rstart : [mdata borrowed:1 String.Pos.Raw]) (len : [mdata borrowed:1 String.Pos.Raw]), (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.Raw.offsetBy len lstart) (String.rawEndPos lhs)) -> (LE.le.{0} String.Pos.Raw String.instLERaw (String.Pos.Raw.offsetBy len rstart) (String.rawEndPos rhs)) -> Bool
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pattern.Internal.memcmpStr`.
-- In a full split, the body would be extracted from the environment.
