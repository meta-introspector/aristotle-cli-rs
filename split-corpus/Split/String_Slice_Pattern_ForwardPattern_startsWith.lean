import Mathlib

set_option pp.all true
-- spec: String.Slice.Pattern.ForwardPattern.startsWith : forall {ρ : Type} (pat : ρ) [self : String.Slice.Pattern.ForwardPattern ρ pat], String.Slice -> Bool
def String.Slice.Pattern.ForwardPattern.startsWith : forall {ρ : Type} (pat : ρ) [self : String.Slice.Pattern.ForwardPattern ρ pat], String.Slice -> Bool :=
  fun (ρ : Type) (pat : ρ) [self : String.Slice.Pattern.ForwardPattern ρ pat] => self.3
