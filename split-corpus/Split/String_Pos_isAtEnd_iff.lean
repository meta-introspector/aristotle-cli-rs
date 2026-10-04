import Mathlib

-- spec: theorem String.Pos.isAtEnd_iff : forall {s : String} {pos : String.Pos s}, Iff (String.Pos.IsAtEnd s pos) (Eq.{1} (String.Pos s) pos (String.endPos s))
theorem String.Pos.isAtEnd_iff : forall {s : String} {pos : String.Pos s}, Iff (String.Pos.IsAtEnd s pos) (Eq.{1} (String.Pos s) pos (String.endPos s)) :=
  fun {s : String} {pos : String.Pos s} => Iff.rfl (String.Pos.IsAtEnd s pos)
