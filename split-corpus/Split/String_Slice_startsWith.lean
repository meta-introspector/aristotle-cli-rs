import Mathlib

set_option pp.all true
-- spec: String.Slice.startsWith : forall {ρ : Type}, String.Slice -> (forall (pat : ρ) [inst._@.Init.Data.String.Slice.1847724407._hygCtx._hyg.43 : String.Slice.Pattern.ForwardPattern ρ pat], Bool)
def String.Slice.startsWith : forall {ρ : Type}, String.Slice -> (forall (pat : ρ) [inst._@.Init.Data.String.Slice.1847724407._hygCtx._hyg.43 : String.Slice.Pattern.ForwardPattern ρ pat], Bool) :=
  fun {ρ : Type} (s : String.Slice) (pat : ρ) [inst._@.Init.Data.String.Slice.1847724407._hygCtx._hyg.43 : String.Slice.Pattern.ForwardPattern ρ pat] => String.Slice.Pattern.ForwardPattern.startsWith ρ pat inst._@.Init.Data.String.Slice.1847724407._hygCtx._hyg.43 s
