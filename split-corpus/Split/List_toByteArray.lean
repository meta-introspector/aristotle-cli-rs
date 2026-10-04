import Mathlib

set_option pp.all true
-- spec: List.toByteArray : (List.{0} UInt8) -> ByteArray
def List.toByteArray : (List.{0} UInt8) -> ByteArray :=
  fun (bs : List.{0} UInt8) => List.toByteArray.loop bs ByteArray.empty
