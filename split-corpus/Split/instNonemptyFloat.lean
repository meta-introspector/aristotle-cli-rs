import Mathlib

-- spec: theorem instNonemptyFloat : Nonempty.{1} Float
theorem instNonemptyFloat : Nonempty.{1} Float :=
  Nonempty.intro.{1} Float (Float.mk (FloatSpec.val floatSpec))
