import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.currPos : forall {ρ : Type} {pat : ρ} {s : String.Slice}, (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) -> (String.Slice.Pos s)
def String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher.currPos : forall {ρ : Type} {pat : ρ} {s : String.Slice}, (String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) -> (String.Slice.Pos s) :=
  fun (ρ : Type) (pat : ρ) (s : String.Slice) (self : String.Slice.Pattern.ToForwardSearcher.DefaultForwardSearcher ρ pat s) => self.1
