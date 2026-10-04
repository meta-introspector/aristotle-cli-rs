import Mathlib

-- spec: opaque String.Internal.isEmpty : String -> Bool
opaque String.Internal.isEmpty : String -> Bool :=
  fun (s : String) => Inhabited.default.{1} Bool instInhabitedBool
