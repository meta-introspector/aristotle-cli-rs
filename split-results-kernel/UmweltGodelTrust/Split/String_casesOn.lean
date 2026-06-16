import Split.String
import Split.String_rec
import Split.ByteArray
import Split.String_ofByteArray
import Split.ByteArray_IsValidUTF8

-- String.casesOn from environment
-- def String.casesOn : forall {motive : String -> Sort.{u}} (t : String), (forall (toByteArray : ByteArray) (isValidUTF8 : ByteArray.IsValidUTF8 toByteArray), motive (String.ofByteArray toByteArray isValidUTF8)) -> (motive t)
-- (definition body omitted)

-- Stub: this file represents the declaration `String.casesOn`.
-- In a full split, the body would be extracted from the environment.
