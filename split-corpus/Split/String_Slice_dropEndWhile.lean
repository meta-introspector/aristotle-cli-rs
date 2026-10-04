import Mathlib

set_option pp.all true
-- spec: String.Slice.dropEndWhile : forall {ρ : Type}, String.Slice -> (forall (pat : ρ) [inst._@.Init.Data.String.Slice.3991015280._hygCtx._hyg.44 : String.Slice.Pattern.BackwardPattern ρ pat], String.Slice)
def String.Slice.dropEndWhile : forall {ρ : Type}, String.Slice -> (forall (pat : ρ) [inst._@.Init.Data.String.Slice.3991015280._hygCtx._hyg.44 : String.Slice.Pattern.BackwardPattern ρ pat], String.Slice) :=
  fun {ρ : Type} (s : String.Slice) (pat : ρ) [inst._@.Init.Data.String.Slice.3991015280._hygCtx._hyg.44 : String.Slice.Pattern.BackwardPattern ρ pat] => _private.Init.Data.String.Slice.0.String.Slice.dropEndWhile.go ρ s pat inst._@.Init.Data.String.Slice.3991015280._hygCtx._hyg.44 (String.Slice.endPos s)
