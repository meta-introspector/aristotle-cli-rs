import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.ForwardSliceSearcher.instForwardPattern_1 : forall {pat : String}, String.Slice.Pattern.ForwardPattern String pat
def String.Slice.Pattern.ForwardSliceSearcher.instForwardPattern_1 : forall {pat : String}, String.Slice.Pattern.ForwardPattern String pat :=
  fun {pat : String} => String.Slice.Pattern.ForwardPattern.mk String pat (String.Slice.Pattern.ForwardSliceSearcher.dropPrefix? (String.toSlice pat)) (fun (s : String.Slice) (x._@.Init.Data.String.Pattern.Basic.3562291020._hygCtx._hyg.22 : Eq.{1} Bool (String.Slice.isEmpty s) Bool.false) => String.Slice.Pattern.ForwardSliceSearcher.dropPrefix? (String.toSlice pat) s) (String.Slice.Pattern.ForwardSliceSearcher.startsWith (String.toSlice pat))
