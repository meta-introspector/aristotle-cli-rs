import Split.String_instLTRaw
import Split.Vector
import Split.String_Slice_Pattern_ForwardSliceSearcher_atEnd
import Split.String_Slice_rawEndPos
import Split.String_Slice_Pattern_ForwardSliceSearcher_emptyBefore
import Split.String_Slice
import Split.Ne
import Split.String_Slice_Pattern_ForwardSliceSearcher_emptyAt
import Split.String_Slice_utf8ByteSize
import Split.String_Pos_Raw
import Split.String_Slice_Pattern_ForwardSliceSearcher_proper
import Split.String_Slice_endPos
import Split.String_Slice_Pattern_ForwardSliceSearcher_buildTable
import Split.Nat
import Split.LT_lt
import Split.String_Slice_Pos
import Split.String_Slice_Pattern_ForwardSliceSearcher
import Split.Eq
import Split.String_Slice_Pattern_ForwardSliceSearcher_rec

-- String.Slice.Pattern.ForwardSliceSearcher.casesOn from environment
-- def String.Slice.Pattern.ForwardSliceSearcher.casesOn : forall {s : String.Slice} {motive : (String.Slice.Pattern.ForwardSliceSearcher s) -> Sort.{u}} (t : String.Slice.Pattern.ForwardSliceSearcher s), (forall (pos : String.Slice.Pos s), motive (String.Slice.Pattern.ForwardSliceSearcher.emptyBefore s pos)) -> (forall (pos : String.Slice.Pos s) (h : Ne.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)), motive (String.Slice.Pattern.ForwardSliceSearcher.emptyAt s pos h)) -> (forall (needle : String.Slice) (table : Vector.{0} Nat (String.Slice.utf8ByteSize needle)) (ht : Eq.{1} (Vector.{0} Nat (String.Slice.utf8ByteSize needle)) table (String.Slice.Pattern.ForwardSliceSearcher.buildTable needle)) (stackPos : String.Pos.Raw) (needlePos : String.Pos.Raw) (hn : LT.lt.{0} String.Pos.Raw String.instLTRaw needlePos (String.Slice.rawEndPos needle)), motive (String.Slice.Pattern.ForwardSliceSearcher.proper s needle table ht stackPos needlePos hn)) -> (motive (String.Slice.Pattern.ForwardSliceSearcher.atEnd s)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pattern.ForwardSliceSearcher.casesOn`.
-- In a full split, the body would be extracted from the environment.
