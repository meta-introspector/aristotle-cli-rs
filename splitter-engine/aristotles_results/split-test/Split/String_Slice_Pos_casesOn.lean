import Split.String_Slice
import Split.String_Slice_Pos_rec
import Split.String_Pos_Raw
import Split.String_Pos_Raw_IsValidForSlice
import Split.String_Slice_Pos_mk
import Split.String_Slice_Pos

-- String.Slice.Pos.casesOn from environment
-- def String.Slice.Pos.casesOn : forall {s : String.Slice} {motive : (String.Slice.Pos s) -> Sort.{u}} (t : String.Slice.Pos s), (forall (offset : String.Pos.Raw) (isValidForSlice : String.Pos.Raw.IsValidForSlice s offset), motive (String.Slice.Pos.mk s offset isValidForSlice)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Slice.Pos.casesOn`.
-- In a full split, the body would be extracted from the environment.
