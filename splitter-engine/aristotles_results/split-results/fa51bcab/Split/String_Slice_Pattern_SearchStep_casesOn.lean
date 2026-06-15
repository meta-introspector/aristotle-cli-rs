import Split.String_Slice_Pattern_SearchStep
import Split.String_Slice
import Split.String_Slice_Pattern_SearchStep_rejected
import Split.String_Slice_Pattern_SearchStep_matched
import Split.String_Slice_Pos
import Split.String_Slice_Pattern_SearchStep_rec

-- String.Slice.Pattern.SearchStep.casesOn from environment
-- def String.Slice.Pattern.SearchStep.casesOn : forall {s : String.Slice} {motive : (String.Slice.Pattern.SearchStep s) -> Sort.{u}} (t : String.Slice.Pattern.SearchStep s), (forall (startPos : String.Slice.Pos s) (endPos : String.Slice.Pos s), motive (String.Slice.Pattern.SearchStep.rejected s startPos endPos)) -> (forall (startPos : String.Slice.Pos s) (endPos : String.Slice.Pos s), motive (String.Slice.Pattern.SearchStep.matched s startPos endPos)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pattern.SearchStep.casesOn`.
-- In a full split, the body would be extracted from the environment.
