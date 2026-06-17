import Mathlib

set_option pp.all true
-- spec: String.Internal.toArray : String -> (Array.{0} Char)
def String.Internal.toArray : String -> (Array.{0} Char) :=
  fun (b : String) => Option.get.{0} (Array.{0} Char) (ByteArray.utf8Decode? (String.toByteArray b)) (String.Internal.toArray._proof_1 b)
