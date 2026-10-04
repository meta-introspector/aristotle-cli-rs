import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.ForwardSliceSearcher.dropPrefix? : String.Slice -> (forall (s : String.Slice), Option.{0} (String.Slice.Pos s))
def String.Slice.Pattern.ForwardSliceSearcher.dropPrefix? : String.Slice -> (forall (s : String.Slice), Option.{0} (String.Slice.Pos s)) :=
  fun (pat : String.Slice) (s : String.Slice) => ite.{1} (Option.{0} (String.Slice.Pos s)) (Eq.{1} Bool (String.Slice.Pattern.ForwardSliceSearcher.startsWith pat s) Bool.true) (instDecidableEqBool (String.Slice.Pattern.ForwardSliceSearcher.startsWith pat s) Bool.true) (Option.some.{0} (String.Slice.Pos s) (String.Slice.pos! s (String.Pos.Raw.offsetBy (String.Slice.rawEndPos pat) (String.Slice.Pos.offset s (String.Slice.startPos s))))) (Option.none.{0} (String.Slice.Pos s))
