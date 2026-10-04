import Mathlib

set_option pp.all true
-- spec: String.singleton : Char -> String
def String.singleton : Char -> String :=
  fun (c : Char) => String.push "" c
