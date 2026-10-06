import Mathlib

set_option pp.all true
-- spec: String.utf8ByteSize : ([mdata borrowed:1 String]) -> Nat
def String.utf8ByteSize : ([mdata borrowed:1 String]) -> Nat :=
  fun (s : String) => ByteArray.size (String.toByteArray s)
