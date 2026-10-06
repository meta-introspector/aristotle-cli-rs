import Mathlib

-- spec: opaque IO.RealWorld.nonemptyType : NonemptyType.{0}
opaque IO.RealWorld.nonemptyType : NonemptyType.{0} :=
  Inhabited.default.{2} NonemptyType.{0} instInhabitedNonemptyType.{0}
