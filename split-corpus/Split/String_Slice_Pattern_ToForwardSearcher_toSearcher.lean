import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.ToForwardSearcher.toSearcher : forall {ρ : Type} (pat : ρ) {σ : outParam.{2} (String.Slice -> Type)} [self : String.Slice.Pattern.ToForwardSearcher ρ pat σ] (s : String.Slice), Std.Iter.{0} (σ s) (String.Slice.Pattern.SearchStep s)
def String.Slice.Pattern.ToForwardSearcher.toSearcher : forall {ρ : Type} (pat : ρ) {σ : outParam.{2} (String.Slice -> Type)} [self : String.Slice.Pattern.ToForwardSearcher ρ pat σ] (s : String.Slice), Std.Iter.{0} (σ s) (String.Slice.Pattern.SearchStep s) :=
  fun (ρ : Type) (pat : ρ) {σ : outParam.{2} (String.Slice -> Type)} [self : String.Slice.Pattern.ToForwardSearcher ρ pat σ] => self.1
