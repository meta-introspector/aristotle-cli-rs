import Mathlib

set_option pp.all true
-- spec: String.length : ([mdata borrowed:1 String]) -> Nat
def String.length : ([mdata borrowed:1 String]) -> Nat :=
  fun (b : String) => List.length.{0} Char (String.toList b)
