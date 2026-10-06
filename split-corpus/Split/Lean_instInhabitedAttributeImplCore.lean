import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedAttributeImplCore : Inhabited.{1} Lean.AttributeImplCore
def Lean.instInhabitedAttributeImplCore : Inhabited.{1} Lean.AttributeImplCore :=
  Inhabited.mk.{1} Lean.AttributeImplCore Lean.instInhabitedAttributeImplCore.default
