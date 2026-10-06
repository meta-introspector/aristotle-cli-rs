import Mathlib

set_option pp.all true
-- spec: String.startsWith : forall {ρ : Type}, String -> (forall (pat : ρ) [inst._@.Init.Data.String.TakeDrop.1847724407._hygCtx._hyg.5 : String.Slice.Pattern.ForwardPattern ρ pat], Bool)
def String.startsWith : forall {ρ : Type}, String -> (forall (pat : ρ) [inst._@.Init.Data.String.TakeDrop.1847724407._hygCtx._hyg.5 : String.Slice.Pattern.ForwardPattern ρ pat], Bool) :=
  fun {ρ : Type} (s : String) (pat : ρ) [inst._@.Init.Data.String.TakeDrop.1847724407._hygCtx._hyg.5 : String.Slice.Pattern.ForwardPattern ρ pat] => String.Slice.startsWith ρ (String.toSlice s) pat inst._@.Init.Data.String.TakeDrop.1847724407._hygCtx._hyg.5
