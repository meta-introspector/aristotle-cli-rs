import Split.String
import Split.ByteArray
import Split.String_ofByteArray
import Split.ByteArray_IsValidUTF8

-- String.rec from environment
-- recursor String.rec : forall {motive : String -> Sort.{u}}, (forall (toByteArray : ByteArray) (isValidUTF8 : ByteArray.IsValidUTF8 toByteArray), motive (String.ofByteArray toByteArray isValidUTF8)) -> (forall (t : String), motive t)

-- Stub: this file represents the declaration `String.rec`.
-- In a full split, the body would be extracted from the environment.
