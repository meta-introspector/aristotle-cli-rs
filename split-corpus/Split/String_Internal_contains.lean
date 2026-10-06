import Mathlib

-- spec: opaque String.Internal.contains : String -> Char -> Bool
opaque String.Internal.contains : String -> Char -> Bool :=
  fun (s : String) (c : Char) => Inhabited.default.{1} Bool instInhabitedBool
