import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedAttributeApplicationTime.default : Lean.AttributeApplicationTime
def Lean.instInhabitedAttributeApplicationTime.default : Lean.AttributeApplicationTime :=
  Lean.AttributeApplicationTime.afterTypeChecking
