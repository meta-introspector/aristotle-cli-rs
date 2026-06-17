import Split.String_Pos_rec
import Split.String
import Split.String_Pos_mk
import Split.String_Pos_Raw
import Split.String_Pos
import Split.String_Pos_Raw_IsValid

-- String.Pos.casesOn from environment
-- def String.Pos.casesOn : forall {s : String} {motive : (String.Pos s) -> Sort.{u}} (t : String.Pos s), (forall (offset : String.Pos.Raw) (isValid : String.Pos.Raw.IsValid s offset), motive (String.Pos.mk s offset isValid)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.Pos.casesOn`.
-- In a full split, the body would be extracted from the environment.
