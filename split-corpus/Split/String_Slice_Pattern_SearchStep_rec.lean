import Mathlib

-- spec: recursor String.Slice.Pattern.SearchStep.rec : forall {s : String.Slice} {motive : (String.Slice.Pattern.SearchStep s) -> Sort.{u}}, (forall (startPos : String.Slice.Pos s) (endPos : String.Slice.Pos s), motive (String.Slice.Pattern.SearchStep.rejected s startPos endPos)) -> (forall (startPos : String.Slice.Pos s) (endPos : String.Slice.Pos s), motive (String.Slice.Pattern.SearchStep.matched s startPos endPos)) -> (forall (t : String.Slice.Pattern.SearchStep s), motive t)
