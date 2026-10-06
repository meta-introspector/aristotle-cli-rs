import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.Char.instToForwardSearcherCharDefaultForwardSearcher : forall {c : Char}, String.Slice.Pattern.ToForwardSearcher Char c (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher Char c)
def String.Slice.Pattern.Char.instToForwardSearcherCharDefaultForwardSearcher : forall {c : Char}, String.Slice.Pattern.ToForwardSearcher Char c (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher Char c) :=
  fun {c : Char} => String.Slice.Pattern.ToForwardSearcher.defaultImplementation Char c (String.Slice.Pattern.Char.instForwardPatternChar c)
