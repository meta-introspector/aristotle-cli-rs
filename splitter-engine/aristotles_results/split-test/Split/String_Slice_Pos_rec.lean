import Split.String_Slice
import Split.String_Pos_Raw
import Split.String_Pos_Raw_IsValidForSlice
import Split.String_Slice_Pos_mk
import Split.String_Slice_Pos

-- String.Slice.Pos.rec from environment
-- recursor String.Slice.Pos.rec : forall {s : String.Slice} {motive : (String.Slice.Pos s) -> Sort.{u}}, (forall (offset : String.Pos.Raw) (isValidForSlice : String.Pos.Raw.IsValidForSlice s offset), motive (String.Slice.Pos.mk s offset isValidForSlice)) -> (forall (t : String.Slice.Pos s), motive t)

-- Stub: this file represents the declaration `String.Slice.Pos.rec`.
-- In a full split, the body would be extracted from the environment.
