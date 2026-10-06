import Mathlib

-- spec: recursor String.rec : forall {motive : String -> Sort.{u}}, (forall (toByteArray : ByteArray) (isValidUTF8 : ByteArray.IsValidUTF8 toByteArray), motive (String.ofByteArray toByteArray isValidUTF8)) -> (forall (t : String), motive t)
