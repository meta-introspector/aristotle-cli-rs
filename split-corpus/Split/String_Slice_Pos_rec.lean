import Mathlib

-- spec: recursor String.Slice.Pos.rec : forall {s : String.Slice} {motive : (String.Slice.Pos s) -> Sort.{u}}, (forall (offset : String.Pos.Raw) (isValidForSlice : String.Pos.Raw.IsValidForSlice s offset), motive (String.Slice.Pos.mk s offset isValidForSlice)) -> (forall (t : String.Slice.Pos s), motive t)
