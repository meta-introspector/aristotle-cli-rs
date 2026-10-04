import Mathlib

-- spec: constructor String.Slice.Pattern.BackwardPattern.mk : forall {ρ : Type} {pat : ρ}, (forall (s : String.Slice), Option.{0} (String.Slice.Pos s)) -> (forall (s : String.Slice), (Eq.{1} Bool (String.Slice.isEmpty s) Bool.false) -> (Option.{0} (String.Slice.Pos s))) -> (String.Slice -> Bool) -> (String.Slice.Pattern.BackwardPattern ρ pat)
