import Mathlib

-- spec: theorem String.Slice.startInclusive_le_endExclusive : forall (self : String.Slice), LE.le.{0} (String.Pos (String.Slice.str self)) (String.instLEPos (String.Slice.str self)) (String.Slice.startInclusive self) (String.Slice.endExclusive self)
theorem String.Slice.startInclusive_le_endExclusive : forall (self : String.Slice), LE.le.{0} (String.Pos (String.Slice.str self)) (String.instLEPos (String.Slice.str self)) (String.Slice.startInclusive self) (String.Slice.endExclusive self) :=
  fun (self : String.Slice) => self.4
