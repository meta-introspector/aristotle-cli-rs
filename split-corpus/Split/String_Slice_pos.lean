import Mathlib

set_option pp.all true
-- spec: String.Slice.pos : forall (s : String.Slice) (off : String.Pos.Raw), (String.Pos.Raw.IsValidForSlice s off) -> (String.Slice.Pos s)
def String.Slice.pos : forall (s : String.Slice) (off : String.Pos.Raw), (String.Pos.Raw.IsValidForSlice s off) -> (String.Slice.Pos s) :=
  fun (s : String.Slice) (off : String.Pos.Raw) (h : String.Pos.Raw.IsValidForSlice s off) => String.Slice.Pos.mk s off h
