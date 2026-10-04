import Mathlib

-- spec: constructor String.Slice.mk : forall (str : String) (startInclusive : String.Pos str) (endExclusive : String.Pos str), (LE.le.{0} (String.Pos str) (String.instLEPos str) startInclusive endExclusive) -> String.Slice
