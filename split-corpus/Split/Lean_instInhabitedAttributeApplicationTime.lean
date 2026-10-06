import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedAttributeApplicationTime : Inhabited.{1} Lean.AttributeApplicationTime
def Lean.instInhabitedAttributeApplicationTime : Inhabited.{1} Lean.AttributeApplicationTime :=
  Inhabited.mk.{1} Lean.AttributeApplicationTime Lean.instInhabitedAttributeApplicationTime.default
