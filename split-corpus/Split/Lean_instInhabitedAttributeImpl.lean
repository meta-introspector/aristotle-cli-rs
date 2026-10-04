import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedAttributeImpl : Inhabited.{1} Lean.AttributeImpl
def Lean.instInhabitedAttributeImpl : Inhabited.{1} Lean.AttributeImpl :=
  Inhabited.mk.{1} Lean.AttributeImpl Lean.instInhabitedAttributeImpl.default
