import Mathlib

-- spec: opaque ST.RefPointed : NonemptyType.{0}
opaque ST.RefPointed : NonemptyType.{0} :=
  Inhabited.default.{2} NonemptyType.{0} instInhabitedNonemptyType.{0}
