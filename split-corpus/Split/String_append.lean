import Mathlib

set_option pp.all true
-- spec: String.append : String -> ([mdata borrowed:1 String]) -> String
def String.append : String -> ([mdata borrowed:1 String]) -> String :=
  fun (s : String) (t : String) => String.ofByteArray (HAppend.hAppend.{0, 0, 0} ByteArray ByteArray ByteArray (instHAppendOfAppend.{0} ByteArray ByteArray.instAppend) (String.toByteArray s) (String.toByteArray t)) (String.append._proof_1 s t)
