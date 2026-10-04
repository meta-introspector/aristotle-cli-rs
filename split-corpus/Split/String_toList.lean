import Mathlib

set_option pp.all true
-- spec: String.toList : String -> (List.{0} Char)
def String.toList : String -> (List.{0} Char) :=
  fun (s : String) => Array.toList.{0} Char (String.Internal.toArray s)
