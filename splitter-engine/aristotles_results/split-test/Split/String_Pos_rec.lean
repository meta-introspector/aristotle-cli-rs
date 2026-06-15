import Split.String
import Split.String_Pos_mk
import Split.String_Pos_Raw
import Split.String_Pos
import Split.String_Pos_Raw_IsValid

-- String.Pos.rec from environment
-- recursor String.Pos.rec : forall {s : String} {motive : (String.Pos s) -> Sort.{u}}, (forall (offset : String.Pos.Raw) (isValid : String.Pos.Raw.IsValid s offset), motive (String.Pos.mk s offset isValid)) -> (forall (t : String.Pos s), motive t)

-- Stub: this file represents the declaration `String.Pos.rec`.
-- In a full split, the body would be extracted from the environment.
