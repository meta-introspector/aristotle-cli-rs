import Mathlib

set_option pp.all true
-- spec: String.toByteArray : String -> ByteArray
def String.toByteArray : String -> ByteArray :=
  fun (self : String) => self.1
