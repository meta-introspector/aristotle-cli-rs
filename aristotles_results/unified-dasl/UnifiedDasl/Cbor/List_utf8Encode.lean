import Mathlib

set_option pp.all true
-- spec: List.utf8Encode : (List.{0} Char) -> ByteArray
def List.utf8Encode : (List.{0} Char) -> ByteArray :=
  fun (l : List.{0} Char) => List.toByteArray (List.flatMap.{0, 0} Char UInt8 String.utf8EncodeChar l)
