import Mathlib

-- spec: theorem String.Slice.Subslice.startInclusive_le_endExclusive : forall {s : String.Slice} (self : String.Slice.Subslice s), LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) (String.Slice.Subslice.startInclusive s self) (String.Slice.Subslice.endExclusive s self)
theorem String.Slice.Subslice.startInclusive_le_endExclusive : forall {s : String.Slice} (self : String.Slice.Subslice s), LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) (String.Slice.Subslice.startInclusive s self) (String.Slice.Subslice.endExclusive s self) :=
  fun (s : String.Slice) (self : String.Slice.Subslice s) => self.3
