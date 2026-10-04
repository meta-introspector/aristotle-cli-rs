import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedAttributeImplCore.default : Lean.AttributeImplCore
def Lean.instInhabitedAttributeImplCore.default : Lean.AttributeImplCore :=
  Lean.AttributeImplCore.mk (Inhabited.default.{1} Lean.Name Lean.instInhabitedName) (Inhabited.default.{1} Lean.Name Lean.instInhabitedName) (Inhabited.default.{1} String String.instInhabited) (Inhabited.default.{1} Lean.AttributeApplicationTime Lean.instInhabitedAttributeApplicationTime)
