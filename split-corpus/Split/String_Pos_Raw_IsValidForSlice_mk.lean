import Mathlib

-- spec: constructor String.Pos.Raw.IsValidForSlice.mk : forall {s : String.Slice} {p : String.Pos.Raw}, (LE.le.{0} String.Pos.Raw String.instLERaw p (String.Slice.rawEndPos s)) -> (String.Pos.Raw.IsValid (String.Slice.str s) (String.Pos.Raw.offsetBy p (String.Pos.offset (String.Slice.str s) (String.Slice.startInclusive s)))) -> (String.Pos.Raw.IsValidForSlice s p)
