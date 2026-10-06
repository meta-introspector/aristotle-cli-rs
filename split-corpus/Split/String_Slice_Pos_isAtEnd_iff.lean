import Mathlib

-- spec: theorem String.Slice.Pos.isAtEnd_iff : forall {s : String.Slice} {pos : String.Slice.Pos s}, Iff (String.Slice.Pos.IsAtEnd s pos) (Eq.{1} (String.Slice.Pos s) pos (String.Slice.endPos s))
theorem String.Slice.Pos.isAtEnd_iff : forall {s : String.Slice} {pos : String.Slice.Pos s}, Iff (String.Slice.Pos.IsAtEnd s pos) (Eq.{1} (String.Slice.Pos s) pos (String.Slice.endPos s)) :=
  fun {s : String.Slice} {pos : String.Slice.Pos s} => Iff.rfl (String.Slice.Pos.IsAtEnd s pos)
