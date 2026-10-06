import Mathlib

-- spec: theorem String.Slice.Pos.offset_str : forall {s : String.Slice} {pos : String.Slice.Pos s}, Eq.{1} String.Pos.Raw (String.Pos.offset (String.Slice.str s) (String.Slice.Pos.str s pos)) (String.Pos.Raw.offsetBy (String.Slice.Pos.offset s pos) (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s)))
theorem String.Slice.Pos.offset_str : forall {s : String.Slice} {pos : String.Slice.Pos s}, Eq.{1} String.Pos.Raw (String.Pos.offset (String.Slice.str s) (String.Slice.Pos.str s pos)) (String.Pos.Raw.offsetBy (String.Slice.Pos.offset s pos) (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s))) :=
  fun {s : String.Slice} {pos : String.Slice.Pos s} => rfl.{1} String.Pos.Raw (String.Pos.offset (String.Slice.str s) (String.Slice.Pos.str s pos))
