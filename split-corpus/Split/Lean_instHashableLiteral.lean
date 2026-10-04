import Mathlib

set_option pp.all true
-- spec: Lean.instHashableLiteral : Hashable.{1} Lean.Literal
def Lean.instHashableLiteral : Hashable.{1} Lean.Literal :=
  Hashable.mk.{1} Lean.Literal Lean.Literal.hash
