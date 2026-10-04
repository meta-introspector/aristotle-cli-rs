import Mathlib

-- spec: constructor String.Slice.Pattern.ToForwardSearcher.mk : forall {ρ : Type} {pat : ρ} {σ : outParam.{2} (String.Slice -> Type)}, (forall (s : String.Slice), Std.Iter.{0} (σ s) (String.Slice.Pattern.SearchStep s)) -> (String.Slice.Pattern.ToForwardSearcher ρ pat σ)
