import Mathlib

-- spec: constructor String.Slice.Subslice.mk : forall {s : String.Slice} (startInclusive : String.Slice.Pos s) (endExclusive : String.Slice.Pos s), (LE.le.{0} (String.Slice.Pos s) (String.instLEPos_1 s) startInclusive endExclusive) -> (String.Slice.Subslice s)
