import Mathlib

set_option pp.all true
-- spec: String.Slice.Pos.casesOn : forall {s : String.Slice} {motive : (String.Slice.Pos s) -> Sort.{u}} (t : String.Slice.Pos s), (forall (offset : String.Pos.Raw) (isValidForSlice : String.Pos.Raw.IsValidForSlice s offset), motive (String.Slice.Pos.mk s offset isValidForSlice)) -> (motive t)
def String.Slice.Pos.casesOn : forall {s : String.Slice} {motive : (String.Slice.Pos s) -> Sort.{u}} (t : String.Slice.Pos s), (forall (offset : String.Pos.Raw) (isValidForSlice : String.Pos.Raw.IsValidForSlice s offset), motive (String.Slice.Pos.mk s offset isValidForSlice)) -> (motive t) :=
  fun {s : String.Slice} {motive : (String.Slice.Pos s) -> Sort.{u}} (t : String.Slice.Pos s) (mk : forall (offset : String.Pos.Raw) (isValidForSlice : String.Pos.Raw.IsValidForSlice s offset), motive (String.Slice.Pos.mk s offset isValidForSlice)) => String.Slice.Pos.rec.{u} s motive (fun (offset : String.Pos.Raw) (isValidForSlice : String.Pos.Raw.IsValidForSlice s offset) => mk offset isValidForSlice) t
