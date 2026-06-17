import Split.String_Slice_Pattern_SearchStep
import Split.String_Slice
import Split.String_Slice_Pattern_SearchStep_rejected
import Split.String_Slice_Pattern_SearchStep_matched
import Split.String_Slice_Pos

-- String.Slice.Pattern.SearchStep.rec from environment
-- recursor String.Slice.Pattern.SearchStep.rec : forall {s : String.Slice} {motive : (String.Slice.Pattern.SearchStep s) -> Sort.{u}}, (forall (startPos : String.Slice.Pos s) (endPos : String.Slice.Pos s), motive (String.Slice.Pattern.SearchStep.rejected s startPos endPos)) -> (forall (startPos : String.Slice.Pos s) (endPos : String.Slice.Pos s), motive (String.Slice.Pattern.SearchStep.matched s startPos endPos)) -> (forall (t : String.Slice.Pattern.SearchStep s), motive t)

-- Stub: this file represents the declaration `String.Slice.Pattern.SearchStep.rec`.
-- In a full split, the body would be extracted from the environment.
