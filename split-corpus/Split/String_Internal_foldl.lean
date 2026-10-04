import Mathlib

-- spec: opaque String.Internal.foldl : (String -> Char -> String) -> String -> String -> String
opaque String.Internal.foldl : (String -> Char -> String) -> String -> String -> String :=
  fun (f : String -> Char -> String) (init : String) (s : String) => Inhabited.default.{1} String String.instInhabited
