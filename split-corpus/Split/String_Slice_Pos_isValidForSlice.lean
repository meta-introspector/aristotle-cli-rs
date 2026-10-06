import Mathlib

-- spec: theorem String.Slice.Pos.isValidForSlice : forall {s : String.Slice} (self : String.Slice.Pos s), String.Pos.Raw.IsValidForSlice s (String.Slice.Pos.offset s self)
theorem String.Slice.Pos.isValidForSlice : forall {s : String.Slice} (self : String.Slice.Pos s), String.Pos.Raw.IsValidForSlice s (String.Slice.Pos.offset s self) :=
  fun (s : String.Slice) (self : String.Slice.Pos s) => self.2
