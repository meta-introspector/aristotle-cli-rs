import Split.String_instLTRaw
import Split.Vector
import Split.String_Slice_rawEndPos
import Split.String_Slice
import Split.String_Slice_utf8ByteSize
import Split.String_Pos_Raw
import Split.String_Slice_Pattern_ForwardSliceSearcher_buildTable
import Split.Nat
import Split.LT_lt
import Split.String_Slice_Pattern_ForwardSliceSearcher
import Split.Eq

-- String.Slice.Pattern.ForwardSliceSearcher.proper from environment
-- constructor String.Slice.Pattern.ForwardSliceSearcher.proper : forall {s : String.Slice} (needle : String.Slice) (table : Vector.{0} Nat (String.Slice.utf8ByteSize needle)), (Eq.{1} (Vector.{0} Nat (String.Slice.utf8ByteSize needle)) table (String.Slice.Pattern.ForwardSliceSearcher.buildTable needle)) -> String.Pos.Raw -> (forall (needlePos : String.Pos.Raw), (LT.lt.{0} String.Pos.Raw String.instLTRaw needlePos (String.Slice.rawEndPos needle)) -> (String.Slice.Pattern.ForwardSliceSearcher s))

-- Stub: this file represents the declaration `String.Slice.Pattern.ForwardSliceSearcher.proper`.
-- In a full split, the body would be extracted from the environment.
