import Mathlib

set_option pp.all true
-- spec: String.ofList : (List.{0} Char) -> String
def String.ofList : (List.{0} Char) -> String :=
  fun (data : List.{0} Char) => String.ofByteArray (List.utf8Encode data) (String.ofList._proof_1 data)
