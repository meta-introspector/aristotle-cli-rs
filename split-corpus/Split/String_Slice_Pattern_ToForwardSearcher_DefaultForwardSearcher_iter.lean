import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.iter : forall {ρ : Type} (pat : ρ) (s : String.Slice), Std.Iter.{0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) (String.Slice.Pattern.SearchStep s)
def String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.iter : forall {ρ : Type} (pat : ρ) (s : String.Slice), Std.Iter.{0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) (String.Slice.Pattern.SearchStep s) :=
  fun {ρ : Type} (pat : ρ) (s : String.Slice) => Std.Iter.mk.{0} (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) (String.Slice.Pattern.SearchStep s) (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.mk ρ pat s (String.Slice.startPos s))
