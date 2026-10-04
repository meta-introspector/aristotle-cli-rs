import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.ForwardPattern.dropPrefixOfNonempty? : forall {ρ : Type} (pat : ρ) [self : String.Slice.Pattern.ForwardPattern ρ pat] (s : String.Slice), (Eq.{1} Bool (String.Slice.isEmpty s) Bool.false) -> (Option.{0} (String.Slice.Pos s))
def String.Slice.Pattern.ForwardPattern.dropPrefixOfNonempty? : forall {ρ : Type} (pat : ρ) [self : String.Slice.Pattern.ForwardPattern ρ pat] (s : String.Slice), (Eq.{1} Bool (String.Slice.isEmpty s) Bool.false) -> (Option.{0} (String.Slice.Pos s)) :=
  fun (ρ : Type) (pat : ρ) [self : String.Slice.Pattern.ForwardPattern ρ pat] => self.2
